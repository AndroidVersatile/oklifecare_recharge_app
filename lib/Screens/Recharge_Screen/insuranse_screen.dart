import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InsuranseScreen extends StatefulWidget {
  const InsuranseScreen({super.key});

  @override
  State<InsuranseScreen> createState() => _InsuranseScreenState();
}

class _InsuranseScreenState extends State<InsuranseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Insuranse',
          style: TextStyle(color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF8E2DE2), // ऊपर का हल्का बैंगनी
                Color(0xFF4A00E0), // नीचे का गहरा बैंगनी
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // कॉलम के बच्चों को सेंटर में लाएं
          children: [
            Image.asset(
              'assets/comingsoon.png', // आपकी "no data found" इमेज
              height: 350, // इमेज की ऊंचाई
              width: 350, // इमेज की चौड़ाई
              fit: BoxFit.contain, // इमेज को कंटेनर में फिट करें
            ),
            const SizedBox(height: 16), // इमेज और टेक्स्ट के बीच स्पेस

          ],
        ),
      ),
    );
  }
}
