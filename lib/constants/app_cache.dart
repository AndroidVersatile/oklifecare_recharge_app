import 'package:shared_preferences/shared_preferences.dart';

class AppCache {
  static final AppCache _appCache = AppCache._internal();
  static const isLogin = "isLogin";
  static const name = "name";
  static const email = "email";
  static const mobile = "mobile";
  static const id = "id";
  static const userType = "userType";
  var isInit = false;
  static const userFormNo = 'userFormNo';
  static const userPass = 'userPass';
  static const kFCMToken = 'FCMToken';
  SharedPreferences? _prefs;

  factory AppCache() {
    return _appCache;
  }
  static const _keyMemberName = 'memberName';
  Future<void> saveMemberName(String memberName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyMemberName, memberName);
  }

  Future<String?> getMemberName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyMemberName);
  }
  Future<bool> saveUserId(String userId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('userId', userId);
  }
  Future<String?> getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }
  Future<bool> checkInit() async {
    if (isInit) {
      return true;
    } else {
      _prefs = await SharedPreferences.getInstance();
      isInit = true;

      return true;
    }
  }

  AppCache._internal() {
    SharedPreferences.getInstance().then((prefs) {
      _prefs = prefs;
      isInit = true;
    });
  }

  clearCache() async {
    await _prefs?.setBool(isLogin, false);
    await _prefs?.clear();
  }

  Future<void> setLoggedIn(bool isLoggedIn) async {
    await _prefs?.setBool("isLoggedIn", isLoggedIn);
  }

  bool isUserLoggedIn() {
    return _prefs?.getBool("isLoggedIn") ?? false;
  }

  Future<void> clearLogin() async {
    await _prefs?.remove("isLoggedIn");
  }

  setUserType(user) async {
    await _prefs!.setString(userType, user);
  }

  getUserType() async {
    return await _prefs!.getString(userType);
  }

  setUserName(user) async {
    await _prefs!.setString(name, user);
  }

  getUserName() async {
    var username =await _prefs!.getString(name);
    return username;
  }

  setUserEmail(user) async {
    await _prefs!.setString(email, user);
  }

  getUserEmail() async {
    return await _prefs!.getString(email);
  }

  Future<void> setUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
  }



  setUserMobile(user) async {
    await _prefs!.setString(mobile, user);
  }

  getUserMobile() async {
    return await _prefs!.getString(mobile);
  }
  Future<bool> logout() async {
    try {
      await clearCache();
      await _prefs?.remove("user_id");
      await _prefs?.remove("password");
      bool result = await _prefs?.setBool(isLogin, false) ?? false;
      return result; // Return true if logout is successful
    } catch (e) {
      return false; // Return false in case of an error
    }
  }

  saveUserPass(String pass) async {
    await _prefs?.setString(userPass, pass);
  }

  getUserPass() async {
    return await _prefs?.getString(userPass);
  }

  saveUserFormNo(String formNo) async {
    await _prefs?.setString(userFormNo, formNo);
  }

  Future<String> getUserFormNo() async {
    await checkInit();
    var token = _prefs?.getString(userFormNo);
    return token ?? '';
  }

  Future<void> saveFCMToken(String token) async {
    await _prefs?.setString(kFCMToken, token);
  }

  Future<String> getFCMToken() async {
    var token = _prefs?.getString(kFCMToken) ?? '';
    return token;
  }
}
