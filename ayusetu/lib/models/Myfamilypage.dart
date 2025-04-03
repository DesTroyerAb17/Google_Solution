import 'dart:convert';
import 'package:ayusetu/drawer%20pages/addpatient.dart';
import 'package:ayusetu/globalVariables.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

class MyFamilyPage extends StatefulWidget {
  const MyFamilyPage({super.key});

  @override
  _MyFamilyPageState createState() => _MyFamilyPageState();
}

class _MyFamilyPageState extends State<MyFamilyPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getFamilyMembers();  // Fetch family members when the page loads
  }

  /// **Function to fetch family members**
  Future<void> _getFamilyMembers() async {
    try {
      final response = await http.get(
        Uri.parse('$base_url/api/users/family-members'),
        headers: {
          'Authorization': 'Bearer $verification_token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        // Clear the existing list and add new family members
        setState(() {
          familymembers.clear();
          for (var member in data) {
            familymembers.add({
              'id': member['_id'] ?? 'Unknown',  // Default to 'Unknown' if id is null
              'name': member['name'] ?? 'Unknown',  // Default name if null
              'gender': member['gender'] ?? 'Unknown', // Default gender if null
              'dateOfBirth': member['dateOfBirth'] ?? 'N/A',
              'height': member['height']?.toString() ?? '0', // Default height if null
              'weight': member['weight']?.toString() ?? '0', // Default weight if null
              'bloodGroup': member['bloodGroup'] ?? 'Unknown',
            });
          }
        });
      } else {
        // Handle failure (e.g., if the API returns an error)
        throw Exception("Failed to load family members");
      }
    } catch (e) {
      // Handle errors
      print("Error fetching family members: $e");
    }
  }

  /// **Add New Patient Button**
  Widget _addNewPatientButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _addPatient,
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFFF8B01), // Orange button
            padding: EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: Text(
            "Add new patient",
            style: GoogleFonts.roboto(
                fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
          ),
        ),
      ),
    );
  }

  /// **Function to add new patient**
  void _addPatient() async {
    final newPatient = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddPatientPage()),
    );

    if (newPatient != null) {
      setState(() {
        familymembers.add(newPatient); // Add the new patient to the list
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "My Family",
          style: GoogleFonts.roboto(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: familymembers.isEmpty
                ? _emptyState()
                : ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: familymembers.length,
                    itemBuilder: (context, index) {
                      final member = familymembers[index];
                      return Dismissible(
                        key: Key(member['name']!),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          margin: EdgeInsets.symmetric(vertical: 6),
                          padding: EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.centerRight,
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                        confirmDismiss: (direction) async {
                          return await _confirmDelete(index);
                        },
                        child: _patientCard(member, index),
                      );
                    },
                  ),
          ),
          _addNewPatientButton(),
        ],
      ),
    );
  }

  /// **Patient Card UI**
  Widget _patientCard(Map<String, String> member, int index) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 6),
      elevation: 3,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            _avatar(member['gender']!),
            SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    member['name']!,  // Default if name is null
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "${member['gender']} | ${member['weight']} kg | ${member['height']} cm",
                    style: GoogleFonts.roboto(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            _moreInfoIcon(member, index),
          ],
        ),
      ),
    );
  }

  /// **Profile Avatar Based on Gender**
  Widget _avatar(String gender) {
    Color bgColor = gender == "Male" ? Colors.blue.shade400 : Colors.pink.shade400;

    return CircleAvatar(
      radius: 26,
      backgroundColor: bgColor,
      child: Icon(Icons.person, color: Colors.white, size: 26),
    );
  }

  /// **More Info Button**
  Widget _moreInfoIcon(Map<String, String> member, int index) {
    return IconButton(
      icon: Icon(Icons.info_outline, color: Colors.grey.shade700),
      onPressed: () {
        _showPatientDetails(member, index);
      },
    );
  }

  /// **Show Patient Details Dialog with Delete**
  void _showPatientDetails(Map<String, String> member, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text(
            member['name']!,  // Default if name is null
            style: GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _infoRow("Gender", member['gender'] ?? 'Unknown'),
              _infoRow("Height", "${member['height']} cm"),
              _infoRow("Weight", "${member['weight']} kg"),
            ],
          ),
          actions: [
            TextButton(
              child: Text("Close", style: TextStyle(color: Colors.black)),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text("Delete", style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.pop(context);
                _removePatient(index);
              },
            ),
          ],
        );
      },
    );
  }

  /// **Info Row for Details Dialog**
  Widget _infoRow(String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.w500)),
          Text(value, style: GoogleFonts.roboto(fontSize: 14, color: Colors.grey.shade700)),
        ],
      ),
    );
  }

  /// **Empty State when no patients are added**
  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.family_restroom, size: 80, color: Colors.grey.shade400),
          SizedBox(height: 12),
          Text(
            "No family members added yet!",
            style: GoogleFonts.roboto(fontSize: 16, color: Colors.grey.shade600),
          ),
          SizedBox(height: 8),
          Text(
            "Tap 'Add new patient' to get started.",
            style: GoogleFonts.roboto(fontSize: 14, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  /// **Confirm Delete Dialog**
  Future<bool?> _confirmDelete(int index) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text("Confirm Delete"),
        content: Text("Are you sure you want to delete this patient?"),
        actions: [
          TextButton(
            child: Text("Cancel", style: TextStyle(color: Colors.black)),
            onPressed: () => Navigator.pop(context, false),
          ),
          TextButton(
            child: Text("Delete", style: TextStyle(color: Colors.red)),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );
  }

  /// **Remove Patient**
  void _removePatient(int index) async {
  final memberId = familymembers[index]['id'];

  try {
    final response = await http.delete(
      Uri.parse('$base_url/api/users/delete-family-member/$memberId'),
      headers: {
        'Authorization': 'Bearer $verification_token',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        familymembers.removeAt(index); // Remove the patient from the list
      });
    } else {
      // Handle non-200 status codes
      String errorMessage = 'Failed to delete family member. Please try again.';
      _showErrorMessage(errorMessage);
    }
  } catch (e) {
    // Handle any errors that occur during the HTTP request
    String errorMessage = 'An error occurred: ${e.toString()}';
    _showErrorMessage(errorMessage);
  }
}

/// Function to show error message in a snackbar
void _showErrorMessage(String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ),
  );
}

}
