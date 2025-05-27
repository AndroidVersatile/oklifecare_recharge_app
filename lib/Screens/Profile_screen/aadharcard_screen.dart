import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AadharCardScreen extends StatefulWidget {
  final VoidCallback onNext;
  const AadharCardScreen({required this.onNext, super.key});

  @override
  State<AadharCardScreen> createState() => _AadharCardScreenState();
}

class _AadharCardScreenState extends State<AadharCardScreen> {
  File? frontImage;
  File? backImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(bool isFront) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        if (isFront) {
          frontImage = File(pickedFile.path);
        } else {
          backImage = File(pickedFile.path);
        }
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
    bool isBothSelected = frontImage != null && backImage != null;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            buildImageCard(
              label: "Select Front Side of Aadhar",
              image: frontImage,
              onTap: () => _pickImage(true),
            ),
            const SizedBox(height: 24),
            buildImageCard(
              label: "Select Back Side of Aadhar",
              image: backImage,
              onTap: () => _pickImage(false),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isBothSelected ? widget.onNext : null,
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
