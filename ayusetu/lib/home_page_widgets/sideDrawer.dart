// SIDE DRAWER
import 'package:ayusetu/drawer%20pages/addpatient.dart';
import 'package:ayusetu/drawer%20pages/health_page.dart';
import 'package:ayusetu/globalVariables.dart';
import 'package:ayusetu/introductory_screens/logo_page.dart';
import 'package:ayusetu/models/Myfamilypage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SideDrawer extends StatelessWidget {
  const SideDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.75,
      backgroundColor: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Header
          Padding(
            padding: const EdgeInsets.only(top: 40, left: 16, right: 16, bottom: 10),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 28,
                  backgroundImage: AssetImage('assets/image_assets/3d_avatar_21.png'),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      username,
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        print("Profile settings clicked!");
                      },
                      child: Text(
                        "Profile setting >",
                        style: GoogleFonts.roboto(fontSize: 14, color: const Color(0xFFFF8B01)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Divider(),

          // Show only if role is patient
          if (role == "user") ...[
            _drawerItem(Icons.group, "Add Patients", () => _navigateTo(context, AddPatientPage()), trailing: Icons.add),
            _drawerItem(Icons.family_restroom, "My Family", () => _navigateTo(context, MyFamilyPage()), trailing: Icons.chevron_right),
            _drawerItem(Icons.file_copy, "My Reports", () {}, trailing: Icons.chevron_right),
          ],

          _drawerItem(Icons.calendar_today, "My Appointments", () {}, trailing: Icons.chevron_right),
          _drawerItem(Icons.library_books, "Health Blog", () => _navigateTo(context, HealthBlogPage()), trailing: Icons.chevron_right),

          const Divider(),

          _drawerItem(Icons.payment, "Payment method", () {}, trailing: Icons.chevron_right),
          _drawerItem(Icons.settings, "Settings", () {}, trailing: Icons.chevron_right),
          _drawerItem(Icons.help_outline, "Help Center", () {}, trailing: Icons.chevron_right),

          const SizedBox(height: 20),
          const Divider(),

          // Logout
          _drawerItem(
            Icons.power_settings_new,
            "Logout",
            () {
              // Reset global variables
              verification_token = "";
              username = "";
              phoneNumber = "";
              verification_id = "";
              role = "";
              familymembers.clear();
              globalPatients.clear();
              globalDiagnosisHistory.clear();

              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LogoPage()),
                (route) => false,
              );
            },
            color: Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title, VoidCallback onTap,
      {Color color = Colors.black, IconData? trailing}) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: GoogleFonts.roboto(fontSize: 14, color: color)),
      trailing: trailing != null ? Icon(trailing, color: Colors.grey.shade600, size: 20) : null,
      onTap: onTap,
    );
  }

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
  }
}
