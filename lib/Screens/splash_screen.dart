import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_cache.dart';
import '../routing/app_pages.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();

    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 4));
    await AppCache().checkInit();
    bool isLoggedIn = AppCache().isUserLoggedIn();
    if (mounted) {
      if (isLoggedIn) {
        context.go(AppPages.CustomBottomNavBar);
      } else {
        context.go(AppPages.customerselection);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              "assets/splashh.png",
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),

          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
