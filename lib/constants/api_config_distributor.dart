import 'dart:convert';

class ApiConfig {
  static const String username = 'test_api';
  static const String password = 'test#\$&api';

  static String getBasicAuth() {
    return 'Basic ' + base64Encode(utf8.encode('$username:$password'));
  }
}
