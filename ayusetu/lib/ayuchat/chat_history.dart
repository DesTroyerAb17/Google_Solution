import 'package:hive/hive.dart';

part 'chat_history.g.dart';

@HiveType(typeId: 0)
class ChatHistory extends HiveObject {
  @HiveField(0)
  String chatId;

  @HiveField(1)
  String title; // ✅ Topmost chat message as title

  @HiveField(2)
  List<Map<String, String>> messages;

  ChatHistory({
    required this.chatId,
    required this.title,
    required this.messages,
  });
}
