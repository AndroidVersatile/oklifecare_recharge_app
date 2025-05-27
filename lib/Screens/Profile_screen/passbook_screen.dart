import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../theme/app_theme.dart';

class PassbookScreen extends StatefulWidget {
  final VoidCallback onNext;

  const PassbookScreen({required this.onNext, super.key});

  @override
  State<PassbookScreen> createState() => _PassbookScreenState();
}

class _PassbookScreenState extends State<PassbookScreen> {
  File? chequeImage;
  File? otherProofImage;
  File? signatureImage;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(String type) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        switch (type) {
          case 'cheque':
            chequeImage = File(pickedFile.path);
            break;
          case 'other':
            otherProofImage = File(pickedFile.path);
            break;
          case 'signature':
            signatureImage = File(pickedFile.path);
            break;
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
    bool allImagesSelected = chequeImage != null && otherProofImage != null && signatureImage != null;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildImageCard(
                label: "Select Cancelled Cheque Image",
                image: chequeImage,
                onTap: () => _pickImage('cheque'),
              ),
              const SizedBox(height: 24),
              buildImageCard(
                label: "Select Other Document Proof (e.g. Handicap, etc.)",
                image: otherProofImage,
                onTap: () => _pickImage('other'),
              ),
              const SizedBox(height: 24),
              buildImageCard(
                label: "Select Signature Image",
                image: signatureImage,
                onTap: () => _pickImage('signature'),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: allImagesSelected ? widget.onNext : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(vertical: 11),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
