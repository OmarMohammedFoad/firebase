import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/loginuser.dart';
import '../services/auth.dart';
import 'TermsAndConditionsDialog.dart';
import 'package:intl/intl.dart';


class RegistrationScreen extends StatefulWidget {
  final Function? toggleView;

  RegistrationScreen({this.toggleView});

  @override
  State<StatefulWidget> createState() {
    return _RegistrationScreen();
  }
}

class _RegistrationScreen extends State<RegistrationScreen> {
  @override
  void initState() {
    super.initState();
    _fetchDoctors();
    _dateOfBirthController = TextEditingController(
        text: DateFormat.yMd().format(dateTime));
  }

  bool _showAdditionalFields = false;

  final AuthService _auth = AuthService();
  bool? _isChecked = false;
  String imageUrl = '';

  bool _obscureText = true;
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _fullName = TextEditingController();
  final _age = TextEditingController();
  final _mobileNumber = TextEditingController();
  TextEditingController _dateOfBirthController = TextEditingController();
  final _weight = TextEditingController();
  final _height = TextEditingController();
  final _bloodGroup = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<dynamic> _items = [];

  DateTime dateTime = DateTime(2023, 12, 24);

  String? _gender;
  String? _selectedItem;
  XFile? image;
  String? ss;

  Future<void> _fetchDoctors() async {
    final QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('users')
        .where('role', isEqualTo: 'Doctor')
        .get();
    final List<dynamic> doctors = snapshot.docs
        .map((doc) => {
              'id': doc.id,
              'name': doc.data()['name'],
            })
        .toList();
    setState(() {
      _items = doctors;
    });
  }

  Future<DateTime?> pickDate() => showDatePicker(
      context: context,
      initialDate: dateTime,
      firstDate: DateTime(1900),
      lastDate: DateTime(2050));

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: dateTime,
        firstDate: DateTime(1900),
        lastDate: DateTime.now());
    if (picked != null && picked != dateTime)
      setState(() {
        dateTime = picked;
        _dateOfBirthController.text =
            DateFormat.yMd().format(dateTime);
      });
  }

  @override
  Widget build(BuildContext context) {
    final gender = DropdownButtonFormField<String>(
      value: _gender,
      decoration: InputDecoration(
        labelText: 'Gender',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
      ),
      items: ['Male', 'Female'].map((gender) {
        return DropdownMenuItem(
          value: gender,
          child: Text(gender),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _gender = value;
        });
      },
      validator: (value) {
        if (value == null) {
          return 'Please select your gender';
        }
        return null;
      },
    );

    final nameField = TextFormField(
      controller: _fullName,
      autofocus: false,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          labelText: "Full Name",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    Future getImage() async {
      image = await ImagePicker().pickImage(source: ImageSource.gallery);

      setState(() {
        // print(_image.toString());
        print('Image Path ${image?.path}');
      });
    }

    final ageField = TextFormField(
      controller: _age,
      autofocus: false,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          labelText: "Age",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final weightField = TextFormField(
      controller: _weight,
      autofocus: false,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          labelText: 'Weight',
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
      keyboardType: TextInputType.number,
    );

    final heightField = TextFormField(
      controller: _height,
      autofocus: false,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          labelText: 'Height',
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
      keyboardType: TextInputType.number,
    );

    final bloodField = TextFormField(
      controller: _bloodGroup,
      autofocus: false,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          labelText: 'Blood Group',
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final mobileField = TextFormField(
      controller: _mobileNumber,
      autofocus: false,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          labelText: "Mobile Number",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final Terms = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("I accept the terms and conditions"),
        Row(
          children: [
            Checkbox(
              value: _isChecked,
              onChanged: (newValue) {
                setState(() {
                  _isChecked = newValue!;
                });
              },
            ),
            InkWell(
                child: const Text(
                  'Read the terms and conditions',
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        TermsAndConditionsDialog(),
                  );
                })
          ],
        )
      ],
    );

    final emailField = TextFormField(
        controller: _email,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        validator: (value) {
          if (value != null) {
            if (value.contains('@') && value.endsWith('.com')) {
              return null;
            }
            return 'Enter a Valid Email Address';
          }
        },
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            labelText: "Email",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))));

    final passwordField = TextFormField(
        obscureText: _obscureText,
        controller: _password,
        autofocus: false,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'This field is required';
          }
          // Return null if the entered password is valid
          return null;
        },
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            labelText: "Password",
            suffixIcon: IconButton(
              icon:
                  Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            ),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))));

    final profilepicture =
        Column(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
      const SizedBox(
        height: 20.0,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: CircleAvatar(
              radius: 100,
              backgroundColor: Color.fromARGB(255, 236, 239, 250),
              child: ClipOval(
                child: SizedBox(
                  width: 180.0,
                  height: 180.0,
                  child: (image != null)
                      ? Image.file(
                          File(image!.path),
                          fit: BoxFit.fill,
                        )
                      : Image.network(
                          "https://wallpapercave.com/wp/wp9566480.png",
                          fit: BoxFit.fill,
                        ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 60.0),
            child: IconButton(
              icon: const Icon(
                Icons.camera_alt,
                size: 30.0,
              ),
              onPressed: () {
                getImage();
              },
            ),
          ),
        ],
      )
    ]);

    final loginTextButton = TextButton(
        onPressed: () {
          widget.toggleView!();
        },
        child: const Text('Go to login'));

    final birthdayText = GestureDetector(
      onTap: () {
        _selectDate(context);
      },
      child: AbsorbPointer(
        child: TextFormField(
          controller: _dateOfBirthController,
          decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
              labelText: '${dateTime.year}/${dateTime.month}/${dateTime.day}',
              suffixIcon: Icon(Icons.calendar_today)),
          /*validator: (value) {
            if (value!.isEmpty) {
              return "Please enter your date of birth";
            }
            return null;
          },*/
        ),
      ),
    );

    final additionalDataButton = ElevatedButton(
      onPressed: () {
        setState(() {
          _showAdditionalFields = !_showAdditionalFields;
        });
      },
      style: ElevatedButton.styleFrom(
        elevation: 5,
        backgroundColor: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      child: Text(
        _showAdditionalFields ? 'Hide More' : 'Add More',
        style: TextStyle(color: Theme.of(context).primaryColorLight),
        textAlign: TextAlign.center,
      ),
    );

    final registerButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Theme.of(context).primaryColor,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            String uniqueFileName =
                DateTime.now().millisecondsSinceEpoch.toString();

            /*Step 2: Upload to Firebase storage*/
            //Install firebase_storage
            //Import the library

            //Get a reference to storage root
            Reference referenceRoot = FirebaseStorage.instance.ref();
            Reference referenceDirImages = referenceRoot.child('images');

            //Create a reference for the image to be stored
            Reference referenceImageToUpload =
                referenceDirImages.child(uniqueFileName);

            //Handle errors/success
            try {
              //Store the file
              await referenceImageToUpload.putFile(File(image!.path));
              //Success: get the download URL
              imageUrl = await referenceImageToUpload.getDownloadURL();
            } catch (error) {
              //Some error occurred
            }
            Timestamp timestamp = Timestamp.fromDate(dateTime);

            dynamic result = await _auth.registerEmailPassword(
              LoginUser(email: _email.text, password: _password.text),
              _fullName.text.trim(),
              _mobileNumber.text.trim(),
              _email.text.trim(),
              //_age.text.trim(),
              timestamp,
              _weight.text.trim(),
              _height.text.trim(),
              _bloodGroup.text.trim(),
              _gender!.trim(),
              _selectedItem.toString(),
              imageUrl,
              false,
            );
            if (result.uid == null) {
              //null means unsuccessfull authentication
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Text(result.code),
                    );
                  });
            }
          }
        },
        child: Text(
          "Register",
          style: TextStyle(color: Theme.of(context).primaryColorLight),
          textAlign: TextAlign.center,
        ),
      ),
    );

    final dropList = Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.shade400,
          width: 10.0,
        ),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: DropdownButton<String>(
        value: _selectedItem,
        icon: Icon(Icons.add_box),
        iconDisabledColor: Colors.black,
        items: _items.map((value) {
          return DropdownMenuItem<String>(
            value: value["id"],
            child: Text(value["name"]),
          );
        }).toList(),
        onChanged: (selectedItem) {
          setState(() {
            print(_selectedItem);
            _selectedItem = selectedItem;
          });
        },
      ),
    );

    final text = Text(
      "choose the doctor",
      style: TextStyle(
        fontSize: 15.5,
        color: Colors.black87,
        fontWeight: FontWeight.bold,
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Registration Demo Page'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: ListView(children: [
        Form(
          autovalidateMode: AutovalidateMode.always,
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                profilepicture,
                const SizedBox(height: 45.0),
                nameField,
                const SizedBox(height: 25.0),
                mobileField,
                const SizedBox(height: 25.0),
                birthdayText,
                const SizedBox(height: 25.0),
                emailField,
                const SizedBox(height: 25.0),
                passwordField,
                const SizedBox(height: 35.0),
                Center(
                  child: Row(
                    children: [
                      text,
                      const SizedBox(width: 35.0),
                      dropList //  droplist,
                    ],
                  ),
                ),
                const SizedBox(height: 25.0),
                Terms,
                const SizedBox(height: 35.0),
                additionalDataButton,
                if (_showAdditionalFields)
                  Column(
                    children: [
                      const SizedBox(height: 15.0),
                      weightField,
                      const SizedBox(height: 15.0),
                      heightField,
                      const SizedBox(height: 15.0),
                      bloodField,
                      const SizedBox(height: 15.0),
                      gender,
                      const SizedBox(height: 15.0),
                    ],
                  ),
                const SizedBox(height: 35.0),
                loginTextButton,
                const SizedBox(height: 15.0),
                registerButton,
                const SizedBox(height: 15.0),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
