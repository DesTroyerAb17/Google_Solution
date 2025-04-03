import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ayusetu/globalVariables.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ayusetu/ai%20diagnosis/diagnosis_result_page.dart';

class DiagnosisPage extends StatefulWidget {
  final String diseaseName;
  final String modelUrl;

  const DiagnosisPage({super.key, required this.diseaseName, required this.modelUrl});

  @override
  _DiagnosisPageState createState() => _DiagnosisPageState();
}

class _DiagnosisPageState extends State<DiagnosisPage> {
  File? _image;
  final picker = ImagePicker();
  bool _isLoading = false;
  String? _selectedPatient;
  final TextEditingController _descriptionController = TextEditingController();
  bool _isImageSelected = false;

  List<Map<String, String>> familymembers = [];
  Set<String> _selectedSymptomList = {};

  final Map<String, List<String>> diseaseSymptoms = {
    'Oral Cancer': [
      'Persistent mouth sores',
      'Red or white patches in the mouth',
      'Lumps or thickening',
      'Pain or discomfort',
      'Difficulty chewing or swallowing',
      'Loose teeth',
      'Chronic bad breath',
      'Change in voice',
      'Bleeding in the mouth',
      'Jaw pain or stiffness',
    ],
    'Skin Cancer': [
      'New mole or skin growth',
      'Changes to existing mole',
      'Itching or bleeding mole',
      'Painful skin lesion',
      'Red or irritated skin around mole',
      'Sores that don\'t heal',
      'Changes in skin color or texture',
    ],
    'Pneumonia': [
      'Continuous coughing',
      'Mucous',
      'Fever and chills',
      'Shortness of breath',
      'Chest pain',
      'Fatigue and weakness',
    ],
  };

  List<String> symptoms = [];

  @override
  void initState() {
    super.initState();
    symptoms = diseaseSymptoms[widget.diseaseName] ?? [];
    _fetchFamilyMembers();
  }

  Future<void> _fetchFamilyMembers() async {
    final response = await http.get(
      Uri.parse('$base_url/api/users/family-members'),
      headers: {
        'Authorization': 'Bearer $verification_token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        familymembers = data.map((member) {
          return {
            'id': member['_id'] as String? ?? 'Unknown',
            'name': member['name'] as String? ?? 'Unknown',
          };
        }).toList();
      });
    } else {
      throw Exception("Failed to load family members");
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _isImageSelected = true;
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_image == null || _selectedSymptomList.isEmpty || _selectedPatient == null || _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please complete all fields!')));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final uri = Uri.parse(widget.modelUrl);
    final request = http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath('image', _image!.path));
    request.fields['symptoms'] = _selectedSymptomList.join(', ');
    request.fields['description'] = _descriptionController.text;

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        final result = await response.stream.bytesToString();
        final decodedResponse = jsonDecode(result);
        Map<String, String>? selectedPatientDetails = familymembers.firstWhere(
          (member) => member['name'] == _selectedPatient,
          orElse: () => {},
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DiagnosisResultPage(
              isDetected: decodedResponse['prediction'] == 'lung cancer',
              confidence: double.tryParse(decodedResponse['confidence'].toString()) ?? 0.0,
              diseaseName: widget.diseaseName,
              patientDetails: selectedPatientDetails,
            ),
          ),
        );
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to get prediction, please try again.')));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _customCircleIndicator(bool isSelected) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.black, // 🔁 changed to black
          width: 2,
        ),
      ),
      child: isSelected
          ? Center(
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black, // 🔁 black filled dot
                ),
              ),
            )
          : SizedBox.shrink(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          '${widget.diseaseName} Diagnosis',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  color: Color(0xFFFFF3E5),
                  padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                  child: Text(
                    "AI disease diagnosis powered by AyuSetu (Name of any important AI model being used)",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF064D99)),
                  ),
                ),
                SizedBox(height: 12),

                // Patient dropdown
                DropdownButtonFormField<String>(
                  value: _selectedPatient,
                  hint: Text("Select patient"),
                  icon: Icon(Icons.arrow_drop_down),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  ),
                  items: familymembers.map((patient) {
                    return DropdownMenuItem<String>(
                      value: patient['name'],
                      child: Text(patient['name']!),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedPatient = value;
                    });
                  },
                ),
                SizedBox(height: 16),

                // Radio-style multi-select symptoms (black)
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Select general symptoms", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      ...symptoms.map((symptom) {
                        final isSelected = _selectedSymptomList.contains(symptom);
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                _selectedSymptomList.remove(symptom);
                              } else {
                                _selectedSymptomList.add(symptom);
                              }
                            });
                          },
                          leading: _customCircleIndicator(isSelected),
                          title: Text(symptom),
                        );
                      }).toList(),
                    ],
                  ),
                ),
                SizedBox(height: 16),

                Align(
                  alignment: Alignment.topLeft,
                  child: Text("Additional description", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    hintText: "Type any additional information, symptoms, feeling",
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                SizedBox(height: 16),

                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: Icon(Icons.upload_file),
                  label: Text("Upload supporting images"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade300,
                    foregroundColor: Colors.black,
                    minimumSize: Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    _isImageSelected ? "Image uploaded successfully!" : "Affected area image , X-rays , USG images",
                    style: TextStyle(
                      color: _isImageSelected ? Colors.green : Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ),

                SizedBox(height: 24),
                _isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _uploadImage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFFF8B01),
                          minimumSize: Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text(
                          'Done',
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
