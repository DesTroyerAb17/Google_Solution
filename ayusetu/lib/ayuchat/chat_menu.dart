import 'package:ayusetu/ayuchat/chat_history.dart';
import 'package:ayusetu/globalVariables.dart' show role;
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'bot.dart'; // your chatbot screen
import '../screen_pages/homepage.dart'; // to navigate back to homepage

class ChatMenuPage extends StatefulWidget {
  const ChatMenuPage({super.key});

  @override
  State<ChatMenuPage> createState() => _ChatMenuPageState();
}

class _ChatMenuPageState extends State<ChatMenuPage> {
  final TextEditingController _searchController = TextEditingController();
  Box<ChatHistory>? chatBox;

  List<ChatHistory> _allChats = [];  // Stores all chats
  List<ChatHistory> _filteredChats = []; // Stores filtered chats


  @override
  void initState() {
    super.initState();
    chatBox = Hive.box<ChatHistory>('chat_history');
    _loadChats();
  }

  void _loadChats() {
  final chats = chatBox!.values.toList().reversed.toList();
  setState(() {
    _allChats = chats; 
    _filteredChats = chats; // Initially, show all chats
  });
}

  void _filterChats(String query) {
  setState(() {
    if (query.isEmpty) {
      _filteredChats = _allChats; // Show all chats when query is empty
    } else {
      _filteredChats = _allChats.where((chat) {
        return chat.title.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
  });
}

  void _startNewChat() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ChatBot(resumeChatId: null)),
    );
  }

  void _resumeChat(String chatId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatBot(resumeChatId: chatId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  backgroundColor: Color(0xFFFF8B01),
  centerTitle: true,
  title: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      // ✅ White Circular Background for Logo
      Container(
        width: 40, // Adjust size as needed
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white, // White background
          shape: BoxShape.circle, // Circular shape
        ),
        padding: EdgeInsets.all(6), // Padding inside the circle
        child: Image.asset(
          "assets/image_assets/ayusetu_logo.png",
          fit: BoxFit.contain,
        ),
      ),
      const SizedBox(width: 8), // Space between logo and text
      // ✅ Ayuchat text in Roboto font
      Text(
        'Ayuchat',
        style: TextStyle(
          fontFamily: 'Roboto', // Ensure Roboto is used
          fontSize: 20, // Adjust size if needed
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    ],
  ),
  leading: IconButton(
    icon: const Icon(Icons.arrow_back, color: Colors.white),
    onPressed: () => Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => MainScreen(userRole: role,)),
    ),
  ),
  actions: [
    IconButton(
      icon: Icon(Icons.more_vert, color: Colors.white),
      onPressed: () {
        // Action menu (if needed)
      },
    ),
  ],
),

      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              // 🔍 Search Chat
              TextField(
  controller: _searchController,
  onChanged: _filterChats, // ✅ Calls search function on text change
  decoration: InputDecoration(
    hintText: "Search chat",
    suffixIcon: Icon(Icons.search),
    suffixIconColor: Colors.blueGrey,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(30)),
    ),
  ),
),

              const SizedBox(height: 20),
          
              // 🗂️ "My Chats" with "+" inside an orange circle
          Row(
            children: [
              SizedBox(width: 16), // ✅ Moves "My Chats" slightly to the right
                Text(
                  "My Chats",
                  style: TextStyle(
                      color: Color(0xFFFF8B01),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: _startNewChat,
                    child: Container(
                    width: 32, // ✅ Adjusted size
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white, // ✅ White background
                      shape: BoxShape.circle,
                      border: Border.all(color: Color(0xFFFF8B01), width: 2), // ✅ Orange Border
                    ),
                  child: Center(
                  child: Icon(Icons.add, color: Color(0xFFFF8B01), size: 20), // ✅ Orange "+"
                  ),
                ),
              ),
            SizedBox(width: 16),
            ],
          ),

          const SizedBox(height: 10),
          
              // 📜 List of chats
              Expanded(
  child: ValueListenableBuilder(
    valueListenable: chatBox!.listenable(),
    builder: (context, Box<ChatHistory> box, _) {
      return ListView.builder(
        itemCount: _filteredChats.length, // ✅ Use filtered list
        itemBuilder: (context, index) {
          final chat = _filteredChats[index];
          return ListTile(
            title: Text(
              chat.title,
              style: TextStyle(fontWeight: FontWeight.w500),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Text(
              _formatTimestamp(chat.chatId),
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            onTap: () => _resumeChat(chat.chatId),
          );
        },
      );
    },
  ),
),

            ],
          ),
        ),
      ),
    );
  }
}

/// 📌 Helper function to format timestamp
String _formatTimestamp(String chatId) {
  final timestamp = DateTime.fromMillisecondsSinceEpoch(int.parse(chatId));
  return "${_formatDate(timestamp)}, ${_formatTime(timestamp)}";
}

/// 📌 Helper function to format date (e.g., "Today" or "March 22")
String _formatDate(DateTime date) {
  final now = DateTime.now();
  if (now.year == date.year && now.month == date.month && now.day == date.day) {
    return "Today";
  }
  return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
}

/// 📌 Helper function to format time (e.g., "10:45 AM")
String _formatTime(DateTime date) {
  return "${date.hour}:${date.minute.toString().padLeft(2, '0')} ${date.hour >= 12 ? 'PM' : 'AM'}";
}
