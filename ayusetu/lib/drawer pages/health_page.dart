import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'infographic_blog.dart'; // ✅ This imports the full list of infographic pages

// Blog model
class Blog {
  final String title;
  final String date;
  final List<String> tags;
  final String imageUrl;
  

  Blog({
    required this.title,
    required this.date,
    required this.tags,
    required this.imageUrl,
  });
}

class HealthBlogPage extends StatefulWidget {
  const HealthBlogPage({super.key});

  @override
  State<HealthBlogPage> createState() => _HealthBlogPageState();
}

class _HealthBlogPageState extends State<HealthBlogPage> {
  String query = "";

  final List<Blog> blogs = [
    Blog(
      title: "What to Do in Case of a Burn",
      date: "April 2, 2025",
      tags: ["Emergency", "Skin Care"],
      imageUrl: "assets/image_assets/blog_burn.jpg",
       ),
    Blog(
      title: "How to Stop a Nosebleed Quickly",
      date: "April 4, 2025",
      tags: ["ENT", "First Aid"],
      imageUrl: "assets/image_assets/blog_nosebleed.jpg",
      ),
    Blog(
      title: "First Aid for Choking: Step-by-Step Guide",
      date: "April 5, 2025",
      tags: ["Emergency", "Life Saving"],
      imageUrl: "assets/image_assets/blog_choking.jpg",
       ),
    Blog(
      title: "What to Do If Someone Faints",
      date: "April 6, 2025",
      tags: ["Emergency Response", "Neurology"],
      imageUrl: "assets/image_assets/blog_fainting.jpg",
      ),
    Blog(
      title: "Basic CPR Instructions for Everyone",
      date: "April 10, 2025",
      tags: ["Life Saving", "First Aid"],
      imageUrl: "assets/image_assets/blog_cpr.jpg",
       ),
    Blog(
      title: "How to Make a DIY First Aid Kit",
      date: "April 8, 2025",
      tags: ["Preparedness", "Family Safety"],
      imageUrl: "assets/image_assets/blog_firstaidkit.jpg",
       ),
    Blog(
      title: "How to Respond to Allergic Reactions",
      date: "April 11, 2025",
      tags: ["Allergy Care", "Emergency Response"],
      imageUrl: "assets/image_assets/blog_allergy.jpg",
      ),
    Blog(
      title: "Emergency Care for Electric Shock",
      date: "April 12, 2025",
      tags: ["Trauma Care", "Emergency Aid"],
      imageUrl: "assets/image_assets/blog_electricshock.jpg",
       ),
    Blog(
      title: "First Aid Basics Everyone Should Know",
      date: "April 6, 2025",
      tags: ["Preventive Care", "General Health"],
      imageUrl: "assets/image_assets/blog_firstaid.jpg",
      ),
  ];

  List<Blog> get filteredBlogs {
    return blogs.where((blog) {
      final lower = query.toLowerCase();
      return blog.title.toLowerCase().contains(lower) ||
          blog.tags.any((tag) => tag.toLowerCase().contains(lower));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Health Blog",
        style: TextStyle(color: Colors.white)),
        
        backgroundColor:  Color(0xFF064D99),
        iconTheme: IconThemeData(color: Colors.white), // <-- Make back arrow white
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(12),
              child: TextField(
                onChanged: (val) => setState(() => query = val),
                decoration: InputDecoration(
                  hintText: "Search Symptoms, Emergency, Medical suggestions",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      "Recommended Blogs",
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                itemCount: filteredBlogs.length,
                separatorBuilder: (context, index) =>
                    Divider(height: 1, color: Colors.grey.shade300),
                itemBuilder: (context, index) {
                  final blog = filteredBlogs[index];
        
                  return InkWell(
                   onTap: () {
          final blogTitle = blog.title.trim();
          print("Opening blog: ${blog.title}");
        
          if (infographicMap.containsKey(blogTitle)) {
          Navigator.push(
            context,
            MaterialPageRoute(
        builder: (_) => infographicMap[blogTitle]!(),
            ),
          );
        }
        },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Wrap(
                                  spacing: 6,
                                  runSpacing: 4,
                                  children: blog.tags
                                      .map((tag) => Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: Colors.orange.shade100,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              tag,
                                              style: TextStyle(
                                                fontSize: 8,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.orange,
                                              ),
                                            ),
                                          ))
                                      .toList(),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  blog.title,
                                  style: GoogleFonts.roboto(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  blog.date,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              blog.imageUrl,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(Icons.broken_image,
                                      size: 60, color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BlogDetailPage extends StatelessWidget {
  final Blog blog;
  const BlogDetailPage({super.key, required this.blog});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(blog.title, overflow: TextOverflow.ellipsis),
        backgroundColor:Color(0xFFFF8B01),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(blog.title,
                style: GoogleFonts.roboto(
                    fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(blog.date,
                style: TextStyle(fontSize: 14, color: Colors.grey[600])),
            SizedBox(height: 12),
            Image.asset(blog.imageUrl),
            SizedBox(height: 12),
            
          ],
        ),
      ),
    );
  }
}
