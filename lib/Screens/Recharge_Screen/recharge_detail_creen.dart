import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user_model.dart';
import '../../providers/loginProvider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/button.dart';

class RechargeDetailScreen extends StatefulWidget {
  final OperatorModel operator;
  final String circle;
  final String mobile;
  final String amount;

  const RechargeDetailScreen({
    required this.operator,
    required this.circle,
    required this.mobile,
    required this.amount,
    super.key,
  });

  @override
  State<RechargeDetailScreen> createState() => _RechargeDetailScreenState();
}

class _RechargeDetailScreenState extends State<RechargeDetailScreen> {
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  Widget _buildTextField({
    required String label,
    String? hint,
    required String value,
    required TextInputType keyboardType,
    required int maxLength,
    required Function(String) onChanged,
    String? Function(String?)? validator,
    bool enabled = true,
    bool readOnly = false,
  }) {
    return TextFormField(
      initialValue: value,
      enabled: enabled,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
      onChanged: onChanged,
      validator: validator,
      style: const TextStyle(color: Colors.grey),
      maxLength: maxLength,
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProviderScreen>(context, listen: false);
    final cashback = provider.cashback;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text('Recharge')),
      body: SingleChildScrollView(
        child: Container(
          margin: AppTheme.screenPadding,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildTextField(
                    label: 'Operator',
                    value: widget.operator.operatorName,
                    enabled: false,
                    readOnly: true,
                    keyboardType: TextInputType.text,
                    maxLength: 50,
                    onChanged: (_) {},
                  ),
                  AppTheme.verticalSpacing(),
                  _buildTextField(
                    label: 'Circle',
                    value: widget.circle,
                    enabled: false,
                    readOnly: true,
                    keyboardType: TextInputType.text,
                    maxLength: 50,
                    onChanged: (_) {},
                  ),
                  AppTheme.verticalSpacing(),
                  _buildTextField(
                    label: 'Mobile No.',
                    value: widget.mobile,
                    keyboardType: TextInputType.phone,
                    maxLength: 15,
                    onChanged: (_) {},
                    enabled: true,
                    readOnly: true,
                    validator: (val) => val == null || val.isEmpty ? 'Enter valid number' : null,
                  ),
                  AppTheme.verticalSpacing(),
                  _buildTextField(
                    label: 'Amount',
                    value: widget.amount,
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    onChanged: (_) {},
                    enabled: true,
                    readOnly: true,
                    validator: (val) => val == null || val.isEmpty ? 'Enter valid amount' : null,
                  ),
                  AppTheme.verticalSpacing(mul: 2),
                  if (cashback.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Text(
                        '${cashback.first.cashback} ${cashback.first.commType == 'Percentage' ? '%' : '\u{20B9}'} Cashback',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ),
                  AppTheme.verticalSpacing(mul: 2),
                  CustomElevatedBtn(
                    isBigSize: true,
                    onPressed:
                    // isLoading
                    //     ? null
                    //     :
                        () async {
                      // if (!formKey.currentState!.validate()) return;
                      //
                      // setState(() => isLoading = true);
                      //
                      // final response = await provider.prepaidRecharge(
                      //   number: widget.mobile,
                      //   amount: widget.amount,
                      //   operator: widget.operator.id.toString(),
                      // );
                      //
                      // setState(() => isLoading = false);
                      //
                      // final isSuccess = response['success'] ?? false;
                      // final message = response['message'] ?? 'Something went wrong';
                      //
                      // if (!mounted) return;
                      //
                      // showDialog(
                      //   context: context,
                      //   builder: (_) => Dialog(
                      //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      //     child: Padding(
                      //       padding: const EdgeInsets.all(16),
                      //       child: Column(
                      //         mainAxisSize: MainAxisSize.min,
                      //         children: [
                      //           CircleAvatar(
                      //             radius: 30,
                      //             backgroundColor: isSuccess ? Colors.green : Colors.red,
                      //             child: Icon(
                      //               isSuccess ? Icons.check_circle : Icons.error,
                      //               color: Colors.white,
                      //               size: 40,
                      //             ),
                      //           ),
                      //           const SizedBox(height: 10),
                      //           Text(
                      //             isSuccess ? 'Recharge Successful' : 'Recharge Failed',
                      //             style: TextStyle(
                      //               fontSize: 18,
                      //               fontWeight: FontWeight.bold,
                      //               color: isSuccess ? Colors.green : Colors.red,
                      //             ),
                      //           ),
                      //           const SizedBox(height: 10),
                      //           Text(
                      //             message,
                      //             style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      //               fontSize: 14,
                      //               color: Colors.black54,
                      //             ),
                      //             textAlign: TextAlign.center,
                      //           ),
                      //           TextButton(
                      //             onPressed: () {
                      //               Navigator.of(context).pop();
                      //               if (isSuccess) Navigator.of(context).pop();
                      //             },
                      //             child: const Text(
                      //               'OK',
                      //               style: TextStyle(fontSize: 15, color: Colors.blueAccent),
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // );
                    },
                    text: isLoading ? 'Please Wait...' : 'Proceed to Recharge',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
