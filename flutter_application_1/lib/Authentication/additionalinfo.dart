import 'package:flutter/material.dart';
import 'package:flutter_application_1/Authentication/main.dart';
import 'package:flutter_application_1/Menu/home_screen.dart';
import 'package:flutter_application_1/services/api_service.dart';

class additionalinfo extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String email;

  additionalinfo({required this.firstName, required this.lastName, required this.email});

  @override
  _AdditionalInfoState createState() => _AdditionalInfoState();
}

class _AdditionalInfoState extends State<additionalinfo> {
  final _formKey = GlobalKey<FormState>();
  String? selectedAge;
  String? selectedAllergy;
  String? selectedSkinType;

  final List<String> ages = List.generate(82, (index) => (index + 18).toString());
  final List<String> allergies = [
    "None",
    "Salicylic acid",
    "Fragrance",
    "Metals",
    "Essential Oils"
  ];
  final List<String> skinTypes = [
    "Normal",
    "Dry",
    "Oily",
    "Combination",
    "Sensitive"
  ];

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          _buildTitle(screenHeight),
          _buildForm(screenHeight, screenWidth),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Positioned.fill(
      child: Image.asset(
        'assets/images/image7.jpg',
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildTitle(double screenHeight) {
    return Positioned(
      top: screenHeight * 0.1,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: Text(
            "Additional Info",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 30,
              color: Color.fromRGBO(72, 52, 102, 1.0),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm(double screenHeight, double screenWidth) {
    return Positioned.fill(
      top: screenHeight * 0.25,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDropdown("Age", ages, selectedAge, (value) => setState(() => selectedAge = value)),
                SizedBox(height: screenHeight * 0.03),
                _buildDropdown("Allergies", allergies, selectedAllergy, (value) => setState(() => selectedAllergy = value)),
                SizedBox(height: screenHeight * 0.03),
                _buildDropdown("Skin Type", skinTypes, selectedSkinType, (value) => setState(() => selectedSkinType = value)),
                SizedBox(height: screenHeight * 0.05),
                _buildSaveButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(String title, List<String> items, String? selectedValue, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: fieldTitleStyle),
        SizedBox(height: 10),
        DropdownButtonFormField<String>(
          value: selectedValue,
          items: items.map((item) => DropdownMenuItem<String>(value: item, child: Text(item))).toList(),
          onChanged: onChanged,
          decoration: dropdownDecoration,
          validator: (value) => value == null ? 'Please select a $title' : null,
        ),
      ],
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return GestureDetector(
      onTap: _submitForm,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(72, 52, 102, 1.0),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Text(
            "Save",
            style: TextStyle(
              color: Color.fromRGBO(245, 245, 255, 1.0),
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration get dropdownDecoration => InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: const Color.fromRGBO(103, 79, 131, 1.0),
          ),
        ),
      );

  TextStyle get fieldTitleStyle => const TextStyle(
        color: Color.fromRGBO(72, 52, 102, 1.0),
        fontSize: 11,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.bold,
      );

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        final additionalInfo = {
          'skin_type': selectedSkinType,
          'age': int.parse(selectedAge!),
          'allergies': selectedAllergy,
        };

        await ApiService.updateAdditionalInfo(additionalInfo);

        // Navigate to the HomeScreen after successful update
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } catch (e) {
        // If update fails, show an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update additional info: ${e.toString()}')),
        );
      }
    }
  }
}

