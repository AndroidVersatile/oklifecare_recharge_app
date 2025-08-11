import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uonly_app/theme/app_theme.dart';

class ScantoPayScreen extends StatefulWidget {
  const ScantoPayScreen({Key? key}) : super(key: key);

  @override
  State<ScantoPayScreen> createState() => _ScantoPayScreenState();
}

class _ScantoPayScreenState extends State<ScantoPayScreen> {
  final MobileScannerController cameraController = MobileScannerController();
  bool _isScanning = false;
  bool _isTorchOn = false;
  bool _isFrontCamera = false;
  String _scanResult = '';

  @override
  void initState() {
    super.initState();
    _requestCameraPermission(); // Only request permission initially
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    if (status.isPermanentlyDenied) {
      _showPermissionDeniedDialog();
    } else if (status.isDenied) {
      _showSnackBar(context, 'Camera permission is required to scan QR codes.', isError: true);
    }
  }

  void _startScanning() async {
    final status = await Permission.camera.status;
    if (!status.isGranted) {
      await _requestCameraPermission();
      return;
    }

    setState(() {
      _scanResult = '';
      _isScanning = true;
    });
    cameraController.start();
  }

  void _onScanDetected(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      if (barcode.rawValue != null && barcode.rawValue!.isNotEmpty) {
        setState(() {
          _scanResult = barcode.rawValue!;
          _isScanning = false;
        });
        _showSnackBar(context, 'Scanned: $_scanResult');
        cameraController.stop();
        break;
      }
    }
  }

  void _showSnackBar(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permission Required'),
        content: const Text('Camera permission permanently denied. Please enable it from app settings.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF018CCF), Color(0xFF018CCF)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: AppBar(
            title: const Text(
              'Scan to Pay',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors
                .transparent,
            centerTitle: true,
            elevation: 0,
            actions: [
              IconButton(
                icon: Icon(_isTorchOn ? Icons.flash_on : Icons.flash_off, color: Colors.white),
                onPressed: () {
                  cameraController.toggleTorch();
                  setState(() => _isTorchOn = !_isTorchOn);
                },
              ),
              IconButton(
                icon: Icon(
                  _isFrontCamera ? Icons.camera_front : Icons.camera_rear,
                  color: Colors.white,
                ),
                onPressed: () {
                  cameraController.switchCamera();
                  setState(() => _isFrontCamera = !_isFrontCamera);
                },
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: _isScanning ? buildScannerView(context) : buildIdleScannerUI(context),
          ),
          if (_scanResult.isNotEmpty) buildProceedToPaySection(context),
        ],
      ),
    );
  }

  Widget buildScannerView(BuildContext context) {
    return Stack(
      children: [
        MobileScanner(
          controller: cameraController,
          onDetect: _onScanDetected,
        ),
        Center(
          child: Container(
            // Increased the size from 0.8 to 0.95 for a larger scanning area
            width: MediaQuery.of(context).size.width * 0.95,
            height: MediaQuery.of(context).size.width * 0.95,
            decoration: BoxDecoration(
              border: Border.all(color: context.colorScheme.secondary, width: 3),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        Positioned(
          top: 40,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            color: Colors.black54,
            child: const Text(
              'Position the QR code within the frame to scan.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildIdleScannerUI(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _scanResult.isEmpty ? Icons.qr_code_scanner : Icons.check_circle_outline,
              size: 100,
              color: _scanResult.isEmpty ? Colors.grey : Colors.green,
            ),
            const SizedBox(height: 16),
            Text(
              _scanResult.isNotEmpty
                  ? 'QR Code Scanned Successfully!'
                  : 'Tap "Scan QR Code" to begin.',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _scanResult.isEmpty ? Colors.grey[700] : Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            if (_scanResult.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Data: $_scanResult',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _startScanning,
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text('Scan QR Code'),
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colorScheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget buildProceedToPaySection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Ready to Pay?',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: context.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Confirm payment for:',
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
          ),
          const SizedBox(height: 5),
          Text(
            _scanResult,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _showSnackBar(context, 'Processing payment for: $_scanResult');
                // Navigate or process payment
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colorScheme.secondary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              child: const Text('Proceed to Pay'),
            ),
          ),
        ],
      ),
    );
  }
}