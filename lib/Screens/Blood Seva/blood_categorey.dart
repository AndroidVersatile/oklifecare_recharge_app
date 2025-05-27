import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uonly_app/Screens/Blood%20Seva/uerbloodseva_screen.dart';

import 'blood_donateform.dart';
import 'ecardseva_form.dart';


class BloodCategoreyScreen extends StatelessWidget {
  const BloodCategoreyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Blood Seva")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 25,),
            CategoryCard(
              icon: Icons.medical_services,
              title: "E-Card Seva",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BloodSevaFormScreen(title: "E-Card Seva")),
                );
              },
            ),
            const SizedBox(height: 20),
            CategoryCard(
              icon: Icons.bloodtype,
              title: "User Blood Seva",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) =>  UserBloodSevaScreen(title: "User Blood Detail")),
                );
              },
            ),
            const SizedBox(height: 20),
            CategoryCard(
              icon: Icons.volunteer_activism,
              title: "Blood Donate",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const BlooddonateFormScreen(title: "Blood Donate"),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        // elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: const LinearGradient(
              colors: [Color(0xFFE95168), Color(0xFFBA68C8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Row(
            children: [
              Icon(icon, size: 32, color: Colors.white),
              const SizedBox(width: 20),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Make text white for better contrast
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}






