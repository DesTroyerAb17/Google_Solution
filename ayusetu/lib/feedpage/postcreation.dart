import 'dart:convert';
import 'dart:io';
import 'package:ayusetu/globalVariables.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  bool isBold = false;
  bool isItalic = false;
  bool isUnderlined = false;
  bool isPostEnabled = false;

  File? _mediaFile;
  String? _mediaType; // image or video
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _titleController.addListener(_updatePostButtonState);
    _bodyController.addListener(_updatePostButtonState);
  }

  void _updatePostButtonState() {
    setState(() {
      isPostEnabled =
          _titleController.text.trim().isNotEmpty || _bodyController.text.trim().isNotEmpty;
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _mediaFile = File(pickedFile.path);
        _mediaType = 'image';
      });
    }
  }

  Future<void> _pickVideo() async {
    final pickedFile = await _picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _mediaFile = File(pickedFile.path);
        _mediaType = 'video';
      });
    }
  }

  Future<void> _submitPost() async {
    final String content = _bodyController.text.trim();
    final String caption = _titleController.text.trim();

    if (content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter content for the post."), backgroundColor: Colors.red),
      );
      return;
    }

    try {
      final uri = Uri.parse('$base_url/api/posts');
      final request = http.MultipartRequest('POST', uri);

      request.fields['content'] = content;
      request.fields['caption'] = caption;

      request.headers['Authorization'] = 'Bearer $verification_token';

      if (_mediaFile != null) {
        final fileName = _mediaFile!.path.split('/').last;
        request.files.add(
          await http.MultipartFile.fromPath(
            'image', // key used by backend
            _mediaFile!.path,
            filename: fileName,
          ),
        );
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Post added successfully!"), backgroundColor: Colors.green),
        );
        _titleController.clear();
        _bodyController.clear();
        setState(() {
          isPostEnabled = false;
          isBold = false;
          isItalic = false;
          isUnderlined = false;
          _mediaFile = null;
          _mediaType = null;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to create post!"), backgroundColor: Colors.red),
        );
      }
    } catch (error) {
      print('Error during post submission: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred: $error"), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = GoogleFonts.roboto(
      fontSize: 14,
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
      decoration: isUnderlined ? TextDecoration.underline : TextDecoration.none,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Create a Post"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              style: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                hintText: "Title",
                hintStyle: GoogleFonts.roboto(fontSize: 16, color: Colors.grey.shade600),
                border: InputBorder.none,
              ),
            ),
            Divider(color: Colors.grey.shade400),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.format_bold, color: isBold ? Colors.blue : Colors.black54),
                  onPressed: () => setState(() => isBold = !isBold),
                ),
                IconButton(
                  icon: Icon(Icons.format_italic, color: isItalic ? Colors.blue : Colors.black54),
                  onPressed: () => setState(() => isItalic = !isItalic),
                ),
                IconButton(
                  icon: Icon(Icons.format_underline, color: isUnderlined ? Colors.blue : Colors.black54),
                  onPressed: () => setState(() => isUnderlined = !isUnderlined),
                ),
                IconButton(
                  icon: Icon(Icons.image, color: Colors.green),
                  onPressed: _pickImage,
                ),
                IconButton(
                  icon: Icon(Icons.videocam, color: Colors.deepPurple),
                  onPressed: _pickVideo,
                ),
                if (_mediaFile != null)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Text(
                        "Selected: ${_mediaFile!.path.split('/').last}",
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.roboto(fontSize: 12, color: Colors.grey[700]),
                      ),
                    ),
                  ),
              ],
            ),
            TextField(
              controller: _bodyController,
              maxLines: 6,
              style: textStyle,
              decoration: InputDecoration(
                hintText: "Post your medical experience",
                hintStyle: GoogleFonts.roboto(color: Colors.grey.shade600),
                border: InputBorder.none,
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isPostEnabled ? _submitPost : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isPostEnabled ? Color(0xFF064D99) : Colors.grey,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  "Post",
                  style: GoogleFonts.roboto(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
