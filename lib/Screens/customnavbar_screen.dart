
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uonly_app/Screens/scantopay_screen.dart';
import '../theme/app_theme.dart';
import '../widgets/error_utils.dart';
import 'Login/home_screen.dart';

import 'Transction history/transaction_history.dart';

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({Key? key}) : super(key: key);

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  int currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    _fetchCounts();
  }

  Future<void> _fetchCounts() async {
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        ErrorUtils.showConfirmDialog(
          context,
          color: context.colorScheme.primary,
          onConfirm: () {
            SystemNavigator.pop();
          },
          message: 'Are you sure you want to exit?',
        );
      },
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              currentPage = index;
            });
          },
          children: const [
            HomeScreen(),
            ScantoPayScreen(),
            HistoryScreen(),
          ],
        ),

        // ✅ Floating QR Button (moved slightly lower)
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: GestureDetector(
          onTap: () {
            setState(() {
              currentPage = 1;
              _pageController.jumpToPage(1);
            });
          },
          child: Padding(
            padding:  EdgeInsets.only(top: 10),
            child: Container(
              height: 60,
              width: 65,
              margin: const EdgeInsets.only(top: 50),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFFE91E63), Color(0xFFE91E63)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),

              ),
              padding: const EdgeInsets.all(12),
              child: const Icon(Icons.qr_code_scanner, color: Colors.white, size: 35),
            ),
          ),
        ),

        // ✅ Bottom Navigation Bar
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 0,
          color: Colors.white,
          child: Container(
            height: 90,
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildNavItem(imagePath:"assets/home.png", label: 'Home', index: 0, ),
                buildNavItem(imagePath:"assets/history.png", label: 'History', index: 2,),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildNavItem({required String imagePath, required String label, required int index}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          currentPage = index;
          _pageController.jumpToPage(index);
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imagePath,height: 30,fit: BoxFit.fill,),

          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: currentPage == index ? Colors.black : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
