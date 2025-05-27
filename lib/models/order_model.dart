
class SelectBankModel {
  int bankCode;
  String bankName;

  SelectBankModel({
    required this.bankCode,
    required this.bankName,
  });

  factory SelectBankModel.fromJson(Map<String, dynamic> json) => SelectBankModel(
    bankCode: int.tryParse(json["BankCode"].toString()) ?? 0,
    bankName: json["BankName"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "BankCode": bankCode,
    "BankName": bankName,
  };
}


class AddBankDetailshowDataModel {
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
  String benificaryName;
  String sts;
  String tdate;
  String panCardNo;

  AddBankDetailshowDataModel({
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
    required this.benificaryName,
    required this.sts,
    required this.tdate,
    required this.panCardNo,
  });

  factory AddBankDetailshowDataModel.fromJson(Map<String, dynamic> json) => AddBankDetailshowDataModel(
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
    benificaryName: json["BenificaryName"],
    sts: json["Sts"],
    tdate: json["Tdate"],
    panCardNo: json["PanCardNo"],
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
    "BenificaryName": benificaryName,
    "Sts": sts,
    "Tdate": tdate,
    "PanCardNo": panCardNo,
  };
}