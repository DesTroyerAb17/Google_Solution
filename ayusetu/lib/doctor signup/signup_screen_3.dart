import 'dart:convert';
import 'package:ayusetu/doctor%20signup/signup_screen_4.dart';
import 'package:ayusetu/globalVariables.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DoctorSignupScreen3 extends StatefulWidget {
  final String doctorName;
  final String phoneNumber;
  final String email;

  const DoctorSignupScreen3({
    super.key,
    required this.doctorName,
    required this.phoneNumber,
    required this.email,
  });

  @override
  _DoctorSignupScreen3State createState() => _DoctorSignupScreen3State();
}

class _DoctorSignupScreen3State extends State<DoctorSignupScreen3> {
  final TextEditingController registrationController = TextEditingController();
  final TextEditingController aadharController = TextEditingController();
  final TextEditingController panController = TextEditingController();
  String? selectedCouncil;

  final List<String> stateMedicalCouncils = [
    "Andhra Pradesh Medical Council",
    "Arunachal Pradesh Medical Council",
    "Assam Medical Council",
    "Bareilly Medical Council",
    "Bhopal Medical Council",
    "Bihar Medical Council",
    "Bombay Medical Council",
    "Chandigarh Medical Council",
    "Chhattisgarh Medical Council",
    "Delhi Medical Council",
    "Goa Medical Council",
    "Gujarat Medical Council",
    "Haryana Medical Council",
    "Himachal Pradesh Medical Council",
    "Jammu & Kashmir Medical Council",
    "Jharkhand Medical Council",
    "Karnataka Medical Council",
    "Kerala Medical Council",
    "Madhya Pradesh Medical Council",
    "Maharashtra Medical Council",
    "Manipur Medical Council",
    "Meghalaya Medical Council",
    "Nagaland Medical Council",
    "Odisha Medical Council",
    "Punjab Medical Council",
    "Rajasthan Medical Council",
    "Tamil Nadu Medical Council",
    "Telangana Medical Council",
    "Uttar Pradesh Medical Council",
    "Uttarakhand Medical Council",
    "West Bengal Medical Council"
  ];

  List<String> filteredCouncils = [];

  @override
  void initState() {
    super.initState();
    filteredCouncils = List.from(stateMedicalCouncils);
    // Add listeners for the new fields
    aadharController.addListener(_updateButtonState);
    panController.addListener(_updateButtonState);
    registrationController.addListener(_updateButtonState);
  }

void _updateButtonState() {
  setState(() {}); // This triggers a rebuild of the UI and updates the button state
}

  bool get isFormValid =>
      registrationController.text.isNotEmpty &&
      aadharController.text.isNotEmpty &&
      panController.text.isNotEmpty &&
      selectedCouncil != null &&
      isValidAadhar(aadharController.text) &&
      isValidPan(panController.text);

  // Aadhar validation (12 digits)
  bool isValidAadhar(String aadhar) {
    return RegExp(r'^\d{12}$').hasMatch(aadhar);
  }

  // PAN validation (AAAAA9999A)
  bool isValidPan(String pan) {
    return RegExp(r'^[A-Z]{5}\d{4}[A-Z]{1}$').hasMatch(pan);
  }

  Future<void> registerDoctor() async {
    final requestBody = json.encode({
      "name": widget.doctorName,
      "email": widget.email,
      "phoneNumber": widget.phoneNumber,
      "registrationNumber": registrationController.text.trim(),
      "aadhar": aadharController.text.trim(),
      "pan": panController.text.trim(),
      "stateMedicalCouncil": selectedCouncil,
    });

    final url = '$base_url/api/doctors/register';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: requestBody,
      );

      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        print("Doctor registered successfully: $responseData");

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DoctorSignupScreen4(doctorName: widget.doctorName),
          ),
        );
      } else {
        print("Failed to register doctor: ${response.body}");
      }
    } catch (e) {
      print("Error during registration: $e");
    }
  }

  void showCouncilSelectionBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.65,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(45),
                  topRight: Radius.circular(45),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 2),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: TextField(
                      controller: TextEditingController(),
                      onChanged: (query) {
                        setModalState(() {
                          filteredCouncils = stateMedicalCouncils
                              .where((council) => council.toLowerCase().contains(query.toLowerCase()))
                              .toList();
                        });
                      },
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search, color: Colors.grey),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.close, color: Colors.grey),
                          onPressed: () {
                            TextEditingController().clear();
                            setModalState(() {
                              filteredCouncils = List.from(stateMedicalCouncils);
                            });
                          },
                        ),
                        hintText: "Search State Medical Council",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.grey.shade400),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredCouncils.length,
                      itemBuilder: (context, index) {
                        return RadioListTile<String>(
                          title: Text(filteredCouncils[index]),
                          value: filteredCouncils[index],
                          groupValue: selectedCouncil,
                          onChanged: (value) {
                            setModalState(() {
                              selectedCouncil = value;
                            });
                          },
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: SizedBox(
                      width: 230,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedCouncil = selectedCouncil;
                          });
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF8B01),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text(
                          "Confirm",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
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
        title: Text(
          widget.doctorName,
          style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        actions: [
          IconButton(icon: const Icon(Icons.help_outline, color: Colors.black), onPressed: () {}),
          IconButton(icon: const Icon(Icons.language, color: Colors.black), onPressed: () {}),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            TextField(
              controller: registrationController,
              decoration: InputDecoration(
                hintText: "Enter Medical Registration no.",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: showCouncilSelectionBottomSheet,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedCouncil ?? "Enter State Medical Council",
                      style: TextStyle(fontSize: 16, color: selectedCouncil == null ? Colors.grey : Colors.black),
                    ),
                    const Icon(Icons.arrow_drop_down, color: Colors.black),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: aadharController,
              decoration: InputDecoration(
                hintText: "Enter Aadhar Number",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                errorText: !isValidAadhar(aadharController.text) && aadharController.text.isNotEmpty
                    ? "Invalid Aadhar number (12 digits required)"
                    : null,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: panController,
              decoration: InputDecoration(
                hintText: "Enter PAN",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                errorText: !isValidPan(panController.text) && panController.text.isNotEmpty
                    ? "Invalid PAN number (format: AAAAA9999A)"
                    : null,
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isFormValid ? registerDoctor : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isFormValid ? const Color(0xFFFF8B01) : Colors.grey.shade300,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text("Verify", style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
