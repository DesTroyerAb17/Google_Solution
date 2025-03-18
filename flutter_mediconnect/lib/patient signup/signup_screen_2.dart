import 'package:flutter/material.dart';
import 'package:flutter_mediconnect/intoductory_screens/otp_page.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PatientSignupScreen2 extends StatefulWidget {
  const PatientSignupScreen2({super.key});

  @override
  _PatientSignupScreen2State createState() => _PatientSignupScreen2State();
}

class _PatientSignupScreen2State extends State<PatientSignupScreen2> {
  final TextEditingController phoneController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isKeyboardVisible = false;
  bool isLoading = false;
  String? errorMessage;

  bool get isPhoneValid => RegExp(r'^[6-9]\d{9}$').hasMatch(phoneController.text);

  @override
  void initState() {
    super.initState();
    phoneController.addListener(() {
      setState(() {}); // Update UI when user types
    });

    KeyboardVisibilityController().onChange.listen((bool visible) {
      setState(() {
        isKeyboardVisible = visible;
      });
    });
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  Future<void> sendOTP() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: "+91${phoneController.text}",
        
        verificationCompleted: (PhoneAuthCredential credential) async {
          // ✅ Auto Sign-in when OTP is detected automatically
          await _auth.signInWithCredential(credential);
          if (mounted) {
            Navigator.pushReplacementNamed(context, "/home");
          }
        },
        
        verificationFailed: (FirebaseAuthException e) {
          setState(() {
            errorMessage = "OTP verification failed: ${e.message}";
            isLoading = false;
          });
        },
        
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            isLoading = false;
          });

          // ✅ Correctly navigating to OTP screen with verificationId
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpPage(
                verificationId: verificationId,
                phoneNumber: "+91${phoneController.text}", 
              ),
            ),
          );
        },
        
        codeAutoRetrievalTimeout: (String verificationId) {
          // Auto-retrieval timed out
        },
      );
    } catch (e) {
      setState(() {
        errorMessage = "Error sending OTP. Check your network: $e";
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

                // Mobile Number Input
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

                // "Get OTP" Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isPhoneValid && !isLoading ? sendOTP : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isPhoneValid && !isLoading
                          ? const Color(0xFFFF8B01)
                          : Colors.grey.shade300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            "Get OTP",
                            style: TextStyle(
                              fontSize: 16,
                              color: isPhoneValid ? Colors.white : Colors.black54,
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
