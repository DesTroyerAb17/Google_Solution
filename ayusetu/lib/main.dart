import 'package:ayusetu/introductory_screens/logo_page.dart';
import 'package:ayusetu/ayuchat/chat_history.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // ✅ Initialize Hive
    await Hive.initFlutter();
    Hive.registerAdapter(ChatHistoryAdapter()); // ✅ Register adapter
    await Hive.openBox<ChatHistory>('chat_history'); // ✅ Open chat history box

    runApp(const MainApp());
  } catch (e) {
    runApp(MaterialApp(
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
      ),
      home: Scaffold(
        body: Center(
          child: Text('Error: ${e.toString()}'),
        ),
      ),
    ));
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        textTheme: ThemeData.light().textTheme.apply(
              bodyColor: Colors.black,
              displayColor: Colors.black,
            ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      home: const LogoPage(),
    );
  }
}
