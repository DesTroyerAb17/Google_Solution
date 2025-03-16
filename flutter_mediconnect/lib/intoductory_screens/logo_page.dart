import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_mediconnect/intoductory_screens/language_select_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LogoPage extends StatefulWidget {
  const LogoPage({super.key});

  @override
  _LogoPageState createState() => _LogoPageState();
}

class _LogoPageState extends State<LogoPage> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>  LanguageSelectScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              'assets/image_assets/ayusetu.svg',  // SVG Logo
              width: 205,
            ),
            const SizedBox(height: 10),
            const Text(
              "Connecting for better healthcare",
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Color(0xFFE67E22), // Orange color for tagline
              ),
            ),
          ],
        ),
      ),
    );
  }
}
