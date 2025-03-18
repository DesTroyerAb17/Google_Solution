import 'package:flutter/material.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false; // ❌ Prevents back button navigation
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("Home")),
        body: const Center(child: Text("Welcome to HomePage!")),
      ),
    );
  }
}
