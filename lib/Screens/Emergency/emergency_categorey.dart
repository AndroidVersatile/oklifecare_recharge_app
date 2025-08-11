// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// import 'Emergencyseva_form.dart';
// import 'emergency_userdetail.dart';
//
// class EmergencyCategoreyScreen extends StatefulWidget {
//   const EmergencyCategoreyScreen({super.key});
//
//   @override
//   State<EmergencyCategoreyScreen> createState() => _EmergencyCategoreyScreenState();
// }
//
// class _EmergencyCategoreyScreenState extends State<EmergencyCategoreyScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Emergency")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             SizedBox(height: 25,),
//             CategoryEmergencyCard(
//               icon: Icons.medical_services,
//               title: "Emergency Seva",
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (_) => const EmergencyFormScreen(title: "Emergency Seva"))
//                 );
//               },
//             ),
//             const SizedBox(height: 20),
//             CategoryEmergencyCard(
//               icon: Icons.bloodtype,
//               title: "Emergency User To User",
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (_) => const EmergencyDetailScreen()),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
//
// class CategoryEmergencyCard extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final VoidCallback onTap;
//
//   const CategoryEmergencyCard({
//     super.key,
//     required this.icon,
//     required this.title,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       child: Card(
//         // elevation: 1,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         child: Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(12),
//             gradient: const LinearGradient(
//               colors: [Color(0xFFE95168), Color(0xFFBA68C8)],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//           padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
//           child: Row(
//             children: [
//               Icon(icon, size: 32, color: Colors.white),
//               const SizedBox(width: 20),
//               Text(
//                 title,
//                 style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white, // Make text white for better contrast
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'Emergencyseva_form.dart';
import 'emergency_seva_form_screen.dart';


// Main BloodCategoreyScreen
class EmergencyCategoreyScreen extends StatefulWidget {
  const EmergencyCategoreyScreen({super.key});

  @override
  State<EmergencyCategoreyScreen> createState() => _EmergencyCategoreyScreenState();
}

class _EmergencyCategoreyScreenState extends State<EmergencyCategoreyScreen> {
  @override
  Widget build(BuildContext context) {
    final int donateCount = 5;
    final int acceptedCount = 3;

    // GridView की settings से match करने वाला width
    final screenWidth = MediaQuery.of(context).size.width;
    const horizontalPadding = 16.0 * 2; // Padding left + right
    const crossAxisSpacing = 10.0;     // GridView का crossAxisSpacing
    final cardWidth = (screenWidth - horizontalPadding - crossAxisSpacing) / 2;

    final categories = [
      {
        'icon': Icons.volunteer_activism,
        'title': 'Emergency e-Card Seva',
        'onTap': () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => EmergencyFormScreen(title: " Emergency e-Card Seva"),
          ),
        ),
      },
      {
        'icon': FontAwesomeIcons.handsHoldingCircle,
        'title': 'Request Details',
        'onTap': () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const EmergencySevaFormScreen(title: ''),
          ),
        ),
      },
      {
        'icon': FontAwesomeIcons.heartPulse,
        'title': 'Emergency User to User',
        'onTap': () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => EmergencyFormScreen(title: 'Emergency User to User'),
          ),
        ),
      },
      {
        'icon': FontAwesomeIcons.usersBetweenLines,
        'title': ' Request Details',
        'onTap': () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const EmergencySevaFormScreen(title: " Request Details"),
          ),
        ),
      },
      {
        'icon': MdiIcons.bloodBag,
        'title': 'Emergency Family Contact',
        'onTap': () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const EmergencyFormScreen(title: "Emergency Family Contact"),
          ),
        ),
      },
      {
        'icon': FontAwesomeIcons.droplet,
        'title': 'Emergency Family Contact QR',
        'onTap': () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const EmergencySevaFormScreen(title: "Emergency Family Contact QR"),
          ),
        ),
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Emergency Seva")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 📊 Top Summary Counts
            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    "Emergency Support",
                    donateCount,
                    Colors.redAccent,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildSummaryCard(
                    "Emergency Accept",
                    acceptedCount,
                    Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // 🔳 Category Grid
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
            // 🏆 Points Card
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
                      const Icon(Icons.emoji_events,
                          color: Colors.amber, size: 28),
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
            ),
          ],
        ),
      ),
    );
  }

  // 🧱 Helper for summary cards (अब width पैरामीटर के साथ)
  Widget _buildSummaryCard(String title, int count, Color color) {
    return Container(
      height: 110,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: color,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
    return GestureDetector(
      onTap: widget.onTap,
      child: Card(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              colors: const [Color(0xFFE95168), Color(0xFFBA68C8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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

// Placeholder for your form screen
class EmergencySevaFormScreen extends StatelessWidget {
  final String title;
  const EmergencySevaFormScreen({super.key, required this.title});
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text(title)), body: Container());
  }
}