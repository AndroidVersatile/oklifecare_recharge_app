import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uonly_app/providers/loginProvider.dart';

import '../theme/app_theme.dart';
import '../widgets/date_utils.dart';
import 'noData_screen.dart';

class ReceiveMoneyScreen extends StatefulWidget {
  const ReceiveMoneyScreen({super.key});

  @override
  State<ReceiveMoneyScreen> createState() => _ReceiveMoneyScreenState();
}

class _ReceiveMoneyScreenState extends State<ReceiveMoneyScreen> {
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

    final creditOnly = wallet
        ?.where((item) => item.crDrType == 'C')
        .toList()
      ?..sort((a, b) => DatesUtils.convertDateTime(b.tDate)
          .compareTo(DatesUtils.convertDateTime(a.tDate)));

    return Scaffold(
      body: creditOnly != null && creditOnly.isNotEmpty
          ? ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: creditOnly.length,
        separatorBuilder: (_, __) => const Divider(
          color: Color(0xFFDDDDDD),
          thickness: 1,
          height: 24,
        ),
        itemBuilder: (context, index) {
          final datum = creditOnly[index];

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Circular Icon
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green.shade600, // Green for credit
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
                          '+${datum.credit}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade800, // Green text
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
                          datum.mobileNo.toString(),
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF616161),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Remark (Full text shown, multiple lines)
                    Text(
                      'Remark: ${datum.remark}',
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: Color(0xFF757575),
                        height: 1.4,
                      ),
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
