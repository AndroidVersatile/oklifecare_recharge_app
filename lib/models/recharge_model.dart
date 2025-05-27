
class CashBackShowModel {
  int id;
  String operatorName;
  String operatorType;
  String commTo;
  String commType;
  double commPer;
  double commAmt;
  double deduction;
  int retailerFormNo;

  CashBackShowModel({
    required this.id,
    required this.operatorName,
    required this.operatorType,
    required this.commTo,
    required this.commType,
    required this.commPer,
    required this.commAmt,
    required this.deduction,
    required this.retailerFormNo,
  });

  factory CashBackShowModel.fromJson(Map<String, dynamic> json) {
    return CashBackShowModel(
      id: json["Id"],
      operatorName: json["OperatorName"],
      operatorType: json["OperatorType"],
      commTo: json["CommTo"],
      commType: json["CommType"],
      commPer: json["CommPer"]?.toDouble() ?? 0.0,
      commAmt: json["CommAmt"]?.toDouble() ?? 0.0,
      deduction: json["Deduction"]?.toDouble() ?? 0.0,
      retailerFormNo: json["RetailerFormNo"],
    );
  }
}

class RechargePlanModel {
  String type;
  String rs;
  String validity;
  String desc;
  int rdataId;

  RechargePlanModel({
    required this.type,
    required this.rs,
    required this.validity,
    required this.desc,
    required this.rdataId,
  });

  factory RechargePlanModel.fromJson(Map<String, dynamic> json) =>
      RechargePlanModel(
        type: json["Type"],
        rs: json["rs"],
        validity: json["validity"],
        desc: json["desc"],
        rdataId: json["RDATA_Id"],
      );

  Map<String, dynamic> toJson() => {
    "Type": type,
    "rs": rs,
    "validity": validity,
    "desc": desc,
    "RDATA_Id": rdataId,
  };
}

class DepositDetailModel {
  int formNo;
  String idNo;
  MemFirstName memFirstName;
  int mlmFormNo;
  RegMode regMode;
  String mlmIdNo;
  int id;
  double amount;
  String payMode;
  String transactionId;
  String remark;
  String tDate;
  String sts;
  String adminRemark;
  String arDate;
  String bankName;
  String uploadReceipt;
  String uploadIMage;
  String upiid;
  String payModeName;
  String paymentStatus;
  Action action;
  ReqFrom reqFrom;
  int retailerId;
  int retailerFormno;

  DepositDetailModel({
    required this.formNo,
    required this.idNo,
    required this.memFirstName,
    required this.mlmFormNo,
    required this.regMode,
    required this.mlmIdNo,
    required this.id,
    required this.amount,
    required this.payMode,
    required this.transactionId,
    required this.remark,
    required this.tDate,
    required this.sts,
    required this.adminRemark,
    required this.arDate,
    required this.bankName,
    required this.uploadReceipt,
    required this.uploadIMage,
    required this.upiid,
    required this.payModeName,
    required this.paymentStatus,
    required this.action,
    required this.reqFrom,
    required this.retailerId,
    required this.retailerFormno,
  });

  factory DepositDetailModel.fromJson(Map<String, dynamic> json) => DepositDetailModel(
    formNo: json["FormNo"],
    idNo: json["IdNo"],
    memFirstName: memFirstNameValues.map[json["MemFirstName"]]!,
    mlmFormNo: json["MLMFormNo"],
    regMode: regModeValues.map[json["RegMode"]]!,
    mlmIdNo: json["MlmIdNo"],
    id: json["Id"],
    amount: json["Amount"],
    payMode: json["PayMode"],
    transactionId: json["TransactionId"],
    remark: json["Remark"],
    tDate: json["TDate"],
    sts: json["Sts"],
    adminRemark: json["AdminRemark"],
    arDate: json["ARDate"],
    bankName: json["BankName"],
    uploadReceipt: json["UploadReceipt"],
    uploadIMage: json["UploadIMage"],
    upiid: json["UPIID"],
    payModeName: json["PayModeName"],
    paymentStatus: json["PaymentStatus"],
    action: actionValues.map[json["Action"]]!,
    reqFrom: reqFromValues.map[json["ReqFrom"]]!,
    retailerId: json["RetailerId"],
    retailerFormno: json["RetailerFormno"],
  );

  Map<String, dynamic> toJson() => {
    "FormNo": formNo,
    "IdNo": idNo,
    "MemFirstName": memFirstNameValues.reverse[memFirstName],
    "MLMFormNo": mlmFormNo,
    "RegMode": regModeValues.reverse[regMode],
    "MlmIdNo": mlmIdNo,
    "Id": id,
    "Amount": amount,
    "PayMode": payMode,
    "TransactionId": transactionId,
    "Remark": remark,
    "TDate": tDate,
    "Sts": sts,
    "AdminRemark": adminRemark,
    "ARDate": arDate,
    "BankName": bankName,
    "UploadReceipt": uploadReceipt,
    "UploadIMage": uploadIMage,
    "UPIID": upiid,
    "PayModeName": payModeNameValues.reverse[payModeName],
    "PaymentStatus": paymentStatusValues.reverse[paymentStatus],
    "Action": actionValues.reverse[action],
    "ReqFrom": reqFromValues.reverse[reqFrom],
    "RetailerId": retailerId,
    "RetailerFormno": retailerFormno,
  };
}

enum Action {
  ACTION,
  EMPTY
}

final actionValues = EnumValues({
  "Action": Action.ACTION,
  "": Action.EMPTY
});

enum AdminRemark {
  EMPTY,
  TESTING_USER_ADMINISTRATOR
}

final adminRemarkValues = EnumValues({
  "": AdminRemark.EMPTY,
  "testing  User : Administrator": AdminRemark.TESTING_USER_ADMINISTRATOR
});

enum BankName {
  ABHYUDAYA_COOPERATIVE_BANK
}

final bankNameValues = EnumValues({
  "ABHYUDAYA COOPERATIVE BANK": BankName.ABHYUDAYA_COOPERATIVE_BANK
});

enum MemFirstName {
  AKANSHA_GAUTAM
}

final memFirstNameValues = EnumValues({
  "akansha gautam": MemFirstName.AKANSHA_GAUTAM
});

enum PayModeName {
  BANK
}

final payModeNameValues = EnumValues({
  "Bank": PayModeName.BANK
});

enum PaymentStatus {
  APPROVED,
  PENDING
}

final paymentStatusValues = EnumValues({
  "Approved": PaymentStatus.APPROVED,
  "Pending": PaymentStatus.PENDING
});

enum RegMode {
  W
}

final regModeValues = EnumValues({
  "W": RegMode.W
});

enum ReqFrom {
  U
}

final reqFromValues = EnumValues({
  "U": ReqFrom.U
});

enum Sts {
  A,
  P
}

final stsValues = EnumValues({
  "A": Sts.A,
  "P": Sts.P
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}


class BeneficaryModel {
  int id;
  String bank;

  BeneficaryModel({
    required this.id,
    required this.bank,
  });

  factory BeneficaryModel.fromJson(Map<String, dynamic> json) =>
      BeneficaryModel(
        id: json["Id"],
        bank: json["Bank"],
      );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "Bank": bank,
  };
}


class WithdrawalDetailModel {
  int formNo;
  String idNo;
  String memFirstName;
  int mlmFormNo;
  String regMode;
  String mlmIdNo;
  int id;
  double amount;
  String remark;
  String reqDate;
  String reqStS;
  String adminRemark;
  String arDate;
  String withdrawalStatus;
  String action;
  String reqFrom;
  int retailerId;
  int retailerFormno;
  String bankName;
  String branchName;
  String accNo;
  String ifscCode;
  String benificaryName;

  WithdrawalDetailModel({
    required this.formNo,
    required this.idNo,
    required this.memFirstName,
    required this.mlmFormNo,
    required this.regMode,
    required this.mlmIdNo,
    required this.id,
    required this.amount,
    required this.remark,
    required this.reqDate,
    required this.reqStS,
    required this.adminRemark,
    required this.arDate,
    required this.withdrawalStatus,
    required this.action,
    required this.reqFrom,
    required this.retailerId,
    required this.retailerFormno,
    required this.bankName,
    required this.branchName,
    required this.accNo,
    required this.ifscCode,
    required this.benificaryName,
  });

  factory WithdrawalDetailModel.fromJson(Map<String, dynamic> json) => WithdrawalDetailModel(
    formNo: json["FormNo"],
    idNo: json["IdNo"],
    memFirstName: json["MemFirstName"],
    mlmFormNo: json["MLMFormNo"],
    regMode: json["RegMode"],
    mlmIdNo: json["MlmIdNo"],
    id: json["Id"],
    amount: json["Amount"],
    remark: json["Remark"],
    reqDate: json["ReqDate"],
    reqStS: json["ReqStS"],
    adminRemark: json["AdminRemark"],
    arDate: json["ARDate"],
    withdrawalStatus: json["WithdrawalStatus"],
    action: json["Action"],
    reqFrom: json["ReqFrom"],
    retailerId: json["RetailerId"],
    retailerFormno: json["RetailerFormno"],
    bankName: json["BankName"],
    branchName: json["BranchName"],
    accNo: json["AccNo"],
    ifscCode: json["IFSCCode"],
    benificaryName: json["BenificaryName"],
  );

  Map<String, dynamic> toJson() => {
    "FormNo": formNo,
    "IdNo": idNo,
    "MemFirstName": memFirstName,
    "MLMFormNo": mlmFormNo,
    "RegMode": regMode,
    "MlmIdNo": mlmIdNo,
    "Id": id,
    "Amount": amount,
    "Remark": remark,
    "ReqDate": reqDate,
    "ReqStS": reqStS,
    "AdminRemark": adminRemark,
    "ARDate": arDate,
    "WithdrawalStatus": withdrawalStatus,
    "Action": action,
    "ReqFrom": reqFrom,
    "RetailerId": retailerId,
    "RetailerFormno": retailerFormno,
    "BankName": bankName,
    "BranchName": branchName,
    "AccNo": accNo,
    "IFSCCode": ifscCode,
    "BenificaryName": benificaryName,
  };
}

class BankDetailShowModel {
  int id;
  int formNo;
  String idNo;
  String loginId;
  String memFirstName;
  int bankId;
  String bankName;
  String branchName;
  String accNo;
  String ifscCode;
  String beneficiaryName; // Fixed naming
  String sts;
  String tdate;

  BankDetailShowModel({
    required this.id,
    required this.formNo,
    required this.idNo,
    required this.loginId,
    required this.memFirstName,
    required this.bankId,
    required this.bankName,
    required this.branchName,
    required this.accNo,
    required this.ifscCode,
    required this.beneficiaryName,
    required this.sts,
    required this.tdate,
  });

  factory BankDetailShowModel.fromJson(Map<String, dynamic> json) =>
      BankDetailShowModel(
        id: json["Id"],
        formNo: json["FormNo"],
        idNo: json["IdNo"],
        loginId: json["Login_Id"],
        memFirstName: json["MemFirstName"],
        bankId: json["BankId"],
        bankName: json["BankName"],
        branchName: json["BranchName"],
        accNo: json["AccNo"],
        ifscCode: json["IfscCode"],
        beneficiaryName: json["BeneficiaryName"], // Fixed naming
        sts: json["Sts"],
        tdate: json["Tdate"],
      );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "FormNo": formNo,
    "IdNo": idNo,
    "Login_Id": loginId,
    "MemFirstName": memFirstName,
    "BankId": bankId,
    "BankName": bankName,
    "BranchName": branchName,
    "AccNo": accNo,
    "IfscCode": ifscCode,
    "BeneficiaryName": beneficiaryName, // Fixed naming
    "Sts": sts,
    "Tdate": tdate,
  };
}



class PaymodeModel {
  int id;
  String paymode;
  int userid;
  String rts;
  String activeStatus;
  String delStatus;

  PaymodeModel({
    required this.id,
    required this.paymode,
    required this.userid,
    required this.rts,
    required this.activeStatus,
    required this.delStatus,
  });

  factory PaymodeModel.fromJson(Map<String, dynamic> json) => PaymodeModel(
    id: json["Id"],
    paymode: json["Paymode"],
    userid: json["Userid"],
    rts: json["RTS"],
    activeStatus: json["ActiveStatus"],
    delStatus: json["DelStatus"],
  );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "Paymode": paymode,
    "Userid": userid,
    "RTS": rts,
    "ActiveStatus": activeStatus,
    "DelStatus": delStatus,
  };
}

class BankDetailModel {
  int aid;
  int bankCode;
  String vBankCode;
  String bankName;
  String ifscCode;
  String acNo;
  String remarks;
  String branchName;
  String status;

  BankDetailModel({
    required this.aid,
    required this.bankCode,
    required this.vBankCode,
    required this.bankName,
    required this.ifscCode,
    required this.acNo,
    required this.remarks,
    required this.branchName,
    required this.status,
  });

  factory BankDetailModel.fromJson(Map<String, dynamic> json) => BankDetailModel(
    aid: json["Aid"],
    bankCode: json["BankCode"],
    vBankCode: json["VBankCode"],
    bankName: json["BankName"],
    ifscCode: json["IFSCCode"],
    acNo: json["AcNo"],
    remarks: json["remarks"],
    branchName: json["BranchName"],
    status: json["Status"],
  );

  Map<String, dynamic> toJson() => {
    "Aid": aid,
    "BankCode": bankCode,
    "VBankCode": vBankCode,
    "BankName": bankName,
    "IFSCCode": ifscCode,
    "AcNo": acNo,
    "remarks": remarks,
    "BranchName": branchName,
    "Status": status,
  };
}