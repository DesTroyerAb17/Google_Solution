import 'package:flutter/material.dart';
import 'package:flutter_mediconnect/patient%20signup/signup_screen_2.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_mediconnect/intoductory_screens/login_page.dart';

class PatientSignupScreen1 extends StatelessWidget {
  const PatientSignupScreen1({super.key});

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
              color: Color(0xFF004E98), // Dark blue background
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
                    'assets/image_assets/ayusetu white.svg', // Ensure SVG exists
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
                const SizedBox(height: 30),
                const Text(
                  "Your Go-to medical companion",
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                _featureText("Get verified doctor's consultation"),
                _featureText("Your medical social platform to connect and interact"),
                _featureText("Your AI-powered companion to tackle medical-related situations"),
                _featureText("First-hand diagnosis and emergency suggestions at your fingertips"),
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
                      MaterialPageRoute(builder: (context) => const PatientSignupScreen2()),
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

                const SizedBox(height: 20),

                // Guest Login Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      side: BorderSide(color: Colors.grey.shade400),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(Icons.person_outline, size: 24, color: Colors.black),
                        
                        const Expanded(
                          child: Text(
                            "Guest login",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20,),
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

  // Feature List with Icons
  static Widget _featureText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.white, size: 16),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
