import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../models/recharge_model.dart';
import '../../providers/loginProvider.dart';
import '../../routing/app_pages.dart';

class RechargePlanScreen extends StatefulWidget {
  const RechargePlanScreen({Key? key}) : super(key: key);

  @override
  State<RechargePlanScreen> createState() => _RechargePlanScreenState();
}

class _RechargePlanScreenState extends State<RechargePlanScreen> with TickerProviderStateMixin {
  TabController? _tabController;
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _mobileNumber = '';
  String _searchQuery = '';
  bool _isLoading = false;
  int _selectedPlanIndex = -1;
  int _selectedTabIndex = 0;
  final Map<String, String> _operatorLogos = {
    'Airtel': 'assets/airtel-logo-icon.png',
    'BSNL': 'assets/bsnl-logo-icon.png',
    'Jio': 'assets/jio-logo-icon.png',
    'Vodafone': 'assets/vodafone-icon.png',
    'VI': 'assets/vodafone-icon.png',
  };
  final Color _primaryColor = const Color(0xFFA05FF0);
  final Color _secondaryColor = const Color(0xFF6A40F0);
  final Color _greenColor = const Color(0xFF4CAF50);

  @override
  void initState() {
    super.initState();
    _numberController.addListener(() => _onMobileNumberChanged(_numberController.text));
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase().trim();
        _selectedPlanIndex = -1;
      });
    });
  }

  void _resetState() {
    _numberController.clear();
    _searchController.clear();
    _mobileNumber = '';
    _searchQuery = '';
    _selectedPlanIndex = -1;
    final provider = context.read<ProviderScreen>();
    provider.clearPlansAndOperator();
    if (_tabController != null) {
      _tabController!.dispose();
      _tabController = null;
    }
    setState(() {});
  }
  @override
  void dispose() {
    _tabController?.dispose();
    _numberController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onMobileNumberChanged(String number) {
    if (number.length == 10) {
      if (_mobileNumber != number) {
        setState(() {
          _mobileNumber = number;
          _searchController.clear();
          _searchQuery = '';
          _selectedPlanIndex = -1;
        });
        _fetchPlans();
      }
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final provider = context.read<ProviderScreen>();
        provider.clearPlansAndOperator();
        _tabController?.dispose();
        _tabController = null;
        setState(() {
          _mobileNumber = number;
          _searchController.clear();
          _searchQuery = '';
          _selectedPlanIndex = -1;
        });
      });
    }
  }

  Future<void> _fetchPlans() async {
    final provider = context.read<ProviderScreen>();
    setState(() {
      _isLoading = true;
    });
    await provider.getOperatorDetails(_mobileNumber);
    final operatorDetails = provider.operatorDetails;

    if (operatorDetails != null) {
      await provider.getRechargePlans(_mobileNumber);
      if (provider.rechargePlanList.isNotEmpty) {
        _initializeTabController(provider.rechargePlanList);
      } else {
        _tabController?.dispose();
        _tabController = null;
      }
    } else {
      _tabController?.dispose();
      _tabController = null;
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _initializeTabController(List<RechargePlan> plans) {
    final types = plans.map((p) => p.type).toSet().toList();
    if (types.isNotEmpty) {
      if (_tabController != null) {
        _tabController!.dispose();
      }
      _tabController = TabController(length: types.length, vsync: this);
      _tabController!.addListener(() {
        if (mounted) {
          _searchController.clear();
          setState(() {
            _searchQuery = '';
            _selectedTabIndex = _tabController!.index;
            _selectedPlanIndex = -1;
          });
        }
      });
      setState(() {
        _selectedTabIndex = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProviderScreen>();
    final operatorDetails = provider.operatorDetails;
    final planTypes = provider.rechargePlanList.map((p) => p.type).toSet().toList();

    if (planTypes.isNotEmpty && (_tabController == null || _tabController!.length != planTypes.length)) {
      _initializeTabController(provider.rechargePlanList);
    }
    if (planTypes.isEmpty && _tabController != null) {
      _tabController!.dispose();
      _tabController = null;
    }

    List<RechargePlan> filteredPlans;
    if (_searchQuery.isEmpty) {
      filteredPlans = provider.rechargePlanList
          .where((plan) => plan.type == (planTypes.isNotEmpty ? planTypes[_selectedTabIndex] : null))
          .toList();
    } else {
      final isNumeric = double.tryParse(_searchQuery) != null;
      if (isNumeric) {
        filteredPlans = provider.rechargePlanList
            .where((plan) => plan.rs.toLowerCase().trim() == _searchQuery)
            .toList();
      } else {
        filteredPlans = provider.rechargePlanList
            .where((plan) =>
        plan.desc.toLowerCase().contains(_searchQuery) ||
            plan.type.toLowerCase().contains(_searchQuery))
            .toList();
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            height: 250,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_primaryColor, _secondaryColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16.0, left: 20.0, right: 20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Mobile Recharge',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Manage your internet with ease.',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        _buildMobileNumberAndOperatorSection(operatorDetails),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    margin: const EdgeInsets.only(top: 24),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 24.0),
                        child: _isLoading
                            ? _buildLoadingIndicator()
                            : provider.rechargePlanList.isNotEmpty
                            ? Column(
                          children: [
                            _buildSearchBar(),
                            const SizedBox(height: 16),
                            if (_searchQuery.isEmpty) _buildPlanTabs(planTypes),
                            const SizedBox(height: 16),
                            _buildPlanList(filteredPlans, operatorDetails),
                          ],
                        )
                            : (operatorDetails != null
                            ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Text(
                              "No recharge plans found for this number.",
                              style: TextStyle(color: Colors.grey[600], fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                            : const SizedBox.shrink()),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileNumberAndOperatorSection(Map<String, dynamic>? operatorDetails) {
    final String operatorName = operatorDetails?['operatorName'] ?? '';
    final String? logoPath = _operatorLogos[operatorName];
    final bool isNumberValid = _mobileNumber.length == 10;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _numberController,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Enter Mobile Number',
                    labelStyle: const TextStyle(color: Colors.white70),
                    prefixIcon: const Icon(Icons.phone_android, color: Colors.white70),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 15),
                    counterText: "",
                  ),
                  validator: (value) {
                    if (value == null || value.length != 10) {
                      return 'Please enter a valid 10-digit mobile number';
                    }
                    return null;
                  },
                ),
              ),
              if (isNumberValid && logoPath != null)
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Image.asset(
                    logoPath,
                    height: 40,
                    width: 40,
                  ),
                ),
            ],
          ),
          if (isNumberValid && operatorDetails != null)
            Padding(
              padding: const EdgeInsets.only(top: 4.0, left: 10.0),
              child: Text(
                operatorDetails['stateName'] ?? '',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(15),
        ),
        child: TextFormField(
          controller: _searchController,
          style: const TextStyle(color: Colors.black87),
          decoration: InputDecoration(
            hintText: 'Search plans (e.g., 2GB, 56 days, ₹99)',
            hintStyle: TextStyle(color: Colors.grey[600]),
            prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
              icon: Icon(Icons.clear, color: Colors.grey[600]),
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _searchQuery = '';
                  _selectedPlanIndex = -1;
                });
              },
            )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          ),
        ),
      ),
    );
  }

  Widget _buildPlanTabs(List<String> planTypes) {
    if (planTypes.isEmpty) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(planTypes.length, (index) {
            final isSelected = index == _selectedTabIndex;
            return _buildCustomTab(planTypes[index], isSelected, () {
              _searchController.clear();
              setState(() {
                _selectedTabIndex = index;
                _selectedPlanIndex = -1;
              });
            });
          }),
        ),
      ),
    );
  }

  Widget _buildCustomTab(String title, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: isSelected ? _secondaryColor : Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildPlanList(List<RechargePlan> plans, Map<String, dynamic>? operatorDetails) {
    if (plans.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(
            _searchQuery.isEmpty ? "No plans found for this category." : "No plans found matching your search.",
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: plans.length,
      itemBuilder: (context, index) {
        final plan = plans[index];
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedPlanIndex = index;
            });
          },
          child: _buildPlanCard(plan, index == _selectedPlanIndex, operatorDetails),
        );
      },
    );
  }

  Widget _buildPlanCard(RechargePlan plan, bool isSelected, Map<String, dynamic>? operatorDetails) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isSelected ? _primaryColor.withOpacity(0.1) : Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: isSelected ? _primaryColor : Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                plan.type,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isSelected ? _secondaryColor : Colors.grey[800],
                ),
              ),
              if (plan.data != null)
                Text(
                  '${plan.data} GB/Day',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: isSelected ? _secondaryColor : Colors.grey[700],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '₹${plan.rs}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: _primaryColor,
                ),
              ),
              Text(
                'Validity: ${plan.validity} days',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_primaryColor, _secondaryColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: ElevatedButton(
              onPressed: ()async{
                if (_mobileNumber.length == 10) {
                  final result = await context.push(
                    AppPages.rechargePlanDetail,
                    extra: {
                      'plan': plan,
                      'mobileNumber': _mobileNumber,
                      'operatorDetails': operatorDetails,
                    },
                  );
                  if (result == true) {
                    _resetState();
                  }
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        title: const Text('Invalid Number'),
                        content: const Text(
                          'Please enter a valid 10-digit mobile number to proceed.',
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text(
                              'OK',
                              style: TextStyle(color: _secondaryColor),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text(
                'Recharge Now',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Divider(color: Colors.grey, height: 1),
          const SizedBox(height: 20),
          _buildPlanDetails(plan.desc, isSelected),
          if (plan.lastUpdate != null)
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                'Last Updated: ${plan.lastUpdate!.split('T')[0]}',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }
  Widget _buildPlanDetails(String desc, bool isSelected) {
    final parts = desc.split('|');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: parts.map((part) {
        final detail = part.trim();
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.check_circle_outline,
                color: isSelected ? _greenColor : Colors.grey[400],
                size: 18,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  detail,
                  style: TextStyle(
                    color: isSelected ? Colors.black87 : Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
  Widget _buildLoadingIndicator() {
    return Center(child: CircularProgressIndicator(color: _primaryColor));
  }
}