import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/auth.dart';
import 'edit_profile_screen.dart';

class ProfilePage extends StatelessWidget {
  final currentUser = FirebaseAuth.instance;
  final AuthService _auth = AuthService();
  final user = FirebaseAuth.instance.currentUser!;

  String? patientId = '';
  String? email = '';
  String? name = '';
  String? age = '';
  String? phone = '';
  String? img = '';
  String? gender = "";
  String? bloodType = "";
  String? height = "";
  String? weight = "";
  DateTime? _dateOfBirth;
  int? _age;


  @override
  Widget build(BuildContext context) {
    final SignOut = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Theme.of(context).primaryColor,
      child: MaterialButton(
        minWidth: MediaQuery
            .of(context)
            .size
            .width,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 25.0, 15.0),
        onPressed: () async {
          await _auth.signOut();
        },
        child: Text(
          "Logout",
          style: TextStyle(color: Theme
              .of(context)
              .primaryColorLight),
          textAlign: TextAlign.center,
        ),
      ),
    );

    final GoogleSignOut = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Theme.of(context).primaryColor,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
          await _auth.signOutWithGoogle();
        },
        child: Text(
          "Logout",
          style: TextStyle(color: Theme
              .of(context)
              .primaryColorLight),
          textAlign: TextAlign.center,
        ),
      ),
    );

    void _calculateAge() {
      final now = DateTime.now();
      final age = now.year - _dateOfBirth!.year;
      if (now.month < _dateOfBirth!.month ||
          (now.month == _dateOfBirth!.month && now.day < _dateOfBirth!.day)) {
        _age = age - 1;
      } else {
        _age = age;
      }
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .where("uid", isEqualTo: currentUser.currentUser!.uid)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  //Error Handling conditions
                  if (snapshot.hasError) {
                    return const  Text("Something went wrong");
                  }
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemBuilder: (context, i) {
                          var data = snapshot.data!.docs[i];
                          patientId = data['uid'];
                          email = data['email'];
                          name = data['name'];
                          //age = data['age'];
                          img = data['imgurl'];
                          gender = data['gender'];
                          height = data['height'];
                          weight = data['weight'];
                          bloodType = data['bloodGroup'];
                          phone = data['number'];
                          final dobTimestamp = data['dateOfBirth'] as Timestamp?;
                          if (dobTimestamp != null) {
                            _dateOfBirth = dobTimestamp.toDate();
                            _calculateAge();
                          }
                          return Center(
                            child: Container(
                              margin: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 50,
                                    backgroundColor:
                                        Color.fromARGB(255, 236, 239, 250),
                                    child: ClipOval(
                                      child: SizedBox(
                                        width: 190.0,
                                        height: 190.0,
                                        child: Image.network(
                                          img!,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        name!,
                                        style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        EditProfileScreen(
                                                          docId: patientId,
                                                          image: img,
                                                          name: name,
                                                          email: email,
                                                          //age: _age.toString(),
                                                          //timestamp: _dateOfBirth,
                                                          number: phone,
                                                          gender: gender,
                                                          weight: weight,
                                                          height: height,
                                                          bloodGroup: bloodType,
                                                        )));
                                          },
                                          icon: Icon(Icons.edit)),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          padding: const EdgeInsets.only(
                                              left: 8.0, bottom: 4.0),
                                          alignment: Alignment.topLeft,
                                          child:const  Text(
                                            "User Information",
                                            style: TextStyle(
                                              color: Colors.black87,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                        Card(
                                          child: Container(
                                            alignment: Alignment.topLeft,
                                            padding: EdgeInsets.all(15),
                                            child: Column(
                                              children: <Widget>[
                                                Column(
                                                  children: <Widget>[
                                                    ...ListTile.divideTiles(
                                                      color: Colors.grey,
                                                      tiles: [
                                                        ListTile(
                                                          leading:
                                                          Icon(Icons.email),
                                                          title: Text("Email"),
                                                          subtitle: Text(
                                                              email!),
                                                        ),
                                                        ListTile(
                                                          leading:
                                                          Icon(Icons.phone),
                                                          title: Text("Phone"),
                                                          subtitle:
                                                          Text(phone!),
                                                        ),
                                                        ListTile(
                                                          leading: Icon(
                                                              Icons.numbers),
                                                          title: Text("Age"),
                                                          subtitle: Text(_age.toString()),
                                                        ),
                                                        ListTile(
                                                          leading: Icon(
                                                              Icons.person),
                                                          title: Text("gender"),
                                                          subtitle: gender!
                                                                  .isEmpty
                                                              ? Text("")
                                                              : Text(gender!),
                                                        ),
                                                        ListTile(
                                                          leading:
                                                          Icon(Icons.height),
                                                          title: Text("height"),
                                                          subtitle:
                                                          height!.toString().isEmpty? Text("") :Text(height.toString()!),
                                                        ),
                                                        ListTile(
                                                          leading:
                                                          Icon(Icons.height),
                                                          title: Text("weight"),
                                                          subtitle:
                                                          weight!.toString().isEmpty? Text("") :Text(weight.toString()!),
                                                        ),
                                                        ListTile(
                                                          leading:
                                                          Icon(Icons.bloodtype),
                                                          title: Text("BloodType"),
                                                          subtitle:
                                                          bloodType!.isEmpty? Text("") :Text(bloodType!),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                  }

                  return const CircularProgressIndicator();
                }),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: user.displayName != null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding:
                              const EdgeInsets.only(left: 20.0, bottom: 4.0),
                          alignment: Alignment.topLeft,
                          child: const Text(
                            "User Information",
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Card(
                          child: Container(
                            alignment: Alignment.topLeft,
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 20,
                                    ),
                                    CircleAvatar(
                                      radius: 50,
                                      backgroundColor:
                                          Color.fromARGB(255, 236, 239, 250),
                                      child: ClipOval(
                                        child: SizedBox(
                                          width: 190.0,
                                          height: 190.0,
                                          // child: Image.network(
                                          //   user.photoURL!,
                                          //   fit: BoxFit.fill,
                                          // ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      user.displayName!,
                                      style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    ...ListTile.divideTiles(
                                      color: Colors.grey,
                                      tiles: [
                                        ListTile(
                                          leading: const Icon(Icons.email),
                                          title: const Text("Email"),
                                          subtitle: Text(user.email!),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    )
                  : const Text(""),
            ),
            user.displayName != null
                ? Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: Center(child: SignOut),
                )
                : Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: Center(child: SignOut),
                )
          ],
        ),
      ),
    );
  }
}