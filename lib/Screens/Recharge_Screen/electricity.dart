import 'package:flutter/material.dart';
import 'package:flutter/material.dart';


class ElectricityScreen extends StatefulWidget {
  @override
  State<ElectricityScreen> createState() => _ElectricityScreenState();
}

class _ElectricityScreenState extends State<ElectricityScreen> {
  String billerName = '';
  final List<Map<String, String>> rajasthanBillers = [
    {'name': 'Ajmer Vidyut Vitran Nigam Ltd (AVVNL)'},
    {'name': 'Bharatpur Electricity Services Ltd (BESL)'},
    {'name': 'Bikaner Electricity Supply Limited (BKSEL)'},
    {'name': 'Jaipur Vidyut Vitran Nigam Ltd (JVVNL)'},
    {'name': 'Jodhpur Vidyut Vitran Nigam Limited (JDVVNL)'},
    {'name': 'Kota Electricity Distribution Ltd (KEDL)'},
    {'name': 'TP Ajmer Distribution Ltd - Rajasthan (TPADL)'},
  ];

  final List<Map<String, String>> allBillers = [
    {'name': 'Adani Electricity Mumbai Limited (AEML)'},
    {'name': 'Ajmer Vidyut Vitran Nigam Ltd (AVVNL)'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Select Electricity Provider',
          style: TextStyle(color: Colors.black),
        ),
        leading: const BackButton(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            searchBar(context),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: [
                  sectionTitle('Billers in Rajasthan'),
                  ...rajasthanBillers.map(buildBillerTile),
                  sectionTitle('All Billers'),
                  ...allBillers.map(buildBillerTile),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget searchBar(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SearchBillerScreen(
              billers: [...rajasthanBillers, ...allBillers],
            ),
          ),
        );
      },
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.grey[300]!),
          color: Colors.white,
        ),
        alignment: Alignment.centerLeft,
        child: Row(
          children: const [
            Icon(Icons.search, color: Colors.grey),
            SizedBox(width: 10),
            Text(
              'Search by biller',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  IconData getIconForBiller(String name) {
    if (name.contains('Ajmer')) return Icons.flash_on;
    if (name.contains('Jaipur')) return Icons.lightbulb_outline;
    if (name.contains('Jodhpur')) return Icons.bolt;
    if (name.contains('Adani')) return Icons.electric_bolt;
    if (name.contains('Kota')) return Icons.power;
    return Icons.electrical_services;
  }
// Inside buildBillerTile method
  Widget buildBillerTile(Map<String, String> biller) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      leading: CircleAvatar(
        backgroundColor: Colors.grey[200],
        radius: 22,
        child: Icon(
          getIconForBiller(biller['name']!),
          color: Colors.blueGrey,
          size: 24,
        ),
      ),
      title: Text(
        biller['name']!,
        style: const TextStyle(color: Colors.black, fontSize: 14),
      ),
      onTap: () {

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BillPaymentScreen(billerName: biller['name']!),
          ),
        );
      },
    );
  }

}

class SearchBillerScreen extends StatefulWidget {
  final List<Map<String, String>> billers;

  const SearchBillerScreen({super.key, required this.billers});

  @override
  State<SearchBillerScreen> createState() => _SearchBillerScreenState();
}

class _SearchBillerScreenState extends State<SearchBillerScreen> {
  List<Map<String, String>> filteredBillers = [];
  String query = '';

  @override
  void initState() {
    super.initState();
    filteredBillers = widget.billers;
  }

  void updateSearch(String input) {
    setState(() {
      query = input;
      filteredBillers = widget.billers
          .where((biller) =>
          biller['name']!.toLowerCase().contains(input.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // ✅ Set scaffold background to white
      appBar: AppBar(
        backgroundColor: Colors.white, // ✅ AppBar background
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: TextField(
          autofocus: true,
          onChanged: updateSearch,
          style: const TextStyle(color: Colors.black),
          decoration: const InputDecoration(
            hintText: 'Search by biller',
            hintStyle: TextStyle(color: Colors.grey),
            border: InputBorder.none,
          ),
        ),
      ),
      body: Container(
        color: Colors.white, // ✅ Ensures ListView has white background
        child: ListView.builder(
          itemCount: filteredBillers.length,
          itemBuilder: (_, index) {
            final biller = filteredBillers[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey[200],
                child: const Icon(
                  Icons.electrical_services,
                  color: Colors.blueGrey,
                ),
              ),
              title: Text(
                biller['name']!,
                style: const TextStyle(color: Colors.black,fontWeight: FontWeight.normal,fontSize: 14),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) =>  BillPaymentScreen(billerName: biller['name']!)),
                );
              },
            );
          },
        ),
      ),
    );
  }
}



class BillPaymentScreen extends StatefulWidget {
  final String billerName;

  const BillPaymentScreen({super.key, required this.billerName});

  @override
  State<BillPaymentScreen> createState() => _BillPaymentScreenState();
}

class _BillPaymentScreenState extends State<BillPaymentScreen> {
  final TextEditingController _kNumberController = TextEditingController();
  bool isFilled = false;

  @override
  void initState() {
    super.initState();
    _kNumberController.addListener(() {
      setState(() {
        isFilled = _kNumberController.text.length == 12;
      });
    });
  }

  @override
  void dispose() {
    _kNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          widget.billerName,
          style: const TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: Icon(Icons.help_outline, color: Colors.black),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'K Number',
              style: TextStyle(color: Colors.black87, fontSize: 14),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _kNumberController,
              style: const TextStyle(color: Colors.black),
              keyboardType: TextInputType.number,
              maxLength: 12,
              decoration: InputDecoration(
                counterText: '',
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                hintText: 'Please enter a valid 12 digit K Number',
                hintStyle: const TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Icon(Icons.shield_outlined, color: Colors.grey, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'By continuing, you authorize the app to fetch your current and upcoming bills and send reminders',
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ),
              ],
            ),
            const Spacer(),

            // Confirm Button
            SizedBox(
              width: double.infinity,
              child: Container(
                decoration: BoxDecoration(
                  gradient: isFilled
                      ? const LinearGradient(
                    colors: [Color(0xFFE95168), Color(0xFFBA68C8)],
                  )
                      : null,
                  color: isFilled ? null : Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ElevatedButton(
                  onPressed: isFilled
                      ? () {
                   Navigator.push(context,MaterialPageRoute(builder:(context)=>PaymentConfirmationScreen(billerName: widget.billerName,)));
                  }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'CONFIRM',
                    style: TextStyle(
                      color: isFilled ? Colors.white : Colors.grey,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class PaymentConfirmationScreen extends StatefulWidget {
  final String billerName;

  const PaymentConfirmationScreen({super.key, required this.billerName});

  @override
  State<PaymentConfirmationScreen> createState() =>
      _PaymentConfirmationScreenState();
}

class _PaymentConfirmationScreenState extends State<PaymentConfirmationScreen> {
  String paymentStatus = 'Pending'; // Mocked payment status
  double amountDue = 150.50; // Example amount
  String dueDate = '2025-05-15'; // Example due date

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          '${widget.billerName} - Payment Confirmation',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: Icon(Icons.help_outline, color: Colors.black),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Payment Summary',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            PaymentDetailTile(label: 'Amount Due:', value: '₹$amountDue'),
            PaymentDetailTile(label: 'Due Date:', value: dueDate),
            PaymentDetailTile(label: 'Status:', value: paymentStatus),
            const SizedBox(height: 24),
            const Text(
              'Please confirm your payment details before proceeding.',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFE95168), Color(0xFFBA68C8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    // Logic to confirm the payment
                    setState(() {
                      paymentStatus = 'Paid'; // Mocking a successful payment
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'CONFIRM PAYMENT',
                    style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (paymentStatus == 'Paid')
              Center(
                child: Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                  size: 40,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class PaymentDetailTile extends StatelessWidget {
  final String label;
  final String value;

  const PaymentDetailTile({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
