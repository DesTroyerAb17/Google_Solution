import 'package:ayusetu/doctor_screens/appoinment_request_page.dart';
import 'package:flutter/material.dart';
import 'requests.dart';
class MyAppointmentsPage extends StatelessWidget {
  const MyAppointmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('My Appointments'),
          backgroundColor: Colors.white,
         bottom: TabBar(
  tabs: [
    const Tab(text: 'Upcoming'),
    // 👇 Custom Row for "Requests" with badge
    Tab(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Requests'),
          const SizedBox(width: 6),
          if (RequestsData.requests.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${RequestsData.requests.length}',
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
        ],
      ),
    ),
    const Tab(text: 'Olders'),
  ],
),

        ),
        body: TabBarView(
          children: [
            UpcomingTab(),
            RequestsTab(),
            OldersTab(),
          ],
        ),
      ),
    );
  }
}
class UpcomingAppointments {
  static List<Map<String, String>> items = [];

  static void add(Map<String, String> appointment) {
    items.add(appointment);
  }
}

class UpcomingTab extends StatefulWidget {
  const UpcomingTab({super.key});

  @override
  State<UpcomingTab> createState() => _UpcomingTabState();
}

class _UpcomingTabState extends State<UpcomingTab> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.builder(
          padding: const EdgeInsets.only(bottom: 100),
          itemCount: UpcomingAppointments.items.length,
          itemBuilder: (context, index) {
            final item = UpcomingAppointments.items[index];
            final isSelected = index == selectedIndex;

            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = isSelected ? null : index;
                });
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: isSelected ? Colors.blue : Colors.grey.shade300,
                    width: isSelected ? 1.5 : 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
  children: [
    Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.calendar_today, color: Colors.blue),
    ),
    const SizedBox(width: 12),
    Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item['title'] ?? '',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            item['subtitle'] ?? '',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 13,
            ),
          ),
        ],
      ),
    ),
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF5EB),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        item['status'] ?? '',
        style: const TextStyle(
          color: Colors.orange,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
      ),
    ),
  ],
),

              ),
            );
          },
        ),

        // Bottom sticky section
        if (selectedIndex != null)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2)),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Start Consultation", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Starting video chat...")),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text("Start Video Chat", style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}


class RequestsTab extends StatefulWidget {
  const RequestsTab({super.key});

  @override
  State<RequestsTab> createState() => _RequestsTabState();
}

class _RequestsTabState extends State<RequestsTab> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: RequestsData.requests.length,
      itemBuilder: (context, index) {
        final request = RequestsData.requests[index];
        return ListTile(
          leading: const CircleAvatar(
            backgroundImage: AssetImage('assets/image_assets/patient.png'),
          ),
          title: Text(request['title']),
          subtitle: Text("${request['name']} | ${request['language']}"),
          trailing: Text(
            request['price'],
            style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
          ),
          onTap: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AppointmentRequestPage(requestData: request),
              ),
            );

            // If confirmed, remove from list and refresh UI
            if (result == true) {
              setState(() {
                RequestsData.requests.removeAt(index);
              });
            }
          },
        );
      },
    );
  }
}

class OldersTab extends StatelessWidget {
  const OldersTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: Icon(Icons.calendar_today),
          title: Text("Shashwat’s chest consultation"),
          subtitle: Text("21/03/25 | Dr Shiva Reddy"),
        ),
        ListTile(
          leading: Icon(Icons.calendar_today),
          title: Text("Radha’s skin consultation"),
          subtitle: Text("21/03/25 | Dr Shiva Reddy"),
        ),
      ],
    );
  }
}
 