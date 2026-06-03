import 'package:flutter/material.dart';
import 'package:flutter_application_1/Authentication/additionalinfo.dart';
import 'package:flutter_application_1/services/api_service.dart';
import 'main.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Container(
            height: screenHeight,
            width: screenWidth,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/image7.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: screenHeight * 0.1,
            left: 0,
            right: 0,
            child: const Center(
              child: Text(
                "Get Started",
                style: TextStyle(
                  color: Color.fromRGBO(72, 52, 102, 1.0),
                  fontSize: 40,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: screenHeight * 0.25),
                    buildField("First Name", _firstNameController),
                    buildField("Last Name", _lastNameController),
                    buildField("Email", _emailController, isEmail: true),
                    buildField("Password", _passwordController, isPassword: true),
                    SizedBox(height: screenHeight * 0.05),
                    GestureDetector(
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
                            "Sign Up",
                            style: TextStyle(
                              color: Color.fromRGBO(245, 245, 255, 1.0),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: screenHeight * 0.02),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage()),
                          );
                        },
                        child: const Text(
                          "Already have an account? Sign in",
                          style: TextStyle(
                            color: Color.fromRGBO(72, 52, 102, 1.0),
                            fontSize: 12,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildField(String label, TextEditingController controller, {bool isPassword = false, bool isEmail = false}) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color.fromRGBO(72, 52, 102, 1.0),
              fontSize: 11,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color.fromRGBO(103, 79, 131, 1.0)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextFormField(
                controller: controller,
                obscureText: isPassword,
                keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter $label';
                  }
                  if (isEmail && !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  if (isPassword && value.length < 6) {
                    return 'Password must be at least 6 characters long';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Enter $label",
                  hintStyle: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 15,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        final userData = {
          'username': '${_firstNameController.text} ${_lastNameController.text}',
          'email': _emailController.text,
          'password': _passwordController.text,
          'full_name': '${_firstNameController.text} ${_lastNameController.text}',
        };

        print('Attempting to register user: ${userData['email']}'); // Add logging

        final response = await ApiService.register(userData);

        print('Registration successful: ${response['userId']}'); // Add logging

        // If registration is successful, navigate to the AdditionalInfo page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => additionalinfo(
              firstName: _firstNameController.text,
              lastName: _lastNameController.text,
              email: _emailController.text,
            ),
          ),
        );
      } catch (e) {
        print('Registration error: $e'); // Add logging

        // Show a more user-friendly error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Registration failed: ${e.toString().contains('Exception:')
                ? e.toString().split('Exception:')[1]
                : 'Please try again later'}'
            ),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Dismiss',
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
              textColor: Colors.white,
            ),
          ),
        );
      }
    }
  }
}

