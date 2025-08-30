import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../constants/app_cache.dart';

class RefundStatusScreen extends StatefulWidget {
  final String id;

  const RefundStatusScreen({super.key, required this.id});

  @override
  State<RefundStatusScreen> createState() => _RefundStatusScreenState();
}

class _RefundStatusScreenState extends State<RefundStatusScreen> {
  Map<String, dynamic>? responseData;
  bool isLoading = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchRefundStatus();
  }

  Future<void> fetchRefundStatus() async {
    setState(() {
      isLoading = true;
      _errorMessage = '';
    });
    final appCache = AppCache();
    String? formNo = await appCache.getUserFormNo();
    final url = Uri.parse(
        "https://oklifecare.com/Dashboard/API/RechargeAPI.aspx?reqtype=refundrequest");
    final String rechargeId = widget.id;
    try {
      final body = {"formNo": formNo, "rechargeid": rechargeId};
      print("🌐 Refund API URL => $url");
      print("🔵 Refund API Request => $body");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );
      print("🟢 Refund API Response Status: ${response.statusCode}");
      print("🟢 Refund API Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedResponse = jsonDecode(response.body);
        if (decodedResponse['Data'] != null &&
            (decodedResponse['Data'] as List).isNotEmpty) {
          setState(() {
            responseData = decodedResponse;
          });
        } else {
          setState(() {
            _errorMessage =
                decodedResponse['Message'] ?? 'Failed to load refund status.';
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Server error: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Network error: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  String _formatDate(dynamic date) {
    if (date == null) return 'N/A';
    if (date is DateTime) {
      return DateFormat('dd MMM yyyy, hh:mm a').format(date);
    }
    if (date is String && date.startsWith('/Date(') && date.endsWith(')/')) {
      RegExp regex = RegExp(r'\d+');
      String? timestampString = regex.firstMatch(date)?.group(0);
      if (timestampString != null && timestampString.isNotEmpty) {
        try {
          int timestamp = int.parse(timestampString);
          return DateFormat('dd MMM yyyy, hh:mm a')
              .format(DateTime.fromMillisecondsSinceEpoch(timestamp));
        } catch (e) {
          print('Error parsing timestamp: $e');
        }
      }
    }
    return date.toString();
  }

  String _getStatusDisplayText(String? status) {
    switch (status?.toUpperCase()) {
      case 'F':
        return 'Failed';
      case 'P':
        return 'Pending';
      case 'S':
        return 'Success';
      default:
        return status ?? 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "Refund Status",
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
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4A00E0)),
        ),
      );
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
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
                onPressed: fetchRefundStatus,
                icon: const Icon(Icons.refresh, color: Colors.white),
                label: const Text('Retry', style: TextStyle(color: Colors.white)),
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
      );
    }

    if (responseData == null ||
        responseData!["Data"] == null ||
        (responseData!["Data"] as List).isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/no_Data.png',
              height: 200,
              width: 200,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 20),
            const Text(
              'No refund details found for this transaction.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    final String apiStatus = responseData!["Status"] ?? 'False';
    final String apiMessage = responseData!["Message"] ?? 'Unknown status';
    final bool isApiSuccess = apiStatus == "True";

    return RefreshIndicator(
      onRefresh: fetchRefundStatus,
      color: const Color(0xFF4A00E0),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            _buildStatusHeader(isApiSuccess, apiMessage),
            _buildDetailsSection(responseData!['Data']),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusHeader(bool isSuccess, String message) {
    final Color headerColor = isSuccess ? Colors.green.shade700 : Colors.red.shade700;
    final IconData headerIcon = isSuccess ? Icons.check_circle_outline : Icons.cancel_outlined;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      color: isSuccess ? Colors.green.shade50 : Colors.red.shade50,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(headerIcon, color: headerColor, size: 60),
          const SizedBox(height: 15),
          Text(
            isSuccess ? "Refund Successful!" : "Refund Failed",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: headerColor,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: headerColor.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsSection(List<dynamic> data) {
    if (data.isEmpty) return const SizedBox.shrink();

    final item = data.first;
    final String transactionStatus = _getStatusDisplayText(item['RechargeSts']);
    Color statusDisplayColor;
    IconData statusIcon;

    if (transactionStatus == 'Success') {
      statusDisplayColor = Colors.green;
      statusIcon = Icons.check_circle_outline;
    } else if (transactionStatus == 'Failed') {
      statusDisplayColor = Colors.red;
      statusIcon = Icons.error_outline;
    } else if (transactionStatus == 'Pending') {
      statusDisplayColor = Colors.orange;
      statusIcon = Icons.hourglass_empty;
    } else {
      statusDisplayColor = Colors.grey;
      statusIcon = Icons.info_outline;
    }

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Transaction Details",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(statusIcon, color: statusDisplayColor, size: 28),
                const SizedBox(width: 10),
                Text(
                  "Recharge Status:   $transactionStatus",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: statusDisplayColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _buildDetailList(item),
        ],
      ),
    );
  }

  Widget _buildDetailList(Map<String, dynamic> item) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildDetailRow("Member Name", item['MemFirstName']),
          _buildDetailRow("Recharge No", item['RechargeNo']),
          _buildDetailRow("Amount", "₹${item['Amount'] ?? '0.00'}"),
          _buildDetailRow("Operator", item['OperatorName']),
          _buildDetailRow("Type", item['OperatorDesc']),
          _buildDetailRow("Transaction ID", item['TrnId']),
          _buildDetailRow("Commission", "₹${item['CommissionAmount'] ?? '0.00'}"),
          _buildDetailRow("Transaction Date", _formatDate(item['TDate'])),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String title, String? value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 15,
              color: Colors.grey[700],
            ),
          ),
          Flexible(
            child: Text(
              value ?? 'N/A',
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}