import 'package:flutter/material.dart';
import 'package:ayusetu/screen_pages/appointment_confirmation.dart';

class ScheduleAppointmentPage extends StatefulWidget {
  const ScheduleAppointmentPage({super.key});

  @override
  State<ScheduleAppointmentPage> createState() => _ScheduleAppointmentPageState();
}

class _ScheduleAppointmentPageState extends State<ScheduleAppointmentPage> {
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  int selectedLanguageIndex = 0;

  List<String> languages = ['Hindi', 'English', 'Bangla', 'Odia', 'Marathi'];

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFFF8B01), // Orange selection
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Color(0xFFFF8B01),
              ),
            ), dialogTheme: DialogThemeData(backgroundColor: Colors.white),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        controller.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Schedule Appointment', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Patient Details
              _buildPatientDetails(),
              const SizedBox(height: 16),
      
              // Availability
              _buildAvailabilitySection(),
              const SizedBox(height: 16),
      
              // Language selection
              const Text(
                'Choose your preferred language',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              _buildLanguageChips(),
              const SizedBox(height: 16),
      
              // Price breakdown
              _buildPriceBreakdown(),
            ],
          ),
        ),
      ),
      bottomSheet: _buildBottomStickyButtons(),
    );
  }

  Widget _buildPatientDetails() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey.shade400,
            radius: 20,
            child: const Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Shashwat Talukdar',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  'Male | 23 yrs | 74 kg',
                  style: TextStyle(color: Colors.grey[700], fontSize: 13),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3E5),
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Text(
              'Me',
              style: TextStyle(color: Color(0xFFFF8B01), fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailabilitySection() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Your availability',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: fromDateController,
                  readOnly: true,
                  onTap: () => _selectDate(context, fromDateController),
                  decoration: const InputDecoration(
                    hintText: 'From date',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: toDateController,
                  readOnly: true,
                  onTap: () => _selectDate(context, toDateController),
                  decoration: const InputDecoration(
                    hintText: 'To date',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.calendar_today_outlined, size: 20, color: Colors.grey.shade700),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(languages.length, (index) {
          bool selected = selectedLanguageIndex == index;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(languages[index]),
              selected: selected,
              onSelected: (_) {
                setState(() => selectedLanguageIndex = index);
              },
              selectedColor: const Color(0xFFFFF3E5),
              backgroundColor: Colors.white,
              labelStyle: TextStyle(
                color: selected ? const Color(0xFFFF8B01) : Colors.black,
              ),
              shape: StadiumBorder(side: BorderSide(color: Colors.grey.shade300)),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildPriceBreakdown() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Price Breakdown', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          _priceRow('Charge 1', 'Rs 299'),
          _priceRow('Charge 2', 'Rs 0'),
          _priceRow('Charge 3', 'FREE'),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total',
                      style: TextStyle(
                          color: Color(0xFFFF8B01),
                          fontWeight: FontWeight.bold,
                          fontSize: 15)),
                  Text(
                    'Inclusive of all taxes',
                    style: TextStyle(color: Colors.blueGrey, fontSize: 10),
                  ),
                ],
              ),
              Text(
                '₹299',
                style: TextStyle(
                    color: Color(0xFFFF8B01),
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomStickyButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AppointmentPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF8B01),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Rs 299 | Pay & Consult',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text(
              'Change Payment method >',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }

  Widget _priceRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value),
        ],
      ),
    );
  }
}
