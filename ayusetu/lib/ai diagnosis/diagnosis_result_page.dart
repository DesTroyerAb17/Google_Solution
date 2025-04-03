import 'package:flutter/material.dart';

class DiagnosisResultPage extends StatelessWidget {
  final bool isDetected;
  final double confidence;
  final String diseaseName;
  final Map<String, String>  patientDetails;

  const DiagnosisResultPage({super.key, required this.isDetected, required this.confidence, required this.diseaseName, required this.patientDetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFF8B01),
        title: Text(
          'Diagnosis Report',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Patient Details Section with Border
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    CircleAvatar(child: Icon(Icons.person)),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          patientDetails['name'] ?? 'Unknown', 
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                        ),
                        Text(
                          "${patientDetails['gender'] ?? 'Unknown'} | ${patientDetails['age'] ?? 'Unknown'} yrs | ${patientDetails['weight'] ?? 'Unknown'} kg", 
                          style: TextStyle(fontSize: 14))
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Diagnosis Section with Border (Green Box)
              Container(
                width: double.infinity, // Make the box take the full width
                padding: EdgeInsets.all(20.0), // Increased padding
                decoration: BoxDecoration(
                  color: Colors.orange.shade50, // Light orange background for the box
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.orange.shade300, // Light orange border
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.thumb_up, // Thumbs-up icon
                      color: Colors.green,
                      size: 79, // Increased size of the thumbs-up icon
                    ),
                    SizedBox(height: 10),
                    // Added border for the "Not Detected" text and centered
                    Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.green.shade300, // Light green border
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(  // Centering the text inside the container
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center, // Centering the row horizontally
                          children: [
                            Icon(
                              Icons.local_hospital, // Hospital safety icon
                              color: Colors.green,
                              size: 20,
                            ),
                            SizedBox(width: 5),
                            Text(
                              "$diseaseName Not Detected", // Display the disease status
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '*You may not have $diseaseName. But suspecting to have such a disease might be concerning. Please seek medical attention.*',
                      style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Implement action for Get Professional Help
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFF8B01),
                        minimumSize: Size(double.infinity, 50),
                        textStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // Rounded corners
                        ),
                      ),
                      child: Text('Get Professional Help', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Suggested Actions Section with Left-aligned "What you can do next"
              Align(
                alignment: Alignment.centerLeft,
                child: Text("What you can do next", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  // No border here for the options
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        "Find a doctor", 
                        style: TextStyle(fontWeight: FontWeight.bold) // Bold font for title
                      ),
                      subtitle: Text("View doctors in our network", style: TextStyle(fontSize: 12)), // Small description below title
                      trailing: Icon(Icons.arrow_forward),
                      onTap: () {
                        // Navigate to doctor search or list
                      },
                    ),
                    ListTile(
                      title: Text(
                        "Treatment options", 
                        style: TextStyle(fontWeight: FontWeight.bold) // Bold font for title
                      ),
                      subtitle: Text("Learn about treatments for $diseaseName", style: TextStyle(fontSize: 12)), // Small description below title
                      trailing: Icon(Icons.arrow_forward),
                      onTap: () {
                        // Navigate to treatment options
                      },
                    ),
                    ListTile(
                      title: Text(
                        "Second opinion", 
                        style: TextStyle(fontWeight: FontWeight.bold) // Bold font for title
                      ),
                      subtitle: Text("Get a second opinion from a specialist", style: TextStyle(fontSize: 12)), // Small description below title
                      trailing: Icon(Icons.arrow_forward),
                      onTap: () {
                        // Navigate to second opinion request
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Book Online Consultation Button with Full Width
              ElevatedButton(
                onPressed: () {
                  // Implement booking consultation logic
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFF8B01),
                  minimumSize: Size(double.infinity, 50), // Full width button
                  padding: EdgeInsets.symmetric(vertical: 14),
                  textStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.white), // White text and bold
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Rounded corners
                  ),
                ),
                child: Text("Book Online Consultation", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
