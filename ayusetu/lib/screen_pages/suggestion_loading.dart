import 'package:ayusetu/screen_pages/suggestion_result.dart';
import 'package:flutter/material.dart';

// void main() {
//   runApp(const SuggestionLoading());
// }

class SuggestionLoading extends StatelessWidget {
  const SuggestionLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF064C99), // Blue color
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 16,
            color: Colors.black,
          ),
        ),
      ),
      home: const LoadingScreen(),
    );
  }
}

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>  SuggestionResult()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon (Doctor's icon)
            const Icon(
              Icons.medical_services,
              size: 100,
              color: Color(0xFF064C99), // Blue color for icon
            ),
            const SizedBox(height: 30),
            // Main text
            const Text(
              'AI suggesting specialists for you',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF8B01), // Orange color for text
              ),
            ),
            const SizedBox(height: 10),
            // Subtext
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.0),
              child: Text(
                'Kindly wait for a sometime, while we understand what your problems are to suggest you the best consultation results',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
