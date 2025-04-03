import 'package:ayusetu/globalVariables.dart';
import 'package:ayusetu/introductory_screens/otp_page.dart';
import 'package:ayusetu/introductory_screens/user_select_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController phoneController = TextEditingController();
  bool isKeyboardVisible = false;
  bool isLoading = false;
  String? errorMessage;

  bool get isPhoneValid => RegExp(r'^[6-9]\d{9}$').hasMatch(phoneController.text);

  @override
  void initState() {
    super.initState();
    phoneController.addListener(() {
      setState(() {}); // Update UI when the user types
    });
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  // Function to check if phone number exists in the database
  // Function to check if phone number exists in the database
// Function to check if phone number exists in the database and then send OTP
Future<void> checkPhoneExists() async {
  setState(() {
    isLoading = true;
    errorMessage = null;
  });

  try {
    // Adding '+91' prefix to the phone number
    String phoneNumber = "+91${phoneController.text.trim()}";

    // Debug: print phone number being checked
    print("Checking phone number: $phoneNumber");

    // Constructing the URL to check the phone number
    final url = '$base_url/api/auth/check-phone?phoneNumber=$phoneNumber';
    print("Constructed URL: $url");

    // Sending the request to the server
    final response = await http.get(Uri.parse(url));

    // Debug: print status code of the response
    print("Response Status Code: ${response.statusCode}");

    if (response.statusCode == 200) {
      // If the status code is 200 (OK), parsing the response body
      final responseData = json.decode(response.body);

      // Debug: print response data
      print("Response data: $responseData");

      if (responseData['exists'] == true) {
        // If phone number exists, proceed to send OTP
        print("Phone number exists, sending OTP");

        // Now send the OTP request
        await sendOTP(phoneNumber);
      } else {
        // If phone number does not exist, show error message
        print("Phone number does not exist. Error message: ${responseData['message']}");
        setState(() {
          errorMessage = responseData['message'];
          isLoading = false;
        });
      }
    } else {
      // Debug: print the error if response code is not 200
      print("Failed to connect to server. Response Status Code: ${response.statusCode}");
      setState(() {
        errorMessage = "Error checking phone number.";
        isLoading = false;
      });
    }
  } catch (e) {
    // Debug: print the error if something goes wrong
    print("Error while sending request: $e");
    setState(() {
      errorMessage = "Error checking phone number. Try again.";
      isLoading = false;
    });
  }
}

// Function to send OTP using the send-otp endpoint
Future<void> sendOTP(String phoneNumber) async {
  setState(() {
    isLoading = true;
    errorMessage = null;
  });

  try {
    // Constructing the URL for sending OTP
    final url = '$base_url/api/auth/send-otp';
    print("Sending OTP request to URL: $url");

    // Making the POST request
    final response = await http.post(
      Uri.parse(url),
      body: json.encode({
        'phoneNumber': phoneNumber, // Sending the phone number in the body
      }),
      headers: {'Content-Type': 'application/json'},
    );

    // Debug: print status code of the response
    print("OTP Response Status Code: ${response.statusCode}");

    if (response.statusCode == 200) {
      // If OTP is successfully sent (bypassed or real), navigate to OTP page
      final responseData = json.decode(response.body);
      print("OTP Response: $responseData");

      // Navigate to OTP page (pass phone number and role if needed)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OtpPage(phoneNumber: phoneNumber),
        ),
      );
    } else {
      // If there's an error, show it
      setState(() {
        errorMessage = "Error sending OTP. Please try again.";
        isLoading = false;
      });
      print("Error sending OTP: ${response.body}");
    }
  } catch (e) {
    // Debug: print the error if something goes wrong
    print("Error while sending OTP request: $e");
    setState(() {
      errorMessage = "Error sending OTP. Try again.";
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
          "Login",
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
                const Text(
                  "Enter your mobile number",
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
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Expanded(child: Divider(thickness: 1)),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text("Login option"),
                    ),
                    const Expanded(child: Divider(thickness: 1)),
                  ],
                ),
                const SizedBox(height: 20),
                // "Check Phone" Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isPhoneValid && !isLoading ? checkPhoneExists : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isPhoneValid && !isLoading ? const Color(0xFFFF8B01) : Colors.grey.shade300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            "Check Phone Number",
                            style: TextStyle(
                              fontSize: 16,
                              color: isPhoneValid ? Colors.white : Colors.black54,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 20),
                // "I don’t have an account" Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const UserSelectionScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF8B01),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "I don’t have an account",
                      style: TextStyle(fontSize: 16, color: Colors.white),
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
