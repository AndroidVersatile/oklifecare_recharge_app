import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:uonly_app/providers/loginProvider.dart';
import 'package:uonly_app/routing/app_pages.dart';
import '../../constants/app_cache.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? _selectedPasswordType;
  String? _storedPassword;

  bool _oldPasswordVisible = false;
  bool _newPasswordVisible = false;
  bool _confirmPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _loadStoredPassword();
  }

  Future<void> _loadStoredPassword() async {
    final appCache = AppCache();
    String? password = await appCache.getUserPass();
    setState(() {
      _storedPassword = password;
    });
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_oldPasswordController.text != _storedPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Old password is incorrect'),
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      }

      final provider = Provider.of<ProviderScreen>(context, listen: false);

      final response = await provider.changePassword(
        oldPassword: _oldPasswordController.text,
        newPassword: _newPasswordController.text,
        type: _selectedPasswordType ?? '',
      );

      if (response['Status'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['Message'] ?? 'Password changed successfully'),
            backgroundColor: Colors.green,
          ),
        );
       context.pushNamed(AppPages.login); // Or reset the form if you prefer
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['Message'] ?? 'Failed to change password'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    final isLoading = Provider.of<ProviderScreen>(context).isLoading;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/background_image.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 80),
              Center(child: Image.asset('assets/logo.png', height: 50)),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.only(left: 30),
                child: Text(
                  'Change',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 30),
                child: Text(
                  'Password',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, -4)),
                    ],
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(25),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const SizedBox(height: 25),
                          DropdownButtonFormField<String>(
                            value: _selectedPasswordType,
                            decoration: InputDecoration(
                              labelText: 'Password Type*',
                              prefixIcon: const Icon(Icons.vpn_key, color: Colors.redAccent),
                              filled: true,
                              fillColor: Colors.grey.shade100,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(color: Colors.black, width: 1),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select password type';
                              }
                              return null;
                            },
                            items: const [
                              DropdownMenuItem(value: 'Login', child: Text('Login')),
                              DropdownMenuItem(value: 'Transaction', child: Text('Transaction')),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _selectedPasswordType = value;
                              });
                            },
                          ),
                          const SizedBox(height: 20),

                          _buildPasswordField(
                            controller: _oldPasswordController,
                            label: 'Old Password*',
                            icon: Icons.lock_outline,
                            isVisible: _oldPasswordVisible,
                            onToggle: () {
                              setState(() {
                                _oldPasswordVisible = !_oldPasswordVisible;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter old password';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),

                          _buildPasswordField(
                            controller: _newPasswordController,
                            label: 'New Password*',
                            icon: Icons.lock_reset_outlined,
                            isVisible: _newPasswordVisible,
                            onToggle: () {
                              setState(() {
                                _newPasswordVisible = !_newPasswordVisible;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter new password';
                              } else if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),

                          _buildPasswordField(
                            controller: _confirmPasswordController,
                            label: 'Confirm Password*',
                            icon: Icons.verified_user_outlined,
                            isVisible: _confirmPasswordVisible,
                            onToggle: () {
                              setState(() {
                                _confirmPasswordVisible = !_confirmPasswordVisible;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please confirm new password';
                              } else if (value != _newPasswordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 40),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: isLoading ? null : _submitForm,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                                padding: const EdgeInsets.symmetric(vertical: 11),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: isLoading
                                  ? const CircularProgressIndicator(color: Colors.white)
                                  : const Text(
                                'Change Password',
                                style: TextStyle(fontSize: 18, color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool isVisible,
    required VoidCallback onToggle,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: !isVisible,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.redAccent),
        suffixIcon: IconButton(
          icon: Icon(
            isVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
          onPressed: onToggle,
        ),
        filled: true,
        fillColor: Colors.grey.shade100,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.black, width: 1),
        ),
      ),
    );
  }
}
