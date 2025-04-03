import 'dart:convert';
import 'package:ayusetu/globalVariables.dart';
import 'package:ayusetu/screen_pages/suggestion_loading.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ConsultationPage extends StatefulWidget {
  const ConsultationPage({super.key});

  @override
  State<ConsultationPage> createState() => _ConsultationPageState();
}

class _ConsultationPageState extends State<ConsultationPage> {
  String? selectedPatientId;
  TextEditingController additionalDescriptionController = TextEditingController();

  List<Map<String, String>> familymembers = [];

  final Map<String, List<String>> symptomCategories = {
    'general symptoms': [
      'Fever or chills',
      'Fatigue or weakness',
      'Sudden weight loss or gain',
      'Loss of appetite',
      'Night sweats',
      'Body aches or joint pain',
      'Swelling in any part of the body',
    ],
    'respiratory symptoms': [
      'Persistent cough (more than 2 weeks)',
      'Shortness of breath',
      'Wheezing or noisy breathing',
      'Chest pain while breathing or coughing',
      'Coughing up blood',
      'Runny or stuffy nose',
      'Frequent sore throat',
    ],
    'stomach symptoms': ['Nausea', 'Vomiting', 'Abdominal pain'],
    'neurological symptoms': ['Headache', 'Dizziness', 'Seizures'],
    'cardiac & circulatory symptoms': ['Chest pain', 'Heart palpitations', 'Fatigue'],
    'skin & hair symptoms': ['Rashes', 'Itching', 'Dry skin'],
    'urinary & reproductive symptoms': ['Painful urination', 'Frequent urination'],
    'muscle & bone symptoms': ['Muscle pain', 'Joint pain'],
    'emotional symptoms': ['Anxiety', 'Depression'],
    'ENT symptoms': ['Sore throat', 'Ear pain'],
    'metabolic symptoms': ['Excessive thirst', 'Frequent urination'],
  };

  final Map<String, String?> selectedSymptoms = {};

  @override
  void initState() {
    super.initState();
    _getFamilyMembers();
  }

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
        setState(() {
          familymembers.clear();
          for (var member in data) {
            familymembers.add({
              'id': member['_id'] ?? 'Unknown',
              'name': member['name'] ?? 'Unknown',
              'gender': member['gender'] ?? 'Unknown',
              'dateOfBirth': member['dateOfBirth'] ?? 'N/A',
              'height': member['height']?.toString() ?? '0',
              'weight': member['weight']?.toString() ?? '0',
              'bloodGroup': member['bloodGroup'] ?? 'Unknown',
            });
          }
        });
      } else {
        throw Exception("Failed to load family members");
      }
    } catch (e) {
      print("Error fetching family members: $e");
    }
  }

  bool isFormValid() {
    if (selectedPatientId == null) return false;
    return selectedSymptoms.values.any((value) => value != null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Book Consultation"),
        backgroundColor: Colors.white,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                value: selectedPatientId,
                decoration: const InputDecoration(
                  labelText: "Select patient",
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(color: Colors.black, fontSize: 16),
                iconEnabledColor: Colors.black,
                items: familymembers.map((member) {
                  return DropdownMenuItem<String>(
                    value: member['id'],
                    child: Text(
                      member['name'] ?? 'Unknown',
                      style: const TextStyle(color: Colors.black),
                    ),
                  );
                }).toList(),
                onChanged: (val) => setState(() => selectedPatientId = val),
              ),
              const SizedBox(height: 16),

              // Symptom Sections
              ...symptomCategories.entries.map((entry) {
                final category = entry.key;
                final symptoms = entry.value;
                final selected = selectedSymptoms[category];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Theme(
                      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                        title: Text(
                          "Select $category",
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        children: symptoms.map((symptom) {
                          return RadioListTile<String>(
                            title: Text(symptom, style: const TextStyle(color: Colors.black)),
                            value: symptom,
                            groupValue: selected,
                            activeColor: Colors.black,
                            onChanged: (value) {
                              setState(() {
                                selectedSymptoms[category] = value;
                              });
                            },
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                );
              }).toList(),

              const Text(
                "Additional description",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: additionalDescriptionController,
                maxLines: 4,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  hintText: "Type any additional information, symptoms, feeling",
                  hintStyle: TextStyle(color: Colors.black54),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isFormValid()
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const SuggestionLoading()),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isFormValid() ? const Color(0xFFFF8B01) : Colors.grey,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Suggest Consultation",
                    style: TextStyle(fontSize: 16, color: Colors.white),
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
