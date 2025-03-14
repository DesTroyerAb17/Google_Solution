import 'package:flutter/material.dart';
import 'login_page.dart'; // Import the login page

class LanguageSelectScreen extends StatefulWidget {
  const LanguageSelectScreen({super.key});

  @override
  _LanguageSelectScreenState createState() => _LanguageSelectScreenState();
}

class _LanguageSelectScreenState extends State<LanguageSelectScreen> {
  List<String> languages = [
    "English", "Hindi", "Bangla", "Odia", "Kannada", "Tamil", "Telugu",
    "Marathi", "Gujarati", "Assamese", "Punjabi", "Malayalam", "Urdu",
    "Bhojpuri", "Sindhi", "Maithili", "Nepali", "Konkani", "Manipuri"
  ];
  
  String? selectedLanguage;
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // White background
      appBar: AppBar(
        title: const Text(
          "Language Selection",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {}); // Rebuild list when searching
              },
              decoration: InputDecoration(
                hintText: "Search your language",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),

          // Scrollable Language List
          Expanded(
            child: ListView.builder(
              itemCount: languages.length,
              itemBuilder: (context, index) {
                String language = languages[index];

                // Filter logic for search functionality
                if (searchController.text.isNotEmpty &&
                    !language.toLowerCase().contains(searchController.text.toLowerCase())) {
                  return const SizedBox(); // Hide items that don't match search
                }

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedLanguage = language;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: selectedLanguage == language
                            ? const Color(0xFF064D99) // Blue border
                            : Colors.transparent, 
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white, // No background color change
                    ),
                    child: Text(
                      language,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: selectedLanguage == language
                            ? const Color(0xFF064D99) // Blue text when selected
                            : Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            ),
          ),

          // Confirm Selection Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: selectedLanguage != null ? () {
                // Navigate to Login Page
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              } : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF8B01), // Orange button
                minimumSize: const Size(364, 54),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Confirm selection",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
