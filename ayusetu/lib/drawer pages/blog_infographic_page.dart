import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BlogInfographicPage extends StatelessWidget {
  final String title;
  final String bannerImage;
  final String intro;
  final List<BlogStep> steps;
  final List<String> medicalTips;
  final List<String> quickTips;

  const BlogInfographicPage({
    super.key,
    required this.title,
    required this.bannerImage,
    required this.intro,
    required this.steps,
    required this.medicalTips,
    required this.quickTips,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, overflow: TextOverflow.ellipsis),
        backgroundColor: Color(0xFF064D99),
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(bannerImage),
              const SizedBox(height: 16),
              Text(
                title,
                style: GoogleFonts.roboto(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                intro,
                style: GoogleFonts.roboto(fontSize: 14, height: 1.6),
              ),
              const SizedBox(height: 24),
              Text(
                "🩺 Step-by-Step Instructions",
                style: GoogleFonts.roboto(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ...steps.map((step) => Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${step.number}. ${step.title}",
                          style: GoogleFonts.roboto(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          step.description,
                          style: GoogleFonts.roboto(fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        if (step.imagePath != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(step.imagePath!),
                          ),
                      ],
                    ),
                  )),
              const SizedBox(height: 10),
              Text(
                "⚠️ When to Seek Medical Help",
                style: GoogleFonts.roboto(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...medicalTips.map((tip) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("• "),
                        Expanded(
                          child: Text(
                            tip,
                            style: GoogleFonts.roboto(fontSize: 14),
                          ),
                        )
                      ],
                    ),
                  )),
              const SizedBox(height: 20),
              Text(
                "🧠 Quick Tips",
                style: GoogleFonts.roboto(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...quickTips.map((tip) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("• "),
                        Expanded(
                          child: Text(
                            tip,
                            style: GoogleFonts.roboto(fontSize: 14),
                          ),
                        )
                      ],
                    ),
                  )),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class BlogStep {
  final int number;
  final String title;
  final String description;
  final String? imagePath;

  BlogStep({
    required this.number,
    required this.title,
    required this.description,
    this.imagePath,
  });
}
