import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EmergencyFormScreen extends StatefulWidget {
  final String title;
  const EmergencyFormScreen({super.key, required this.title});

  @override
  State<EmergencyFormScreen> createState() => _EmergencyFormScreenState();
}

class _EmergencyFormScreenState extends State<EmergencyFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String? _selectedEmergencyType;
  final List<String> _emergencyTypes = ['Accident', 'Medical', 'Fire', 'Other'];

  final Color pink = Color(0xFFE95168);
  final Color purple = Color(0xFFBA68C8);

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
        borderSide: BorderSide(color: Colors.grey.shade400, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.red, width: 2),
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
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
          padding: EdgeInsets.fromLTRB(
            20,
            20,
            20,
            MediaQuery.of(context).viewInsets.bottom + 20,
          ),
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
                      hintText: 'Enter full name',
                    ),
                    validator: (value) =>
                    value!.isEmpty ? 'Enter name' : null,
                  ),
                  SizedBox(height: 20),

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
                      if (value == null || value.isEmpty)
                        return 'Enter mobile number';
                      if (value.length < 10) return 'Enter valid number';
                      return null;
                    },
                  ),
                  SizedBox(height: 20),

                  // Emergency Type
                  DropdownButtonFormField<String>(
                    decoration: inputDecoration.copyWith(
                      labelText: 'Emergency Type',
                      prefixIcon: Icon(Icons.warning_amber, color: pink),
                    ),
                    value: _selectedEmergencyType,
                    items: _emergencyTypes
                        .map((type) => DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    ))
                        .toList(),
                    onChanged: (value) =>
                        setState(() => _selectedEmergencyType = value),
                    validator: (value) =>
                    value == null ? 'Select emergency type' : null,
                  ),
                  SizedBox(height: 20),

                  // Address
                  TextFormField(
                    controller: _addressController,
                    decoration: inputDecoration.copyWith(
                      labelText: 'Address',
                      prefixIcon: Icon(Icons.home, color: pink),
                      hintText: 'Enter address',
                    ),
                    validator: (value) =>
                    value!.isEmpty ? 'Enter address' : null,
                  ),
                  SizedBox(height: 20),

                  // Description
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 4,
                    decoration: inputDecoration.copyWith(
                      labelText: 'Description',
                      hintText: 'Explain the emergency in brief',
                      hintStyle: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.normal,
                          fontSize: 15),
                    ),
                    validator: (value) =>
                    value!.isEmpty ? 'Enter description' : null,
                  ),
                  SizedBox(height: 30),

                  // Submit Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      elevation: 1,
                      shadowColor: purple.withOpacity(0.5),
                      backgroundColor: Colors.transparent,
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        bool confirm = await showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text("Confirm Submission"),
                            content: Text(
                                "Are you sure you want to submit this form?"),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, false),
                                child: Text("Cancel"),
                              ),
                              ElevatedButton(
                                onPressed: () =>
                                    Navigator.pop(context, true),
                                child: Text("Submit"),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Form Submitted'),
                              backgroundColor: pink,
                            ),
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
                        constraints: BoxConstraints(minHeight: 30),
                        child: Text(
                          "Submit",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
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
