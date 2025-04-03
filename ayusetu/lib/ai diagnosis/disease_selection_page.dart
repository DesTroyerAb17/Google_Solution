import 'package:ayusetu/ai%20diagnosis/diagnosis_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DiseaseSelectionPage extends StatelessWidget {
  const DiseaseSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFF8B01),
        title: Text('Select Diagnosis'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => _navigateToDiagnosisPage(context, "Pneumonia", "https://pneumoniaclassifier-i4md.onrender.com/predict"),
              child: _diseaseOption("Pneumonia", "assets/icons/pneumonia.svg"),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () => _navigateToDiagnosisPage(context, "Skin Cancer", "https://your-render-model-url.com/skin_cancer"),
              child: _diseaseOption("Skin Cancer", "assets/icons/skin_cancer.svg"),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () => _navigateToDiagnosisPage(context, "Lung Cancer", "https://oralapi.onrender.com/predict"),
              child: _diseaseOption("Lung Cancer", "assets/icons/lung_cancer.svg"),
            ),
          ],
        ),
      ),
    );
  }

  // Navigate to diagnosis page with dynamic parameters
  void _navigateToDiagnosisPage(BuildContext context, String diseaseName, String modelUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DiagnosisPage(diseaseName: diseaseName, modelUrl: modelUrl),
      ),
    );
  }

  // Disease option card
  Widget _diseaseOption(String name, String iconPath) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFFFF5EB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          SvgPicture.asset(iconPath, width: 40, height: 40),
          SizedBox(width: 16),
          Text(name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
