import 'package:flutter/material.dart';

class DoctorListPage extends StatefulWidget {
  const DoctorListPage({Key? key}) : super(key: key);

  @override
  _DoctorListPageState createState() => _DoctorListPageState();
}

class _DoctorListPageState extends State<DoctorListPage> {
  // Track selected doctor index
  int? _selectedDoctorIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Available Doctors'),
        backgroundColor: const Color(0xFFFF8B01),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: 3, // Number of doctors
              itemBuilder: (BuildContext context, int index) {
                String name;
                String specialty;

                switch (index) {
                  case 0:
                    name = 'Dr. John Smith';
                    specialty = 'Cardiologist';
                    break;
                  case 1:
                    name = 'Dr. Jane Doe';
                    specialty = 'Neurologist';
                    break;
                  case 2:
                    name = 'Dr. David Lee';
                    specialty = 'ENT Specialist';
                    break;
                  default:
                    name = 'Unknown Doctor';
                    specialty = 'Unknown';
                }

                return DoctorCard(
                  key: ValueKey('doctor_$index'),
                  name: name,
                  specialty: specialty,
                  isSelected: _selectedDoctorIndex == index,
                  onSelect: () {
                    setState(() {
                      _selectedDoctorIndex = index;
                    });
                  },
                );
              },
            ),
          ),
          if (_selectedDoctorIndex != null)
            Container(
              padding: const EdgeInsets.all(16),
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF8B01),
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 50),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Confirm Selection',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class DoctorCard extends StatelessWidget {
  const DoctorCard({
    Key? key,
    required this.name,
    required this.specialty,
    required this.isSelected,
    required this.onSelect,
  }) : super(key: key);

  final String name;
  final String specialty;
  final bool isSelected;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelect,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        color: const Color(0xFF333333),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: isSelected
                      ? Border.all(color: const Color(0xFFFF8B01), width: 2)
                      : null,
                ),
                child: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Specialty: $specialty',
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
