import 'package:flutter/material.dart';
import 'package:flutter_mediconnect/doctor%20signup/signup_screen_3.dart';

class DoctorSignupScreen2 extends StatefulWidget {
  const DoctorSignupScreen2({super.key});

  @override
  _DoctorSignupScreen2State createState() => _DoctorSignupScreen2State();
}

class _DoctorSignupScreen2State extends State<DoctorSignupScreen2> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  bool get isFormValid =>
      isValidPhone(phoneController.text) &&
      isValidEmail(emailController.text) &&
      isValidName(nameController.text);

  void _updateButtonState() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    phoneController.addListener(_updateButtonState);
    emailController.addListener(_updateButtonState);
    nameController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    phoneController.dispose();
    emailController.dispose();
    nameController.dispose();
    super.dispose();
  }

  bool isValidPhone(String phone) {
    return RegExp(r'^[6-9]\d{9}$').hasMatch(phone); // Indian 10-digit number
  }

  bool isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(email);
  }

  bool isValidName(String name) {
    return RegExp(r'^[a-zA-Z\s]+$').hasMatch(name); // Only letters and spaces
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Doctor registration",
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.black),
            onPressed: () {
              // Help action (if needed)
            },
          ),
          IconButton(
            icon: const Icon(Icons.language, color: Colors.black),
            onPressed: () {
              // Language selection logic
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // Phone Number Field
            Row(
              children: [
                Container(
                  width: 60,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      "+91",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: "Enter Mobile number",
                      errorText: phoneController.text.isNotEmpty && !isValidPhone(phoneController.text)
                          ? "Invalid phone number"
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Email Field
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: "Enter Email",
                errorText: emailController.text.isNotEmpty && !isValidEmail(emailController.text)
                    ? "Invalid email address"
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Name Field
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(left: 12, top: 14),
                  child: Text(
                    "Dr ",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                ),
                hintText: "Enter your name",
                errorText: nameController.text.isNotEmpty && !isValidName(nameController.text)
                    ? "Invalid name"
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 50),

            // Proceed Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isFormValid
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const DoctorSignupScreen3()),
                        );
                      }
                    : null, // Disabled when fields are empty or invalid
                style: ElevatedButton.styleFrom(
                  backgroundColor: isFormValid ? const Color(0xFFFF8B01) : Colors.grey.shade300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  "Proceed",
                  style: TextStyle(
                    fontSize: 16,
                    color: isFormValid ? Colors.white : Colors.black54,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
