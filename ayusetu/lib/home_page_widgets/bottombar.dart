import 'package:ayusetu/ai%20diagnosis/aidiagnosis.dart';
import 'package:ayusetu/screen_pages/consultation_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // SVG support
import 'package:google_fonts/google_fonts.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: CircularNotchedRectangle(), // Creates a notch for AI button
      color: Colors.white, // Background color
      elevation: 5, // Subtle shadow effect
      notchMargin: 6, // Increases notch space
      child: SizedBox(
        height: 60, // Ensures enough space for bottom bar items
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround, // Even spacing
          children: [
            _navItem(
              icon: Icons.home,
              label: 'Feed',
              isSelected: selectedIndex == 0,
              onTap: () => onItemTapped(0),
            ),
            _navItem(
              assetImagePath: 'assets/image_assets/consult.svg',
              label: 'Consult',
              isSelected: selectedIndex == 1,
              onTap: () {
              Navigator.push(
                context,
               MaterialPageRoute(builder: (context) => ConsultationPage()),
                );
              },
            ),
            _aiDiagnosisButton(context),
          ],
        ),
      ),
    );
  }

  /// Common Navigation Item - Now supports Icon or SVG image
  Widget _navItem({
    IconData? icon,
    String? assetImagePath,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          assetImagePath != null
              ? SvgPicture.asset(
                  assetImagePath,
                  width: 32,
                  height: 32,
                  colorFilter: ColorFilter.mode(
                    isSelected ? Color(0xFF064D99) : Colors.grey,
                    BlendMode.srcIn,
                  ),
                )
              : Icon(
                  icon,
                  size: 32,
                  color: isSelected ? Color(0xFF064D99) : Colors.grey,
                ),
          SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.roboto(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isSelected ? Color(0xFF064D99) : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  /// AI Diagnosis Button - Perfect 175x54 Alignment
  Widget _aiDiagnosisButton(BuildContext context) {
    return SizedBox(
      width: 175,
      height: 54,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AiDiagnosisHistoryPage()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFFFF5EB),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Color(0xFF064D99), width: 2),
          ),
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_box, color: Color(0xFF064D99), size: 24),
            SizedBox(width: 8),
            Text(
              "AI Diagnosis",
              style: GoogleFonts.roboto(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF064D99),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
