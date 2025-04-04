import 'package:flutter/material.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final reports = [
      {
        'title': 'Oral cancer diagnosis report',
        'date': '04/04/25',
        'patient': 'Anjali Verma',
      },
      {
        'title': 'Lung cancer prescription summary',
        'date': '03/04/25',
        'patient': 'Rohan Singh',
      },
      {
        'title': 'Skin analysis & treatment report',
        'date': '02/04/25',
        'patient': 'Meera Kapoor',
      },
      {
        'title': 'Chest infection diagnosis prescription',
        'date': '01/04/25',
        'patient': 'Shashwat Talukdar',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Reports"),
        leading: const BackButton(),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.separated(
        itemCount: reports.length,
        separatorBuilder: (_, __) => const Divider(height: 1, thickness: 0.6),
        itemBuilder: (context, index) {
          final report = reports[index];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3E0), // soft beige
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.description, color: Colors.brown),
            ),
            title: Text(
              report['title'] ?? '',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              "${report['date']} | ${report['patient']}",
              style: const TextStyle(color: Colors.grey),
            ),
            onTap: () {
              // TODO: Open report details
            },
          );
        },
      ),
    );
  }
}
