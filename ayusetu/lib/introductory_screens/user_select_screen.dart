import 'package:ayusetu/doctor signup/signup_screen_1.dart';
import 'package:ayusetu/patient signup/signup_screen_1.dart';
import 'package:flutter/material.dart';

class UserSelectionScreen extends StatefulWidget {
  const UserSelectionScreen({super.key});

  @override
  _UserSelectionScreenState createState() => _UserSelectionScreenState();
}

class _UserSelectionScreenState extends State<UserSelectionScreen> {
  String? selectedUser;

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
          "User selection",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.language, color: Colors.black),
            onPressed: () {
              // Implement language selection logic
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Welcome User!",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(height: 5),
          const Text(
            "Please select your user profile to continue",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 20),

          // User Selection Options (Doctor & Patient)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Doctor Selection
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedUser = "Doctor";
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  width: selectedUser == "Doctor" ? 140 : 120,
                  height: selectedUser == "Doctor" ? 180 : 160,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: selectedUser == "Doctor" ? const Color(0xFF064D99) : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Image.asset(
                    'assets/image_assets/doctor.png',
                    fit: BoxFit.contain,
                    width: 120,
                    height: 120,
                  ),
                ),
              ),
              const SizedBox(width: 20),

              // Patient Selection
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedUser = "Patient";
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  width: selectedUser == "Patient" ? 140 : 120,
                  height: selectedUser == "Patient" ? 180 : 160,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: selectedUser == "Patient" ? const Color(0xFF064D99) : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Image.asset(
                    'assets/image_assets/patient.png',
                    fit: BoxFit.contain,
                    width: 120,
                    height: 120,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),

          // Confirm Selection Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton(
              onPressed: selectedUser != null
                  ? () {
                      if (selectedUser == "Doctor") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => DoctorSignupScreen1()),
                        );
                      } else if (selectedUser == "Patient") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PatientSignupScreen1()),
                        );
                      }
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedUser != null
                    ? const Color(0xFFFF8B01)
                    : Colors.grey[300],
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Confirm Selection",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
