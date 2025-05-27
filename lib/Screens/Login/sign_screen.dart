import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:uonly_app/providers/loginProvider.dart';
import 'package:uonly_app/routing/app_pages.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  int _currentStep = 0;
  bool _isPasswordVisible = false;

  // Controllers for Step 1
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Controller for Step 2
  final TextEditingController _aadhaarController = TextEditingController();

  // Controllers for Step 3
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<ProviderScreen>(context, listen: false).fetchCountries();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    double fontScale(double value) => value * width / 375;
    double heightScale(double value) => value * height / 812;
    double widthScale(double value) => value * width / 375;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/welcome.png',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: heightScale(200)),
              Padding(
                padding: EdgeInsets.only(left: widthScale(30)),
                child: Text(
                  'Create\nAccount',
                  style: TextStyle(
                    fontSize: fontScale(34),
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: heightScale(20)),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(widthScale(30)),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  child: _buildStepContent(heightScale, fontScale, widthScale),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent(
      double Function(double) heightScale,
      double Function(double) fontScale,
      double Function(double) widthScale,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Step ${_currentStep + 1} of 3',
          style: TextStyle(
            color: Color(0xFFE95168),
            fontSize: fontScale(20),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: heightScale(10)),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                if (_currentStep == 0) ...[
                  _buildTextField('Name', _nameController),
                  _buildTextField('Email', _emailController),
                  _buildTextField('Phone Number', _phoneController),

                ] else if (_currentStep == 1) ...[
                  _buildTextField('Aadhaar Number', _aadhaarController),
                  SizedBox(height: 30,),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Aadhaar Verified")),
                      );
                      Future.delayed(Duration(milliseconds: 500), () {
                        setState(() {
                          _currentStep = 2;
                        });
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFE95168),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 8,  // vertical space
                        horizontal: 20, // horizontal space
                      ),
                    ),
                    child: Text(
                      'Verify Aadhaar',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                ] else if (_currentStep == 2) ...[
                  _buildDropdown('State', _stateController,
                      ['Rajasthan', 'Madhya Pradesh', 'Uttar Pradesh']),
                  _buildDropdown('District', _districtController,
                      ['Karauli', 'Jaipur', 'Bharatpur']),
                  _buildDropdown('City', _cityController,
                      ['Karauli City', 'Jaipur City']),
                  _buildTextField('Pincode', _pincodeController),
                ],
              ],
            ),
          ),
        ),
        SizedBox(height: 10,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (_currentStep > 0)
              TextButton(
                onPressed: () {
                  setState(() {
                    _currentStep--;
                  });
                },
                child: Text(
                  'Back',
                  style: TextStyle(
                    fontSize: fontScale(18),
                    color: Color(0xFF018BD3),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            if (_currentStep != 1) // Hide button in Step 2
              SizedBox(
                height: heightScale(50),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFE95168),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 8,  // vertical space
                      horizontal: 20, // horizontal space
                    ),
                  ),
                  onPressed: () {
                    if (_currentStep < 2) {
                      setState(() {
                        _currentStep++;
                      });
                    } else {
                      // Final submit action
                      context.pushNamed(AppPages.login);
                    }
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _currentStep < 2 ? 'Next' : 'Submit',
                        style: TextStyle(
                          fontSize: fontScale(20),
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: widthScale(5)),
                      Image.asset(
                        "assets/send.png",
                        height: heightScale(20),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller,
      {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        obscureText: isPassword && !_isPasswordVisible,
        decoration: InputDecoration(
          labelText: hint,
          suffixIcon: isPassword
              ? IconButton(
            icon: Icon(_isPasswordVisible
                ? Icons.visibility
                : Icons.visibility_off),
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
          )
              : null,
          border: UnderlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildDropdown(
      String hint, TextEditingController controller, List<String> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: controller.text.isNotEmpty ? controller.text : null,
        decoration: InputDecoration(
          labelText: hint,
          border: UnderlineInputBorder(),
        ),
        items: items.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            controller.text = value!;
          });
        },
      ),
    );
  }
}
