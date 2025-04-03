import 'package:ayusetu/globalVariables.dart';

class Post {
  final String id;
  final String authorName;
  final String authorPhoneNumber;
  final String content;
  final String caption;
  final String imageUrl;
  final DateTime createdAt;
  final List<Comment> comments;

  Post({
    required this.id,
    required this.authorName,
    required this.authorPhoneNumber,
    required this.content,
    required this.caption,
    required this.imageUrl,
    required this.createdAt,
    required this.comments,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    var commentJson = json['comments'] as List<dynamic>? ?? [];
    List<Comment> commentList = commentJson.map((comment) => Comment.fromJson(comment)).toList();

    // ✅ Handle image URL logic
    String rawImageUrl = json['imageUrl'] ?? '';
    String finalImageUrl = rawImageUrl.startsWith('/uploads/')
        ? '$base_url$rawImageUrl'
        : rawImageUrl;

    return Post(
      id: json['_id'] ?? '',
      authorName: json['author']?['name'] ?? 'Unknown',
      authorPhoneNumber: json['author']?['phoneNumber'] ?? '',
      caption: json['caption'] ?? '',
      content: json['content'] ?? '',
      imageUrl: finalImageUrl,
      createdAt: DateTime.parse(json['createdAt']),
      comments: commentList,
    );
  }
}

class Comment {
  final String userName;
  final String userProfilePic;
  final String commentText;

  Comment({
    required this.userName,
    required this.userProfilePic,
    required this.commentText,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      userName: json['user']?['name']?.toString() ?? 'Anonymous',
      userProfilePic: json['user']?['profilePic']?.toString() ?? '',
      commentText: json['text']?.toString() ?? '',
    );
  }
}
