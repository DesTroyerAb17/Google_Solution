// TOPBAR.dart
import 'package:ayusetu/feedpage/postcreation.dart';
import 'package:ayusetu/globalVariables.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF064D99),
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          Builder(
            builder: (BuildContext context) {
              return GestureDetector(
                onTap: () {
                  Scaffold.of(context).openDrawer(); // ✅ Open drawer for both roles
                },
                child: const CircleAvatar(
                  radius: 18,
                  backgroundImage: AssetImage('assets/image_assets/3d_avatar_21.png'),
                ),
              );
            },
          ),
          const SizedBox(width: 25),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreatePostPage()),
                );
              },
              child: AbsorbPointer(
                child: TextField(
                  readOnly: true,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 15),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Post your medical experience',
                    hintStyle: GoogleFonts.roboto(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFFB8C1CC),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white, size: 28),
            onPressed: () {
              print("Notification Icon Clicked!");
            },
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
