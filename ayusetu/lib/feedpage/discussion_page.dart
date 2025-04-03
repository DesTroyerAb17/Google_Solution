import 'dart:async';
import 'dart:convert';
import 'package:ayusetu/globalVariables.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class DiscussionPage extends StatefulWidget {
  final String postId;

  const DiscussionPage({super.key, required this.postId});

  @override
  State<DiscussionPage> createState() => _DiscussionPageState();
}

class _DiscussionPageState extends State<DiscussionPage> {
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Map<String, dynamic>> _comments = [];
  bool isLoading = true;
  Timer? _autoRefreshTimer;

  @override
  void initState() {
    super.initState();
    _fetchComments();

    _autoRefreshTimer = Timer.periodic(Duration(seconds: 10), (timer) {
      if (mounted) _fetchComments();
    });
  }

  @override
  void dispose() {
    _autoRefreshTimer?.cancel();
    _commentController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchComments() async {
    try {
      final response = await http.get(
        Uri.parse('$base_url/api/posts'),
        headers: {
          'Authorization': 'Bearer $verification_token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        final post = data.firstWhere(
          (p) => p['_id'] == widget.postId,
          orElse: () => null,
        );

        if (post == null) {
          print('Post not found');
          setState(() => isLoading = false);
          return;
        }

        final List<dynamic> comments = post['comments'] ?? [];

        setState(() {
          _comments = comments.map<Map<String, dynamic>>((comment) {
            final rawPic = comment['user']?['profilePic'] ?? '';
            final profilePic = rawPic.startsWith('/uploads/')
                ? '$base_url$rawPic'
                : rawPic;

            return {
              'name': comment['user']?['name'] ?? 'Unknown',
              'message': comment['text'] ?? '',
              'profilePic': profilePic,
            };
          }).toList();
          isLoading = false;
        });

        _scrollToBottom();
      } else {
        print('Failed to fetch posts: ${response.statusCode}');
        setState(() => isLoading = false);
      }
    } catch (e) {
      print('Error fetching comments: $e');
      setState(() => isLoading = false);
    }
  }

  void _postComment() async {
    String trimmedComment = _commentController.text.trim();
    if (trimmedComment.isEmpty) return;

    final commentData = {
      'text': trimmedComment,
    };

    try {
      final response = await http.post(
        Uri.parse('$base_url/api/posts/${widget.postId}/comments'),
        headers: {
          'Authorization': 'Bearer $verification_token',
          'Content-Type': 'application/json',
        },
        body: json.encode(commentData),
      );

      if (response.statusCode == 200) {
        _commentController.clear();
        FocusScope.of(context).unfocus();

        // Add comment locally
        final newComment = {
          'name': 'You',
          'message': trimmedComment,
          'profilePic': '',
        };

        setState(() {
          _comments.add(newComment);
        });

        _scrollToBottom();

        // Fetch actual comments from backend
        _fetchComments();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Comment posted')),
        );
      } else {
        print('Failed to post comment');
        print(response.body);
      }
    } catch (e) {
      print('Error posting comment: $e');
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isCommentEmpty = _commentController.text.trim().isEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text("Discussion", style: GoogleFonts.roboto(color: Colors.black)),
        leading: BackButton(color: Colors.black),
      ),
      body: Column(
        children: [
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    itemCount: _comments.length,
                    itemBuilder: (context, index) {
                      final comment = _comments[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundImage: comment['profilePic'].toString().isNotEmpty
                                  ? NetworkImage(comment['profilePic'])
                                  : AssetImage('assets/image_assets/3d_avatar_21.png')
                                      as ImageProvider,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey.shade300, width: 1),
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      comment['name'],
                                      style: GoogleFonts.roboto(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      comment['message'],
                                      style: GoogleFonts.roboto(
                                        fontSize: 14,
                                        color: Colors.black87,
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(12, 10, 12, 16),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFFBFC9D2)),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextField(
                      controller: _commentController,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: "Add your thoughts",
                        hintStyle: GoogleFonts.roboto(color: Colors.grey.shade600),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: isCommentEmpty ? null : _postComment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFF8B01),
                    padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  child: Text("Post", style: GoogleFonts.roboto(color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
