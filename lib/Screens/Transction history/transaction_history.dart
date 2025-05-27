
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uonly_app/Screens/Transction%20history/transaction_detailscreen.dart';
import '../../models/wallet_statement_model.dart';
import '../../providers/loginProvider.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<WalletStatementModel> _filteredList = [];

  @override
  void initState() {
    super.initState();

    final provider = context.read<ProviderScreen>();
    provider.getWalletStatement().then((_) {
      _filteredList = provider.walletList;
    });

    _searchController.addListener(_filterList);
  }

  void _filterList() {
    final query = _searchController.text.toLowerCase();
    final provider = context.read<ProviderScreen>();

    setState(() {
      _filteredList = provider.walletList.where((txn) {
        return txn.memFirstName.toLowerCase().contains(query) ||
            txn.remark.toLowerCase().contains(query) ||
            txn.tDate.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _openFilter() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black,
      builder: (context) {
        return FilterSheet();
      },
    );
  }

  String formatTransactionDate(String rawDate) {
    final timestampStr = rawDate.replaceAll(RegExp(r'[^\d]'), '');
    final timestamp = int.tryParse(timestampStr);
    if (timestamp == null) return '';

    final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inHours < 12) {
      if (difference.inMinutes < 1) {
        return 'Just now';
      } else if (difference.inMinutes < 60) {
        return '${difference.inMinutes} minutes ago';
      } else {
        return '${difference.inHours} hours ago';
      }
    } else {
      return DateFormat('dd MMM yyyy').format(dateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProviderScreen>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title:Text("Transaction History"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        // foregroundColor: Colors.w,
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: _openFilter,
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.tune, color: Colors.grey),
                          SizedBox(width: 8),
                          Text("Filter",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      // download logic
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      color: const Color(0xFFE8F4FD),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        child: Row(
                          children: const [
                            Icon(Icons.file_download_outlined,
                                color: Color(0xFF018BD3)),
                            SizedBox(width: 8),
                            Text(
                              "Download Statement",
                              style: TextStyle(
                                  color: Color(0xFF018BD3),
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),

                  hintText: "Search transactions",
                  hintStyle: const TextStyle(color: Colors.grey,fontWeight: FontWeight.normal),
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount:  _filteredList.length,
                separatorBuilder: (context, index) => const Divider(
                  color: Colors.grey,
                  thickness: 0.2,
                ),
                itemBuilder: (context, index) {
                  final txn = _filteredList[index];
                  return GestureDetector(
                    onTap:(){
                      setState(() {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TransactionDetailScreen(
                                transaction: txn
                            ),
                          ),
                        );
                      });
                    },
                    child: ListTile(
                      contentPadding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      leading: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F4FD),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(8),
                        child:
                        Transform.rotate(
                          angle: txn.displaySts == "Debit" ? 0 : 3.14, // 0 for Debit, 180° for Credit
                          child: Icon(
                            Icons.arrow_outward,
                            color: txn.displaySts == "Debit" ? Colors.red : Colors.green,
                          ),
                        ),
                      ),
                      title: Text(
                        txn.displaySts == "Debit" ? "Paid To" : "Received From",
                        style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontWeight: FontWeight.w500),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            txn.memFirstName,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 3,),
                          Text(
                            formatTransactionDate(txn.tDate),
                            style:
                            const TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            txn.displaySts == "Credit"
                                ? "+₹${txn.credit}"
                                : "-₹${txn.debit}",
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 3),
                         Text(
                            txn.displaySts,
                            style: TextStyle(color: Colors.grey, fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}




class FilterSheet extends StatefulWidget {
  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  int selectedTabIndex = 0;

  List<String> months = [];
  List<bool> selectedMonths = [];


  List<bool> selectedCategories = [];

  List<String> statuses = ["Success", "Failed", "Pending"];
  List<bool> selectedStatuses = [];

  List<String> paymentTypes = ["UPI", "Card", "Net Banking"];
  List<bool> selectedPaymentTypes = [];

  List<Map<String, dynamic>> tabs = [
    {"label": "Months", "icon": Icons.calendar_month},
    {"label": "Status", "icon": Icons.info_outline},
    {"label": "Payment", "icon": Icons.payment},
  ];

  @override
  void initState() {
    super.initState();

    // Generate months from Jan 2021 to now, and reverse for latest first
    DateTime start = DateTime(2021, 1);
    DateTime now = DateTime.now();

    while (start.isBefore(DateTime(now.year, now.month + 1))) {
      months.add("${_getMonthName(start.month)} ${start.year}");
      start = DateTime(start.year, start.month + 1);
    }

    months = months.reversed.toList(); // 👈 Reverse months here

    selectedMonths = List<bool>.filled(months.length, false);
    selectedStatuses = List<bool>.filled(statuses.length, false);
    selectedPaymentTypes = List<bool>.filled(paymentTypes.length, false);
  }

  String _getMonthName(int month) {
    const List<String> monthNames = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return monthNames[month - 1];
  }

  List<Widget> buildFilterOptions() {
    List<String> options;
    List<bool> selectedList;

    switch (selectedTabIndex) {
      case 0:
        options = months;
        selectedList = selectedMonths;
        break;

      case 1:
        options = statuses;
        selectedList = selectedStatuses;
        break;
      case 2:
        options = paymentTypes;
        selectedList = selectedPaymentTypes;
        break;
      default:
        options = [];
        selectedList = [];
    }

    return List.generate(
      options.length,
          (index) => Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                selectedList[index] = !selectedList[index];
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    options[index],
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 15,
                    ),
                  ),
                  Checkbox(
                    value: selectedList[index],
                    onChanged: (val) {
                      setState(() {
                        selectedList[index] = val!;
                      });
                    },
                    activeColor: Colors.black,
                    checkColor: Colors.white,
                    fillColor: MaterialStateProperty.resolveWith<Color>((states) {
                      if (states.contains(MaterialState.selected)) {
                        return Colors.black;
                      }
                      return Colors.white;
                    }),
                    side: BorderSide(color: Colors.grey.shade400, width: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(color: Colors.grey.shade300, thickness: 0.7, height: 0),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.85,
      child: Row(
        children: [
          // Left side tabs
          Container(
            width: 150,
            color: Colors.white,
            child: ListView.builder(
              itemCount: tabs.length,
              itemBuilder: (context, index) {
                bool isSelected = selectedTabIndex == index;
                return InkWell(
                  onTap: () {
                    setState(() {
                      selectedTabIndex = index;
                    });
                  },
                  child: Container(
                    color: isSelected ? Colors.grey.shade200 : Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                    child: Center(
                      child: Row(
                        children: [
                          Icon(
                            tabs[index]['icon'],
                            size: 20,
                            color: isSelected ? Colors.black : Colors.grey,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              tabs[index]['label'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: isSelected ? Colors.black : Colors.grey[600],
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Right side filters
          Expanded(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Column(
                children: [
                  // Title and Close button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Select Filters',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.black),
                        onPressed: () {
                          Navigator.pop(context); // 👈 Close sheet
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Filter options
                  Expanded(
                    child: ListView(
                      children: buildFilterOptions(),
                    ),
                  ),
                  // Apply button
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFE95168), Color(0xFFBA68C8)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      onPressed: () {
                        // TODO: Handle filter apply logic
                      },
                      child: const Text(
                        "APPLY",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}



