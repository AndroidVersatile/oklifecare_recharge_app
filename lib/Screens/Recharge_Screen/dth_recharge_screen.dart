import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../providers/loginProvider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/button.dart';

class DthRechargeScreen extends StatefulWidget {
  const DthRechargeScreen({super.key});

  @override
  State<DthRechargeScreen> createState() => _DthRechargeScreenState();
}

class _DthRechargeScreenState extends State<DthRechargeScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      // await context.read<ProviderScreen>().getRechargeOperator('RA==');
    });
    super.initState();
  }

  bool isLoading = false;
  String amount = '';
  String number = '';
  String operator = '';
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ProviderScreen>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Recharge your DTH'),
      ),
      body: SingleChildScrollView(
        padding: AppTheme.screenPadding,
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Operator Dropdown inside the Card
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
                        value: operator.isEmpty
                            ? provider.operatorModel.first.operatorName
                            : operator,
                        items: provider.operatorModel
                            .map((e) => e.operatorName)
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            operator = val!;
                          });
                        },
                      ),
                      const SizedBox(height: 16), // Space

                      // Mobile Number Field
                      _buildTextField(
                        label: 'Enter DTH No.',
                        value: number,
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        onChanged: (val) {
                          setState(() {
                            number = val;
                          });
                        },
                        validator: (val) {
                          if (val == null || val.length != 10) {
                            return 'Enter a valid 10-digit number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16), // Space

                      // Amount Field
                      _buildTextField(
                        label: 'Enter Amount',
                        value: amount,
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        onChanged: (val) {
                          setState(() {
                            amount = val;
                          });
                        },
                        validator: (val) {
                          if (val == null || double.tryParse(val) == null) {
                            return 'Enter a valid amount';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // Proceed Button
              AppTheme.verticalSpacing(mul: 2),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: CustomElevatedBtn(
                  isBigSize: true,
                  onPressed: isLoading
                      ? null
                      : () async {
                          if (!formKey.currentState!.validate()) return;
                          setState(() {
                            isLoading = true;
                          });

                          // Get the operator code for the selected operator name
                          final selectedOperator =
                              provider.operatorModel.firstWhere(
                            (e) => e.operatorName == operator,
                            orElse: () => provider.operatorModel.first,
                          );

                          var res = await provider.dthRecharge(
                            number: number,
                            amount: amount,
                            operator: selectedOperator.operatorCode
                                .toString(), // Pass the operator code
                          );

                          setState(() {
                            isLoading = false;
                          });

                          // FIX: Check for the 'success' key and get the 'message'
                          bool isSuccess = res['success'] == true;
                          String message =
                              res['message'] ?? 'Something went wrong.';

                          showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              child: Container(
                                constraints: BoxConstraints(
                                  maxHeight: 250,
                                ),
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircleAvatar(
                                      radius: 30,
                                      backgroundColor: isSuccess
                                          ? Colors.green.shade100
                                          : Colors.red.shade100,
                                      child: Icon(
                                        isSuccess
                                            ? Icons.check_circle
                                            : Icons.error,
                                        color: isSuccess
                                            ? Colors.green
                                            : Colors.red,
                                        size: 40,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      isSuccess
                                          ? 'Recharge Successful'
                                          : 'Recharge Failed',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: isSuccess
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      message, // Use the message from the API response
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 20),
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text(
                                        'OK',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.blueAccent,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                  text: isLoading ? 'Please Wait...' : 'Proceed to Recharge',
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
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
      items: items
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: onChanged,
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.normal,
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
        labelStyle: TextStyle(fontWeight: FontWeight.normal),
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
      // maxLength: maxLength,
      onChanged: onChanged,
      validator: validator,
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.normal,
      ),
    );
  }
}
