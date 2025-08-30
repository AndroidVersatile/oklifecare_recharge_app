import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../models/recharge_model.dart';
import '../../providers/loginProvider.dart';
import '../../routing/app_pages.dart';

class RechargeDetailScreen extends StatefulWidget {
  final RechargePlan plan;
  final String mobileNumber;
  final Map<String, dynamic>? operatorDetails;

  const RechargeDetailScreen({
    super.key,
    required this.plan,
    required this.mobileNumber,
    this.operatorDetails,
  });

  @override
  State<RechargeDetailScreen> createState() => _RechargeDetailScreenState();
}

class _RechargeDetailScreenState extends State<RechargeDetailScreen> {
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  final Color _primaryColor = const Color(0xFFA05FF0);
  final Color _secondaryColor = const Color(0xFF6A40F0);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProviderScreen>(context);
    final String operatorName = widget.operatorDetails?['operatorName'] ?? 'N/A';
    final String circle = widget.operatorDetails?['stateName'] ?? 'N/A';
    final String operatorCode = (widget.operatorDetails?['operatorCode'] ??
        widget.operatorDetails?['operatorId'])
        ?.toString() ??
        'N/A';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Confirm Recharge',
          style: TextStyle(color: Colors.white),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Container(
            height: 250,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_primaryColor, _secondaryColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 24),
                _buildRechargeSummaryCard(operatorName, circle, operatorCode),
                const Spacer(),
                _buildRechargeButton(provider, operatorCode),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRechargeSummaryCard(String operatorName, String circle, String operatorCode) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recharge Details',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const Divider(height: 30, color: Colors.grey),
          _buildDetailRow('Mobile Number', widget.mobileNumber),
          _buildDetailRow('Company', operatorName),
          _buildDetailRow('State', circle),
          _buildDetailRow('Plan', widget.plan.type),
          _buildDetailRow('Validity', '${widget.plan.validity} days'),

          const SizedBox(height: 16),
          _buildAmountRow(),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF555555)),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: _primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Recharge Amount',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
          ),
          Text(
            '₹${widget.plan.rs}',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _primaryColor),
          ),
        ],
      ),
    );
  }

  Widget _buildRechargeButton(ProviderScreen provider, String operatorCode) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [_primaryColor, _secondaryColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: ElevatedButton(
          onPressed: isLoading
              ? null
              : () async {
            setState(() => isLoading = true);

            final response = await provider.prepaidRecharge(
              number: widget.mobileNumber,
              amount: widget.plan.rs,
              operator: operatorCode,
            );

            if (!mounted) return;
            setState(() => isLoading = false);

            final bool isSuccess = response['success'] ?? false;

            if (isSuccess) {
              final RechargeResponse rechargeData = response['data'];

              context.go(
                AppPages.rechargesuccessscreen,
                extra: rechargeData,

              );
            } else {
              final String message = response['message'] ?? 'Something went wrong';
              _showErrorDialog(message);
            }

          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          child: isLoading
              ? const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          )
              : const Text(
            'Confirm & Pay',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ),
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                radius: 30,
                backgroundColor: Colors.red,
                child: Icon(Icons.error, color: Colors.white, size: 40),
              ),
              const SizedBox(height: 10),
              const Text(
                'Recharge Failed',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
              ),
              const SizedBox(height: 10),
              Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 14, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text('OK', style: TextStyle(fontSize: 15, color: _secondaryColor)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}




