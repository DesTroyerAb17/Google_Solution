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

    runApp(MainApp());
  } catch (e) {
    runApp(MaterialApp(
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
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LogoPage(),
    );
  }
}
