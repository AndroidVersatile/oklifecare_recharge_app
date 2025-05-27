// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:uonly_app/providers/loginProvider.dart';
//
// import '../theme/app_theme.dart';
// import '../widgets/date_utils.dart';
// import 'noData_screen.dart';
//
// class SendMoneyScreen extends StatefulWidget {
//   const SendMoneyScreen({super.key});
//
//   @override
//   State<SendMoneyScreen> createState() => _SendMoneyScreenState();
// }
//
// class _SendMoneyScreenState extends State<SendMoneyScreen> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<ProviderScreen>().getWalletStatement();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<ProviderScreen>(context);
//     final wallet = provider.walletList;
//
//     if (wallet != null && wallet.isNotEmpty) {
//       wallet.sort((a, b) {
//         final dateA = DatesUtils.convertDateTime(a.tDate);
//         final dateB = DatesUtils.convertDateTime(b.tDate);
//         return dateB.compareTo(dateA);
//       });
//     }
//
//     return Scaffold(
//       // appBar: AppBar(
//       //   title: const Text('Wallet Statement'),
//       // ),
//       body: wallet != null && wallet.isNotEmpty
//           ? ListView.separated(
//         padding: AppTheme.screenPadding,
//         itemCount: wallet.length,
//         separatorBuilder: (_, __) => Divider(
//           color: Colors.grey.shade300,
//           thickness: 0.8,
//           height: 20,
//         ),
//         itemBuilder: (context, index) {
//           final datum = wallet[index];
//           final isCredit = datum.crDrType == 'C';
//
//           return Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(10),
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: isCredit ? Colors.green : Colors.orange,
//                 ),
//                 child: Text(
//                   datum.crDrType,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Expanded(
//                           child: Text(
//                             datum.memFirstName,
//                             style: const TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ),
//                         Text(
//                           '₹${isCredit ? datum.credit : datum.debit}',
//                           style: TextStyle(
//                             fontSize: 15,
//                             fontWeight: FontWeight.bold,
//                             color: isCredit ? Colors.green : Colors.orange,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       'Date: ${DatesUtils.getFormattedDateFromDateTime(DatesUtils.convertDateTime(datum.tDate))}',
//                       style: const TextStyle(
//                         fontSize: 13,
//                         color: Colors.grey,
//                       ),
//                     ),
//                     const SizedBox(height: 2),
//                     Text(
//                       'Remark: ${datum.remark}',
//                       style: const TextStyle(
//                         fontSize: 13,
//                         color: Colors.black54,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           );
//         },
//       )
//           : const NoDataScreen(),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uonly_app/providers/loginProvider.dart';
import '../theme/app_theme.dart';
import '../widgets/date_utils.dart';
import 'noData_screen.dart';

class SendMoneyScreen extends StatefulWidget {
  const SendMoneyScreen({super.key});

  @override
  State<SendMoneyScreen> createState() => _SendMoneyScreenState();
}

class _SendMoneyScreenState extends State<SendMoneyScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProviderScreen>().getWalletStatement();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProviderScreen>(context);
    final wallet = provider.walletList;

    final debitOnly = wallet
        ?.where((item) => item.crDrType == 'D')
        .toList()
      ?..sort((a, b) => DatesUtils.convertDateTime(b.tDate)
          .compareTo(DatesUtils.convertDateTime(a.tDate)));

    return Scaffold(
      body: debitOnly != null && debitOnly.isNotEmpty
          ? ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: debitOnly.length,
        separatorBuilder: (_, __) => const Divider(
          color: Color(0xFFDDDDDD),
          thickness: 1,
          height: 24,
        ),
        itemBuilder: (context, index) {
          final datum = debitOnly[index];

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Circular Icon
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.orange.shade700,
                ),
                child: Text(
                  datum.crDrType,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name + Amount
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            datum.memFirstName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF212121),
                            ),
                          ),
                        ),
                        Text(
                          '-${datum.debit}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFE65100),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // Date
                    Row(
                      children: [
                        const Icon(Icons.calendar_today,
                            size: 14, color: Colors.blueGrey),
                        const SizedBox(width: 6),
                        Text(
                          DatesUtils.getFormattedDateFromDateTime(
                            DatesUtils.convertDateTime(datum.tDate),
                          ),
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF616161),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Mobile Number
                    Row(
                      children: [
                        const Icon(Icons.phone_android,
                            size: 14, color: Colors.teal),
                        const SizedBox(width: 6),
                        Text(
                          datum.mobileNo.toString() ?? '',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF616161),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Remark (Styled, Limited Lines)
                    Text(
                      'Remark : ${datum.remark}',
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: Color(0xFF757575),
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 3,
                    ),

                  ],
                ),
              ),
            ],
          );
        },
      )
          : const NoDataScreen(),
    );
  }
}
