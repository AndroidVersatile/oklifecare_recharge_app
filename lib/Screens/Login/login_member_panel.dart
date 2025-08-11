
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../providers/loginProvider.dart';
import '../../routing/app_pages.dart';

class LoginMemberPanelScreen extends StatefulWidget {
  @override
  _LoginMemberPanelScreenState createState() => _LoginMemberPanelScreenState();
}

class _LoginMemberPanelScreenState extends State<LoginMemberPanelScreen> {
  bool _obscurePassword = true;
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String encodeBase64(String value) {
    return base64.encode(utf8.encode(value));
  }


  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      String userId = _userIdController.text.trim();
      String password = _passwordController.text.trim();

      try {
        final response = await http.get(
          Uri.parse(
            "https://olcweb.net/oksekharidoAPI/api/Home/getMemberDashboardLink"
                "?Username=$userId&Password=$password",
          ),
          headers: {'Content-Type': 'application/json'},
        );


        if (response.statusCode == 200) {
          final data = json.decode(response.body);

          if (data['Success'] == true && data['data'] != null) {
            final String rawUrl = data['data'];
            final String cleanUrl = rawUrl.replaceAll('"', '');

            // ✅ Save credentials
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString("user_id", userId);
            await prefs.setString("password", password);

            // ✅ Navigate to WebView screen
            context.pushNamed(AppPages.webviewScreen, extra: cleanUrl);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(data['StatusMessage'] ?? "Login failed")),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error ${response.statusCode}: ${response.reasonPhrase}")),
          );
        }
      } catch (e) {
        print("Login error: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login failed. Please try again.")),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<ProviderScreen>(context);
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    // Scaling functions
    double fontScale(double value) => value * width / 375;
    double heightScale(double value) => value * height / 812;
    double widthScale(double value) => value * width / 375;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/loginn.png', fit: BoxFit.cover,
              height: height, width: width,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: heightScale(200)),
              Padding(
                padding: EdgeInsets.only(left: widthScale(30)),
                child: Text("Welcome\nBack",
                  style: TextStyle(fontSize: fontScale(34), fontWeight: FontWeight.bold,
                    color: Colors.white, letterSpacing: 0.1,),
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
                    ),),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(widthScale(30)),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: heightScale(5)),
                            Text("Login", style: TextStyle(color: Color(0xFFD81B5B), fontSize: fontScale(20), fontWeight: FontWeight.bold,
                            ),),
                            SizedBox(height: heightScale(10)),
                            TextFormField(
                              controller: _userIdController,
                              decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey),),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey), // unfocused border
                                ),
                                labelStyle: TextStyle(color: Colors.grey, fontSize: fontScale(15),),
                                labelText: "User ID",
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
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
                                labelStyle: TextStyle(color: Colors.grey, fontSize: fontScale(15),),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey), // unfocused border
                                ),
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: Color(0xFFD81B5B),
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
                                  child: Text("Back",
                                    style: TextStyle(
                                      color: Color(0xFF018CCF),
                                      fontSize: fontScale(17),
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: heightScale(50), width: 130,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFFD81B5B),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(widthScale(25)),
                                      ),),
                                    // onPressed: () async {
                                    //   if (_formKey.currentState!.validate()) {
                                    //     String userId = _userIdController.text.trim();
                                    //     String password = _passwordController.text.trim();
                                    //     var res = await loginProvider.loginUser(userId, password);
                                    //     if (res['Status'] == 'True') {
                                    //       ScaffoldMessenger.of(context).showSnackBar(
                                    //         SnackBar(content: Text("✅ Login Successful")),
                                    //       );
                                    //       context.pushNamed(AppPages.CustomBottomNavBar);
                                    //     } else {
                                    //       ScaffoldMessenger.of(context).showSnackBar(
                                    //         SnackBar(content: Text(res['Message'] ?? "Login Failed"),
                                    //         ),);
                                    //     }
                                    //   }
                                    // },
                                    onPressed: _handleLogin,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Center(
                                          child: Text("Sign In", style: TextStyle(
                                            fontSize: fontScale(18), fontWeight: FontWeight.bold,
                                            letterSpacing: 1.2, color: Colors.white,
                                          ),
                                            textAlign: TextAlign.center,
                                          ),),
                                        SizedBox(width: widthScale(5)),
                                        Image.asset("assets/send.png", height: heightScale(19 ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: heightScale(30)),
                            Divider(thickness: 1.2, color: Colors.grey,),
                            SizedBox(height: heightScale(10)),
                            Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextButton(
                                    onPressed: () {},
                                    child: Text("Did you forgot your Password?",
                                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                                        fontSize: fontScale(16), letterSpacing: 0,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {},
                                    child: Text("Tap here for reset",
                                      style: TextStyle(
                                        color: Color(0xFF018BD3), fontWeight: FontWeight.w700, fontSize: fontScale(16),
                                        letterSpacing: 0,),),
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