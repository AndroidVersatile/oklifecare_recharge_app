import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_file/open_file.dart';
import 'package:uonly_app/Screens/Transction%20history/recharge_refundscreen.dart';
import '../../models/recharge_model.dart';
import '../../constants/app_cache.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<TransactionStatusModel> _transactions = [];
  List<TransactionStatusModel> _filteredTransactions = [];
  bool _isLoading = true;
  bool _isDownloading = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchTransactionHistory();
    _searchController.addListener(_filterTransactions);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterTransactions);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchTransactionHistory() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    const String apiUrl =
        'https://oklifecare.com/Dashboard/API/RechargeAPI.aspx?reqtype=rechargereport';
    final appCache = AppCache();
    String? formNo = await appCache.getUserFormNo();

    if (formNo == null) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'User not logged in. Please log in again.';
      });
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'formno': formNo,
        }),
      );

      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);

        if (responseData is Map<String, dynamic> &&
            responseData['Status'] == 'True' &&
            responseData['Data'] is List) {
          final List<dynamic> jsonList = responseData['Data'];
          List<TransactionStatusModel> parsedTransactions = [];
          for (var item in jsonList) {
            String dateString = item['TDate'];
            RegExp regex = RegExp(r'\d+');
            String timestampString =
                regex.firstMatch(dateString)?.group(0) ?? '';
            DateTime transactionDate;
            if (timestampString.isNotEmpty) {
              int timestamp = int.parse(timestampString);
              try {
                transactionDate = DateTime.fromMillisecondsSinceEpoch(timestamp);
              } catch (e) {
                print('RangeError: Invalid timestamp. Error: $e');
                transactionDate = DateTime.now();
              }
            } else {
              transactionDate = DateTime.now();
            }
            item['TDate'] = transactionDate;
            parsedTransactions.add(TransactionStatusModel.fromJson(item));
          }
          setState(() {
            _transactions = parsedTransactions;
            _filteredTransactions = parsedTransactions;
          });
        } else {
          final String message =
              responseData['Message'] ?? 'Unexpected response format.';
          setState(() {
            _errorMessage = 'Failed to load transactions: $message';
          });
        }
      } else {
        setState(() {
          _errorMessage =
          'Failed to load transactions. Server status: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error fetching data. Check network connection: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterTransactions() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredTransactions = _transactions.where((transaction) {
        return (transaction.operatorName?.toLowerCase().contains(query) ??
            false) ||
            (transaction.rechargeNo?.toLowerCase().contains(query) ?? false) ||
            _getStatusText(transaction.rechargeSts).toLowerCase().contains(query);
      }).toList();
    });
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'success':
      case 's':
        return Colors.green[600]!;
      case 'failed':
      case 'f':
        return Colors.red[600]!;
      case 'pending':
      case 'p':
        return Colors.orange[600]!;
      default:
        return Colors.grey[600]!;
    }
  }

  String _getStatusText(String status) {
    switch (status.toUpperCase()) {
      case 'S':
        return 'Success';
      case 'F':
        return 'Failed';
      case 'P':
        return 'Pending';
      default:
        return 'Unknown';
    }
  }

  Future<void> _downloadStatementPDF() async {
    setState(() {
      _isDownloading = true;
    });

    try {
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        Fluttertoast.showToast(
          msg: "Storage permission is required to download the statement.",
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        return;
      }

      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (context) => [
            pw.Center(
              child: pw.Text(
                'Recharge History Statement',
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(height: 16),
            pw.Table.fromTextArray(
              columnWidths: {
                0: const pw.FlexColumnWidth(2.5),
                1: const pw.FlexColumnWidth(2.5),
                2: const pw.FlexColumnWidth(1.5),
                3: const pw.FlexColumnWidth(2),
                4: const pw.FlexColumnWidth(4),
              },
              headers: [
                'Date',
                'Operator',
                'Status',
                'Amount',
                'Transaction ID'
              ],
              data: _filteredTransactions.map((transaction) {
                final date = DateFormat('dd MMM yyyy, hh:mm a')
                    .format(transaction.tDate);
                final amount = '₹${transaction.amount?.toStringAsFixed(2) ?? '0.00'}';
                final status = _getStatusText(transaction.rechargeSts);
                return [
                  date,
                  transaction.operatorName ?? 'N/A',
                  status,
                  amount,
                  transaction.trnId ?? 'N/A',
                ];
              }).toList(),
              cellAlignment: pw.Alignment.centerLeft,
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              headerDecoration:
              const pw.BoxDecoration(color: PdfColors.grey300),
              cellStyle: const pw.TextStyle(fontSize: 10),
            ),
          ],
        ),
      );

      final directory = await getExternalStorageDirectory();
      final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final fileName = 'Recharge_Statement_$timestamp.pdf';
      final filePath = '${directory!.path}/$fileName';

      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());

      Fluttertoast.showToast(
        msg: "PDF saved to: $filePath",
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );

      await OpenFile.open(filePath);
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error saving PDF: $e",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } finally {
      setState(() {
        _isDownloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Transaction History',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF8E2DE2),
                Color(0xFF4A00E0),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Search transactions",
                        hintStyle: const TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.normal),
                        prefixIcon:
                        const Icon(Icons.search, color: Colors.grey),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 14),
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
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Transactions',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  InkWell(
                    onTap: _isDownloading ? null : _downloadStatementPDF,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4A00E0).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          _isDownloading
                              ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Color(0xFF4A00E0),
                            ),
                          )
                              : const Icon(
                            Icons.file_download_outlined,
                            color: Color(0xFF4A00E0),
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _isDownloading ? "Downloading..." : "Download",
                            style: TextStyle(
                              color: Color(0xFF4A00E0),
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _isLoading && _transactions.isEmpty
                  ? const Center(
                  child: CircularProgressIndicator(
                      valueColor:
                      AlwaysStoppedAnimation<Color>(Color(0xFF4A00E0))))
                  : _errorMessage.isNotEmpty
                  ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline,
                          color: Colors.red, size: 48),
                      const SizedBox(height: 10),
                      Text(
                        _errorMessage,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 16, color: Colors.red),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: _fetchTransactionHistory,
                        icon: const Icon(Icons.refresh,
                            color: Colors.white),
                        label: const Text('Retry',
                            style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4A00E0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
                  : _filteredTransactions.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/no_Data.png',
                      height: 250,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'No transactions found yet.',
                      style: TextStyle(
                          fontSize: 18, color: Colors.grey),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              )
                  : ListView.separated(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                itemCount: _filteredTransactions.length,
                itemBuilder: (context, index) {
                  final transaction =
                  _filteredTransactions[index];
                  return _buildTransactionRow(transaction);
                },
                separatorBuilder: (context, index) =>
                const Divider(
                    color: Colors.grey,
                    height: 1,
                    thickness: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionRow(TransactionStatusModel transaction) {
    final String statusText = _getStatusText(transaction.rechargeSts);
    final Color statusColor = _getStatusColor(statusText);
    final String formattedDate = DateFormat('dd MMM yyyy, hh:mm a').format(transaction.tDate);
    final bool isSuccess = statusText == 'Success';
    final bool isRefundable = statusText == 'Pending' || statusText == 'Success';
    final String amountSymbol = isSuccess ? '+' : '-';

    return InkWell(
      onTap: () {
        _showDetailsDialog(transaction);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 17.0),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F4FD),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Transform.rotate(
                angle: isSuccess ? 0 : 3.14,
                child: Icon(
                  Icons.arrow_outward,
                  color: isSuccess ? Colors.green : Colors.red,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.operatorName ?? 'Unknown Operator',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formattedDate,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$amountSymbol ₹${transaction.amount?.toStringAsFixed(2) ?? '0.00'}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  statusText,
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                ),
                const SizedBox(height:7),
                if (isRefundable)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RefundStatusScreen(id: transaction.id ?? ''),
                            ),
                          );

                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.orange,
                          side: const BorderSide(color: Colors.orange),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text(
                              'Refund',
                              style: TextStyle(fontSize: 10),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 10,
                            ),
                          ],
                        ),
                      ),

                    ],
                  )
                else
                  Text(
                    statusText,
                    style: const TextStyle(color: Colors.grey, fontSize: 11),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDetailsDialog(TransactionStatusModel transaction) {
    final String statusText = _getStatusText(transaction.rechargeSts);
    final Color statusColor = _getStatusColor(statusText);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text(
            'Transaction Details',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                _buildDetailRow('Recharge No', transaction.rechargeNo),
                _buildDetailRow('Amount',
                    '₹${transaction.amount?.toStringAsFixed(2) ?? '0.00'}'),
                _buildDetailRow('Status', statusText, valueColor: statusColor),
                _buildDetailRow('Operator', transaction.operatorName),
                _buildDetailRow('Type', transaction.operatorType),
                _buildDetailRow('Transaction ID', transaction.trnId),
                _buildDetailRow('Operator Trn ID', transaction.opTrnId),
                _buildDetailRow('Live Trn ID', transaction.liveTrnId),
                _buildDetailRow('Date',
                    DateFormat('dd MMM yyyy, hh:mm a').format(transaction.tDate)),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close',
                  style: TextStyle(color: Color(0xFF4A00E0))),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String? value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label:',
            style: TextStyle(
                fontWeight: FontWeight.w600, color: Colors.grey[700]),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value ?? 'N/A',
              textAlign: TextAlign.end,
              style: TextStyle(
                  color: valueColor ?? Colors.black87,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}