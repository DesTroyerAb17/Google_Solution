import 'package:ayusetu/config/secrets.dart';
import 'package:ayusetu/ayuchat/chat_history.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import 'package:hive_flutter/hive_flutter.dart';


class ChatBot extends StatefulWidget {
  final String? resumeChatId;
  const ChatBot({super.key, this.resumeChatId});

  @override
  _ChatBotState createState() => _ChatBotState();}

class _ChatBotState extends State<ChatBot> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  final String apiKey = Secrets.geminiApiKey;

  late final GenerativeModel _model = GenerativeModel(
    model: 'gemini-1.5-flash-latest',
    apiKey: apiKey,
  );

  late String chatId ;
  Box<ChatHistory>? chatBox;

  @override
void initState() {
  super.initState();
  initializeChat();
}

Future<void> initializeChat() async {
  chatBox = await Hive.openBox<ChatHistory>('chat_history');
  chatId = widget.resumeChatId ?? DateTime.now().millisecondsSinceEpoch.toString();

  if (chatBox!.containsKey(chatId)) {
    final storedChat = chatBox!.get(chatId);
    if (storedChat != null) {
      _messages.clear();
      _messages.addAll(storedChat.messages);
    }
  }

  setState(() {}); // trigger UI build
}


  // ✅ Load previous chat messages if user selects a previous chat
  void loadChatHistory() async {
    if (chatBox!.containsKey(chatId)) {
      final storedChat = chatBox!.get(chatId)!;
      setState(() {
        _messages.clear();
        _messages.addAll(storedChat.messages);
      });
    }
  }

  // ✅ Function to send messages and save chat history
  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    setState(() {
      _messages.add({"user": message, "bot": "Typing..."});
    });

    try {
      final systemPrompt = """
      You are Ayuchat, a professional and safe medical assistant. Your job is to provide reliable, easy-to-understand, and medically accurate information related to:

- Diseases, symptoms, diagnoses
- Medicine suggestions (non-prescription, general advice only)
- Nutrition, wellness, mental health
- First aid and home care tips

✅ If a user asks for medication, you may:
- Suggest general **OTC (over-the-counter)** medicines if they are commonly used
- Recommend **consulting a doctor** before taking any prescription medication
- Clearly state that you are **not a licensed medical practitioner**

❌ You must not prescribe medicine directly or recommend dosage unless it's general/common (e.g., paracetamol for fever).

Always prioritize safety. If the user's request is dangerous, too specific, or requires a prescription, respond with:
"I'm here to help, but it's best to consult a qualified doctor before taking any medication."

Stay friendly, focused, and helpful."
Example:

User: I have a sore throat, what medicine can I take?
Bot: You may consider warm water gargles and lozenges. For general relief, OTC options like paracetamol or ibuprofen may help. Always consult a doctor if symptoms persist.

User: What should I take for acidity?
Bot: For common acidity or heartburn, antacids like ranitidine or omeprazole may help. Please consult a healthcare provider for ongoing issues.

      However, if a user greets you or initiates small talk with messages like "hello", "how are you?", or "what do you do?", you may respond politely and warmly — and then gently encourage them to ask about a health topic.
      For example:
      User: "Hello, how are you?"
      Bot: "Hello! I'm doing well and ready to help. Feel free to ask me anything related to your health or well-being."
      You should maintain a friendly but focused tone, encouraging users to ask health-specific questions while allowing a brief introductory interaction.
      """ ;
bool isAskingForMedicine(String message) {
  final lower = message.toLowerCase();
  return lower.contains("medicine") || lower.contains("tablet") || lower.contains("pill") || lower.contains("drug");
}

// Then in sendMessage:

      final content = [
        Content.text(systemPrompt),
        if (isAskingForMedicine(message))
    Content.text("Reminder: Be clear and cautious when suggesting any medicines."),
        Content.text("User: $message"),
      ];

      final response = await _model.generateContent(content);

      setState(() {
        _messages.last["bot"] = response.text?.trim().isNotEmpty ?? false
            ? response.text!
            : "⚠️ I couldn't process that. Please ask about health topics.";
      });

      saveChatHistory();
    } catch (e) {
      setState(() {
        _messages.last["bot"] = "❌ Error: Unable to connect to AI.";
      });
    }
  }

  // ✅ Save chat history in Hive
 Future<void> saveChatHistory() async {
  String generatedTitle = "Untitled Chat";

  // If resuming, keep the existing title
  if (chatBox!.containsKey(chatId)) {
    final chatSession = ChatHistory(
      chatId: chatId,
      title: chatBox!.get(chatId)?.title ?? generatedTitle,
      messages: List.from(_messages),
    );
    await chatBox!.put(chatId, chatSession);
    return;
  }

  // ✅ Use first 4–5 messages (user + bot)
  final introMessages = _messages.take(5).map((msg) {
    return "User: ${msg['user']}\nBot: ${msg['bot']}";
  }).join("\n");

  try {
    final titleResponse = await _model.generateContent([
      Content.text(
        "Based on the following short conversation between a user and a medical assistant, create a short and clear 3 to 5 word title that summarizes the topic. Do NOT include punctuation:\n\n$introMessages"
      ),
    ]);

    final result = titleResponse.text?.trim();

    if (result != null && result.isNotEmpty) {
      generatedTitle = result;
    } else {
      generatedTitle = "Health Chat";
    }

    print("📌 Gemini-generated title: $generatedTitle");
  } catch (e) {
    print("⚠️ Error generating title: $e");
  }

  final chatSession = ChatHistory(
    chatId: chatId,
    title: generatedTitle,
    messages: List.from(_messages),
  );

  await chatBox!.put(chatId, chatSession);
}



  // ✅ Start a new chat
  void startNewChat() {
    setState(() {
      chatId = DateTime.now().millisecondsSinceEpoch.toString();
      _messages.clear();
    });
  }

  // ✅ Resume a previous chat
  void resumeChat(String selectedChatId) {
    setState(() {
      chatId = selectedChatId;
      _messages.clear();
      loadChatHistory();
    });
    Navigator.pop(context); // Close drawer after selecting chat
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
      Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        padding: EdgeInsets.all(6),
        child: Image.asset(
          "assets/image_assets/ayusetu_logo.png",
          fit: BoxFit.contain,
        ),
      ),
      const SizedBox(width: 8),
      Text(
        'Ayuchat',
        style: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    ],
  ),
  leading: IconButton(
    icon: const Icon(Icons.arrow_back, color: Colors.white),
    onPressed: () => Navigator.pop(context), // ✅ Go back to ChatMenuPage
  ),
  actions: [
    IconButton(
      icon: Icon(Icons.more_vert, color: Colors.white),
      onPressed: () {
        // future menu options
      },
    ),
  ],
),

      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(msg["user"]!, style: const TextStyle(color: Colors.white)),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(msg["bot"]!, style: const TextStyle(color: Colors.black)),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Padding(
  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
  child: Row(
    children: [
      // 📎 Attachment Icon
      IconButton(
        icon: Icon(Icons.attach_file, color: Colors.grey),
        onPressed: () {
          // Handle file attachment
        },
      ),

      // 📝 Message Input Field with Send Icon as Hint
      Expanded(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[100], // Light grey background
            borderRadius: BorderRadius.circular(30), // Rounded border
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: TextField(
              controller: _controller,
              textInputAction: TextInputAction.send, // Enables send functionality with keyboard
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  sendMessage(value);
                  _controller.clear();
                }
              },
              decoration: InputDecoration(
                hintText: "Write message", // ✈️ Send icon inside hint text
                hintStyle: TextStyle(color: Colors.grey[500]),
                border: InputBorder.none, // Removes default border
              ),
            ),
          ),
        ),
      ),

      // 🎙️ Microphone Icon for Voice Input
      IconButton(
        icon: Icon(Icons.mic, color: Colors.grey),
        onPressed: () {
          // Handle voice input
        },
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
class ChatBotButton extends StatelessWidget {
  const ChatBotButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.blueAccent,
      child: const Icon(Icons.chat, color: Colors.white),
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ChatBot()),
      ),
    );
  }
}