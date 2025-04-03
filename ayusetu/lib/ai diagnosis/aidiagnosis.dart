import 'package:flutter/material.dart';
import 'package:ayusetu/globalVariables.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ayusetu/ai%20diagnosis/diagnosis_page.dart'; // Ensure the import path is correct // Import the disease selection page

class AiDiagnosisHistoryPage extends StatefulWidget {
  const AiDiagnosisHistoryPage({super.key});

  @override
  _AiDiagnosisHistoryPageState createState() => _AiDiagnosisHistoryPageState();
}

class _AiDiagnosisHistoryPageState extends State<AiDiagnosisHistoryPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> _filteredDiagnoses = [];

  // A map to store the disease name and its respective model URL
  final Map<String, String> diseaseUrls = {
    "Lung Cancer": "https://oralapi.onrender.com/predict",
    "Oral Cancer": "https://oralapi.onrender.com/predict",
    "Pneumonia": "https://pneumoniaclassifier-i4md.onrender.com/predict",
  };

  @override
  void initState() {
    super.initState();
    _filteredDiagnoses = globalDiagnosisHistory; // Initialize the diagnosis list
    _searchController.addListener(_filterDiagnoses);
  }

  void _filterDiagnoses() {
    setState(() {
      String query = _searchController.text.toLowerCase();
      _filteredDiagnoses = globalDiagnosisHistory
          .where((diagnosis) => diagnosis['diagnosis']!.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFFFF8B01),
        elevation: 0,
        title: Text(
          "AI Diagnosis History",
          style: GoogleFonts.roboto(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          _searchBar(),
          _diagnosisList(),
        ],
      ),
      floatingActionButton: _newDiagnosisButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  // **Search Bar**
  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          hintText: "Search your diagnoses",
          hintStyle: GoogleFonts.roboto(fontSize: 14, color: Colors.grey.shade500),
          filled: true,
          fillColor: Colors.white,
          prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.orange, width: 2),
          ),
        ),
      ),
    );
  }

  // **Diagnosis List**
  Widget _diagnosisList() {
    return Expanded(
      child: _filteredDiagnoses.isEmpty
          ? Center(child: Text("No results found", style: GoogleFonts.roboto(fontSize: 16, color: Colors.grey)))
          : ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filteredDiagnoses.length,
              itemBuilder: (context, index) {
                final diagnosis = _filteredDiagnoses[index];
                return _diagnosisCard(diagnosis);
              },
            ),
    );
  }

  // **Diagnosis Card**
  Widget _diagnosisCard(Map<String, String> diagnosis) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 6),
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: EdgeInsets.all(12),
        leading: SvgPicture.asset(
          diagnosis['icon']!,
          width: 48,
          height: 48,
          placeholderBuilder: (context) => CircularProgressIndicator(),
        ),
        title: Text(
          diagnosis['diagnosis']!,
          style: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          "${diagnosis['date']} | ${diagnosis['patient']}",
          style: GoogleFonts.roboto(fontSize: 14, color: Colors.grey.shade600),
        ),
        trailing: Icon(Icons.chevron_right, color: Colors.grey.shade500),
        onTap: () {
          print("Clicked on ${diagnosis['diagnosis']}");
        },
      ),
    );
  }

  // **New Diagnosis Button**
  Widget _newDiagnosisButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => _showDiseaseSelectionSheet(context), // Trigger disease selection
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFFF8B01),
            padding: EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: Text(
            "New Diagnosis",
            style: GoogleFonts.roboto(
                fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
          ),
        ),
      ),
    );
  }

  // **Show Disease Selection Bottom Sheet**
  void _showDiseaseSelectionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return _diseaseSelectionContent();
      },
    );
  }

  // **Disease Selection Content**
  Widget _diseaseSelectionContent() {
    List<Map<String, String>> diseases = [
      {"name": "Lung Cancer", "icon": "assets/image_assets/lung_cancer.svg"},
      {"name": "Oral Cancer", "icon": "assets/image_assets/oral_cancer.svg"},
      {"name": "Pneumonia", "icon": "assets/image_assets/pneumonia.svg"},
    ];

    String? selectedDisease;

    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Disease selection",
                    style: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: diseases.map((disease) {
                  bool isSelected = selectedDisease == disease["name"];
                  return GestureDetector(
                    onTap: () {
                      setState(() => selectedDisease = disease["name"]);
                    },
                    child: _diseaseOption(
                      name: disease["name"]!,
                      iconPath: disease["icon"]!,
                      isSelected: isSelected,
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: selectedDisease != null
                      ? () {
                          print("Starting Diagnosis for $selectedDisease");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DiagnosisPage(
                                diseaseName: selectedDisease!,
                                modelUrl: diseaseUrls[selectedDisease!]!,
                              ),
                            ),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedDisease != null ? Color(0xFFFF8B01) : Colors.grey,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text(
                    "Start Diagnosis",
                    style: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // **Disease Selection Option**
  Widget _diseaseOption({required String name, required String iconPath, required bool isSelected}) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Color(0xFFFFF5EB),
        borderRadius: BorderRadius.circular(12),
        border: isSelected ? Border.all(color: Color(0xFF064D99), width: 2) : null,
      ),
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(iconPath, width: 40, height: 40),
                SizedBox(height: 6),
                Text(
                  name,
                  style: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF064D99)),
                ),
              ],
            ),
          ),
          if (isSelected)
            Positioned(
              top: 6,
              right: 6,
              child: Icon(Icons.check_circle, color: Color(0xFF064D99), size: 20),
            ),
        ],
      ),
    );
  }
}
