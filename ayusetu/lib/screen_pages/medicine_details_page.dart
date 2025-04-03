import 'package:flutter/material.dart';

class MedicineDetailsPage extends StatelessWidget {
  final String title;

  MedicineDetailsPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prescription Details'),
        backgroundColor: Color.fromARGB(255, 246, 154, 3),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Prescription Title
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            // Medicines
            _medicineCard(medicine: "Paracetamol 500mg", dosage: "Take 1 tablet twice daily"),
            _medicineCard(medicine: "Amoxicillin 500mg", dosage: "Take 1 tablet thrice daily for 7 days"),
            _medicineCard(medicine: "Cough Syrup 100ml", dosage: "Take 10ml after meals, twice a day"),

            // Additional note
            SizedBox(height: 20),
            Text("You can add more medicine cards here as needed."),
          ],
        ),
      ),
    );
  }

  // Medicine Card with orangish tint
  Widget _medicineCard({required String medicine, required String dosage}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 65, 65, 65).withOpacity(0.2),  // Light orange background
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            // Medicine Name in a circular rectangular box
            Container(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 153, 36).withOpacity(0.2), // Orangish tint
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                medicine,
                style: TextStyle(color: const Color.fromARGB(255, 12, 12, 12), fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(width: 16),
            // Dosage details
            Text(
              dosage,
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
