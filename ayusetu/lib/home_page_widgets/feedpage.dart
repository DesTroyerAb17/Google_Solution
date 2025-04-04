import 'dart:convert';
import 'package:ayusetu/feedpage/discussion_page.dart';
import 'package:ayusetu/globalVariables.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:ayusetu/models/mypost.dart';
import 'package:ayusetu/ayuchat/chat_menu.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  List<Post> posts = [];
  bool isLoading = true;

  double posX = 250;
  double posY = 500;

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    print("Fetching posts...");
    try {
      final response = await http.get(Uri.parse('$base_url/api/posts'));

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        print("Decoded list length: ${data.length}");

        setState(() {
          posts = data.map((post) => Post.fromJson(post)).toList();
          isLoading = false;
        });
      } else {
        print("Failed to fetch posts. Status: ${response.statusCode}");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e, stack) {
      print('Error fetching posts: $e');
      print('StackTrace: $stack');
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _buildRichText(String content) {
    List<TextSpan> textSpans = _parseContent(content);
    return RichText(
      text: TextSpan(
        style: GoogleFonts.roboto(fontSize: 14, color: Colors.black87),
        children: textSpans,
      ),
    );
  }

  List<TextSpan> _parseContent(String content) {
    List<TextSpan> textSpans = [];
    final regex = RegExp(r'(\*\*[^*]+\*\*|\*[^*]+\*)');
    final matches = regex.allMatches(content);

    int lastMatchEnd = 0;

    for (final match in matches) {
      if (match.start > lastMatchEnd) {
        textSpans.add(TextSpan(text: content.substring(lastMatchEnd, match.start)));
      }

      final matchedText = match.group(0)!;

      if (matchedText.startsWith('**')) {
        textSpans.add(TextSpan(
          text: matchedText.substring(2, matchedText.length - 2),
          style: TextStyle(fontWeight: FontWeight.bold),
        ));
      } else if (matchedText.startsWith('*')) {
        textSpans.add(TextSpan(
          text: matchedText.substring(1, matchedText.length - 1),
          style: TextStyle(fontStyle: FontStyle.italic),
        ));
      }

      lastMatchEnd = match.end;
    }

    if (lastMatchEnd < content.length) {
      textSpans.add(TextSpan(text: content.substring(lastMatchEnd)));
    }

    return textSpans;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double bottomNavHeight = 80;
    double topBarHeight = 60;
    double minY = topBarHeight + 10;
    double maxY = screenHeight - bottomNavHeight - 70;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          isLoading
              ? Center(child: CircularProgressIndicator())
              : posts.isEmpty
                  ? Center(child: Text("No posts available"))
                  : RefreshIndicator(
                      onRefresh: fetchPosts,
                      child: ListView.builder(
                        itemCount: posts.length,
                        itemBuilder: (context, index) {
                          final post = posts[index];
                          return _postCard(
                            avatar: 'assets/image_assets/3d_avatar_21.png',
                            username: post.authorName,
                            postText: post.content,
                            role: 'Patient', // Optional: update if available in backend
                            createdAt: post.createdAt,
                            caption: post.caption,
                            postId: post.id,
                            imageUrl: post.imageUrl,
                          );
                        },
                      ),
                    ),

          /// ✅ Movable AyuChat button
          Positioned(
            left: posX.clamp(0, screenWidth - 150),
            top: posY.clamp(minY-50, maxY-100),
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  posX += details.delta.dx;
                  posY += details.delta.dy;
                });
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 100),
                curve: Curves.easeOut,
                child: _ayuChatButton(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return "${dt.day} ${_monthName(dt.month)} '${dt.year % 100}";
  }

  String _monthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  Widget _ayuChatButton(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChatMenuPage()),
        );
      },
      backgroundColor: Color(0xFFFF8B01),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
        side: BorderSide(color: Color(0xFF064D99), width: 2),
      ),
      label: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            padding: EdgeInsets.all(3),
            child: Image.asset('assets/image_assets/ayusetu blue.png', fit: BoxFit.contain),
          ),
          SizedBox(width: 8),
          Text(
            "AyuChat",
            style: GoogleFonts.roboto(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _addThoughtsBar(BuildContext context, String postId) {
    return InkWell(
      onTap: () {
        print("Navigating to DiscussionPage with postId: $postId");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DiscussionPage(postId: postId)),
        );
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                "Add your thoughts",
                style: GoogleFonts.roboto(
                  fontSize: 15,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
            Icon(Icons.add_comment_outlined, color: Colors.grey.shade600),
          ],
        ),
      ),
    );
  }

  Widget _postCard({
    required String avatar,
    required String username,
    required String caption,
    required String role,
    required DateTime createdAt,
    required String postText,
    required String postId,
    required String imageUrl,
  }) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.grey.shade300, blurRadius: 5, offset: Offset(0, 2)),
        ],
      ),
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(radius: 20, backgroundImage: AssetImage(avatar)),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      caption,
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "@$username | $role | ${_formatDate(createdAt)}",
                      style: GoogleFonts.roboto(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12),

          /// Main content
          _buildRichText(postText),

          /// Image
          if (imageUrl.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200,
                  errorBuilder: (context, error, stackTrace) {
                    return Text('Could not load image', style: TextStyle(color: Colors.red));
                  },
                ),
              ),
            ),

          SizedBox(height: 12),

          /// Add comment bar
          _addThoughtsBar(context, postId),
        ],
      ),
    );
  }
}
