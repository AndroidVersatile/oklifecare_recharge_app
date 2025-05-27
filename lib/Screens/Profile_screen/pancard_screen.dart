import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../theme/app_theme.dart';

class PancardScreen extends StatefulWidget {
  final VoidCallback onNext;

  const PancardScreen({required this.onNext, super.key});

  @override
  State<PancardScreen> createState() => _PancardScreenState();
}

class _PancardScreenState extends State<PancardScreen> {
  File? panCardImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        panCardImage = File(pickedFile.path);
      });
    }
  }

  Widget buildImageCard({
    required String label,
    File? image,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        child: Container(
          height: 180,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey[100],
          ),
          child: image != null
              ? ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(image, fit: BoxFit.cover, width: double.infinity),
          )
              : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.upload_file, size: 40, color: Colors.grey),
              const SizedBox(height: 8),
              Text(label, style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 4),
              const Text("Tap to select", style: TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            buildImageCard(
              label: "Select Pan Card Image",
              image: panCardImage,
              onTap: _pickImage,
            ),
            AppTheme.verticalSpacing(mul: 3),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: panCardImage != null ? widget.onNext : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(vertical: 11),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
