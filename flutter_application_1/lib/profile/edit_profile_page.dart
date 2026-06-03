import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/api_service.dart';

class EditProfilePage extends StatefulWidget {
  final Map<String, dynamic> userData;

  EditProfilePage({required this.userData});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _usernameController;
  late TextEditingController _fullNameController;
  late TextEditingController _ageController;
  String? _selectedSkinType;
  late TextEditingController _allergiesController;

  final List<String> _skinTypes = ['Normal', 'Dry', 'Oily', 'Combination', 'Sensitive'];

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.userData['username']);
    _fullNameController = TextEditingController(text: widget.userData['full_name']);
    _ageController = TextEditingController(text: widget.userData['age']?.toString() ?? '');
    _selectedSkinType = widget.userData['skin_type'];
    _allergiesController = TextEditingController(text: widget.userData['allergies']);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _fullNameController.dispose();
    _ageController.dispose();
    _allergiesController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      try {
        final updatedData = {
          'username': _usernameController.text,
          'full_name': _fullNameController.text,
          'age': int.tryParse(_ageController.text) ?? 0,
          'skin_type': _selectedSkinType,
          'allergies': _allergiesController.text,
        };

        await ApiService.updateProfile(updatedData);
        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        backgroundColor: Color.fromRGBO(72, 52, 102, 1.0),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username'),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter username' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _fullNameController,
                decoration: InputDecoration(labelText: 'Full Name'),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter full name' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _ageController,
                decoration: InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter age' : null,
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedSkinType,
                decoration: InputDecoration(labelText: 'Skin Type'),
                items: _skinTypes.map((String type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedSkinType = newValue;
                  });
                },
                validator: (value) =>
                    value == null ? 'Please select skin type' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _allergiesController,
                decoration: InputDecoration(labelText: 'Allergies'),
                maxLines: 3,
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: _updateProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(72, 52, 102, 1.0),
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                child: Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}