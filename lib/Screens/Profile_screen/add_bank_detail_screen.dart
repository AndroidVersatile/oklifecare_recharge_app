import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../constants/assets.dart';
import '../../providers/loginProvider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/button.dart';
import '../../widgets/textfield.dart';

class AddBankDetailScreen extends StatefulWidget {
  const AddBankDetailScreen({super.key});

  @override
  State<AddBankDetailScreen> createState() => _AddBankDetailScreenState();
}

class _AddBankDetailScreenState extends State<AddBankDetailScreen> {
  final formKey = GlobalKey<FormState>();
  String branchName = '';
  String accountNo = '';
  String ifscCode = '';
  String beneficiaryName = '';
  String panCard = '';
  bool isBankDetailSubmitted = false; // flag to control message display

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var provider = context.read<ProviderScreen>();
      await provider.fetchBankName();
      await provider.getBankDetailAllDataShow();
    });
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ProviderScreen>(context);
    var bankList = provider.selectBankModel;
    var bankDetails = provider.addBankDetailshowDataModel;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Bank'),
      ),
      body: Container(
        padding: AppTheme.screenPadding,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.verifyBg),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppTheme.verticalSpacing(),
                    CustomDropDownButton(
                      items: bankList.map((e) => e.bankName).toList(),
                      label: "Select Bank",
                      initialSelection: provider.currentBank,
                      onSelect: (val) {
                        provider.currentBank = val;
                        provider.notifyListeners();
                      },
                    ),
                    AppTheme.verticalSpacing(),
                    CustomTextFormField(
                      hintText: 'Branch Name',
                      onChanged: (val) => branchName = val,
                      validator: (val) =>
                      val!.isEmpty ? 'Enter a valid branch name' : null,
                    ),
                    AppTheme.verticalSpacing(),
                    CustomTextFormField(
                      hintText: 'Account No',
                      onChanged: (val) => accountNo = val,
                      validator: (val) =>
                      val!.isEmpty ? 'Enter a valid account number' : null,
                    ),
                    AppTheme.verticalSpacing(),
                    CustomTextFormField(
                      hintText: 'IFSC Code',
                      onChanged: (val) => ifscCode = val,
                      validator: (val) =>
                      val!.isEmpty ? 'Enter a valid IFSC code' : null,
                    ),
                    AppTheme.verticalSpacing(),
                    CustomTextFormField(
                      hintText: 'Beneficiary Name',
                      onChanged: (val) => beneficiaryName = val,
                      validator: (val) => val!.isEmpty
                          ? 'Enter a valid beneficiary name'
                          : null,
                    ),
                    AppTheme.verticalSpacing(),
                    CustomTextFormField(
                      hintText: 'PAN Card',
                      onChanged: (val) => panCard = val,
                      validator: (val) =>
                      val!.isEmpty ? 'Enter a valid PAN card number' : null,
                    ),
                    AppTheme.verticalSpacing(),
                    CustomElevatedBtn(
                      isBigSize: true,
                      onPressed: () async {
                        if (!formKey.currentState!.validate()) return;

                        if (bankDetails != null && bankDetails.isNotEmpty) {
                          Fluttertoast.showToast(
                            msg: "You can submit bank details only once.",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.black54,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                          return;
                        }

                        var selectedBank = provider.selectBankModel.firstWhere(
                              (element) => element.bankName == provider.currentBank,
                        );

                        await provider.updateBankDetails(
                          bankId: selectedBank.bankCode.toString(),
                          branchName: branchName,
                          accountNo: accountNo,
                          ifscCode: ifscCode,
                          beneficiaryName: beneficiaryName,
                          panCard: panCard,
                        );

                        setState(() {
                          isBankDetailSubmitted = true;
                        });

                        await provider.getBankDetailAllDataShow();

                        Fluttertoast.showToast(
                          msg: "Bank details submitted successfully!",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                      },
                      text: 'SUBMIT',
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
