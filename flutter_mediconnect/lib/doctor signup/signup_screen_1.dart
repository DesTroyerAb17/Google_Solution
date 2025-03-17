import 'package:flutter/material.dart';
import 'package:flutter_mediconnect/doctor%20signup/signup_screen_2.dart';
import 'package:flutter_mediconnect/intoductory_screens/login_page.dart';
import 'package:flutter_svg/flutter_svg.dart';


class DoctorSignupScreen1 extends StatefulWidget {
  const DoctorSignupScreen1({super.key});

  @override
  _DoctorSignupScreen1State createState() => _DoctorSignupScreen1State();
}

class _DoctorSignupScreen1State extends State<DoctorSignupScreen1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top Blue Section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 50),
            decoration: const BoxDecoration(
              color: Color(0xFF064D99), // Blue Background
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Center(
                  child: SvgPicture.asset(
                    'assets/image_assets/ayusetu white.svg', // Ensure correct SVG file path
                    width: 80,
                  ),
                ),
                const SizedBox(height: 10),
                const Center(
                  child: Text(
                    "AyuSetu",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const Center(
                  child: Text(
                    "For Doctors",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                const Text(
                  "E-clinic at your fingertips",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 15),
                _featureText("Manage your doctor profile"),
                _featureText("Provide online video consultation"),
                _featureText("View patients’ records from anywhere"),
                _featureText("Generate e-prescription after patient consultation"),
              ],
            ),
          ),
          const SizedBox(height: 30),

          // Phone Number Input (Now a Button)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Get started! Enter your mobile number",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                // GestureDetector replaces TextField
                GestureDetector(
                  onTap: () {
                    // Navigate directly to DoctorSignupScreen2
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const DoctorSignupScreen2()),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                    child: const Center(
                      child: Text(
                        "Enter Mobile Number",
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),
                const Text(
                  "Read our Terms and Conditions & Privacy Policy before proceeding",
                  style: TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 20),

                // Confirm Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF8B01),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "I already have an account",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _featureText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.white, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
