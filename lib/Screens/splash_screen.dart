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

    _controller.forward(); // Start the animation

    _navigate(); // Start delayed navigation
  }

  Future<void> _navigate() async {
    await Future.delayed(Duration(seconds: 4)); // Wait for animation

    await AppCache().checkInit(); // Initialize cache
    bool isLoggedIn = AppCache().isUserLoggedIn();

    if (isLoggedIn) {
      context.go(AppPages.CustomBottomNavBar);
    } else {
      context.go(AppPages.customerselection);
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
            // Background splash image
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
