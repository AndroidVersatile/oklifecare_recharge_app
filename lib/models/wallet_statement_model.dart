class WalletStatementModel {
  int id;
  int formNo;
  String idNo;
  String memFirstName;
  int mobileNo;
  String emailId;
  String remark;
  int credit;
  int debit;
  String crDrType;
  String mode;
  String tDate;
  int balance;
  String displaySts;

  WalletStatementModel({
    required this.id,
    required this.formNo,
    required this.idNo,
    required this.memFirstName,
    required this.mobileNo,
    required this.emailId,
    required this.remark,
    required this.credit,
    required this.debit,
    required this.crDrType,
    required this.mode,
    required this.tDate,
    required this.balance,
    required this.displaySts,
  });

  factory WalletStatementModel.fromJson(Map<String, dynamic> json) => WalletStatementModel(
    id: (json["Id"] as num).toInt(),
    formNo: (json["FormNo"] as num).toInt(),
    idNo: json["IdNo"] ?? '',
    memFirstName: json["MemFirstName"] ?? '',
    mobileNo: (json["MobileNo"] as num).toInt(),
    emailId: json["EmailId"] ?? '',
    remark: json["Remark"] ?? '',
    credit: (json["Credit"] as num).toInt(),
    debit: (json["Debit"] as num).toInt(),
    crDrType: json["CrDrType"] ?? '',
    mode: json["Mode"] ?? '',
    tDate: json["TDate"] ?? '',
    balance: (json["Balance"] as num).toInt(),
    displaySts: json["DisplaySts"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "FormNo": formNo,
    "IdNo": idNo,
    "MemFirstName": memFirstName,
    "MobileNo": mobileNo,
    "EmailId": emailId,
    "Remark": remark,
    "Credit": credit,
    "Debit": debit,
    "CrDrType": crDrType,
    "Mode": mode,
    "TDate": tDate,
    "Balance": balance,
    "DisplaySts": displaySts,
  };
}
