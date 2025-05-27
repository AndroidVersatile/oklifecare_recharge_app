import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uonly_app/providers/loginProvider.dart';

class UpdatedHistoryScreen extends StatefulWidget {
  const UpdatedHistoryScreen({super.key});

  @override
  State<UpdatedHistoryScreen> createState() => _UpdatedHistoryScreenState();
}

class _UpdatedHistoryScreenState extends State<UpdatedHistoryScreen> {
  int _currentStep = 0;

  // Personal Step Controllers and Variables
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController middleNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController fatherNameController = TextEditingController();
  final TextEditingController motherNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController ecardofficeaddressController = TextEditingController();
  final TextEditingController presentaddressController = TextEditingController();
  final TextEditingController districtController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  String? maritalStatus;
  String? selectedDepartment;
  String? selectedBloodGroup;
  String? selectedGender;
  String? selectedPlanType;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      final provider = Provider.of<ProviderScreen>(context, listen: false);
      provider.fetchUserdata().then((_) {
        final user = provider.userDetail;
        if (user != null) {
          firstNameController.text = user.firmName;
          middleNameController.text = user.middleName;
          lastNameController.text = user.lastName;
          fatherNameController.text = user.fathersName;
          motherNameController.text = user.mothersName;
          usernameController.text = user.userName;
          passwordController.text = user.passw;
          dobController.text = user.dob;
           cityController.text = user.city;

          setState(() {
            maritalStatus = user.maritalStatus;
             selectedDepartment = user.departmentId.toString();
            selectedBloodGroup = user.bloodGroupId.toString();
            selectedGender = user.gender;
            selectedPlanType = user.planId.toString();
          });
        }
      });
    });
  }


  final List<String> steps = ['Personal', 'Contact', 'Qualification & Experience'];

  Widget getStepContent(int step) {
    switch (step) {
      case 0:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: firstNameController,
              decoration: const InputDecoration(labelText: 'First Name'),
            ),
            TextField(
              controller: middleNameController,
              decoration: const InputDecoration(labelText: 'Middle Name'),
            ),
            TextField(
              controller: lastNameController,
              decoration: const InputDecoration(labelText: 'Last Name'),
            ),
            TextField(
              controller: fatherNameController,
              decoration: const InputDecoration(labelText: 'Father Name'),
            ),
            TextField(
              controller: motherNameController,
              decoration: const InputDecoration(labelText: 'Mother Name'),
            ),
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            TextField(
              controller: dobController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Date of Birth',
                suffixIcon: Icon(Icons.calendar_today,color: Colors.grey,),
              ),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime(2000),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (pickedDate != null) {
                  dobController.text =
                  "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                }
              },
            ),
            const SizedBox(height: 10),
            const Text("Marital Status:"),
            Row(
              children: ['Single', 'Married', 'Other'].map((status) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Radio<String>(
                      activeColor: Colors.green,
                      value: status,
                      groupValue: maritalStatus,
                      onChanged: (val) {
                        setState(() => maritalStatus = val);
                      },
                    ),
                    Text(status),
                    const SizedBox(width: 10),
                  ],
                );
              }).toList(),
            ),
            DropdownButtonFormField(
              decoration: const InputDecoration(labelText: 'Select Department'),
              items: ['HR', 'Sales', 'IT', 'Marketing']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) => setState(() => selectedDepartment = val),
            ),
            DropdownButtonFormField(
              decoration:
              const InputDecoration(labelText: 'Select Blood Group'),
              items: ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) => setState(() => selectedBloodGroup = val),
            ),
            DropdownButtonFormField(
              decoration: const InputDecoration(labelText: 'Gender'),
              items: ['Male', 'Female', 'Other']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) => setState(() => selectedGender = val),
            ),
            DropdownButtonFormField(
              decoration: const InputDecoration(labelText: 'Plan Type'),
              items: ['Free', 'Basic', 'Premium']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) => setState(() => selectedPlanType = val),
            ),
          ],
        );

      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TextField(
              decoration: InputDecoration(labelText: 'E-Card Seva Office Address'),
            ),
            const TextField(
              decoration: InputDecoration(labelText: 'Present Address'),
            ),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Nationality (Country)'),
              items: ['India', 'USA', 'UK', 'Canada']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) {},
            ),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'State'),
              items: ['Rajasthan', 'Maharashtra', 'Delhi', 'Gujarat']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) {},
            ),
            const TextField(
              decoration: InputDecoration(labelText: 'District'),
            ),
            const TextField(
              decoration: InputDecoration(labelText: 'City'),
            ),
            const TextField(
              decoration: InputDecoration(labelText: 'Mobile Number'),
              keyboardType: TextInputType.phone,
            ),
            const TextField(
              decoration: InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
            ),
            const TextField(
              decoration: InputDecoration(labelText: 'Email ID'),
              keyboardType: TextInputType.emailAddress,
            ),
            const TextField(
              decoration: InputDecoration(labelText: 'Gmail ID'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 10),
            const Text(
              'Location (Map)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            GestureDetector(
              onTap: () {
                // TODO: implement map picker functionality
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Pick Location on Map'),
                    Icon(Icons.map),
                  ],
                ),
              ),
            ),
          ],
        );
        case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TextField(
              decoration: InputDecoration(labelText: 'Highest Qualification'),
            ),
            const TextField(
              decoration: InputDecoration(labelText: 'University/College'),
            ),
            const TextField(
              decoration: InputDecoration(labelText: 'Last Qualification'),
            ),
            const TextField(
              decoration: InputDecoration(labelText: 'Work Type'),
            ),
            const TextField(
              decoration: InputDecoration(labelText: 'Work Experience (in years)'),
              keyboardType: TextInputType.number,
            ),
          ],
        );


      default:
        return const SizedBox.shrink();
    }
  }

  Widget buildStepHeadersWithLines() {
    return Row(
      children: List.generate(steps.length * 2 - 1, (i) {
        if (i.isOdd) {
          return Expanded(
            child: Container(
              height: 2,
              color: i < _currentStep * 2 ? Colors.green : Colors.grey.shade300,
            ),
          );
        } else {
          int index = i ~/ 2;
          bool isActive = index == _currentStep;
          bool isCompleted = index < _currentStep;

          return Column(
            children: [
              GestureDetector(
                onTap: () => setState(() => _currentStep = index),
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: isCompleted
                      ? Colors.green
                      : (isActive ? Colors.blue : Colors.grey.shade300),
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      color:
                      isActive || isCompleted ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                steps[index],
                style: TextStyle(
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  fontSize: 12,
                  color: isActive ? Colors.blue : Colors.black54,
                ),
              ),
            ],
          );
        }
      }),
    );
  }

  @override
  void dispose() {
    // Dispose all controllers
    firstNameController.dispose();
    middleNameController.dispose();
    lastNameController.dispose();
    fatherNameController.dispose();
    motherNameController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    dobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Profile'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            buildStepHeadersWithLines(),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: getStepContent(_currentStep),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentStep > 0)
                  ElevatedButton(

                    onPressed: () => setState(() => _currentStep--),
                    child: const Text('Back',style: TextStyle(color: Colors.white),),
                  )
                else
                  const SizedBox(),
                ElevatedButton(
                  onPressed: () {
                    if (_currentStep < steps.length - 1) {
                      setState(() => _currentStep++);
                    } else {
                      // Final submission logic here
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Profile Updated',style: TextStyle(color: Colors.white),),),
                      );
                    }
                  },
                  child: Text(
                      _currentStep < steps.length - 1 ? 'Continue' : 'Finish',style: TextStyle(color: Colors.white),),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
