import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        backgroundColor: Color.fromRGBO(72, 52, 102, 1.0),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/image5.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          ListView(
            children: [
              SwitchListTile(
                title: Text("Enable Notifications"),
                value: _notificationsEnabled,
                onChanged: (bool value) {
                  setState(() {
                    _notificationsEnabled = value;
                  });
                },
              ),
              ListTile(
                title: Text("Language"),
                trailing: DropdownButton<String>(
                  value: _selectedLanguage,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedLanguage = newValue!;
                    });
                    // TODO: Implement language change
                  },
                  items: <String>['English', 'Spanish', 'French', 'German']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              ListTile(
                title: Text("Privacy Policy"),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // TODO: Navigate to Privacy Policy page
                },
              ),
              ListTile(
                title: Text("Terms of Service"),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // TODO: Navigate to Terms of Service page
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

