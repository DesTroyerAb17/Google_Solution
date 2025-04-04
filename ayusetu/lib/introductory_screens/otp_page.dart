import 'package:ayusetu/globalVariables.dart';
import 'package:ayusetu/screen_pages/homepage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OtpPage extends StatefulWidget {
  final String phoneNumber;
  final String? name; // Optional name parameter

  const OtpPage({super.key, required this.phoneNumber, this.name});

  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  bool isLoading = false;
  String? errorMessage;

  final List<TextEditingController> otpControllers =
      List.generate(6, (index) => TextEditingController());

  bool get isOtpFilled =>
      otpControllers.every((controller) => controller.text.length == 1);

  // Function to verify OTP and send to backend
  Future<void> verifyOTP() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    String otpCode = otpControllers.map((c) => c.text).join();
    String phoneNumber = widget.phoneNumber;
    String? name = widget.name; // Get name from the constructor

    // Prepare the request data
    final requestBody = json.encode({
      "phoneNumber": phoneNumber,
      "otp": otpCode,
      // Only send name if it's not null
      if (name != null) "name": name, // Add name only if it's provided
    });

    // Endpoint to verify OTP
    final url = '$base_url/api/auth/verify-otp'; // Adjust the URL to your backend

    // Print the constructed URL and request body for debugging
    print("Sending POST request to: $url");
    print("Request body: $requestBody");

    try {
      // Sending the POST request
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: requestBody,
      );

      if (response.statusCode == 200) {
        // If the response is successful
        final responseData = json.decode(response.body);
        print('OTP verified successfully: $responseData');

        // Store the values in global variables
        verification_token = responseData['token']; // Store the token
        verification_id = responseData['profile']['_id']; // Store the user ID
        username = responseData['profile']['name']; // Store the username
        phoneNumber = responseData['profile']['phoneNumber']; 
        role = responseData['role']; 

        // Store the phone number

        // Print the values to verify they're stored correctly
        print("Verification Token: $verification_token");
        print("Verification ID: $verification_id");
        print("Username: $username");
        print("Phone Number: $phoneNumber");

        // Navigate to home page or next screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainScreen(userRole: role)), // Change to your desired page
        );
      } else {
        // If the response is unsuccessful (e.g., Invalid OTP)
        setState(() {
          errorMessage = "Invalid OTP! Please try again.";
          isLoading = false;
        });
      }
    } catch (e) {
      // Catch network errors
      print("Error during OTP verification: $e");
      setState(() {
        errorMessage = "Error verifying OTP. Try again.";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Verify OTP"),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Enter OTP sent to your mobile number",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),

            // OTP Input Fields
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(6, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: SizedBox(
                    width: 40,
                    child: TextField(
                      controller: otpControllers[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        counterText: "",
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.orange),
                        ),
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty && index < 5) {
                          FocusScope.of(context).nextFocus();
                        } else if (value.isEmpty && index > 0) {
                          FocusScope.of(context).previousFocus();
                        }
                      },
                    ),
                  ),
                );
              }),
            ),

            if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  errorMessage!,
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                ),
              ),

            const SizedBox(height: 30),

            // Verify OTP Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isOtpFilled ? verifyOTP : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isOtpFilled ? Colors.orange : Colors.grey.shade300,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Verify OTP", style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),

            const SizedBox(height: 20),

            // Resend OTP Button
            Center(
              child: TextButton(
                onPressed: () {
                  // Add your resend OTP logic here
                },
                child: const Text(
                  "Resend OTP",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
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
