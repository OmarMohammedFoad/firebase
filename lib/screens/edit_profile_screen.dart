import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class EditProfileScreen extends StatefulWidget {

  final docId, image, name, number, email, gender, height, weight, bloodGroup;

  EditProfileScreen({this.docId, this.image, this.name, this.number, this.email, this.gender,
  this.height, this.weight, this.bloodGroup});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  String _gender = "";


  TextEditingController _emailController = TextEditingController();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  TextEditingController _bloodGroupController = TextEditingController();
  TextEditingController _heightController = TextEditingController();
  TextEditingController _weightController = TextEditingController();
  final ImagePicker picker = ImagePicker();

  File? image;


  @override
  void initState() {
    super.initState();
    _nameController.text = widget.name;
    _phoneNumberController.text = widget.number;
    _emailController.text = widget.email;
    _genderController.text = widget.gender;
    _gender = widget.gender;
    _bloodGroupController.text = widget.bloodGroup;
    _heightController.text = widget.height;
    _weightController.text = widget.weight;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    _genderController.dispose();
    _bloodGroupController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future pickImage() async {
    final upload = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      image = File(upload!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("Edit Profile", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                if(image == null){
                  FirebaseFirestore.instance
                      .collection("users")
                      .doc(widget.docId)
                      .update({
                    "name": _nameController.text,
                    "number": _phoneNumberController.text,
                    "gender": _gender,
                    "imgurl": widget.image.toString(),
                    "bloodGroup": _bloodGroupController.text,
                    "weight": _weightController.text,
                    "height": _heightController.text,
                  });
                }else{
                  final Reference storage =
                  FirebaseStorage.instance
                      .ref()
                      .child("${_nameController.text}.jpg");
                  final UploadTask task =
                  storage.putFile(image!);
                  print(task);
                  task.then((value) async {
                    String url =
                    (await storage.getDownloadURL())
                        .toString();
                    FirebaseFirestore.instance
                        .collection("users")
                        .doc(widget.docId)
                        .update({
                      "name": _nameController.text,
                      "number": _phoneNumberController.text,
                      "gender": _gender,
                      "imgurl": url,
                      "bloodGroup": _bloodGroupController.text,
                      "weight": _weightController.text,
                      "height": _heightController.text,
                    });
                  });
                }
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(
                    backgroundColor:
                    Theme.of(context).cardColor,
                    duration: Duration(seconds: 1),
                    content: Row(children: [
                      Icon(Icons.check,
                          color: Colors.white),
                      SizedBox(
                          width:
                          MediaQuery.of(context)
                              .size
                              .width *
                              0.04),
                      Text('Patient data edited successfully')
                    ])));
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
              children: [
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
                            width: 150.0,
                            height: 150.0,
                            child: (image == null)
                                ? Image.network(widget.image)
                                : Image.file(image!)
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
                          pickImage();
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15.0),
                Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                            labelText: "Name",
                            border:
                            OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter your name";
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      flex: 1,
                      child: TextFormField(
                        controller: _phoneNumberController,
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                            labelText: "Mobile Number",
                            border:
                            OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter your phone number";
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15.0),
                TextFormField(
                  controller: _emailController,
                  enabled: false,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      labelText: "Email",
                      border:
                      OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
                ),
                SizedBox(height: 15.0),
                SizedBox(height: 15.0),
                Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: TextFormField(
                        controller: _bloodGroupController,
                        decoration: InputDecoration(labelText: "Blood Group",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32.0)),),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter your blood group";
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      flex: 1,
                      child: DropdownButtonFormField<String>(
                        value: _gender,
                        decoration: InputDecoration(
                          labelText: 'Gender',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32.0)),
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
                            _gender = value!;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select your gender';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15.0),
                Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: TextFormField(
                        controller: _weightController,
                        decoration: InputDecoration(labelText: "Weight (kg)",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32.0)),
                          contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter your weight";
                          }
                          if (int.tryParse(value!) == null) {
                            return "Please enter a valid number";
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      flex: 1,
                      child: TextFormField(
                        controller: _heightController,
                        decoration: InputDecoration(labelText: "Height (cm)",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32.0)),
                          contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),),
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
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}