import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../models/user_model.dart'; // Assuming this is the correct path for OperatorModel
import '../../providers/loginProvider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/button.dart';

class DthRechargeScreen extends StatefulWidget {
  const DthRechargeScreen({super.key});

  @override
  State<DthRechargeScreen> createState() => _DthRechargeScreenState();
}

class _DthRechargeScreenState extends State<DthRechargeScreen> {
  OperatorModel? operator;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var provider = context.read<ProviderScreen>();
      await provider.getRechargeOperator();
      if (provider.operatorModel.isNotEmpty) {
        setState(() {
          operator = provider.operatorModel.first;
        });
      }
    });
    super.initState();
  }

  bool isLoading = false;
  String amount = '';
  String number = '';

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ProviderScreen>(context);
    if (provider.operatorModel.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Recharge your DTH'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recharge your DTH'),
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
                        value: operator!.operatorName,
                        items: provider.operatorModel.map((e) => e.operatorName).toList(),
                        onChanged: (val) {
                          setState(() {
                            operator = provider.operatorModel.firstWhere(
                                  (e) => e.operatorName == val,
                            );
                          });
                        },
                      ),
                      const SizedBox(height: 16),
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
                      const SizedBox(height: 16),
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

                    // FIX: Pass the operator code directly from the state variable.
                    var res = await provider.dthRecharge(
                      number: number,
                      amount: amount,
                      operator: operator!.operatorCode.toString(),
                    );

                    setState(() {
                      isLoading = false;
                    });

                    bool isSuccess = res['success'] == true;
                    String message = res['message'] ?? 'Something went wrong.';

                    showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Container(
                          constraints: const BoxConstraints(
                            maxHeight: 260,
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
                                  isSuccess ? Icons.check_circle : Icons.error,
                                  color: isSuccess ? Colors.green : Colors.red,
                                  size: 40,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                isSuccess ? 'Recharge Successful' : 'Recharge Failed',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: isSuccess ? Colors.green : Colors.red,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                message,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 20),
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text(
                                  'OK',
                                  style: TextStyle(
                                    fontSize: 14,
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

  // ... (Your helper methods `_buildDropdownField` and `_buildTextField` are fine as is)
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
      style: const TextStyle(
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
    required int maxLength, // maxLength को फ़ंक्शन में जोड़ें
    required Function(String) onChanged,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        counterText: '', // इससे 1/10 जैसा टेक्स्ट हट जाएगा
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
      maxLength: maxLength, // यहां maxLength को पास करें
      onChanged: onChanged,
      validator: validator,
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.normal,
      ),
    );
  }
}