import 'package:ayusetu/screen_pages/video_chat.dart';
import 'package:flutter/material.dart';

class MyAppointmentsPage extends StatefulWidget {
  @override
  _MyAppointmentsPageState createState() => _MyAppointmentsPageState();
}

class _MyAppointmentsPageState extends State<MyAppointmentsPage> with SingleTickerProviderStateMixin {
  int? selectedIndex;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        selectedIndex = null; // Reset selection on tab switch
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('My Appointments'),
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF064C99),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF064C99)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            indicatorColor: Color(0xFFFF8B01),
            labelColor: Color(0xFFFF8B01),
            unselectedLabelColor: Colors.black,
            tabs: const [
              Tab(text: 'Upcoming'),
              Tab(text: 'Older'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Upcoming Tab
                _buildAppointmentList(isUpcoming: true),
                // Older Tab
                _buildAppointmentList(isUpcoming: false),
              ],
            ),
          ),
          if (selectedIndex != null && _tabController.index == 0)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => VideoCallPage()),
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      "Join Video Chat",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAppointmentList({required bool isUpcoming}) {
    final appointments = isUpcoming
        ? [
            {"title": "Shashwat’s chest consultation", "subtitle": "21/03/25 | Dr Shiva Reddy", "time": "in 2 days"},
            {"title": "Shashwat’s chest consultation", "subtitle": "21/03/25 | Dr Shiva Reddy", "time": "Today, 10 AM"},
            {"title": "Shashwat’s chest consultation", "subtitle": "21/03/25 | Dr Shiva Reddy", "time": "in 7 days"},
          ]
        : [
            {"title": "Shashwat’s chest consultation", "subtitle": "21/03/25 | Dr Shiva Reddy", "time": "Completed"},
            {"title": "Susmita’s abdomen consultation", "subtitle": "21/03/25 | Dr Shiva Reddy", "time": "Completed"},
            {"title": "Srikant’s lung consultation", "subtitle": "21/03/25 | Dr Shiva Reddy", "time": "Completed"},
            {"title": "Radha’s skin consultation", "subtitle": "21/03/25 | Dr Shiva Reddy", "time": "Completed"},
          ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final appointment = appointments[index];
        return _appointmentCard(
          index: index,
          title: appointment["title"]!,
          subtitle: appointment["subtitle"]!,
          time: appointment["time"]!,
          isUpcoming: isUpcoming,
        );
      },
    );
  }

  Widget _appointmentCard({
    required int index,
    required String title,
    required String subtitle,
    required String time,
    required bool isUpcoming,
  }) {
    final isSelected = selectedIndex == index;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: GestureDetector(
        onTap: isUpcoming
            ? () {
                setState(() {
                  selectedIndex = isSelected ? null : index;
                });
              }
            : null,
        child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isSelected && isUpcoming ? Color(0xFFFF8B01) : Colors.transparent,
              width: 2,
            ),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            leading: Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isUpcoming ? Colors.blue : Colors.grey.shade400,
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.calendar_month,
                color: isUpcoming ? Colors.blue : Colors.black,
                size: 24,
              ),
            ),
            title: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
            subtitle: Text(
              subtitle,
              style: TextStyle(fontSize: 12, color: Colors.black),
            ),
            trailing: isUpcoming
                ? Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFFF8B01).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: Text(
                      time,
                      style: TextStyle(
                        color: Color(0xFFFF8B01),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
