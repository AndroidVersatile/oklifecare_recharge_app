// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
//
// import '../../models/wallet_statement_model.dart';
//
// class TransactionDetailScreen extends StatelessWidget {
//   final WalletStatementModel transaction;
//
//   const TransactionDetailScreen({super.key, required this.transaction});
//   String formatDate(String rawDate) {
//     final timestampStr = rawDate.replaceAll(RegExp(r'[^\d]'), '');
//     final timestamp = int.tryParse(timestampStr);
//     if (timestamp == null) return rawDate;
//
//     final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
//     return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final isCredit = transaction.displaySts == "Credit";
//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text(
//           'Transaction Details',
//           style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
//         ),
//         centerTitle: true,
//       ),
//       body: ListView(
//         padding: const EdgeInsets.all(16),
//         children: [
//           _buildSuccessHeader(),
//           const SizedBox(height: 20),
//           _buildRecipientCard(),
//           const SizedBox(height: 20),
//           _buildDetailsSection(),
//           const SizedBox(height: 24),
//           _buildActionButtons(context),
//           const SizedBox(height: 30),
//           _buildSupportCard(),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSuccessHeader() {
//     return Column(
//       children: [
//         const Icon(Icons.check_circle, color: Colors.green, size: 60),
//         const SizedBox(height: 10),
//         const Text(
//           'Transaction Successful',
//           style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.green),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           transaction['time'] ?? '',
//           style: const TextStyle(color: Colors.grey),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildRecipientCard() {
//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Row(
//           children: [
//             CircleAvatar(
//               radius: 30,
//               backgroundColor: Colors.blue.shade100,
//               child: const Icon(Icons.account_circle, color: Colors.blue, size: 32),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     transaction['name'] ?? 'Recipient',
//                     style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     transaction['upi'] ?? 'UPI ID',
//                     style: const TextStyle(color: Colors.grey),
//                   ),
//                 ],
//               ),
//             ),
//             Text(
//               transaction['amount'] ?? '₹--',
//               style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDetailsSection() {
//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text("Payment Info", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//             const Divider(height: 20),
//             _buildDetailRow("Transaction ID", transaction['txnId']),
//             _buildDetailRow("Debited From", transaction['account']),
//             _buildDetailRow("UTR", transaction['utr']),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDetailRow(String label, String? value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(label, style: const TextStyle(color: Colors.grey)),
//           Expanded(
//             child: Text(
//               value ?? '--',
//               textAlign: TextAlign.right,
//               style: const TextStyle(fontWeight: FontWeight.w500),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildActionButtons(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         _SimpleActionButton(
//           icon: Icons.receipt,
//           label: 'View Receipt',
//           onTap: () {
//             // TODO
//           },
//         ),
//         _SimpleActionButton(
//           icon: Icons.share,
//           label: 'Share',
//           onTap: () {
//             // TODO
//           },
//         ),
//       ],
//     );
//   }
//
//   Widget _buildSupportCard() {
//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: ListTile(
//         contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         leading: const Icon(Icons.help_outline, color: Colors.blue),
//         title: const Text("Need Help?", style: TextStyle(fontWeight: FontWeight.w600)),
//         subtitle: const Text("Contact our support team"),
//         trailing: const Icon(Icons.arrow_forward_ios, size: 16),
//         onTap: () {
//           // TODO
//         },
//       ),
//     );
//   }
// }
//
// class _SimpleActionButton extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final VoidCallback? onTap;
//
//   const _SimpleActionButton({
//     required this.icon,
//     required this.label,
//     this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Column(
//         children: [
//           CircleAvatar(
//             radius: 26,
//             backgroundColor: Colors.blue.shade50,
//             child: Icon(icon, color: Colors.blue, size: 24),
//           ),
//           const SizedBox(height: 8),
//           Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
//         ],
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/wallet_statement_model.dart';

class TransactionDetailScreen extends StatelessWidget {
  final WalletStatementModel transaction;

  const TransactionDetailScreen({super.key, required this.transaction});

  String formatDate(String rawDate) {
    final timestampStr = rawDate.replaceAll(RegExp(r'[^\d]'), '');
    final timestamp = int.tryParse(timestampStr);
    if (timestamp == null) return rawDate;

    final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final isCredit = transaction.displaySts.toLowerCase() == "credit";

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Transaction Details',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSuccessHeader(),
          const SizedBox(height: 20),
          _buildRecipientCard(),
          const SizedBox(height: 20),
          _buildDetailsSection(),
          const SizedBox(height: 24),
          _buildActionButtons(context),
          const SizedBox(height: 30),
          _buildSupportCard(),
        ],
      ),
    );
  }

  Widget _buildSuccessHeader() {
    return Column(
      children: [
        const Icon(Icons.check_circle, color: Colors.green, size: 60),
        const SizedBox(height: 10),
        const Text(
          'Transaction Successful',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.green),
        ),
        const SizedBox(height: 4),
        Text(
          formatDate(transaction.tDate),
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildRecipientCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.blue.shade100,
              child: const Icon(Icons.account_circle, color: Colors.blue, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.memFirstName,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'UPI ID', // Static
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            Text(
              transaction.credit != "0" && transaction.credit != ""
                  ? '₹${transaction.credit}'
                  : '₹${transaction.debit}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsSection() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Payment Info", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const Divider(height: 20),
            _buildDetailRow("Transaction ID", transaction.idNo),
            _buildDetailRow("Debited From", " Bank A/C ****1234"),
            _buildDetailRow("UTR", "315620198765"), // Used "mode" as a placeholder
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Expanded(
            child: Text(
              value ?? '--',
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _SimpleActionButton(
          icon: Icons.receipt,
          label: 'View Receipt',
          onTap: () {
            // TODO: Implement View Receipt
          },
        ),
        _SimpleActionButton(
          icon: Icons.share,
          label: 'Share',
          onTap: () {
            // TODO: Implement Share
          },
        ),
      ],
    );
  }

  Widget _buildSupportCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: const Icon(Icons.help_outline, color: Colors.blue),
        title: const Text("Need Help?", style: TextStyle(fontWeight: FontWeight.w600)),
        subtitle: const Text("Contact our support team"),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // TODO: Navigate to Support Page
        },
      ),
    );
  }
}

class _SimpleActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _SimpleActionButton({
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: Colors.blue.shade50,
            child: Icon(icon, color: Colors.blue, size: 24),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
