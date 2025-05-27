import 'package:flutter/material.dart';
import 'package:uonly_app/widgets/button.dart';

class UpgradeidScreen extends StatefulWidget {
  const UpgradeidScreen({super.key});

  @override
  State<UpgradeidScreen> createState() => _UpgradeidScreenState();
}

class _UpgradeidScreenState extends State<UpgradeidScreen> {
  final TextEditingController userIdController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  String? selectedPlan;
  final List<String> plans = ['Plan 1', 'Plan 2'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upgrade ID"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User ID
            TextField(
              controller: userIdController,
              decoration: const InputDecoration(
                labelText: 'User ID No.',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // User Name
            TextField(
              controller: userNameController,
              decoration: const InputDecoration(
                labelText: 'User Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Upgrade Type Dropdown
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Select Upgrade Type',
                border: OutlineInputBorder(),
              ),
              value: selectedPlan,
              items: plans.map((plan) {
                return DropdownMenuItem(
                  value: plan,
                  child: Text(plan),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedPlan = value;
                  if (value == 'Plan 1') {
                    amountController.text = '500';
                  } else if (value == 'Plan 2') {
                    amountController.text = '1000';
                  }
                });
              },
            ),
            const SizedBox(height: 16),

            // Plan Amount
            TextField(
              controller: amountController,
              decoration: const InputDecoration(
                labelText: 'Plan Amount',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 30),

            // Update Button
            Center(
              child: CustomElevatedBtn(onPressed:(){}, text: "Update",isBigSize: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
