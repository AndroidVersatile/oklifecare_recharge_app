import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class BlooddonateFormScreen extends StatefulWidget {
  final String title;
  const BlooddonateFormScreen({super.key, required this.title});

  @override
  State<BlooddonateFormScreen> createState() => _BlooddonateFormScreenState();
}

class _BlooddonateFormScreenState extends State<BlooddonateFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _ageController = TextEditingController();
  final _hospitalController = TextEditingController();
  final _currentAddressController = TextEditingController();

  String? _selectedBloodType;
  String? _selectedGender;

  final List<String> _bloodTypes = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
  final List<String> _genders = ['Male', 'Female', 'Other'];

  final Color pink = const Color(0xFFE95168);
  final Color purple = const Color(0xFFBA68C8);

  File? _selectedFile;

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> _openInGoogleMaps() async {
    String address = _currentAddressController.text.trim();
    if (address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an address to open in Maps.')),
      );
      return;
    }

    final encodedAddress = Uri.encodeComponent(address);
    final googleMapsUrl = 'https://www.google.com/maps/search/?api=1&query=$encodedAddress';

    if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
      await launchUrl(Uri.parse(googleMapsUrl), mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch Google Maps')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final inputDecoration = InputDecoration(
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.grey, width: 2), // Changed to grey
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
    );

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        foregroundColor: pink,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Name
                  TextFormField(
                    controller: _nameController,
                    decoration: inputDecoration.copyWith(
                      labelText: 'Name',
                      prefixIcon: Icon(Icons.person, color: pink),
                      hintText: 'Enter your name',
                    ),
                    validator: (value) => value!.isEmpty ? 'Enter name' : null,
                  ),
                  const SizedBox(height: 20),

                  // Mobile Number
                  TextFormField(
                    controller: _mobileController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: inputDecoration.copyWith(
                      labelText: 'Mobile Number',
                      prefixIcon: Icon(Icons.phone, color: pink),
                      hintText: 'Enter mobile number',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Enter mobile number';
                      if (value.length < 10) return 'Enter valid mobile number';
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Age
                  TextFormField(
                    controller: _ageController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: inputDecoration.copyWith(
                      labelText: 'Age',
                      prefixIcon: Icon(Icons.calendar_today, color: pink),
                      hintText: 'Enter your age',
                    ),
                    validator: (value) => value == null || value.isEmpty ? 'Enter age' : null,
                  ),
                  const SizedBox(height: 20),

                  // Gender Dropdown
                  DropdownButtonFormField<String>(
                    decoration: inputDecoration.copyWith(
                      labelText: 'Gender',
                      prefixIcon: Icon(Icons.person_outline, color: pink),
                    ),
                    value: _selectedGender,
                    items: _genders
                        .map((gender) => DropdownMenuItem(
                      value: gender,
                      child: Text(gender, style: const TextStyle(fontWeight: FontWeight.normal)),
                    ))
                        .toList(),
                    onChanged: (value) => setState(() => _selectedGender = value),
                    validator: (value) => value == null ? 'Select gender' : null,
                  ),
                  const SizedBox(height: 20),

                  // Blood Type Dropdown
                  DropdownButtonFormField<String>(
                    decoration: inputDecoration.copyWith(
                      labelText: 'Blood Type',
                      prefixIcon: Icon(Icons.bloodtype, color: pink),
                    ),
                    value: _selectedBloodType,
                    items: _bloodTypes
                        .map((type) => DropdownMenuItem(
                      value: type,
                      child: Text(type, style: const TextStyle(fontWeight: FontWeight.normal)),
                    ))
                        .toList(),
                    onChanged: (value) => setState(() => _selectedBloodType = value),
                    validator: (value) => value == null ? 'Select blood type' : null,
                   ),

                  const SizedBox(height: 20),

                  // Current Address
                  TextFormField(
                    controller: _currentAddressController,
                    maxLines: 3,
                    decoration: inputDecoration.copyWith(
                      labelText: 'Current Address',

                      hintText: 'Enter your address',
                      suffixIcon: Tooltip(
                        message: 'Open in Google Maps',
                        child: IconButton(
                          icon: Icon(Icons.location_pin, color: Colors.redAccent),
                          onPressed: _openInGoogleMaps,
                        ),
                      ),
                    ),
                    validator: (value) => value!.isEmpty ? 'Enter current address' : null,
                  ),
                  const SizedBox(height: 20),

                  // File Upload
                  Text(
                    "Requestion Letter (Upload Photo)",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: _pickFile,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.attach_file, color: Colors.black54),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _selectedFile != null
                                  ? _selectedFile!.path.split('/').last
                                  : 'Upload File',
                              style: TextStyle(
                                color: _selectedFile != null ? Colors.black87 : Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Submit Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      backgroundColor: Colors.transparent,
                      elevation: 1,
                      shadowColor: purple.withOpacity(0.5),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        bool confirm = await showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text("Confirm Submission"),
                            content: const Text("Are you sure you want to submit this form?"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text("Cancel"),
                              ),
                              ElevatedButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text("Submit"),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Form Submitted'), backgroundColor: pink),
                          );
                        }
                      }
                    },
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [pink, purple]),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        constraints: const BoxConstraints(minHeight: 48),
                        child: const Text(
                          "Submit",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
