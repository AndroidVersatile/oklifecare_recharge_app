class UserDetailModel {
  final int id;
  final int sessId;
  final int formNo;
  final String idNo;
  final String passw;
  final String memFirstName;
  final String firmName;
  final String fathersName;
  final String dob;
  final String gender;
  final String mobileNo;
  final String emailId;
  final String address1;
  final String address2;
  final int stateId;
  final String district;
  final String city;
  final int pinCode;
  final int bankId;
  final String accountNo;
  final String bankName;
  final String branchName;
  final String ifscCode;
  final String panNo;
  final String aadharNo;
  final String activeStatus;
  final String rts;
  final int userId;
  final String delSts;
  final String regMode;
  final String hostIP;
  final String loginSts;
  final String isQrGenerate;
  final String qrPath;
  final double dailyLimit;
  final String logoutTime;
  final int departmentId;
  final double securityAmount;
  final int planId;
  final String activationDate;
  final int locationId;
  final String gstNo;
  final int uplinerFormno;
  final double salary;
  final String userName;
  final String lastName;
  final int businessCategoryId;
  final int bloodGroupId;
  final String mothersName;
  final String maritalStatus;
  final String phoneNo;
  final String gmailId;
  final String upiAddress;
  final String lastQualification;
  final String workType;
  final String workExperience;
  final String transactionPassword;
  final String photoPath;
  final String lastIp;
  final String lastLoginTime;
  final String lastModified;
  final String isVendorReg;
  final String profileImg;
  final int refLegNo;
  final String businessName;
  final String businessMobileNo;
  final String businessWhatsapp;
  final String businessEmailId;
  final String businessAddress;
  final String businessLiveLocation;
  final int cntryCode;
  final String middleName;
  final String googleMapLoc;
  final String verifyLink;
  final String isVerify;
  final String verifydt;
  final String busGoogleMapLoc;

  UserDetailModel({
    required this.id,
    required this.sessId,
    required this.formNo,
    required this.idNo,
    required this.passw,
    required this.memFirstName,
    required this.firmName,
    required this.fathersName,
    required this.dob,
    required this.gender,
    required this.mobileNo,
    required this.emailId,
    required this.address1,
    required this.address2,
    required this.stateId,
    required this.district,
    required this.city,
    required this.pinCode,
    required this.bankId,
    required this.accountNo,
    required this.bankName,
    required this.branchName,
    required this.ifscCode,
    required this.panNo,
    required this.aadharNo,
    required this.activeStatus,
    required this.rts,
    required this.userId,
    required this.delSts,
    required this.regMode,
    required this.hostIP,
    required this.loginSts,
    required this.isQrGenerate,
    required this.qrPath,
    required this.dailyLimit,
    required this.logoutTime,
    required this.departmentId,
    required this.securityAmount,
    required this.planId,
    required this.activationDate,
    required this.locationId,
    required this.gstNo,
    required this.uplinerFormno,
    required this.salary,
    required this.userName,
    required this.lastName,
    required this.businessCategoryId,
    required this.bloodGroupId,
    required this.mothersName,
    required this.maritalStatus,
    required this.phoneNo,
    required this.gmailId,
    required this.upiAddress,
    required this.lastQualification,
    required this.workType,
    required this.workExperience,
    required this.transactionPassword,
    required this.photoPath,
    required this.lastIp,
    required this.lastLoginTime,
    required this.lastModified,
    required this.isVendorReg,
    required this.profileImg,
    required this.refLegNo,
    required this.businessName,
    required this.businessMobileNo,
    required this.businessWhatsapp,
    required this.businessEmailId,
    required this.businessAddress,
    required this.businessLiveLocation,
    required this.cntryCode,
    required this.middleName,
    required this.googleMapLoc,
    required this.verifyLink,
    required this.isVerify,
    required this.verifydt,
    required this.busGoogleMapLoc,
  });

  factory UserDetailModel.fromJson(Map<String, dynamic> json) {
    return UserDetailModel(
      id: json['Id'] ?? 0,
      sessId: json['SessId'] ?? 0,
      formNo: json['FormNo'] ?? 0,
      idNo: json['IdNo'] ?? '',
      passw: json['Passw'] ?? '',
      memFirstName: json['MemFirstName'] ?? '',
      firmName: json['FirmName'] ?? '',
      fathersName: json['FathersName'] ?? '',
      dob: json['DOB'] ?? '',
      gender: json['Gender'] ?? '',
      mobileNo: json['MobileNo'].toString(),
      emailId: json['EmailId'] ?? '',
      address1: json['Address1'] ?? '',
      address2: json['Address2'] ?? '',
      stateId: json['StateId'] ?? 0,
      district: json['District'] ?? '',
      city: json['City'] ?? '',
      pinCode: json['PinCode'] ?? 0,
      bankId: json['BankId'] ?? 0,
      accountNo: json['AccountNo'] ?? '',
      bankName: json['BankName'] ?? '',
      branchName: json['BranchName'] ?? '',
      ifscCode: json['IfscCode'] ?? '',
      panNo: json['PanNo'] ?? '',
      aadharNo: json['AadharNo'].toString(),
      activeStatus: json['ActiveStatus'] ?? '',
      rts: json['RTS'] ?? '',
      userId: json['UserId'] ?? 0,
      delSts: json['DelSts'] ?? '',
      regMode: json['RegMode'] ?? '',
      hostIP: json['HostIP'] ?? '',
      loginSts: json['LoginSTs'] ?? '',
      isQrGenerate: json['IsQrGenerate'] ?? '',
      qrPath: json['QRPath'] ?? '',
      dailyLimit: (json['DailyLimit'] ?? 0).toDouble(),
      logoutTime: json['LogoutTime'] ?? '',
      departmentId: json['M_DepartmentMaster_Id'] ?? 0,
      securityAmount: (json['SecurityAmount'] ?? 0).toDouble(),
      planId: json['PlanId'] ?? 0,
      activationDate: json['ActivationDate'] ?? '',
      locationId: json['LocationID'] ?? 0,
      gstNo: json['GSTNo'] ?? '',
      uplinerFormno: json['UplinerFormno'] ?? 0,
      salary: (json['Salary'] ?? 0).toDouble(),
      userName: json['UserName'] ?? '',
      lastName: json['LastName'] ?? '',
      businessCategoryId: json['BusinessCategoryID'] ?? 0,
      bloodGroupId: json['BloodGroupID'] ?? 0,
      mothersName: json['MothersName'] ?? '',
      maritalStatus: json['MaritalStatus'] ?? '',
      phoneNo: json['PhoneNo'] ?? '',
      gmailId: json['GmailID'] ?? '',
      upiAddress: json['UPIAddress'] ?? '',
      lastQualification: json['LastQualification'] ?? '',
      workType: json['WorkType'] ?? '',
      workExperience: json['WorkExperience'] ?? '',
      transactionPassword: json['TransactionPassword'] ?? '',
      photoPath: json['PhotoPath'] ?? '',
      lastIp: json['LastIp'] ?? '',
      lastLoginTime: json['LastLoginTime'] ?? '',
      lastModified: json['lastmodified'] ?? '',
      isVendorReg: json['ISVendorReg'] ?? '',
      profileImg: json['ProfileImg'] ?? '',
      refLegNo: json['RefLegNo'] ?? 0,
      businessName: json['BusinessName'] ?? '',
      businessMobileNo: json['BusinessMobileNo'].toString(),
      businessWhatsapp: json['Businesswhatsapp'].toString(),
      businessEmailId: json['BusinessEmailId'] ?? '',
      businessAddress: json['BusinessAddress'] ?? '',
      businessLiveLocation: json['BusinessLiveLocation'] ?? '',
      cntryCode: json['CntryCode'] ?? 0,
      middleName: json['Middlename'] ?? '',
      googleMapLoc: json['GoogleMapLoc'] ?? '',
      verifyLink: json['VerifyLink'] ?? '',
      isVerify: json['isVerify'] ?? '',
      verifydt: json['Verifydt'] ?? '',
      busGoogleMapLoc: json['BusGoogleMapLoc'] ?? '',
    );
  }
}
class BalanceModel {
  final double balance;

  BalanceModel({required this.balance});

  factory BalanceModel.fromJson(Map<String, dynamic> json) {
    return BalanceModel(
      balance: json['Balance'].toDouble(),
    );
  }
}

class OperatorModel {
  int id;
  String operatorName;

  OperatorModel({
    required this.id,
    required this.operatorName,
  });

  factory OperatorModel.fromJson(Map<String, dynamic> json) => OperatorModel(
    id: json["Id"],
    operatorName: json["OperatorName"],
  );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "OperatorName": operatorName,
  };
}
class CircleModel {
  int circleCode;
  String circleName;

  CircleModel({
    required this.circleCode,
    required this.circleName,
  });

  factory CircleModel.fromJson(Map<String, dynamic> json) => CircleModel(
    circleCode: json["CircleCode"],
    circleName: json["CircleName"],
  );

  Map<String, dynamic> toJson() => {
    "CircleCode": circleCode,
    "CircleName": circleName,
  };
}

class DepositImageModel {
  int seqNo;
  int imgId;
  String imgText;
  String imgPath;
  String activeStatus;
  String status;
  String navigateUrl;
  String displayForImage;

  DepositImageModel({
    required this.seqNo,
    required this.imgId,
    required this.imgText,
    required this.imgPath,
    required this.activeStatus,
    required this.status,
    required this.navigateUrl,
    required this.displayForImage,
  });

  factory DepositImageModel.fromJson(Map<String, dynamic> json) => DepositImageModel(
    seqNo: json["SeqNo"],
    imgId: json["ImgID"],
    imgText: json["ImgText"],
    imgPath: json["ImgPath"],
    activeStatus: json["ActiveStatus"],
    status: json["Status"],
    navigateUrl: json["NavigateURL"],
    displayForImage: json["DisplayForImage"],
  );

  Map<String, dynamic> toJson() => {
    "SeqNo": seqNo,
    "ImgID": imgId,
    "ImgText": imgText,
    "ImgPath": imgPath,
    "ActiveStatus": activeStatus,
    "Status": status,
    "NavigateURL": navigateUrl,
    "DisplayForImage": displayForImage,
  };
}

class WithdrawalImageModel {
  int seqNo;
  int imgId;
  String imgText;
  String imgPath;
  String activeStatus;
  String status;
  String navigateUrl;
  String displayForImage;

  WithdrawalImageModel({
    required this.seqNo,
    required this.imgId,
    required this.imgText,
    required this.imgPath,
    required this.activeStatus,
    required this.status,
    required this.navigateUrl,
    required this.displayForImage,
  });

  factory WithdrawalImageModel.fromJson(Map<String, dynamic> json) => WithdrawalImageModel(
    seqNo: json["SeqNo"],
    imgId: json["ImgID"],
    imgText: json["ImgText"],
    imgPath: json["ImgPath"],
    activeStatus: json["ActiveStatus"],
    status: json["Status"],
    navigateUrl: json["NavigateURL"],
    displayForImage: json["DisplayForImage"],
  );

  Map<String, dynamic> toJson() => {
    "SeqNo": seqNo,
    "ImgID": imgId,
    "ImgText": imgText,
    "ImgPath": imgPath,
    "ActiveStatus": activeStatus,
    "Status": status,
    "NavigateURL": navigateUrl,
    "DisplayForImage": displayForImage,
  };
}