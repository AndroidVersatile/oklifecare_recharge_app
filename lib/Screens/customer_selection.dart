
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../routing/app_pages.dart';

class CustomerSelectionScreen extends StatefulWidget {
  const CustomerSelectionScreen({super.key});

  @override
  State<CustomerSelectionScreen> createState() => _CustomerSelectionScreenState();
}

class _CustomerSelectionScreenState extends State<CustomerSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    // MediaQuery values
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final textScale = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.08), // Responsive horizontal padding
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: height * 0.17), // Responsive top spacing
                Center(
                  child: Image.asset(
                    'assets/logos.png',
                    height: height * 0.2, // Responsive image height
                  ),
                ),
                SizedBox(height: height * 0.05), // Spacer after image

                RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    style: TextStyle(fontSize: width * 0.07), // Responsive font size
                    children: [
                      TextSpan(
                        text: "Welcome!\n",
                        style: TextStyle(
                          color: const Color(0xFFE95168),
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const TextSpan(
                        text: "Registration\nfor a ",
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.2,
                          height: 1.2,
                        ),
                      ),
                      const TextSpan(
                        text: "Benefits",
                        style: TextStyle(
                          color: Color(0xFF018BD3),
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.2,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: height * 0.08),

                // Create Account Button
                SizedBox(
                  height: height * 0.07,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      context.pushNamed(AppPages.signscreen);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFE95168),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    child: Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: width * 0.05,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),

                SizedBox(height: height * 0.015),
                 Divider(color: Colors.black),
                SizedBox(height: height * 0.015),

                // I have an account Button
                SizedBox(
                  height: height * 0.07,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      context.pushNamed(AppPages.login);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF018BD3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    child: Text(
                      'I have an account',
                      style: TextStyle(
                        fontSize: width * 0.05,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
