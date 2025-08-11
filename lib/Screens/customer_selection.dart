
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
                    'assets/logotype.png',
                    height: height * 0.2,
                  ),
                ),
                SizedBox(height: height * 0.05), // Spacer after image

                RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    style: TextStyle(fontSize: width * 0.06), // Responsive font size
                    children: [
                      TextSpan(
                        text: "Welcome Login for a Benefits.",
                        style: TextStyle(
                          color: const Color(0xFF4CAF50),

                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.2,
                        ),
                      ),

                    ],
                  ),
                ),

                SizedBox(height: height * 0.08),
                SizedBox(
                  height: height * 0.07,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      context.pushNamed(AppPages.loginmemeber);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFD81B5B),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    child: Text(
                      'Member Panel',
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

                SizedBox(
                  height: height * 0.07,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      context.pushNamed(AppPages.login);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF018CCF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    child: Text(
                      'Utility Recharge Panel',
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
