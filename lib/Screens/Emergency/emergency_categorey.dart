import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'Emergencyseva_form.dart';
import 'emergency_userdetail.dart';

class EmergencyCategoreyScreen extends StatefulWidget {
  const EmergencyCategoreyScreen({super.key});

  @override
  State<EmergencyCategoreyScreen> createState() => _EmergencyCategoreyScreenState();
}

class _EmergencyCategoreyScreenState extends State<EmergencyCategoreyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Emergency")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 25,),
            CategoryEmergencyCard(
              icon: Icons.medical_services,
              title: "Emergency Seva",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EmergencyFormScreen(title: "Emergency Seva"))
                );
              },
            ),
            const SizedBox(height: 20),
            CategoryEmergencyCard(
              icon: Icons.bloodtype,
              title: "Emergency User To User",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EmergencyDetailScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}



class CategoryEmergencyCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const CategoryEmergencyCard({
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

