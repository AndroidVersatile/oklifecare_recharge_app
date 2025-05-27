import 'package:flutter/material.dart';
import 'package:uonly_app/Screens/receivemoney_screen.dart';
import 'package:uonly_app/Screens/sendmoney_screen.dart';

class WalletStatementScreen extends StatefulWidget {
  const WalletStatementScreen({super.key});

  @override
  State<WalletStatementScreen> createState() => _WalletStatementScreenState();
}

class _WalletStatementScreenState extends State<WalletStatementScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Wallet Statement'),
          bottom: const TabBar(
            labelColor: Color(0xFF0075C5),
            unselectedLabelColor: Colors.grey,
            labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.0),
            unselectedLabelStyle: TextStyle(fontSize: 14),
            tabs: [
              Tab(text: 'Send Money'),
              Tab(text: 'Receive Money'),

            ],
          ),
        ),
        body: TabBarView(
          children: [
            SendMoneyScreen(),
           ReceiveMoneyScreen(),

          ],
        ),
      ),
    );
  }
}