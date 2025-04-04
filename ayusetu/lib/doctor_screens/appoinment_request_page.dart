import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'my_appoinments.dart';

class AppointmentRequestPage extends StatefulWidget {
  final Map<String, dynamic> requestData;

  const AppointmentRequestPage({super.key, required this.requestData});

  @override
  State<AppointmentRequestPage> createState() => _AppointmentRequestPageState();
}

class _AppointmentRequestPageState extends State<AppointmentRequestPage> {
  final TextEditingController fromDateController = TextEditingController();
  final TextEditingController toDateController = TextEditingController();

  DateTime? selectedFromDate;
  DateTime? selectedToDate;

  int selectedDateIndex = 1; // Default selected chip
  int selectedTimeIndex = 0;

  final List<String> preferredDates = [
    "Thu, 03 Apr",
    "Fri, 04 Apr",
    "Mon, 07 Apr",
    "Tue, 08 Apr",
  ];

  final List<String> preferredTimes = [
    "10:20 AM",
    "10:40 AM",
    "11:10 AM",
    "11:30 AM",
  ];

  Future<void> _selectDate(BuildContext context, TextEditingController controller, bool isFromDate) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isFromDate ? DateTime.now() : (selectedFromDate ?? DateTime.now()),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('dd MMM yyyy').format(picked);
        if (isFromDate) {
          selectedFromDate = picked;
        } else {
          selectedToDate = picked;
        }
      });
    }
  }

  void _confirmAndSchedule(BuildContext context) {
    if (fromDateController.text.isEmpty || toDateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select From and To dates")),
      );
      return;
    }

    UpcomingAppointments.add({
      'title': widget.requestData['title'],
      'subtitle':
          "${preferredDates[selectedDateIndex]} at ${preferredTimes[selectedTimeIndex]} | ${widget.requestData['name']}",
      'status': "Confirmed",
    });

    Navigator.pop(context, true);
  }

  @override
  void dispose() {
    fromDateController.dispose();
    toDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final requestData = widget.requestData;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Appointment Request"),
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: const BackButton(),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Chest consultation", style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 16),

                  /// Patient Details
                  _sectionContainer(
                    title: "Patient details",
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.grey,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      title: Text(requestData['name']),
                      subtitle: Text("Male | ${requestData['age']} yrs | ${requestData['weight']} kg"),
                    ),
                  ),
                  const SizedBox(height: 16),

                  /// Preferred Language
                  const Text("Preferred language", style: TextStyle(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Chip(
                      backgroundColor: const Color(0xFFFFF3E0),
                      label: Text(requestData['language']),
                    ),
                  ),
                  const SizedBox(height: 20),

                  /// Availability
                  _sectionContainer(
                    title: "Patient availability",
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: fromDateController,
                                readOnly: true,
                                onTap: () => _selectDate(context, fromDateController, true),
                                decoration: const InputDecoration(
                                  labelText: 'From date',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: toDateController,
                                readOnly: true,
                                onTap: () => _selectDate(context, toDateController, false),
                                decoration: const InputDecoration(
                                  labelText: 'To date',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text("Choose your preferred date"),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: List.generate(preferredDates.length, (index) {
                            return ChoiceChip(
                              label: Text(preferredDates[index]),
                              selected: selectedDateIndex == index,
                              onSelected: (_) => setState(() => selectedDateIndex = index),
                            );
                          }),
                        ),
                        const SizedBox(height: 16),
                        const Text("Choose your preferred time"),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: List.generate(preferredTimes.length, (index) {
                            return ChoiceChip(
                              label: Text(preferredTimes[index]),
                              selected: selectedTimeIndex == index,
                              onSelected: (_) => setState(() => selectedTimeIndex = index),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  /// Consultation Charge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text("Total earning", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                            Text("Exclusive of all taxes", style: TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                        Text(
                          requestData['price'],
                          style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 18),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ✅ Bottom confirm button
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () => _confirmAndSchedule(context),
              child: const Text("Confirm & Schedule",style: TextStyle(color: Colors.white),),
            ),
          ),
        ],
      ),
    );
  }

  /// Reusable section container
  Widget _sectionContainer({required String title, required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12.0, left: 12),
            child: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
          child,
        ],
      ),
    );
  }
}
