import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Screens/services/app_services.dart';
import '../constants/api_urls.dart';
import '../constants/app_cache.dart';
import '../models/cashback_model.dart';
import '../models/order_model.dart';
import '../models/recharge_model.dart';
import '../models/user_model.dart';
import '../models/login_model.dart';
import '../models/wallet_statement_model.dart';
import '../widgets/error_utils.dart';

class ProviderScreen extends ChangeNotifier {
  UserDetailModel? _userDetail;
  double currentWalletBalance = 0.0;
  BalanceModel? _walletBalance;
  BalanceModel? get walletBalance => _walletBalance;
  bool _isLoading = false;
  String? _errorMessage;
  String userFormNo = '';
  final AppCache cache = AppCache();
  final _apiClient = APIService.ApiClient();
  String currentBank = '';
  UserDetailModel? get userDetail => _userDetail;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<WalletStatementModel> walletList = List.empty(growable: true);
  List<OperatorModel> operatorModel = [];
  List<CircleModel> circleList = List.empty(growable: true);
  List<CashBackShowModel> cashBackShowModel = List.empty(growable: true);
  List<RechargePlanModel> rechargePlanList = List.empty(growable: true);
  List<RechargePlanModel> filteredRechargePlanList = List.empty(growable: true);
  List<SelectBankModel> selectBankModel = List.empty(growable: true);
  List<AddBankDetailshowDataModel> addBankDetailshowDataModel =
  List.empty(growable: true);
  List<CashbackReportModel> dthCashbackReportList = List.empty(growable: true);
  update() {
    notifyListeners();
  }
  String? _mobileNo;
  String? get mobileNo => _mobileNo;
  Future<Map<String, dynamic>> loginUser(String userId, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final String baseUrl =
          "https://oklifecare.com/Dashboard/API/RechargeAPI.aspx?reqtype=idlogin";

      final Map<String, String> requestBody = {
        "loginid": userId,
        "loginpwd": password
      };

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          "Content-Type": "application/json", // raw JSON body ke liye
        },
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("Login API Response: $data");
        if (data['Status'] == 'True') {
          final appCache = AppCache();
          userFormNo = data['Data'][0]['FormNo'].toString();
          await appCache.saveUserFormNo(userFormNo);
          String passFromApi = data['Data'][0]['Passw'].toString();
          await appCache.saveUserPass(passFromApi);
        } else {
          _errorMessage = data["Message"] ?? "Login failed";
        }

        _isLoading = false;
        notifyListeners();
        return data;
      } else {
        _errorMessage = "Server error. Please try again later.";
        _isLoading = false;
        notifyListeners();
        return {"Status": "False", "Message": _errorMessage};
      }
    } catch (e) {
      _errorMessage = "Failed to connect to the server.";
      _isLoading = false;
      notifyListeners();
      return {"Status": "False", "Message": _errorMessage};
    }
  }

  Future<void> fetchUserdata() async {
    _isLoading = true;
    notifyListeners();

    final appCache = AppCache();
    var formno = await appCache.getUserFormNo();

    final String baseUrl = ApiUrls.baseUrl;
    final Uri url = Uri.parse(baseUrl).replace(queryParameters: {
      "ReqType": "GetUserDetail",
      "FormNo": formno,
    });

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['Status'] == 'True') {
          _userDetail = UserDetailModel.fromJson(data['Data'][0]);
        }
      } else {
        throw Exception('Failed to load user detail');
      }
    } catch (e) {
      print('Error fetching user detail: $e');
    }

    _isLoading = false;
    notifyListeners();
  }
  Future<void> fetchWalletBalance() async {
    try {
      final String baseUrl =
          "https://oklifecare.com/Dashboard/API/RechargeAPI.aspx?reqtype=balance";
      final appCache = AppCache();
      String? formNo = await appCache.getUserFormNo();

      if (formNo == null || formNo.isEmpty) {
        print("FormNo not found in cache");
        return;
      }

      final Map<String, String> requestBody = {
        "formno": formNo
      };

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("Wallet Balance API Response: $data"); // Console print

        if (data['Status'] == 'True' && data['Data'] != null) {
          currentWalletBalance = double.tryParse(
            data['Data'][0]['Balance'].toString(),
          ) ??
              0.0;
          _walletBalance = BalanceModel(balance: currentWalletBalance);

          notifyListeners();
        }
      } else {
        print("Error: ${response.statusCode} - ${response.reasonPhrase}");
      }
    } catch (e) {
      print("Error fetching wallet balance: $e");
    }
  }
  Future<dynamic> getRechargeOperator() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiClient.dio.post(
        "${ApiUrls.baseUrl}?reqtype=opcode",
        data: {
          "services": "P"
        },
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
        ),
      );

      print("Status Code: ${response.statusCode}");
      print("Raw Response: ${response.data}");

      if (response.statusCode == 200 && response.data != null) {
        var data = response.data is String ? json.decode(response.data) : response.data;

        if (data['Status'] == 'True' || data['status'] == 200) {
          operatorModel = List<OperatorModel>.from(
            (data['Data'] as List).map((e) => OperatorModel.fromJson(e)),
          );
        } else {
          print("API Error: ${data['Message']}");
        }
      } else {
        print("Server Error: ${response.statusCode}");
      }
      return response.data;
    } catch (e) {
      print("Exception: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<dynamic> getWalletStatement() async {
    _isLoading = true;
    notifyListeners();

    var formno = await cache.getUserFormNo();
    final response = await _apiClient.dio.get(ApiUrls.baseUrl, queryParameters: {
      'ReqType': 'WalletTransactionDetail',
      'FormNo': formno,
    });

    var data = json.decode(response.data);
    if (response.statusCode == 200 && data['Status'] == 'True') {
      final list = data['Data'] as List;
      walletList = list.map((e) => WalletStatementModel.fromJson(e)).toList();
    } else {
      walletList = [];
    }

    _isLoading = false;
    notifyListeners();
    return data;
  }

  Future<Map<String, dynamic>> changePassword({
    required String oldPassword,
    required String newPassword,
    required String type,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      final formNo = await AppCache().getUserFormNo(); // Assuming this method exists
      final encodedType = base64Encode(utf8.encode(type));
      final encodedOldPassword = base64Encode(utf8.encode(oldPassword));
      final encodedNewPassword = base64Encode(utf8.encode(newPassword));
      final url = Uri.parse(
        'http://uonely.versatileitsolution.com/UserPanel/API/App_Api.aspx'
            '?ReqType=ChangePassword'
            '&Type=$encodedType'
            '&FormNo=$formNo'
            '&OldPassword=$encodedOldPassword'
            '&NewPassword=$encodedNewPassword',
      );
      final response = await http.get(url);
      print("Request URL: $url");
      _isLoading = false;
      notifyListeners();
      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        print("Response JSON: $result");
        return result;
      } else {
        print("Server returned error status: ${response.statusCode}");
        return {
          "Status": false,
          "Message": "Server error. Please try again.",
        };
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print("Exception caught: $e");
      return {
        "Status": false,
        "Message": "Something went wrong: ${e.toString()}",
      };
    }
  }

  // Future<dynamic> getRechargeOperator(type) async {
  //   _isLoading = true;
  //   notifyListeners();
  //
  //   final response =
  //   await _apiClient.dio.get(ApiUrls.baseUrl, queryParameters: {
  //     'reqtype': 'opcode'
  //     // 'OperatorType': type,
  //   });
  //   var data = json.decode(response.data);
  //   if (response.statusCode == 200) {
  //     operatorModel = await List.castFrom(data['Data'].map((e) {
  //       return OperatorModel.fromJson(e);
  //     }).toList());
  //     print(operatorModel);
  //   }
  //   _isLoading = false;
  //   notifyListeners();
  //   return data;
  // }


  Future<dynamic> getMobileCircle() async {
   _isLoading = true;
    notifyListeners();
    final response =
    await _apiClient.dio.get(ApiUrls.baseUrl, queryParameters: {
      'ReqType': 'PrePaidRechargeFillCircle',
      'OperatorType': 'Qw==',
    });
    var data = json.decode(response.data);
    if (response.statusCode == 200) {
      circleList = await List.castFrom(data['Data'].map((e) {
        return CircleModel.fromJson(e);
      }).toList());
      print(circleList);
    }
    _isLoading = false;
    notifyListeners();
    return data;
  }


  Future<Map<String, dynamic>> prepaidRecharge({
    required String number,
    required String amount,
    required String operator,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      var formno = await cache.getUserFormNo();
      var formData = {
        'ReqType': 'PrePaidRecharge',
        'FormNo': formno,
        'RechargeNo': base64.encode(utf8.encode(number)),
        'amount': base64.encode(utf8.encode(amount)),
        'OperatorType': base64.encode(utf8.encode(operator)),
      };

      final response = await _apiClient.dio.get(
        ApiUrls.baseUrl,
        queryParameters: formData,
      );

      var data = json.decode(response.data);

      if (response.statusCode == 200 && data['Message'] == 'Success') {
        return {
          'success': true,
          'message': 'Recharge of ₹$amount for $number is successful. Thank you for using our service.',
        };
      } else {
        return {
          'success': false,
          'message': 'Recharge of ₹$amount for $number has failed. Please try again.',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Something went wrong: $e',
      };
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  Future<void> getDTHCashbackShow() async {
    try {
      final response =
      await _apiClient.dio.get(ApiUrls.baseUrl, queryParameters: {
        'ReqType': 'FillUserCommissionData',
        'RetailerID': 'MA==', // Use appropriate encoded retailer ID
        'ServiceID': 'RA==',
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.data);
        cashBackShowModel = List<CashBackShowModel>.from(
          data['Data'].map((json) => CashBackShowModel.fromJson(json)),
        );
        notifyListeners();
      }
    } catch (e) {
      print("Error fetching cashback data: $e");
    }
  }
  List<String> rechargeTabList = List.empty(growable: true);

  Future<dynamic> getRechargePlan({
    required String number,
    required String operator,
    required String circle,
  }) async {
    _isLoading = true;
    notifyListeners();
    rechargePlanList.clear();
    String encodedNumber = base64.encode(utf8.encode(number));
    String encodedCircle = base64.encode(utf8.encode(circle));
    String encodedOperator = base64.encode(utf8.encode(operator));

    // Print base64-encoded values
    print('Encoded RechargeNo: $encodedNumber');
    print('Encoded CircleID: $encodedCircle');
    print('Encoded OperatorID: $encodedOperator');

    try {
      final response = await _apiClient.dio.get(
        ApiUrls.baseUrl,
        queryParameters: {
          'ReqType': 'GetPlan',
          'RechargeNo': encodedNumber,
          'CircleID': encodedCircle,
          'OperatorID': encodedOperator,
        },
      );

      var data = json.decode(response.data);

      if (response.statusCode == 200) {
        rechargePlanList = await List.castFrom(data['Data'].map((e) {
          return RechargePlanModel.fromJson(e);
        }).toList());
        print('Recharge Plan List: $rechargePlanList');

        // Create type list
        var tempList = rechargePlanList.map((e) => e.type).toList();
        print('Type List: $tempList');

        for (int i = 0; i < tempList.length; i++) {
          if (!rechargeTabList.contains(tempList[i])) {
            rechargeTabList.add(tempList[i]);
          }
        }
        print('Recharge Tab List: $rechargeTabList');

        // Filter list according to the type
        filterRechargePlanList(rechargeTabList.first);
      }
      return data;
    } catch (e) {
      print('Error fetching recharge plans: $e');
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  filterRechargePlanList(value) {
    filteredRechargePlanList = rechargePlanList
        .where(
          (element) => element.type.contains(value),
    )
        .map(
          (e) => e,
    )
        .toList();

    print(filteredRechargePlanList);
    update();
  }

  List<CashbackModel> cashback = List.empty(growable: true);

  Future<dynamic> getCashbackDetails({
    required String serviceId,
    required String operatorId,
    required String amount,
  }) async {
    _isLoading = true;
    notifyListeners();
    var formno = await cache.getUserFormNo();
    final response =
    await _apiClient.dio.get(ApiUrls.baseUrl, queryParameters: {
      'ReqType': 'CommissionCashback',
      'RetailerFormno': formno,
      'ServiceID': base64.encode(utf8.encode(serviceId)),
      'OperatorID': base64.encode(utf8.encode(operatorId)),
      'amount': base64.encode(utf8.encode(amount)),
    });
    var data = json.decode(response.data);
    if (response.statusCode == 200) {
      cashback = await List.castFrom(data['Data'].map((e) {
        return CashbackModel.fromJson(e);
      }).toList());
    }
    print(cashback);
   _isLoading = false;
    notifyListeners();
    return data;
  }

  Future<dynamic> dthRecharge({
    required String number,
    required String amount,
    required String operator,
  }) async {
    _isLoading = true;
    notifyListeners();
    var formno = await cache.getUserFormNo();

    final response =
    await _apiClient.dio.get(ApiUrls.baseUrl, queryParameters: {
      'ReqType': 'DthRecharge',
      'FormNo': formno,
      'RechargeNo': base64.encode(utf8.encode(number)),
      'amount': base64.encode(utf8.encode(amount)),
      'OperatorType': base64.encode(utf8.encode(operator)),
    });
    var data = json.decode(response.data);
    if (data['Status'] == 'True') {}
    _isLoading = false;
    notifyListeners();
    return data;
  }

  Future<dynamic> fetchBankName() async {
   _isLoading = true;
    notifyListeners();

    final response =
    await _apiClient.dio.get(ApiUrls.baseUrl, queryParameters: {
      'ReqType': 'FillBank',
    });
    var data = json.decode(response.data);
    if (response.statusCode == 200) {
      selectBankModel = await List.castFrom(data['Data'].map((e) {
        return SelectBankModel.fromJson(e);
      }).toList());
    }
    _isLoading = false;
    notifyListeners();
    return data;
  }


  Future<void> getBankDetailAllDataShow() async {
    _isLoading = true;
    notifyListeners();

    var formno = await cache.getUserFormNo();

    // Print the userId to the console
    print('User ID hhh: $formno'); // This will print the userId in the console

    try {
      final response = await _apiClient.dio.get(
        ApiUrls.baseUrl,
        queryParameters: {
          'ReqType': 'FillDetailBank',
          'FormNo': formno, // Using the userId here
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.data);

        if (responseData['Data'] != null) {
          addBankDetailshowDataModel = List<AddBankDetailshowDataModel>.from(
            responseData['Data']
                .map((e) => AddBankDetailshowDataModel.fromJson(e)),
          );

          addBankDetailshowDataModel.forEach((detail) {
            print('Bank Name: ${detail.bankName}');
            print('Account Number: ${detail.accNo}');
          });
        } else {
          print("No data available");
        }
      } else {
        print("API Error: ${response.statusCode} ${response.statusMessage}");
      }
    } catch (e) {
      print("Error fetching bank details: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  Future<void> updateBankDetails({
    required String bankId,
    required String branchName,
    required String accountNo,
    required String ifscCode,
    required String beneficiaryName,
    required String panCard,
  }) async {
    _isLoading = true;
    notifyListeners();

    print('Bank ID: $bankId');
    print('Branch Name: $branchName');
    print('Account No: $accountNo');
    print('IFSC Code: $ifscCode');
    print('Beneficiary Name: $beneficiaryName');
    print('PAN Card: $panCard');
    var formno = await cache.getUserFormNo();
    try {
      final response =
      await _apiClient.dio.get(ApiUrls.baseUrl, queryParameters: {
        'ReqType': 'Fillbankdetailsubmit',
        'Id': 'MA==',
        'Mobileno': 'OTgyOTg5ODI5OA==',
        'formNo': formno,
        'BankID': base64.encode(utf8.encode(bankId)),
        'BranchName': base64.encode(utf8.encode(branchName)),
        'AccNo': base64.encode(utf8.encode(accountNo)),
        'IFSCCode': base64.encode(utf8.encode(ifscCode)),
        'BenificaryName': base64.encode(utf8.encode(beneficiaryName)),
        'Mode': 'MA==',
        'UserID': 'NTE0MzY5MDU=',
        'PanCardno': base64.encode(utf8.encode(panCard)),
      });

      print('Response Status: ${response.statusCode}');
      print('Response Data: ${response.data}');

      var data = json.decode(response.data);

      if (response.statusCode == 200 && data['Status'] == 'True') {
        print('Bank details updated successfully');

        Fluttertoast.showToast(
          msg: data['Message'] ?? 'Successfully updated bank details.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
        );
      } else {
        throw Exception('Failed to update bank details');
      }
    } catch (e) {
      print('Error: $e');

      Fluttertoast.showToast(
        msg: "Error updating bank details.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<DepositDetailModel> depositDetailModel = List.empty(growable: true);
  Future<dynamic> getDepositFundDetails() async {
    _isLoading = true;
    notifyListeners();
    var formno = await cache.getUserFormNo();

    final response =
    await _apiClient.dio.get(ApiUrls.baseUrl, queryParameters: {
      'ReqType': 'DepositeRequestDetails',
      'formNo': formno,
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.data);
      depositDetailModel = (data['Data'] as List<dynamic>)
          .map((e) => DepositDetailModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception("Failed to load deposit details");
    }

   _isLoading = false;
    notifyListeners();
  }

  List<BeneficaryModel> beneficiaryModel = List.empty(growable: true);
  Future<dynamic> getBeneficiary() async {
    _isLoading = true;
    notifyListeners();

    var formno = await cache.getUserFormNo();

    final response = await _apiClient.dio.get(ApiUrls.baseUrl, queryParameters: {
      'ReqType': 'WithdrawalBeneficary',
      'FormNo': formno,
    });

    var data = json.decode(response.data);

    // Print full response data to console
    print("Response Data: $data");

    if (response.statusCode == 200) {
      beneficiaryModel = await List.castFrom(data['Data'].map((e) {
        return BeneficaryModel.fromJson(e);
      }).toList());
    }

    _isLoading = false;
    notifyListeners();

    return data;
  }

  List<WithdrawalDetailModel> withdrawalDetailModel =
  List.empty(growable: true);
  Future<dynamic> getWithdrawalFundDetails() async {
    _isLoading = true;
    notifyListeners();
    var formno = await cache.getUserFormNo();

    final response =
    await _apiClient.dio.get(ApiUrls.baseUrl, queryParameters: {
      'ReqType': 'WithdrawalReqDetails',
      'formNo': formno,
    });
    var data = json.decode(response.data);
    if (response.statusCode == 200) {
      final data = json.decode(response.data);
      withdrawalDetailModel = (data['Data'] as List<dynamic>)
          .map((e) => WithdrawalDetailModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception("Failed to load withdrawal details");
    }
    _isLoading = false;
    notifyListeners();
    return data;
  }
  List<BankDetailShowModel> bankDetailShowModel = List.empty(growable: true);
  Future<void> getBankDetailShow() async {
    _isLoading = true;
    notifyListeners();
    var formno = await cache.getUserFormNo();
    try {
      final response =
      await _apiClient.dio.get(ApiUrls.baseUrl, queryParameters: {
        'ReqType': 'FillDetailBank',
        'FormNo':formno,
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.data);
        if (data['Data'] != null) {
          bankDetailShowModel = List<BankDetailShowModel>.from(
            data['Data'].map((e) => BankDetailShowModel.fromJson(e)),
          );
        }
      } else {
        // Handle API errors
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching bank details: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }



  Future<dynamic> submitDepositRequest({
    required BuildContext context, // Accept BuildContext as a parameter
    required String points,
    required String payMode,
    required String utr,
    required String remark,
    required String bankID,
    required String imageCode,
  }) async {
    try {
      print("Starting submitDepositRequest...");

      _isLoading = true;
      notifyListeners();

      // Retrieve user ID
      var formno = await cache.getUserFormNo();
      print("User ID (FormNo): $formno");

      // Convert data to Base64 (except imageCode)
      final base64Points = base64Encode(utf8.encode(points));
      final base64PayMode = base64Encode(utf8.encode(payMode));
      final base64Utr = base64Encode(utf8.encode(utr));
      final base64Remark = base64Encode(utf8.encode(remark));
      final base64BankID = base64Encode(utf8.encode(bankID));
      final base64ImageCode = imageCode; // Do not encode imageCode again
     print ("Image Recepit :$base64ImageCode");
      print("Sending Parameters:");
      print({
        'ReqType': 'DepositeRequest',
        'FormNo': formno,
        'Amount': base64Points,
        'PayMode': base64PayMode,
        'UTRNo': base64Utr,
        'Remarks': base64Remark,
        'ImageCode': base64ImageCode,
        'BankID': base64BankID,
      });

      // Send API request
      final response = await _apiClient.dio.post(
        "http://uonely.versatileitsolution.com/UserPanel/API/App_Api.aspx?ReqType=DepositeRequest",
        data: {
          'request': [
            {
              'FormNo': formno,
              'Amount': base64Points,
              'PayMode': base64PayMode,
              'UTRNo': base64Utr,
              'Remarks': base64Remark,
              'ImageCode': base64ImageCode,
              'BankID': base64BankID,
            }
          ]
        },
      );
      print("Raw API Response: ${response.data}");
      final rawResponse = response.data;
      Map<String, dynamic> data;

      if (rawResponse is String) {
        data = jsonDecode(rawResponse); // Handle plain string response
      } else if (rawResponse is Map<String, dynamic>) {
        data = rawResponse; // Handle JSON object
      } else {
        throw FormatException("Unexpected response format: $rawResponse");
      }

      print("Parsed Response: $data");

     _isLoading = false;
      notifyListeners();
      return data; // Return the parsed response
    } catch (e) {
      print("Error in submitDepositRequest: $e");

      _isLoading = false;
      return {
        'Status': 'False',
        'Message': 'An error occurred. Please try again.',
      };
    }
  }

  List<PaymodeModel> payMode = List.empty(growable: true);
  Future<dynamic> getPayModeList() async {
    _isLoading = true;
    notifyListeners();

    final response =
    await _apiClient.dio.get(ApiUrls.baseUrl, queryParameters: {
      'ReqType': 'LoadPaymode',
    });
    var data = json.decode(response.data);
    if (response.statusCode == 200) {
      payMode = await List.castFrom(data['Data'].map((e) {
        return PaymodeModel.fromJson(e);
      }).toList());
    }
    print(payMode);
    _isLoading = false;
    notifyListeners();
    return data;
  }

  List<BankDetailModel> bankDetail = List.empty(growable: true);
  Future<dynamic> getBankDetailList() async {
    _isLoading = true;
    notifyListeners();

    final response =
    await _apiClient.dio.get(ApiUrls.baseUrl, queryParameters: {
      'ReqType': 'LoadCompanyBankDetail',
    });
    var data = json.decode(response.data);
    if (response.statusCode == 200) {
      bankDetail = await List.castFrom(data['Data'].map((e) {
        return BankDetailModel.fromJson(e);
      }).toList());
    }
    print(bankDetail);
    _isLoading = false;
    notifyListeners();
    return data;
  }

  List<UpiDetailModel> upiDetail = List.empty(growable: true);
  Future<dynamic> getUPIDetailList() async {
    _isLoading = true;
    notifyListeners();

    final response =
    await _apiClient.dio.get(ApiUrls.baseUrl, queryParameters: {
      'ReqType': 'LoadCompanyUPIDetail',
    });
    var data = json.decode(response.data);
    if (response.statusCode == 200) {
      upiDetail = await List.castFrom(data['Data'].map((e) {
        return UpiDetailModel.fromJson(e);
      }).toList());
    }
    print(upiDetail);
    _isLoading = false;
    notifyListeners();
    return data;
  }











}




