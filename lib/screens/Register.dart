import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/models/TermsAndConditionsDialog%5B1%5D.dart';
import 'package:flutter/material.dart';

import '../models/loginuser.dart';
import '../services/auth.dart';


class Register extends StatefulWidget {
  final Function? toggleView;

  Register({this.toggleView});

  @override
  State<StatefulWidget> createState() {

    return _Register();

  }


}


class _Register extends State<Register> {
  final AuthService _auth = AuthService();
    bool? _isChecked = false;


  @override
  void initState() {
    super.initState();
    _fetchDoctors();
  }

  bool _obscureText = true;
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _fullName = TextEditingController();
  final _age = TextEditingController();
  final _mobileNumber = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<dynamic> _items = [];


  String? _selectedItem;
  String? ss;


  Future<void> _fetchDoctors() async {
    final QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'Doctor')
        .get();
    final List<dynamic> doctors = snapshot.docs.map((doc) =>{ 'id': doc.id,
      'name': doc.data()['name'],}).toList();
    setState(() {
      _items = doctors;
    });
  }





  @override
  Widget build(BuildContext context) {
    final nameField = TextFormField(
      controller: _fullName,
      autofocus: false,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Full Name",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final ageField = TextFormField(
      controller: _age,
      autofocus: false,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Age",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final mobileField = TextFormField(
      controller: _mobileNumber,
      autofocus: false,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Mobile Number",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final  Terms = Column(
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
          child:const  Text(
            'Read the terms and conditions',
            style: TextStyle(decoration: TextDecoration.underline),
          ),
        
        onTap: () {
              showDialog(
              context: context,
              builder: (BuildContext context) => TermsAndConditionsDialog( 
                               
              ),
            );}
        )

            ],
          )
        ],
    );
    final emailField = TextFormField(
        controller: _email,
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
            hintText: "Email",
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
            hintText: "Password",
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

    final txtbutton = TextButton(
        onPressed: () {
          widget.toggleView!();
        },
        child: const Text('Go to login'));

    final registerButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Theme.of(context).primaryColor,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            dynamic result = await _auth.registerEmailPassword(
                LoginUser(email: _email.text, password: _password.text),
                _fullName.text.trim(),
                _mobileNumber.text.trim(),
                _email.text.trim(),
                _age.text.trim(),
                _selectedItem.toString(),
                _selectedItem.toString()
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

    final droplist =  Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.shade400,
          width: 10.0,
        ),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child:   DropdownButton<String>(
        value: _selectedItem,
        icon: Icon(Icons.add_box),
        iconDisabledColor:Colors.black ,
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

    final  text =  Text("choose the doctor",style:   TextStyle(
      fontSize: 15.5 ,
      color: Colors.black87,
      fontWeight: FontWeight.bold,

    ),);


    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Registration Demo Page'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: ListView(
          children: [Form(
            autovalidateMode: AutovalidateMode.always,
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 45.0),
                  nameField,
                  const SizedBox(height: 25.0),
                  mobileField,
                  const SizedBox(height: 25.0),
                  ageField,
                  const SizedBox(height: 25.0),
                  emailField,
                  const SizedBox(height: 25.0),
                  passwordField,
                  const SizedBox(height: 35.0),
                  Center(
                    child: Row(children: [
                      text,
                      const SizedBox(width: 35.0),
                      droplist//  droplist,
                    ],),
                  ),

                  const SizedBox(height: 25.0),
                  txtbutton,
                  const SizedBox(height: 35.0),
                  Terms,
                  const SizedBox(height: 35.0),
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