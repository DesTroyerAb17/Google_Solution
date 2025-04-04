import 'package:ayusetu/home_page_widgets/bottombar.dart';
import 'package:ayusetu/home_page_widgets/feedpage.dart';
import 'package:ayusetu/home_page_widgets/sideDrawer.dart';
import 'package:ayusetu/home_page_widgets/topbar.dart';
import 'package:ayusetu/screen_pages/consultation_page.dart';

import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  final String userRole; // 👈 Add this

  const MainScreen({super.key, required this.userRole}); // 👈 Make it required

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    FeedPage(),
    ConsultationPage(), // Or AppointmentsPage if doctor
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(),
      drawer: SideDrawer(),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
        role: widget.userRole, // ✅ Pass the role here
      ),
    );
  }
}
