import 'dart:convert';

CashbackModel cashbackModelFromJson(String str) =>
    CashbackModel.fromJson(json.decode(str));

String cashbackModelToJson(CashbackModel data) => json.encode(data.toJson());

class CashbackModel {
  int id;
  String operatorName;
  String operatorType;
  String commTo;
  String commType;
  dynamic commPer;
  dynamic commAmt;
  dynamic deduction;
  int retailerFormNo;
  dynamic amount;
  double cashback;

  CashbackModel({
    required this.id,
    required this.operatorName,
    required this.operatorType,
    required this.commTo,
    required this.commType,
    required this.commPer,
    required this.commAmt,
    required this.deduction,
    required this.retailerFormNo,
    required this.amount,
    required this.cashback,
  });

  factory CashbackModel.fromJson(Map<String, dynamic> json) => CashbackModel(
        id: json["Id"],
        operatorName: json["OperatorName"],
        operatorType: json["OperatorType"],
        commTo: json["CommTo"],
        commType: json["CommType"],
        commPer: json["CommPer"],
        commAmt: json["CommAmt"],
        deduction: json["Deduction"],
        retailerFormNo: json["RetailerFormNo"],
        amount: json["Amount"],
        cashback: json["Cashback"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "OperatorName": operatorName,
        "OperatorType": operatorType,
        "CommTo": commTo,
        "CommType": commType,
        "CommPer": commPer,
        "CommAmt": commAmt,
        "Deduction": deduction,
        "RetailerFormNo": retailerFormNo,
        "Amount": amount,
        "Cashback": cashback,
      };
}



class UpiDetailModel {
  String upiId;
  int id;
  String imgPath;
  String activeStatus;
  String status;

  UpiDetailModel({
    required this.upiId,
    required this.id,
    required this.imgPath,
    required this.activeStatus,
    required this.status,
  });

  factory UpiDetailModel.fromJson(Map<String, dynamic> json) => UpiDetailModel(
    upiId: json["UPI_ID"],
    id: json["ID"],
    imgPath: json["ImgPath"],
    activeStatus: json["ActiveStatus"],
    status: json["Status"],
  );

  Map<String, dynamic> toJson() => {
    "UPI_ID": upiId,
    "ID": id,
    "ImgPath": imgPath,
    "ActiveStatus": activeStatus,
    "Status": status,
  };
}

class AccountDetailModel {
  String accNo;
  String bankName;
  String branchName;
  String ifscCode;
  int formNo;

  AccountDetailModel({
    required this.accNo,
    required this.bankName,
    required this.branchName,
    required this.ifscCode,
    required this.formNo,
  });

  factory AccountDetailModel.fromJson(Map<String, dynamic> json) =>
      AccountDetailModel(
        accNo: json["AccNo"] ?? "",
        bankName: json["BankName"] ?? "",
        branchName: json["BranchName"] ?? "",
        ifscCode: json["IFSCCode"] ?? "",
        formNo: json["FormNo"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
    "AccNo": accNo,
    "BankName": bankName,
    "BranchName": branchName,
    "IFSCCode": ifscCode,
    "FormNo": formNo,
  };
}


class CashbackReportModel {
  int formNo;
  String idNo;
  String memFirstName;
  int mobileNo;
  String emailId;
  int mlmFormNo;
  String regMode;
  String mlmIdNo;
  int retailerId;
  String remark;
  double credit;
  double debit;
  String crDrType;
  String mode;
  String tDate;
  String displaySts;

  CashbackReportModel({
    required this.formNo,
    required this.idNo,
    required this.memFirstName,
    required this.mobileNo,
    required this.emailId,
    required this.mlmFormNo,
    required this.regMode,
    required this.mlmIdNo,
    required this.retailerId,
    required this.remark,
    required this.credit,
    required this.debit,
    required this.crDrType,
    required this.mode,
    required this.tDate,
    required this.displaySts,
  });

  factory CashbackReportModel.fromJson(Map<String, dynamic> json) => CashbackReportModel(
    formNo: json["FormNo"],
    idNo: json["IdNo"],
    memFirstName: json["MemFirstName"],
    mobileNo: json["MobileNo"],
    emailId: json["EmailId"],
    mlmFormNo: json["MlmFormNo"],
    regMode: json["RegMode"],
    mlmIdNo: json["MlmIdNo"],
    retailerId: json["RetailerId"],
    remark: json["Remark"],
    credit: json["Credit"],
    debit: json["Debit"],
    crDrType: json["CrDrType"],
    mode: json["Mode"],
    tDate: json["TDate"],
    displaySts: json["DisplaySts"],
  );

  Map<String, dynamic> toJson() => {
    "FormNo": formNo,
    "IdNo": idNo,
    "MemFirstName": memFirstName,
    "MobileNo": mobileNo,
    "EmailId": emailId,
    "MlmFormNo": mlmFormNo,
    "RegMode": regMode,
    "MlmIdNo": mlmIdNo,
    "RetailerId": retailerId,
    "Remark": remark,
    "Credit": credit,
    "Debit": debit,
    "CrDrType": crDrType,
    "Mode": mode,
    "TDate": tDate,
    "DisplaySts": displaySts,
  };
}