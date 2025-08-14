import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:uonly_app/Screens/Recharge_Screen/recharge_detail_creen.dart';
import '../../models/user_model.dart';
import '../../providers/loginProvider.dart';
import '../../routing/app_pages.dart';
import '../../theme/app_theme.dart';
import '../../widgets/button.dart';
import '../../widgets/error_utils.dart';

class RechargePlanScreen extends StatefulWidget {
  const RechargePlanScreen({super.key});
  @override
  State<RechargePlanScreen> createState() => _RechargePlanScreenState();
}
class _RechargePlanScreenState extends State<RechargePlanScreen>
    with TickerProviderStateMixin,AutomaticKeepAliveClientMixin {
  TabController? controller;
  int tabCount = 0;
  TextEditingController numberController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String number = '';
  String amount = '';
  OperatorModel? operator;
  CircleModel? circle;
  bool isLoading = false;
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var provider = context.read<ProviderScreen>();
      await provider.getRechargeOperator();
      await provider.getMobileCircle();
      if (provider.operatorModel.isNotEmpty) {
        operator = provider.operatorModel.first;
      }
      if (provider.circleList.isNotEmpty) {
        circle = provider.circleList.first;
      }
      setState(() {});
    });
  }

  void _initializeTabController(int length) {
    controller = TabController(length: length, vsync: this);
  }
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ProviderScreen>(context);
    // No need for a separate `plans` variable here, as we'll use the provider directly

    if (tabCount != provider.rechargeTabList.length) {
      tabCount = provider.rechargeTabList.length;
      // Only initialize the tab controller if there are tabs
      if (tabCount > 0) {
        _initializeTabController(tabCount);
      }
    }

    // The `DefaultTabController` and `Scaffold` remain unchanged
    return DefaultTabController(
      length: provider.rechargeTabList.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Recharge Plan'),
        ),
        body: SingleChildScrollView(
          padding: AppTheme.screenPadding,
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _buildDropdownField(
                          label: 'Operator',
                          value: operator?.operatorName,
                          items: provider.operatorModel.map((e) => e.operatorName).toList(),
                          onChanged: (val) {
                            operator = provider.operatorModel.firstWhere(
                                  (e) => e.operatorName == val,
                            );
                            setState(() {});
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildDropdownField(
                          label: 'Circle',
                          value: circle?.stateName,
                          items: provider.circleList.map((e) => e.stateName).toList(),
                          onChanged: (val) {
                            circle = provider.circleList.firstWhere((e) => e.stateName == val);
                            setState(() {});
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          label: 'Mobile Number',
                          value: number,
                          keyboardType: TextInputType.number,
                          maxLength: 10,
                          onChanged: (val) => number = val,
                          validator: (val) {
                            if (val == null || val.length != 10) {
                              return 'Enter a valid number';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                AppTheme.verticalSpacing(mul: 2),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: CustomElevatedBtn(
                    isBigSize: true,
                    onPressed: isLoading
                        ? null
                        : () async {
                      if (!formKey.currentState!.validate()) return;

                      // Check if operator and circle are selected
                      if (operator == null || circle == null) {
                        ErrorUtils.showSimpleInfoDialog(context, message: 'Please select an operator and a circle.');
                        return;
                      }

                      setState(() {
                        isLoading = true;
                      });

                      // Call the API with the correct parameters
                      var res = await provider.getRechargePlan(
                        number: number,
                        operatorId: operator!.operatorCode.toString(),
                        stateId: circle!.stateId.toString(),
                      );

                      setState(() {
                        isLoading = false;
                      });

                      if (res != null && res['status'] == 'false') {
                        ErrorUtils.showSimpleInfoDialog(context, message: res['message']);
                      } else {
                        // The provider already calls notifyListeners, so this setState is not strictly needed but can be a good habit.
                        setState(() {});
                      }
                    },
                    text: isLoading ? 'Please Wait...' : 'Get Recharge Plan',
                  ),
                ),
                AppTheme.verticalSpacing(mul: 2),
                // Show the search and tab bar only when data is available
                if (provider.rechargeTabList.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'Search Plans...',
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: const Icon(Icons.search),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                      ),
                      onChanged: (val) {
                        setState(() {
                          searchQuery = val.toLowerCase();
                        });
                      },
                    ),
                  ),
                  TabBar(
                    controller: controller,
                    isScrollable: true,
                    dividerColor: Colors.grey,
                    dividerHeight: 0.1,
                    labelColor: Colors.grey.shade600,
                    unselectedLabelColor: Colors.black,
                    onTap: (index) {
                      provider.filterRechargePlanList(provider.rechargeTabList[index]);
                      setState(() {});
                    },
                    tabs: provider.rechargeTabList.map((tab) => Tab(text: tab.toUpperCase())).toList(),
                  ),
                  AppTheme.verticalSpacing(mul: 2),
                  // Using a flexible layout with Expanded and ListView.builder
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7, // Adjust height as needed
                    child: TabBarView(
                      controller: controller,
                      children: provider.rechargeTabList.map((tab) {
                        final plans = provider.filteredRechargePlanList
                            .where((plan) =>
                        (plan.desc.toLowerCase().contains(searchQuery) ||
                            plan.rs.toString().toLowerCase().contains(searchQuery)))
                            .toList();

                        return ListView.builder(
                          itemCount: plans.length,
                          itemBuilder: (_, index) {
                            final plan = plans[index];
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              padding: AppTheme.screenPadding,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(AppTheme.radius),
                                boxShadow: const [
                                  BoxShadow(
                                    blurRadius: 4,
                                    color: Colors.black12,
                                  )
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '\u{20B9}${plan.rs}',
                                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            // Corrected to handle nullable `validity`
                                            plan.validity?.toString() ?? 'N/A',
                                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const Text(
                                            'Validity',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  AppTheme.verticalSpacing(),
                                  // ... (The code before the description section)

// This is the updated section to display the description as a numbered list
                                  // ... (The code before the description section)

// This is the updated section to display the description as a numbered list
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ...plan.desc
                                          .split('.')
                                          .where((s) => s.isNotEmpty)
                                          .toList() // Convert the Iterable to a List
                                          .asMap()
                                          .entries
                                          .map((entry) {
                                        final int index = entry.key;
                                        final String point = entry.value;
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 2.0),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${index + 1}.', // Display the number and a period (e.g., "1.", "2.")
                                                style: TextStyle(
                                                  color: Colors.grey.shade700,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  point.trim(), // Trim removes extra spaces
                                                  style: TextStyle(
                                                    color: Colors.grey.shade700,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ],
                                  ),

// ... (The code after the description section)

// ... (The code after the description section)
                                  AppTheme.verticalSpacing(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8.0),
                                        // child: Row(
                                        //   children: const [
                                        //     Icon(Icons.card_giftcard, color: Colors.green, size: 18),
                                        //     SizedBox(width: 4),
                                        //     Text(
                                        //       'Cashback: ₹2.50',
                                        //       style: TextStyle(
                                        //         color: Colors.green,
                                        //         fontWeight: FontWeight.bold,
                                        //       ),
                                        //     ),
                                        //   ],
                                        // ),
                                      ),
                                      Align(
                                        alignment: Alignment.topRight,
                                        child:GestureDetector(
                                          onTap: () async {
                                            try {
                                              amount = plan.rs.toString();

                                              // await provider.getCashbackDetails(
                                              //   amount: amount,
                                              //   operatorId: operator!.operatorCode.toString(),
                                              //   serviceId: 'P',
                                              // );

                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => RechargeDetailScreen(
                                                    operator: operator!,
                                                    circle: circle!.stateName,
                                                    amount: amount,
                                                    mobile: number,
                                                  ),
                                                ),
                                              );
                                            } catch (e, st) {
                                              print('Error navigating to RechargeDetailScreen: $e');
                                              print(st);
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text("Something went wrong: $e")),
                                              );
                                            }
                                          },

                                          // borderRadius: BorderRadius.circular(7.0),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  Color(0xFFE95168), // Pink
                                                  Color(0xFFBA68C8), // Purple
                                                ],
                                              ),
                                              borderRadius: BorderRadius.circular(7.0),
                                            ),
                                            child: Text(
                                              'Recharge',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }).toList(),

                    ),
                  ),
                  AppTheme.verticalSpacing(mul: 3),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }

// Helper methods like `_buildDropdownField` and `_buildTextField` remain the same.
  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      value: value,
      items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
      onChanged: onChanged,
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.normal, // This will ensure the text is not bold
      ),
    );
  }
  Widget _buildTextField({
    required String label,
    String? hint,
    required String value,
    required TextInputType keyboardType,
    required int maxLength,
    required Function(String) onChanged,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      keyboardType: keyboardType,
      maxLength: maxLength,
      onChanged: onChanged,
      validator: validator,
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.normal, // Ensure text is not bold here too
      ),
    );
  }

}
class RibbonBox extends StatelessWidget {
  final String text;

  const RibbonBox({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Color(0xFF018BD3),
        borderRadius: BorderRadius.circular(5), // Set border radius here
      ),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}

