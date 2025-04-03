import 'package:flutter/material.dart';

class DoctorProfilePage extends StatelessWidget {
  const DoctorProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Doctor's Profile"),
        backgroundColor: Color(0xFFFF8B01), // Matching with your app's color
      ),
      body: Container(
        color: Colors.white, // Set background color to whitish (aligned with the rest of the app)
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Doctor Profile Picture
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[300],
                  child: Icon(Icons.person, size: 50, color: Colors.white),
                ),
              ),
              SizedBox(height: 16),
              
              // Doctor Name
              Center(
                child: Text(
                  'Dr. Shiva Reddy',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1D1B20), // Matching the dark color theme
                  ),
                ),
              ),
              SizedBox(height: 8),
              
              // Specialty
              Center(
                child: Text(
                  'General Medicine',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF79747E), // Grey text color for the specialty
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Doctor's Bio or Experience
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Dr. Shiva Reddy is a highly skilled General Medicine specialist with over 10 years of experience. He is known for his expertise in treating a wide range of medical conditions and for providing compassionate care to his patients.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF49454F), // Dark grey color for the description text
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
              SizedBox(height: 16),

              // Contact Information
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Contact Information:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1D1B20),
                  ),
                ),
              ),
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Phone: +91 123 456 7890',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF1D1B20),
                  ),
                ),
              ),
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Email: dr.shiva@health.com',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF1D1B20),
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Book Appointment Button (Positioned at bottom center and elongated)
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity, // Elongated to fill the width
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // Add logic for booking an appointment
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFF8B01), // Orange button color
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      'Book Appointment',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
