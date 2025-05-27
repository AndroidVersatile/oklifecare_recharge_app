// import 'package:flutter/material.dart';
//
// import 'package:provider/provider.dart';
// import 'package:uonly_app/theme/app_theme.dart';
//
// import '../../providers/loginProvider.dart';
// import '../../widgets/date_utils.dart';
// import '../noData_screen.dart';
//
//
//
// class CashbackReportScreen extends StatefulWidget {
//   const CashbackReportScreen({super.key});
//
//   @override
//   State<CashbackReportScreen> createState() => _CashbackReportScreenState();
// }
//
// class _CashbackReportScreenState extends State<CashbackReportScreen> {
//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
//       await context.read<ProviderScreen>().getDTHCashbackReport(all: true);
//       await context.read<ProviderScreen>().getPrepaidCashbackReport(all: true);
//     });
//
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var provider = Provider.of<ProviderScreen>(context);
//     var prepaid = provider.prepaidCashbackReportList;
//     var dth = provider.dthCashbackReportList;
//     if (dth != null && dth.isNotEmpty) {
//       dth.sort((a, b) {
//         DateTime dateA = DatesUtils.convertDateTime(a.tDate);
//         DateTime dateB = DatesUtils.convertDateTime(b.tDate);
//         return dateB.compareTo(dateA); // Most recent date first
//       });
//     }
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('CashBack Report'),
//         actions: [
//           PopupMenuButton<String>(
//             icon: Icon(Icons.filter_alt),
//             offset: Offset(0, 50),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(10),
//             ),
//             onSelected: (value) {
//               print('Selected: $value');
//               context
//                   .read<ProviderScreen>()
//                   .getDTHCashbackReport(all: value == 'all' ? true : false);
//               context
//                   .read<ProviderScreen>()
//                   .getPrepaidCashbackReport(all: value == 'all' ? true : false);
//             },
//             itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
//               PopupMenuItem<String>(
//                 value: 'all',
//                 child: Text('All'),
//               ),
//               PopupMenuItem<String>(
//                 value: 'user',
//                 child: Text('User'),
//               ),
//             ],
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//           padding: AppTheme.screenPadding,
//           width: context.screenWidth,
//           child: (prepaid.isEmpty && dth.isEmpty)
//               ? NoDataScreen()
//               : Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               if (prepaid.isNotEmpty) ...[
//                 Text(
//                   'Prepaid:-',
//                   style: context.textTheme.titleLarge?.copyWith(
//                     fontWeight: FontWeight.bold,
//                   ),
//                   textAlign: TextAlign.start,
//                 ),
//                 Container(
//                   padding: AppTheme.screenPadding,
//                   width: context.screenWidth,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(AppTheme.radius),
//                     color: Colors.grey.shade100,
//                     boxShadow: [
//                       BoxShadow(
//                         spreadRadius: 0.2,
//                         blurRadius: 2,
//                         color: context.colorScheme.shadow.withOpacity(0.4),
//                       ),
//                     ],
//                   ),
//                   child: ListView.builder(
//                     physics: const NeverScrollableScrollPhysics(),
//                     shrinkWrap: true,
//                     itemCount: prepaid.length,
//                     itemBuilder: (context, index) {
//                       final item = prepaid[index];
//                       return Container(
//                         padding: AppTheme.screenPadding,
//                         margin: const EdgeInsets.only(bottom: 10),
//                         width: double.infinity,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(AppTheme.radius),
//                           color: Colors.white,
//                           boxShadow: [
//                             BoxShadow(
//                               spreadRadius: 0.2,
//                               blurRadius: 2,
//                               color: context.colorScheme.shadow.withOpacity(0.4),
//                             ),
//                           ],
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               item.remark,
//                               style: const TextStyle(fontWeight: FontWeight.bold),
//                             ),
//                             Text(
//                               item.credit.toString(),
//                               style: const TextStyle(fontSize: 14),
//                             ),
//                             Text(
//                               DatesUtils.getFormattedDateFromDateTime(DatesUtils.convertDateTime(item.tDate)),
//                               style: const TextStyle(fontSize: 14),
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//               if (dth.isNotEmpty) ...[
//                 Container(
//                   padding: AppTheme.screenPadding,
//                   width: context.screenWidth,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(AppTheme.radius),
//                     color: Colors.grey.shade100,
//                     boxShadow: [
//                       BoxShadow(
//                         spreadRadius: 0.2,
//                         blurRadius: 2,
//                         color: context.colorScheme.shadow.withOpacity(0.4),
//                       ),
//                     ],
//                   ),
//                   child: ListView.builder(
//                     physics: const NeverScrollableScrollPhysics(),
//                     shrinkWrap: true,
//                     itemCount: dth.length,
//                     itemBuilder: (context, index) {
//                       final item = dth[index];
//                       bool isCredit = item.credit > 0; // Check if the transaction is a credit
//
//                       return Container(
//                         padding: AppTheme.screenPadding,
//                         margin: const EdgeInsets.only(bottom: 10),
//                         width: double.infinity,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(AppTheme.radius),
//                           color: Colors.white,
//                           boxShadow: [
//                             BoxShadow(
//                               spreadRadius: 0.2,
//                               blurRadius: 2,
//                               color: context.colorScheme.shadow.withOpacity(0.4),
//                             ),
//                           ],
//                         ),
//                         child: Row(
//                           children: [
//                             // Gift Icon instead of CircleAvatar
//                             Icon(
//                               Icons.card_giftcard,  // Gift icon
//                               color: isCredit ? Colors.green : Colors.orange, // Green for Credit, Orange for Debit
//                               size: 30,  // You can adjust the size of the icon
//                             ),
//                             const SizedBox(width: 10),
//                             // Transaction details
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   // Credit/Remark Details
//                                   Text(
//                                     isCredit ? 'Credit: ${item.credit.toStringAsFixed(2)}' : 'Debit: ${item.debit.toStringAsFixed(2)}',
//                                     style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//                                   ),
//                                   const SizedBox(height: 5),
//                                   // Date
//                                   Text(
//                                     'Date: ${DatesUtils.getFormattedDateFromDateTime(DatesUtils.convertDateTime(item.tDate))}',
//                                     style: const TextStyle(fontSize: 14),
//                                   ),
//                                   const SizedBox(height: 5),
//                                   // Remark
//                                   Text(
//                                     'Remark: ${item.remark}',
//                                     style: const TextStyle(fontSize: 14),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//
//                     },
//                   ),
//                 ),
//                 AppTheme.verticalSpacing(mul: 5),
//               ],
//
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
