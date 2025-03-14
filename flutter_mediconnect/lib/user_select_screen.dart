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
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      color: selectedUser == "Doctor" ? Colors.blue : Colors.transparent,
                      width: 2.0,
                    ),
                  ),
                  child: Padding( // Add padding here
                    padding: const EdgeInsets.all(4.0), // Adjust padding as needed
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4.0), // Adjust image radius according to padding
                      child: Image.asset(
                        selectedUser == "Doctor"
                            ? 'assets/image_assets/doctor_selected.png'
                            : 'assets/image_assets/doctor.png',
                        width: 160,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
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
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      color: selectedUser == "Patient" ? Colors.blue : Colors.transparent,
                      width: 2.0,
                    ),
                  ),
                  child: Padding( // Add padding here
                    padding: const EdgeInsets.all(4.0), // Adjust padding as needed
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4.0), // Adjust image radius according to padding
                      child: Image.asset(
                        selectedUser == "Patient"
                            ? "assets/image_assets/patient_selected.png"
                            : "assets/image_assets/patient.png",
                        width: 160,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
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
                      Navigator.pop(context);
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
              child: Text(
                "Confirm Selection",
                style: TextStyle(
                  fontSize: 16,
                  color: selectedUser != null ? Colors.white : Colors.black54,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}