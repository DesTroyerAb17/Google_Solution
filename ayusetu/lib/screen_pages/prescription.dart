import 'package:flutter/material.dart';

import 'medicine_details_page.dart';

void main() {
  runApp(MaterialApp(
    home: MyPrescriptionsPage(),
  ));
}

class MyPrescriptionsPage extends StatefulWidget {
  @override
  _MyPrescriptionsPageState createState() => _MyPrescriptionsPageState();
}

class _MyPrescriptionsPageState extends State<MyPrescriptionsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Prescriptions'),
        backgroundColor: Color.fromARGB(255, 255, 154, 3),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // List of prescriptions
            Expanded(
              child: ListView(
                children: [
                  _prescriptionCard(
                    title: "Shashwat’s chest infection diagnosis prescription",
                    date: "21/03/25 | Dr Shiva Reddy",
                  ),
                  _prescriptionCard(
                    title: "Radha’s pneumonia infection diagnosis prescription",
                    date: "21/03/25 | Dr Shiva Reddy",
                  ),
                  _prescriptionCard(
                    title: "Srikant’s lung cancer diagnosis prescription",
                    date: "21/03/25 | Dr Shiva Reddy",
                  ),
                  _prescriptionCard(
                    title: "Srikant’s pneumonia infection diagnosis prescription",
                    date: "21/03/25 | Dr Shiva Reddy",
                  ),
                  _prescriptionCard(
                    title: "Susmita’s stomach infection diagnosis prescription",
                    date: "21/03/25 | Dr Shiva Reddy",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _prescriptionCard({required String title, required String date}) {
    return GestureDetector(
      onTap: () {
        // Navigate to the medicine details page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MedicineDetailsPage(title: title)),
        );
      },
      child: Card(
        elevation: 2,
        margin: EdgeInsets.only(bottom: 12),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          leading: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Color(0xFFFFE0B2), // Light orangish background
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.description,  // Prescription icon (Notepad icon)
              color: Colors.orange,
            ),
          ),
          title: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            date,
            style: TextStyle(fontSize: 12),
          ),
        ),
      ),
    );
  }
}
