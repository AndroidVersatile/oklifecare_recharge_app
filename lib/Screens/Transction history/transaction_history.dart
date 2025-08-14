import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // http package को import करें
import 'package:intl/intl.dart'; // DateFormat के लिए import करें
import '../../constants/app_cache.dart';
import '../../models/recharge_model.dart';


class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<TransactionStatusModel> _transactions = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchTransactionHistory();
  }

  Future<void> _fetchTransactionHistory() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    const String apiUrl = 'https://oklifecare.com/Dashboard/API/RechargeAPI.aspx?reqtype=rechargereport';
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
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'formno': formNo,
        },
      );

      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);

        if (responseData is Map<String, dynamic> && responseData['Data'] is List) {
          final List<dynamic> jsonList = responseData['Data'];
          setState(() {
            _transactions = transactionStatusListFromJson(jsonList);
          });
        } else {
          final String message = responseData['Message'] ?? 'Unexpected response format.';
          setState(() {
            _errorMessage = 'Failed to load transactions: $message';
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Failed to load transactions. Server responded with status: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error fetching data: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'success':
        return Colors.green;
      case 'failed':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      // FIX: AppBar को `appBar:` नाम वाले आर्गुमेंट के अंदर रखें
      appBar: AppBar(
        title: const Text(
          'Transaction History',
          style: TextStyle(color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF8E2DE2), // ऊपर का हल्का बैंगनी
                Color(0xFF4A00E0), // नीचे का गहरा बैंगनी
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      // `body:` आर्गुमेंट पहले से ही सही जगह पर है
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0277BD))))
          : _errorMessage.isNotEmpty
          ? Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 10),
              Text(
                _errorMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.red),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _fetchTransactionHistory,
                icon: const Icon(Icons.refresh, color: Colors.white),
                label: const Text('Retry', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0277BD),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      )
          : _transactions.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/no_Data.png',
              height: 650,
              width: 650,
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: _transactions.length,
        itemBuilder: (context, index) {
          final transaction = _transactions[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6.0),
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recharge No: ${transaction.rechargeNo}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF0277BD),
                        ),
                      ),
                      Text(
                        '₹${transaction.amount?.toStringAsFixed(2) ?? '0.00'}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 15, color: Colors.grey),
                  _buildInfoRow('Status:', transaction.rechargeSts, _getStatusColor(transaction.rechargeSts)),
                  _buildInfoRow('Operator:', transaction.operatorName),
                  _buildInfoRow('Type:', transaction.operatorType),
                  _buildInfoRow('Transaction ID:', transaction.trnId),
                  _buildInfoRow('Operator Trn ID:', transaction.opTrnId),
                  _buildInfoRow('Live Trn ID:', transaction.liveTrnId),
                  _buildInfoRow(
                    'Date:',
                    DateFormat('dd MMM yyyy, hh:mm a').format(transaction.tDate),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
  Widget _buildInfoRow(String label, String value, [Color? valueColor]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey[700]),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: valueColor ?? Colors.black87),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}