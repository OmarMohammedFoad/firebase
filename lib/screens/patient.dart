import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import "package:firebase/services/auth.dart";
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  String _name = "John Doe";
  String _phoneNumber = "123-456-7890";
  DateTime _dateOfBirth = DateTime(1990, 1, 1);
  String _gender = "Male";
  String _bloodGroup = "AB+";
  int _height = 170;
  int _weight = 70;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _dateOfBirthController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  TextEditingController _bloodGroupController = TextEditingController();
  TextEditingController _heightController = TextEditingController();
  TextEditingController _weightController = TextEditingController();
  // final AuthService _auth = AuthService();



  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: _name);
    _phoneNumberController = TextEditingController(text: _phoneNumber);
    _dateOfBirthController = TextEditingController(
        text: DateFormat.yMd().format(_dateOfBirth));
    _genderController = TextEditingController(text: _gender);
    _bloodGroupController = TextEditingController(text: _bloodGroup);
    _heightController = TextEditingController(text: _height.toString());
    _weightController = TextEditingController(text: _weight.toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneNumberController.dispose();
    _dateOfBirthController.dispose();
    _genderController.dispose();
    _bloodGroupController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _dateOfBirth,
        firstDate: DateTime(1900),
        lastDate: DateTime.now());
    if (picked != null && picked != _dateOfBirth)
      setState(() {
        _dateOfBirth = picked;
        _dateOfBirthController.text =
            DateFormat.yMd().format(_dateOfBirth);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Save the changes to the user's profile
                final docuser = FirebaseFirestore.instance.collection('users').doc("id");
                docuser.update({
                  "name" : _name
                });
                _name = _nameController.text;
                _phoneNumber = _phoneNumberController.text;
                _gender = _genderController.text;
                _bloodGroup = _bloodGroupController.text;
                _height = int.parse(_heightController.text);
                _weight = int.parse(_weightController.text);
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: "Name"),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter your name";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _phoneNumberController,
                  decoration: InputDecoration(labelText: "Phone Number"),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter your phone number";
                    }
                    return null;
                  },
                ),
                GestureDetector(
                  onTap: () {
                    _selectDate(context);
                  },
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: _dateOfBirthController,
                      decoration: InputDecoration(
                          labelText: "Date of Birth",
                          suffixIcon: Icon(Icons.calendar_today)),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter your date of birth";
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                TextFormField(
                  controller: _genderController,
                  decoration: InputDecoration(labelText: "Gender"),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter your gender";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _bloodGroupController,
                  decoration: InputDecoration(labelText: "Blood Group"),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter your blood group";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _heightController,
                  decoration: InputDecoration(labelText: "Height (cm)"),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter your height";
                    }
                    if (int.tryParse(value) == null) {
                      return "Please enter a valid number";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _weightController,
                  decoration: InputDecoration(labelText: "Weight (kg)"),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter your weight";
                    }
                    if (int.tryParse(value) == null) {
                      return "Please enter a valid number";
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}