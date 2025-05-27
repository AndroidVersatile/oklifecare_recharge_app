import 'package:flutter/material.dart';
import 'package:uonly_app/Screens/Profile_screen/pancard_screen.dart';
import 'package:uonly_app/Screens/Profile_screen/passbook_screen.dart';
import 'aadharcard_screen.dart';

class KycUpdateScreen extends StatefulWidget {
  const KycUpdateScreen({super.key});

  @override
  State<KycUpdateScreen> createState() => _KycUpdateScreenState();
}

class _KycUpdateScreenState extends State<KycUpdateScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void goToNextTab() {
    if (_tabController.index < 2) {
      _tabController.animateTo(_tabController.index + 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UPLOAD KYC DOCUMENT'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Aadhar'),
            Tab(text: 'PAN Card'),
            Tab(text: 'Other Document'),

          ],
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.black,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          AadharCardScreen(onNext: goToNextTab),
          PancardScreen(onNext: goToNextTab),
          PassbookScreen(onNext: goToNextTab),

        ],
      ),
    );
  }
}
