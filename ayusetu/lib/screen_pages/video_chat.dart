import 'package:ayusetu/screen_pages/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';  // Import flutter_svg package to use for SVG files

class VideoCallPage extends StatelessWidget {
  const VideoCallPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: Scaffold(
        body: Stack(
          children: [
            // Full-screen video of the doctor (this will be the main view)
            Positioned.fill(
              child: Container(
                color: Colors.white,
                child: SvgPicture.asset(
                  'assets/image_assets/ayusetu logo.png',  // Correct path to the doctor image
                  fit: BoxFit.cover,
                  placeholderBuilder: (BuildContext context) => Center(child: CircularProgressIndicator()),
                  // In case the SVG file is invalid or not loaded, a loading spinner will appear
                ),
              ),
            ),

            // Small image at the bottom right (Patient's video feed in the corner)
            Positioned(
              bottom: 50,
              right: 20,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),  // Rounded corner for the image
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: SvgPicture.asset(
                    'assets/image_assets/patient.svg',  // Correct path for the patient's image
                    fit: BoxFit.cover,
                    placeholderBuilder: (BuildContext context) => Center(child: CircularProgressIndicator()),
                  ),
                ),
              ),
            ),

            // Top Bar with Time (as per the screenshot)
            Positioned(
              top: 50,
              left: 50,
              child: Text(
                '12:38',  // Displaying the time
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Bottom Section for "Consultation in Progress" text and End Call button
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  // Text to indicate consultation status
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Text(
                      'Consultation in progress',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 15, 14, 14),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  // End Call button
                  GestureDetector(
                    onTap: () {
                      // Logic for ending the call and navigating back to HomePage
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => MainScreen()), // Navigate to HomePage
                      );
                    },
                    child: Container(
                      width: 200,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          'End Call',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
