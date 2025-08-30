import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';

import '../constants/app_cache.dart';
import '../models/recharge_model.dart'; // Ensure this path is correct for your model

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<WalletTransactionModel> _transactions = [];
  List<WalletTransactionModel> _filteredTransactions = [];
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

    // Correct API endpoint for wallet transactions
    const String apiUrl =
        'https://oklifecare.com/Dashboard/API/RechargeAPI.aspx?reqtype=walletreport';
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
          List<WalletTransactionModel> parsedTransactions = [];
          for (var item in jsonList) {
            parsedTransactions.add(WalletTransactionModel.fromJson(item));
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

  // Updated filtering logic to use the 'remark' field
  void _filterTransactions() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredTransactions = _transactions.where((transaction) {
        return (transaction.remark?.toLowerCase().contains(query) ?? false);
      }).toList();
    });
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
                'Wallet History Statement',
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
                1: const pw.FlexColumnWidth(1),
                2: const pw.FlexColumnWidth(1),
                3: const pw.FlexColumnWidth(6),
              },
              headers: ['Date', 'Credit', 'Debit', 'Remark'],
              data: _filteredTransactions.map((transaction) {
                final date = DateFormat('dd MMM yyyy, hh:mm a').format(transaction.tDate);
                final credit = '₹${transaction.credit?.toStringAsFixed(2) ?? '0.00'}';
                final debit = '₹${transaction.debit?.toStringAsFixed(2) ?? '0.00'}';
                return [
                  date,
                  credit,
                  debit,
                  transaction.remark ?? 'N/A',
                ];
              }).toList(),
              cellAlignment: pw.Alignment.centerLeft,
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
              cellStyle: const pw.TextStyle(fontSize: 10),
            ),
          ],
        ),
      );

      final directory = await getExternalStorageDirectory();
      final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final fileName = 'Wallet_Statement_$timestamp.pdf';
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
          'Wallet History',
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
            const SizedBox(height: 10),
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
                        hintText: "Search by remark",
                        hintStyle: const TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.normal),
                        prefixIcon: const Icon(Icons.search, color: Colors.grey),
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

  // Updated buildTransactionRow to display new model data with a professional UI
  Widget _buildTransactionRow(WalletTransactionModel transaction) {
    final bool isCredit = (transaction.credit ?? 0) > 0;
    final String amountSymbol = isCredit ? '+' : '-';
    final String formattedDate = DateFormat('dd MMM yyyy, hh:mm a').format(transaction.tDate);
    final String amount = isCredit
        ? '₹${transaction.credit?.toStringAsFixed(2) ?? '0.00'}'
        : '₹${transaction.debit?.toStringAsFixed(2) ?? '0.00'}';
    final Color amountColor = isCredit ? Colors.green[600]! : Colors.red[600]!;

    return InkWell(
      onTap: () {
        _showDetailsDialog(transaction);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 17.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isCredit ? Colors.green[50] : Colors.red[50],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Transform.rotate(
                angle: isCredit ? 0 : 3.14,
                child: Icon(
                  Icons.arrow_outward,
                  color: isCredit ? Colors.green : Colors.red,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.remark ?? 'N/A',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Colors.black87,
                    ),
                    maxLines: null,
                    overflow: TextOverflow.visible,
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
            Text(
              '$amountSymbol $amount',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: amountColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Updated showDetailsDialog with cleaner layout
  void _showDetailsDialog(WalletTransactionModel transaction) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text(
            'Transaction Details',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                _buildDetailRow('Date:', DateFormat('dd MMM yyyy, hh:mm a').format(transaction.tDate)),
                _buildDetailRow('Credit Amount:', '₹${transaction.credit?.toStringAsFixed(2) ?? '0.00'}', valueColor: Colors.green),
                _buildDetailRow('Debit Amount:', '₹${transaction.debit?.toStringAsFixed(2) ?? '0.00'}', valueColor: Colors.red),
                _buildDetailRow('Remark:', transaction.remark),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close', style: TextStyle(color: Color(0xFF4A00E0))),
            ),
          ],
        );
      },
    );
  }

  // Updated _buildDetailRow for better alignment and colors
  Widget _buildDetailRow(String label, String? value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
                fontSize: 14),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value ?? 'N/A',
              textAlign: TextAlign.end,
              style: TextStyle(
                color: valueColor ?? Colors.black87,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Model class provided by user
class WalletTransactionModel {
  final String? remark;
  final double? credit;
  final double? debit;
  final DateTime tDate;

  WalletTransactionModel({
    this.remark,
    this.credit,
    this.debit,
    required this.tDate,
  });

  factory WalletTransactionModel.fromJson(Map<String, dynamic> json) {
    RegExp regex = RegExp(r'\d+');
    String timestampString = regex.firstMatch(json['TDate'] as String)?.group(0) ?? '';
    int timestamp = int.tryParse(timestampString) ?? 0;

    return WalletTransactionModel(
      remark: json['Remark'] as String?,
      credit: (json['Credit'] as num?)?.toDouble(),
      debit: (json['Debit'] as num?)?.toDouble(),
      tDate: DateTime.fromMillisecondsSinceEpoch(timestamp),
    );
  }
}