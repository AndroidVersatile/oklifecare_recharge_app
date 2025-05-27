import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../constants/assets.dart';
import '../../models/recharge_model.dart';
import '../../providers/loginProvider.dart';
import '../../routing/app_pages.dart';
import '../../theme/app_theme.dart';
import '../../widgets/button.dart';
import '../../widgets/date_utils.dart';
import '../../widgets/error_utils.dart';
import '../../widgets/file_picker.dart';

import '../../widgets/textfield.dart';
import '../noData_screen.dart';

class FundsRechargeScreen extends StatefulWidget {
  const FundsRechargeScreen({super.key});

  @override
  State<FundsRechargeScreen> createState() => _FundsRechargeScreenState();
}

class _FundsRechargeScreenState extends State<FundsRechargeScreen>
    with SingleTickerProviderStateMixin {
  String? _selectedCarrier;

  final List<String> _carriers = [
    'IMPS',
  ];
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final provider = context.read<ProviderScreen>();

      // await provider.getAccountDetails();
      await provider.getDepositFundDetails();
      await provider.getBeneficiary();
      await provider.getWithdrawalFundDetails();
      await provider.getBankDetailShow();
      // await provider.getDepositList();
      // await provider.getwithdrawlList();

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ProviderScreen>(context);
    var deposit = provider.depositDetailModel;
    var withdraw = provider.withdrawalDetailModel;
    var bankdetail = provider.bankDetailShowModel;
    var depositList = provider.deposits;
    var withdrawList = provider.withdrawal;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Fund'),
          bottom: const TabBar(
            // controller: _tabController,
            tabs: [
              Tab(text: 'Deposit'),
              Tab(text: 'Withdrawal'),
            ],
          ),
        ),
        body: TabBarView(
            // controller: _tabController,
            children: [
              Container(
                padding: AppTheme.screenPadding,
                height: context.screenHeight,
                width: context.screenWidth,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage(Assets.verifyBg),
                  fit: BoxFit.cover,
                )),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AppTheme.verticalSpacing(),
                      Container(
                        padding: AppTheme.screenPadding,
                        height: context.screenHeight,
                        width: context.screenWidth,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(Assets.verifyBg),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: SingleChildScrollView(
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Stack(children: [
                                  depositList.isNotEmpty
                                      ? Image.network(
                                          depositList[0].imgPath,
                                          height: 150,
                                          width: context.screenWidth,
                                          fit: BoxFit.fill,
                                        )
                                      : Container(
                                          height: 150,
                                          width: context.screenWidth,
                                          color: Colors.grey,
                                          child: Center(
                                            child: Text(
                                              'No Image Available',
                                              style:
                                                  context.textTheme.bodyMedium,
                                            ),
                                          ),
                                        ),
                                  Positioned(
                                    top: 90,
                                    left: 10,
                                    child: CustomElevatedBtn(
                                      isUpperCase: false,
                                      onPressed: () {
                                        context.push(
                                            AppPages.depositRequestFormScreen);
                                      },
                                      text: 'Deposit Amount',
                                    ),
                                  ),
                                ]),
                                if (deposit.isNotEmpty) ...[
                                  Text(
                                    'Deposit Details:-',
                                    style: context.textTheme.titleMedium,
                                  ),
                                  AppTheme.verticalSpacing(),
                                  Container(
                                    padding: AppTheme.screenPadding,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          AppTheme.radius),
                                      color: Colors.grey.shade100,
                                      boxShadow: [
                                        BoxShadow(
                                          spreadRadius: 0.2,
                                          blurRadius: 2,
                                          color: context.colorScheme.shadow
                                              .withOpacity(0.4),
                                        ),
                                      ],
                                    ),
                                    child: deposit.isNotEmpty
                                        ? Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: deposit.map((datum) {
                                              return Container(
                                                padding: AppTheme.screenPadding,
                                                margin: const EdgeInsets.only(
                                                    bottom: 10),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          AppTheme.radius),
                                                  color: Colors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      spreadRadius: 0.2,
                                                      blurRadius: 2,
                                                      color: context
                                                          .colorScheme.shadow
                                                          .withOpacity(0.4),
                                                    ),
                                                  ],
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Amount: ${datum.amount}',
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    SizedBox(height: 5),
                                                    Text(
                                                      'Pay Mode: ${datum.payModeName}',
                                                      style: const TextStyle(
                                                          fontSize: 14),
                                                    ),
                                                    Text(
                                                      'Transaction No: ${datum.transactionId}',
                                                      style: const TextStyle(
                                                          fontSize: 14),
                                                    ),
                                                    SizedBox(height: 5),
                                                    Container(
                                                      margin: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 10),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: Colors
                                                            .grey.shade200,
                                                      ),
                                                      child: datum.uploadIMage
                                                              .isNotEmpty
                                                          ? Image.network(
                                                              datum.uploadIMage,
                                                              height: 150,
                                                              width: double
                                                                  .infinity,
                                                              fit: BoxFit.cover,
                                                            )
                                                          : Center(
                                                              child: Text(
                                                                'No Receipt Available',
                                                                style: context
                                                                    .textTheme
                                                                    .bodyMedium,
                                                              ),
                                                            ),
                                                    ),
                                                    SizedBox(height: 5),
                                                    Text(
                                                      'Date: ${DatesUtils.getFormattedDateFromDateTime(DatesUtils.convertDateTime(datum.tDate))}',
                                                      style: const TextStyle(
                                                          fontSize: 14),
                                                    ),
                                                    Text(
                                                      'Status: ${datum.paymentStatus}',
                                                      style: const TextStyle(
                                                          fontSize: 14),
                                                    ),
                                                    Text(
                                                      'Bank Name: ${datum.bankName}',
                                                      style: const TextStyle(
                                                          fontSize: 14),
                                                    ),
                                                    SizedBox(height: 5),
                                                    Text(
                                                      'Remark: ${datum.remark}',
                                                      style: const TextStyle(
                                                          fontSize: 14),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }).toList(),
                                          )
                                        : NoDataScreen(),
                                  ),

                                ],
                                AppTheme.verticalSpacing(mul: 25),
                              ],
                            ),
                          ),
                        ),
                      ),
                      AppTheme.verticalSpacing(mul: 3),
                    ],
                  ),
                ),
              ),
              Container(
                padding: AppTheme.screenPadding,
                height: context.screenHeight,
                width: context.screenWidth,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage(Assets.verifyBg),
                  fit: BoxFit.cover,
                )),
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Stack(children: [
                          withdrawList.isNotEmpty
                              ? Image.network(
                                  withdrawList[0].imgPath,
                                  height: 150,
                                  width: context.screenWidth,
                                  fit: BoxFit.fill,
                                )
                              : Container(
                                  height: 150,
                                  width: context.screenWidth,
                                  color: Colors.grey,
                                  child: Center(
                                    child: Text(
                                      'No Image Available',
                                      style: context.textTheme.bodyMedium,
                                    ),
                                  ),
                                ),
                          Positioned(
                            top: 90,
                            left: 10,
                            child: CustomElevatedBtn(
                                isUpperCase: false,
                                onPressed: () {
                                  context
                                      .push(AppPages.withdrawRequestFormScreen);
                                },
                                text: 'Withdraw'),
                          )
                        ]),
                        AppTheme.verticalSpacing(mul: 3),
                        if (withdraw.isNotEmpty) ...[
                          Text(
                            'Withdrawal Details:-',
                            style: context.textTheme.titleMedium,
                          ),
                          AppTheme.verticalSpacing(),
                          Container(
                            padding: AppTheme.screenPadding,
                            width: context
                                .screenWidth, // Set width to match the screen
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(AppTheme.radius),
                              color: Colors.grey.shade100,
                              boxShadow: [
                                BoxShadow(
                                  spreadRadius: 0.2,
                                  blurRadius: 2,
                                  color: context.colorScheme.shadow
                                      .withOpacity(0.4),
                                ),
                              ],
                            ),
                            child: withdraw != null && withdraw.isNotEmpty
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: withdraw.map((datum) {
                                      return Container(
                                        padding: AppTheme.screenPadding,
                                        margin:
                                            const EdgeInsets.only(bottom: 10),
                                        width: double
                                            .infinity, // Ensures full width
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              AppTheme.radius),
                                          color:
                                              Colors.white, // Inside box color
                                          boxShadow: [
                                            BoxShadow(
                                              spreadRadius: 0.2,
                                              blurRadius: 2,
                                              color: context.colorScheme.shadow
                                                  .withOpacity(0.4),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Amount: ${datum.amount}',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                               'Date: ${DatesUtils.getFormattedDateFromDateTime(DatesUtils.convertDateTime(datum.reqDate))}',
                                              style:
                                                  const TextStyle(fontSize: 14),
                                           ),
                                            Text(
                                              'Status: ${datum.withdrawalStatus}',
                                              style:
                                                  const TextStyle(fontSize: 14),
                                            ),
                                            Text(
                                              'Beneficary Detail: ${datum.bankName}',
                                              style:
                                                  const TextStyle(fontSize: 14),
                                            ),


                                            const SizedBox(height: 5),
                                            Text(
                                              'Remark: ${datum.remark}',
                                              style:
                                              const TextStyle(fontSize: 14),
                                            ),

                                          ],

                                        ),

                                      );

                                    }).toList(),

                                  )
                                : NoDataScreen(),
                          ),
                          const SizedBox(height: 30),
                        ]
                      ],
                    ),
                  ),
                ),
              ),
            ]),
      ),
    );
  }
}

class DepositRequestFormScreen extends StatefulWidget {
  const DepositRequestFormScreen({super.key});

  @override
  State<DepositRequestFormScreen> createState() => _DepositRequestFormScreenState();
}

class _DepositRequestFormScreenState extends State<DepositRequestFormScreen> {
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  String points = '';
  String utr = '';
  String currentPayMode = '';
  int currentPayModeId = 0;
  String remark = '';
  File? receiptFile;
  Image? receiptImage;
  String? receiptFileType;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<ProviderScreen>().getPayModeList();
      await context.read<ProviderScreen>().getBankDetailList();
      currentPayModeId = context.read<ProviderScreen>().payMode.first.id;
      currentPayMode = context.read<ProviderScreen>().payMode.first.paymode;
      setState(() {});
    });
  }

  void _pickReceiptFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg'],
    );

    if (result != null && result.files.isNotEmpty) {
      PlatformFile file = result.files.single;
      receiptFile = File(file.path!);
      receiptFileType = file.extension;

      if (['jpg', 'jpeg', 'png'].contains(receiptFileType)) {
        receiptImage = Image.file(receiptFile!);
      }

      setState(() {});
    } else {
      ErrorUtils.showSimpleInfoDialog(context, message: 'No file selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ProviderScreen>(context);
    var payMode = provider.payMode;

    return Scaffold(
      appBar: AppBar(title: const Text('Deposit Request')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppTheme.screenPadding,
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomTextFormField(
                  hintText: 'Amount',
                  onChanged: (val) {
                    points = val;
                    setState(() {});
                  },
                  validator: (val) => val!.isEmpty ? 'Enter amount' : null,
                  value: points,
                ),
                AppTheme.verticalSpacing(),
                CustomDropDownButton(
                  fillColor: const Color(0xFFF1F6FB),
                  items: payMode.map((e) => e.paymode).toList(),
                  label: 'Pay Mode',
                  onSelect: (val) {
                    currentPayMode = val;
                    var data = provider.payMode
                        .where((element) => element.paymode == val)
                        .toList();
                    if (data.isNotEmpty) {
                      currentPayModeId = data.first.id;
                    }

                    if (currentPayMode == 'UPI') {
                      provider.getUPIDetailList();
                    } else {
                      provider.getBankDetailList();
                    }
                    setState(() {});
                  },
                  initialSelection: currentPayMode,
                ),
                AppTheme.verticalSpacing(),

                if (provider.upiDetail.isNotEmpty && currentPayMode == 'UPI') ...[
                  Image.network(
                    'http://uonely.versatileitsolution.com/managepanel/${provider.upiDetail.first.imgPath}',
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                  AppTheme.verticalSpacing(),
                  Row(
                    children: [
                      Expanded(
                        child: SelectableText(
                          'UPI Id: ${provider.upiDetail.first.upiId}',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy, color: Colors.blue),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(
                            text: provider.upiDetail.first.upiId,
                          )).then((_) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('UPI ID copied to clipboard!')),
                            );
                          });
                        },
                      ),
                    ],
                  ),
                ],

                if (provider.bankDetail.isNotEmpty && currentPayMode == 'Bank') ...[
                  SelectableText(
                    'Bank Name: ${provider.bankDetail.first.bankName}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  AppTheme.verticalSpacing(),
                  SelectableText(
                    'Branch Name: ${provider.bankDetail.first.branchName}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  AppTheme.verticalSpacing(),
                  Row(
                    children: [
                      Expanded(
                        child: SelectableText(
                          'IFSC Code: ${provider.bankDetail.first.ifscCode}',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy, color: Colors.blue),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(
                            text: provider.bankDetail.first.ifscCode ?? '',
                          )).then((_) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('IFSC Code copied to clipboard!')),
                            );
                          });
                        },
                      ),
                    ],
                  ),
                  AppTheme.verticalSpacing(),
                  Row(
                    children: [
                      Expanded(
                        child: SelectableText(
                          'Acc. No.: ${provider.bankDetail.first.acNo}',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy, color: Colors.blue),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(
                            text: provider.bankDetail.first.acNo ?? '',
                          )).then((_) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Account Number copied to clipboard!')),
                            );
                          });
                        },
                      ),
                    ],
                  ),
                ],

                AppTheme.verticalSpacing(),
                CustomTextFormField(
                  hintText: 'UTR No.',
                  onChanged: (val) {
                    utr = val;
                    setState(() {});
                  },
                  validator: (val) => val!.isEmpty ? 'Enter UTR No' : null,
                  value: utr,
                ),
                AppTheme.verticalSpacing(),
                ChooseFilePicker(
                  title: 'Upload receipt',
                  onFileSelected: (file) {
                    _pickReceiptFile();
                  },
                  type: '',
                ),
                if (receiptImage != null) ...[
                  AppTheme.verticalSpacing(),
                  const Text(
                    'Receipt Preview:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  AppTheme.verticalSpacing(),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      height: 130,
                      child: receiptImage!,
                    ),
                  ),
                ],
                AppTheme.verticalSpacing(),
                CustomTextFormField(
                  hintText: 'Remark',
                  onChanged: (val) {
                    remark = val;
                    setState(() {});
                  },
                  validator: (val) => val!.isEmpty ? 'Enter remark' : null,
                  value: remark,
                ),
                AppTheme.verticalSpacing(mul: 2),
                CustomElevatedBtn(
                  text: isLoading ? 'Please wait...' : 'Proceed',
                  isBigSize: true,
                  onPressed: isLoading
                      ? null
                      : () async {
                    if (!formKey.currentState!.validate()) {
                      return;
                    }

                    if (receiptFile == null) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.orangeAccent,
                                child: Icon(Icons.upload_file, size: 40, color: Colors.white),
                              ),
                              SizedBox(height: 16),
                              Text(
                                "Please upload a receipt.",
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("OK"),
                            ),
                          ],
                        ),
                      );
                      return;
                    }

                    setState(() => isLoading = true);

                    try {
                      String receiptBase64 = base64.encode(await receiptFile!.readAsBytes());
                      var res = await provider.submitDepositRequest(
                        context: context,
                        points: points,
                        payMode: currentPayModeId.toString(),
                        utr: utr,
                        remark: remark,
                        bankID: currentPayModeId.toString(),
                        imageCode: receiptBase64,
                      );
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: res['Status'] == "True"
                                    ? Colors.green.withOpacity(0.2)
                                    : Colors.red.withOpacity(0.2),
                                child: Icon(
                                  res['Status'] == "True"
                                      ? Icons.check_circle_outline
                                      : Icons.error_outline,
                                  size: 50,
                                  color: res['Status'] == "True" ? Colors.green : Colors.red,
                                ),
                              ),

                              const SizedBox(height: 16),
                              Text(
                                res['Status'] == "True"
                                    ? "Your deposit request of ₹$points has been received. It will be processed shortly. Thank you!"
                                    : "Your deposit request of ₹$points has failed. Please try again!",
                                textAlign: TextAlign.justify,

                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);

                              },
                              child: const Text("OK"),
                            ),
                          ],
                        ),
                      );
                      Future.delayed(Duration(seconds: 2));
                      context.pushNamed(AppPages.walletStatement);
                    } catch (e) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.redAccent,
                                child: Icon(Icons.error_outline, size: 40, color: Colors.white),
                              ),
                              SizedBox(height: 16),
                              Text(
                                "An error occurred. Please try again.",
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("OK"),
                            ),
                          ],
                        ),
                      );
                    } finally {
                      setState(() => isLoading = false);
                    }
                  },


                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class WithdrawRequestFormScreen extends StatefulWidget {
  const WithdrawRequestFormScreen({super.key});

  @override
  State<WithdrawRequestFormScreen> createState() =>
      _WithdrawRequestFormScreenState();
}

class _WithdrawRequestFormScreenState extends State<WithdrawRequestFormScreen> {
  final formKey = GlobalKey<FormState>();
  String points = '';

  String remark = '';
  bool isLoading = false; // Declare the loading state

  File? receiptFile;
  List<BeneficaryModel> bank = List.empty(
    growable: true,
  );
  @override
  void initState() {
    super.initState();
    final provider = Provider.of<ProviderScreen>(context, listen: false);
    provider.getBeneficiary();
    // call the API here
  }
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ProviderScreen>(context);
    var beneficarylist = provider.beneficiaryModel;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Withdrawal Request'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: AppTheme.screenPadding,
          height: context.screenHeight,
          width: context.screenWidth,
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage(Assets.verifyBg),
            fit: BoxFit.cover,
          )),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomTextFormField(
                  fillColor: true,
                  hintText: 'Balance',
                  enabled: false,
                  value: provider.currentWalletBalance.toString(),
                ),
                AppTheme.verticalSpacing(),
                CustomTextFormField(
                  hintText: 'Amount',
                  onChanged: (val) {
                    points = val;
                    setState(() {});
                  },
                  validator: (val) {
                    return null;
                  },
                  value: points,
                ),

                AppTheme.verticalSpacing(),
                CustomDropDownButton(
                  items:beneficarylist.map((e) => e.bank).toList(),
                  label: "Select Beneficiary",
                  initialSelection: provider.currentBank,
                  onSelect: (val) {
                    provider.currentBank = val;
                    provider.notifyListeners();
                  },
                ),
                AppTheme.verticalSpacing(),
                CustomTextFormField(
                  hintText: 'Remark',
                  onChanged: (val) {
                    remark = val;
                    setState(() {});
                  },
                  validator: (val) {
                    return null;
                  },
                  value: remark,
                ),
                AppTheme.verticalSpacing(mul: 2),
                CustomElevatedBtn(
                  text: isLoading ? 'Please wait...' : 'Proceed',
                  isBigSize: true,
                  onPressed: isLoading
                      ? null
                      : () async {
                    if (!formKey.currentState!.validate()) return;

                    setState(() {
                      isLoading = true;
                    });

                    final provider = Provider.of<ProviderScreen>(context, listen: false);
                    final selectedBank = provider.beneficiaryModel.firstWhere(
                            (element) => element.bank == provider.currentBank,
                        orElse: () => BeneficaryModel(id: 0, bank: ''));

                    try {
                      var res = await provider.submitWithdrawalRequest(
                         amount:  points,
                        bankID: selectedBank.id.toString(),
                        remarks : remark,
                      );

                      if (res['statusCode'] == 200 &&
                          res['data']['Status'] == 'True') {
                        showIconDialog(
                          context: context,
                          icon: Icons.check_circle,
                          iconColor: Colors.green,
                          message: res['data']['Message'] ?? "Request successful",
                        );

                      } else {
                        showIconDialog(
                          context: context,
                          icon: Icons.error,
                          iconColor: Colors.red,
                          message:
                          res['data']['Message'] ?? "An error occurred. Please try again.",
                        );
                      }
                    } catch (e) {
                      showIconDialog(
                        context: context,
                        icon: Icons.warning,
                        iconColor: Colors.orange,
                        message: "An error occurred. Please try again.",
                      );
                    } finally {
                      setState(() {
                        isLoading = false;
                      });
                    }
                  },

                )


              ],
            ),
          ),
        ),
      ),
    );
  }
  void showIconDialog({
    required BuildContext context,
    required String message,
    required IconData icon,
    Color iconColor = Colors.green,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false, // optional: disable tap outside to close
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 10,
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, size: 60, color: iconColor),
              const SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(); // ✅ close the dialog
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4),
                    child: Text(
                      'Ok',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue, // ✅ neutral color
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



}
