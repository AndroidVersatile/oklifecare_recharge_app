import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:uonly_app/routing/app_pages.dart';
import '../../providers/loginProvider.dart';

class MpinScreen extends StatefulWidget {
  const MpinScreen({super.key});

  @override
  State<MpinScreen> createState() => _MpinScreenState();
}

class _MpinScreenState extends State<MpinScreen> {
  final TextEditingController _mpinController = TextEditingController();
  final PageController _pageController = PageController();
  int _currentPage = 0;
  String? receivedOtp;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _sendOtpToUser());
  }

  // Function to send OTP and display it
  void _sendOtpToUser() async {
    final provider = Provider.of<ProviderScreen>(context, listen: false);
    final response = await provider.sendOtp(); // This is the API call
    if (!mounted) return;
    if (response['Status'] == 'True') {
      setState(() {
        receivedOtp = response['Data'][0]['OTP'].toString();
      });
      print("Received OTP: $receivedOtp"); // Remove this in production
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response['Message']),
      ));
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
    double getResponsiveFontSize(double baseFontSize) {
      if (width > 400) {
        return baseFontSize * 1.2;
      } else if (width > 350) {
        return baseFontSize * 1.1;
      } else {
        return baseFontSize;
      }
    }

    EdgeInsets getResponsivePadding() {
      if (width > 400) {
        return EdgeInsets.symmetric(horizontal: widthScale(40), vertical: heightScale(25));
      } else if (width > 350) {
        return EdgeInsets.symmetric(horizontal: widthScale(30), vertical: heightScale(20));
      } else {
        return EdgeInsets.symmetric(horizontal: widthScale(20), vertical: heightScale(15));
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/welcome.png',
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
                  'Welcome',
                  style: TextStyle(
                    fontSize: getResponsiveFontSize(30),
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.1,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: widthScale(30)),
                child: Text(
                  'Raj Kumar Sharma',
                  style: TextStyle(
                    fontSize: getResponsiveFontSize(21),
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
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
                      padding: getResponsivePadding(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Enter MPIN',
                            style: TextStyle(
                              color: Color(0xFFE95168),
                              fontSize: getResponsiveFontSize(20),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: heightScale(15)),
                          Center(
                            child: Pinput(
                              length: 4,
                              controller: _mpinController,
                              obscureText: false,
                              defaultPinTheme: PinTheme(
                                height: 50,
                                width: 50,
                                textStyle: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          Center(
                            child: SizedBox(
                              height: heightScale(50),
                              width: 180,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFE95168),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(widthScale(20)),
                                  ),
                                ),
                                onPressed: () {
                                  // final enteredMpin = _mpinController.text.trim();
                                  //
                                  // if (enteredMpin.isEmpty) {
                                  //   _showCustomDialog(
                                  //     icon: Icons.warning_amber_rounded,
                                  //     iconColor: Colors.orangeAccent,
                                  //     title: 'MPIN Required',
                                  //     message: 'Please enter your MPIN before proceeding.',
                                  //   );
                                  // } else if (enteredMpin != receivedOtp) {
                                  //   _showCustomDialog(
                                  //     icon: Icons.error_outline,
                                  //     iconColor: Colors.redAccent,
                                  //     title: 'Incorrect MPIN',
                                  //     message: 'The MPIN you entered is incorrect. Please try again.',
                                  //   );
                                  // } else {
                                  //   context.pushNamed(AppPages.CustomBottomNavBar);
                                  // }
                                  context.pushNamed(AppPages.CustomBottomNavBar);
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Center(
                                      child: Text(
                                        "Continue",
                                        style: TextStyle(
                                          fontSize: fontScale(18),
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    SizedBox(width: widthScale(5)),
                                    Image.asset("assets/send.png", height: heightScale(19)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Center(
                            child: Text(
                              "Forgot MPIN?",
                              style: TextStyle(
                                color: Color(0xFF018BD3),
                                fontWeight: FontWeight.w600,
                                fontSize: getResponsiveFontSize(14),
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Center(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: Color(0xFFE1E1E1),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset('assets/figurelock.png', height: 35),
                                  SizedBox(width: 2),
                                  Text(
                                    "Use biometrics or device lock",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Color(0xFF362F2D),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          SizedBox(
                            height: heightScale(160),
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: PageView.builder(
                                      controller: _pageController,
                                      itemCount: 3,
                                      onPageChanged: (index) {
                                        setState(() {
                                          _currentPage = index;
                                        });
                                      },
                                      itemBuilder: (context, index) {
                                        return Image.asset(
                                          'assets/mpinslider.png',
                                          fit: BoxFit.fill,
                                          width: double.infinity,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Center(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: List.generate(3, (index) {
                                      return GestureDetector(
                                        onTap: () {
                                          _pageController.animateToPage(
                                            index,
                                            duration: const Duration(milliseconds: 300),
                                            curve: Curves.easeInOut,
                                          );
                                        },
                                        child: AnimatedContainer(
                                          duration: const Duration(milliseconds: 200),
                                          margin: const EdgeInsets.only(right: 6),
                                          width: _currentPage == index ? 24 : 16,
                                          height: 4,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(2),
                                            color: _currentPage == index ? Colors.blue : Colors.grey[400],
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
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

  void _showCustomDialog({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String message,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.fromLTRB(24, 24, 20, 5),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: iconColor,
              size: 50,
            ),
            const SizedBox(height: 15),
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.end,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.blue,
              textStyle: TextStyle(fontSize: 17),
            ),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

}
