import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';

// import aapke files ka
import '../../providers/loginProvider.dart';
import '../../routing/app_pages.dart';
import 'login_screen.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  /// Base64 Encode (agar kahin chahiye)
  String encodeBase64(String value) {
    return base64.encode(utf8.encode(value));
  }

  /// Saved User ID & Password load karna
  Future<void> _loadSavedCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedUserId = prefs.getString("user_id");
    String? savedPassword = prefs.getString("password");

    if (savedUserId != null && savedPassword != null) {
      setState(() {
        _userIdController.text = savedUserId;
        _passwordController.text = savedPassword;
      });
    }
  }

  /// Login Handle
  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      String userId = _userIdController.text.trim();
      String password = _passwordController.text.trim();
      final loginProvider =
      Provider.of<ProviderScreen>(context, listen: false);

      final result = await loginProvider.loginUser(userId, password);

      if (result['Status'] == 'True') {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("user_id", userId);
        await prefs.setString("password", password);

        Fluttertoast.showToast(
          msg: result['Message'] ?? "Login Successful",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );

        context.pushNamed(AppPages.CustomBottomNavBar);
      } else {
        Fluttertoast.showToast(
          msg: result['Message'] ?? "Login failed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    double fontScale(double value) => value * width / 375;
    double heightScale(double value) => value * height / 812;
    double widthScale(double value) => value * width / 375;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/loginn.png',
              fit: BoxFit.cover,
              height: height,
              width: width,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: heightScale(200)),
              Padding(
                padding: EdgeInsets.only(left: widthScale(30)),
                child: Text(
                  "Welcome\nBack",
                  style: TextStyle(
                    fontSize: fontScale(34),
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.1,
                  ),
                ),
              ),
              SizedBox(height: heightScale(20)),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(widthScale(30)),
                      topRight: Radius.circular(widthScale(30)),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(widthScale(30)),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: heightScale(5)),
                            Text(
                              "Login",
                              style: TextStyle(
                                color: Color(0xFFD81B5B),
                                fontSize: fontScale(20),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: heightScale(10)),
                            TextFormField(
                              controller: _userIdController,
                              decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                labelStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: fontScale(15),
                                ),
                                labelText: "User ID",
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter User ID";
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: heightScale(10)),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                                labelText: "Password",
                                labelStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: fontScale(15),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Color(0xFFD81B5B),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter Password";
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: heightScale(30)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "Back",
                                    style: TextStyle(
                                      color: Color(0xFF018CCF),
                                      fontSize: fontScale(17),
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: heightScale(50),
                                  width: 130,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFFD81B5B),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          widthScale(25),
                                        ),
                                      ),
                                    ),
                                    onPressed: _handleLogin,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Center(
                                          child: Text(
                                            "Sign In",
                                            style: TextStyle(
                                              fontSize: fontScale(18),
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 1.2,
                                              color: Colors.white,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        SizedBox(width: widthScale(5)),
                                        Image.asset(
                                          "assets/send.png",
                                          height: heightScale(19),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: heightScale(30)),
                            Divider(thickness: 1.2, color: Colors.grey),
                            SizedBox(height: heightScale(10)),
                            Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      "Did you forgot your Password?",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: fontScale(16),
                                        letterSpacing: 0,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {},
                                    child: Text(
                                      "Tap here for reset",
                                      style: TextStyle(
                                        color: Color(0xFF018BD3),
                                        fontWeight: FontWeight.w700,
                                        fontSize: fontScale(16),
                                        letterSpacing: 0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
