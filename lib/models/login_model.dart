class LoginModel {
  final String status;
  final String message;
  final List<UserData> data;

  LoginModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      status: json["Status"] ?? "",
      message: json["Message"] ?? "",
      data: (json["Data"] as List?)?.map((e) => UserData.fromJson(e)).toList() ?? [],
    );
  }
}

class UserData {
  final String userName;
  final String passw;
  final int userId;
  final int loginModeId;
  final String loginBy;
  final int formNo;
  final int locationId;
  final String loginUsername;
  final String photoPath;
  final String qrPath;
  final String isQrGenerate;
  final String emailId;
  final String mobileNo;
  final String otp;

  UserData({
    required this.userName,
    required this.passw,
    required this.userId,
    required this.loginModeId,
    required this.loginBy,
    required this.formNo,
    required this.locationId,
    required this.loginUsername,
    required this.photoPath,
    required this.qrPath,
    required this.isQrGenerate,
    required this.emailId,
    required this.mobileNo,
    required this.otp,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      userName: json["UserName"] ?? "",
      passw: json["Passw"] ?? "",
      userId: json["UserId"] ?? 0,
      loginModeId: json["LoginModeId"] ?? 0,
      loginBy: json["LoginBy"] ?? "",
      formNo: json["FormNo"] ?? 0,
      locationId: json["LocationID"] ?? 0,
      loginUsername: json["LoginUsername"] ?? "",
      photoPath: json["PhotoPath"] ?? "",
      qrPath: json["QRPath"] ?? "",
      isQrGenerate: json["IsQrGenerate"] ?? "",
      emailId: json["EmailId"] ?? "",
      mobileNo: json["MobileNo"]?.toString() ?? "",
      otp: json["OTP"] ?? "",
    );
  }
}


class Country {
  final int countryCode;
  final String countryName;

  Country({required this.countryCode, required this.countryName});

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      countryCode: json['CountryCode'],
      countryName: json['CountryName'],
    );
  }
}
