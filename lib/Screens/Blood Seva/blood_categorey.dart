
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:uonly_app/Screens/Blood%20Seva/userbloodseva_form.dart';

import 'ecard_requestdetailscreen.dart';
import 'ecardseva_form.dart';


// Main BloodCategoreyScreen
class BloodCategoreyScreen extends StatefulWidget {
  const BloodCategoreyScreen({super.key});

  @override
  State<BloodCategoreyScreen> createState() => _BloodCategoreyScreenState();
}

class _BloodCategoreyScreenState extends State<BloodCategoreyScreen> {
  @override
  Widget build(BuildContext context) {
    final int donateCount = 5;
    final int acceptedCount = 3;

    final categories = [
      {
        'icon': Icons.volunteer_activism,
        'title': 'E-Card Seva',
        'onTap': () =>
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>BloodSevaFormScreen(title: "E-Card Seva"),
              ),
            ),
      },
      {
        'icon': FontAwesomeIcons.handsHoldingCircle,
        'title': 'Request Details',
        'onTap': () =>
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                const EcardRequestDetailScreen(),
              ),
            ),
      },
      {
        'icon': FontAwesomeIcons.heartPulse,
        'title': 'User Blood Seva',
        'onTap': () =>
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => UserBloodSevaFromScreen(),
              ),
            ),
      },
      {
        'icon': FontAwesomeIcons.usersBetweenLines,
        'title': 'Request History',
        'onTap': () =>
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                const BloodSevaFormScreen(title: "Request History"),
              ),
            ),
      },
      {
        'icon': MdiIcons.bloodBag,
        'title': 'Blood Donate',
        'onTap': () =>
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                const BloodSevaFormScreen(title: "Blood Donate"),
              ),
            ),
      },
      {
        'icon': FontAwesomeIcons.droplet,
        'title': 'Blood Details',
        'onTap': () {
          // TODO: Implement navigation
        },
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Blood Seva")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 📊 Top Summary Counts
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSummaryCard(
                    "Blood Donate", donateCount, Colors.redAccent),
                _buildSummaryCard(
                    "Request Accept", acceptedCount, Colors.green),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: GridView.builder(
                itemCount: categories.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1.4,
                ),
                itemBuilder: (context, index) {
                  final item = categories[index];
                  return CategoryCard(
                    icon: item['icon'] as IconData,
                    title: item['title'] as String,
                    onTap: item['onTap'] as VoidCallback,
                  );
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 16),
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(16),

                border: Border.all(
                  color: Colors.amber.shade400,
                  width: 2,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.emoji_events, color: Colors.amber, size: 28),
                      const SizedBox(width: 10),
                      const Text(
                        'Blood Donate Points',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '1000',
                    style: TextStyle(
                      color: Colors.green.shade800,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )

          ],
        ),
      ),
    );
  }

  // 🧱 Helper for summary cards
  Widget _buildSummaryCard(String title, int count, Color color) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 150,
        height: 110,
        // 🔧 Add fixed height here
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: color,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // 🔄 Center vertically
          children: [
            Text(
              "$count",
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),


          ],
        ),
      ),
    );
  }
}

// 🧱 Reusable Category Card
class CategoryCard extends StatefulWidget {
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
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  @override
  Widget build(BuildContext context) {
    return   GestureDetector(
      onTap: widget.onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient:LinearGradient(
              colors: [Color(0xFFE95168), Color(0xFFBA68C8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(widget.icon, size: 35, color: Colors.white),
              const SizedBox(height: 3),
              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
