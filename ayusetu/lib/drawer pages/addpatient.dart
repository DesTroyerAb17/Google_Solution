import 'dart:convert';
import 'package:ayusetu/globalVariables.dart'; // Import your globalVariables.dart to access verification_token
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class AddPatientPage extends StatefulWidget {
  const AddPatientPage({super.key});

  @override
  _AddPatientPageState createState() => _AddPatientPageState();
}

class _AddPatientPageState extends State<AddPatientPage> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedGender;
  String? _selectedBloodGroup;
  DateTime? _selectedDate;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  bool _isFormValid() {
    return _formKey.currentState?.validate() == true &&
        _selectedGender != null &&
        _selectedBloodGroup != null &&
        _selectedDate != null;
  }

  Future<void> _savePatient() async {
    if (_isFormValid()) {
      final newPatient = {
        'name': _nameController.text,
        'gender': _selectedGender!,
        'dateOfBirth': _selectedDate!.toIso8601String(),
        'height': _heightController.text,
        'weight': _weightController.text,
        'bloodGroup': _selectedBloodGroup!,
      };

      final requestBody = json.encode(newPatient);

      try {
        final response = await http.post(
          Uri.parse('$base_url/api/users/add-family-member'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $verification_token',  // Add Bearer token in the Authorization header
          },
          body: requestBody,
        );

        if (response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green),
                  SizedBox(width: 10),
                  Text("Family member added successfully", style: TextStyle(fontSize: 14)),
                ],
              ),
              backgroundColor: Colors.white,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              duration: Duration(seconds: 2),
            ),
          );
          Navigator.pop(context, newPatient);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Failed to add family member. Please try again."),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error connecting to the server. Try again."),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("Add Patient", style: GoogleFonts.roboto(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _sectionTitle("Basic details"),
              _inputField("Enter your name", _nameController, isText: true),
              _dropdownField("Select your gender", ["Male", "Female"], (value) {
                setState(() => _selectedGender = value);
              }, _selectedGender),
              _datePickerField("Enter your date of birth"),

              SizedBox(height: 16),
              _sectionTitle("Secondary details"),
              _inputFieldWithSuffix("Enter your height", "cm", _heightController),
              _inputFieldWithSuffix("Enter your weight", "kg", _weightController),
              _dropdownField("Select blood group", ["A+", "A-", "B+", "B-", "O+", "O-", "AB+", "AB-"], (value) {
                setState(() => _selectedBloodGroup = value);
              }, _selectedBloodGroup),

              SizedBox(height: 24),
              _saveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black),
      ),
    );
  }

  Widget _inputField(String hintText, TextEditingController controller, {bool isText = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: isText ? TextInputType.text : TextInputType.number,
        validator: (value) {
          if (value == null || value.isEmpty) return "Required field";
          if (isText && !RegExp(r"^[a-zA-Z\s]+$").hasMatch(value)) return "Only letters allowed";
          return null;
        },
        decoration: _inputDecoration(hintText),
        onChanged: (_) => setState(() {}),
      ),
    );
  }

  Widget _dropdownField(String hintText, List<String> items, ValueChanged<String?> onChanged, String? selectedValue) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        decoration: _inputDecoration(hintText),
        value: selectedValue,
        isExpanded: true,
        items: items.map((String item) {
          return DropdownMenuItem(
            value: item,
            child: Text(item, style: GoogleFonts.roboto(fontSize: 14, color: Colors.black)),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            onChanged(value);
          });
        },
        validator: (value) => value == null ? "Required field" : null,
      ),
    );
  }

  Widget _datePickerField(String hintText) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        readOnly: true,
        controller: TextEditingController(
            text: _selectedDate != null ? "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}" : ""),
        decoration: _inputDecoration(hintText).copyWith(
          suffixIcon: IconButton(
            icon: Icon(Icons.calendar_today, color: Colors.black),
            onPressed: _selectDate,
          ),
        ),
        validator: (value) => _selectedDate == null ? "Required field" : null,
      ),
    );
  }

  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Color(0xFFFF8B01),
            colorScheme: ColorScheme.light(primary: Color(0xFFFF8B01)),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
            dialogTheme: DialogTheme(backgroundColor: Colors.white),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Widget _inputFieldWithSuffix(String hintText, String suffixText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: controller,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) return "Required field";
                if (!RegExp(r"^[0-9]+$").hasMatch(value)) return "Only numbers allowed";
                return null;
              },
              decoration: _inputDecoration(hintText),
              onChanged: (_) => setState(() {}),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.only(topRight: Radius.circular(8), bottomRight: Radius.circular(8)),
            ),
            child: Text(suffixText, style: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String hintText) {
    return InputDecoration(
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      hintText: hintText,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Color(0xFFFF8B01), width: 2),
      ),
    );
  }

  Widget _saveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isFormValid() ? _savePatient : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: _isFormValid() ? Color(0xFFFF8B01) : Colors.grey,
          padding: EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text("Save patient", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
      ),
    );
  }
}
