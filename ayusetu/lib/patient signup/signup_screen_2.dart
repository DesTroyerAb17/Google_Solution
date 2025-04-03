import 'package:ayusetu/globalVariables.dart';
import 'package:ayusetu/introductory_screens/otp_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PatientSignupScreen2 extends StatefulWidget {
  const PatientSignupScreen2({super.key});

  @override
  _PatientSignupScreen2State createState() => _PatientSignupScreen2State();
}

class _PatientSignupScreen2State extends State<PatientSignupScreen2> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  bool isKeyboardVisible = false;
  bool isLoading = false;
  String? errorMessage;

  bool get isPhoneValid =>
      RegExp(r'^[6-9]\d{9}$').hasMatch(phoneController.text);
  bool get isNameValid => nameController.text.isNotEmpty;

  @override
  void initState() {
    super.initState();
    nameController.addListener(() {
      setState(() {}); // Update UI when user types
    });
    phoneController.addListener(() {
      setState(() {});
    });

    // Handle keyboard visibility
    KeyboardVisibilityController().onChange.listen((bool visible) {
      setState(() {
        isKeyboardVisible = visible;
      });
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  // Function to send OTP request and navigate to OTP page
  Future<void> submitMobileNumber() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    String phoneNumber = "+91${phoneController.text}"; // Ensure phone number starts with +91

    // Prepare the request data
    final requestBody = json.encode({
      "phoneNumber": phoneNumber,
    });

    final url = '$base_url/api/auth/send-otp'; // Endpoint to send OTP

    try {
      // Sending the POST request
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: requestBody,
      );

      if (response.statusCode == 200) {
        // If the response is successful, navigate to the OTP page
        setState(() {
          isLoading = false;
        });

        // Navigate to OTP page while passing name and phone number
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpPage(
              phoneNumber: phoneNumber,
              name: nameController.text,
            ),
          ),
        );
      } else {
        // If the response is unsuccessful (e.g., Invalid phone number)
        setState(() {
          errorMessage = "Failed to send OTP. Please try again.";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Error submitting the mobile number. Please try again.";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
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
          "Sign Up",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          reverse: isKeyboardVisible,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // Name Input Field
                const Text(
                  "Enter your full name",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: "Full Name",
                    errorText: nameController.text.isNotEmpty && !isNameValid
                        ? "Name cannot be empty"
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Mobile Number Input Field
                const Text(
                  "Get started! Enter your mobile number",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
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
                        child: Text("+91", style: TextStyle(fontSize: 16)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: "Mobile number",
                          errorText: phoneController.text.isNotEmpty && !isPhoneValid
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

                if (errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  ),

                const SizedBox(height: 10),

                // Terms & Conditions
                Row(
                  children: const [
                    Text(
                      "By registering you accept our ",
                      style: TextStyle(fontSize: 12),
                    ),
                    Text(
                      "Terms and Conditions",
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isPhoneValid && isNameValid && !isLoading ? submitMobileNumber : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isPhoneValid && isNameValid && !isLoading
                          ? const Color(0xFFFF8B01)
                          : Colors.grey.shade300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            "Submit",
                            style: TextStyle(
                              fontSize: 16,
                              color: isPhoneValid && isNameValid
                                  ? Colors.white
                                  : Colors.black54,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
