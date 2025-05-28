import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class UserBloodSevaFromScreen extends StatefulWidget {
  const UserBloodSevaFromScreen({super.key});

  @override
  State<UserBloodSevaFromScreen> createState() => _UserBloodSevaFromScreenState();
}

class _UserBloodSevaFromScreenState extends State<UserBloodSevaFromScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _hospitalNameController = TextEditingController();
  final TextEditingController _hospitalAddressController = TextEditingController();

  String _selectedGender = 'Male';
  String _selectedBloodType = 'A+';
  File? _requestLetterFile;

  Future<void> _pickRequestLetter() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _requestLetterFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> _openGoogleMaps(String address) async {
    final query = Uri.encodeComponent(address);
    final googleMapsUrl = 'https://www.google.com/maps/search/?api=1&query=$query';

    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open Google Maps')),
      );
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_requestLetterFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please upload the request letter")),
        );
        return;
      }

      // Proceed with form submission
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Form Submitted Successfully")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("User Blood Seva")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField("Name", _nameController),
              _buildTextField("Mobile Number", _mobileController, keyboardType: TextInputType.phone),
              _buildTextField("Age", _ageController, keyboardType: TextInputType.number),

              _buildDropdown("Gender", ["Male", "Female", "Other"], _selectedGender, (value) {
                setState(() => _selectedGender = value!);
              }),

              _buildDropdown("Blood Type", ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"], _selectedBloodType,
                      (value) {
                    setState(() => _selectedBloodType = value!);
                  }),

              _buildTextField("Hospital Name", _hospitalNameController),
              // Hospital Address field with location icon
              _buildTextField("Hospital Address", _hospitalAddressController, maxLines: 2, isHospitalAddress: true),

              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Request Letter (Upload File)",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickRequestLetter,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.attach_file, color: Colors.blue),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _requestLetterFile != null
                              ? _requestLetterFile!.path.split('/').last
                              : 'Select File from Gallery',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFE95168),
                      Color(0xFFBA68C8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.send, color: Colors.white),
                  label: const Text("Submit Request", style: TextStyle(color: Colors.white)),
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label,
      TextEditingController controller, {
        TextInputType keyboardType = TextInputType.text,
        int maxLines = 1,
        bool isHospitalAddress = false, // added parameter
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontSize: 15),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
          ),
          suffixIcon: isHospitalAddress
              ? IconButton(
            icon: const Icon(Icons.location_on, color: Colors.red),
            onPressed: () {
              final address = controller.text.trim();
              if (address.isNotEmpty) {
                _openGoogleMaps(address);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter hospital address first')),
                );
              }
            },
          )
              : null,
        ),
        validator: (value) => value == null || value.isEmpty ? 'Enter $label' : null,
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items, String selectedValue, ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        onChanged: onChanged,
        items: items.map(
              (e) => DropdownMenuItem(
            value: e,
            child: Text(
              e,
              style: const TextStyle(fontWeight: FontWeight.normal),
            ),
          ),
        ).toList(),
        style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
