import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/screens/Login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../services/auth.dart';

class ProfilePage extends StatelessWidget {
  final currentUser = FirebaseAuth.instance;
  final AuthService _auth = AuthService();
    final user = FirebaseAuth.instance.currentUser!;


  String? email = '';
  String? name = '';
  String? age = '';
  String? phone = '';
  String? img = '';

  @override
  Widget build(BuildContext context) {
    final SignOut = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Theme
          .of(context)
          .primaryColor,
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
      color: Theme
          .of(context)
          .primaryColor,
      child: MaterialButton(
        minWidth: MediaQuery
            .of(context)
            .size
            .width,
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


    return Scaffold(
      resizeToAvoidBottomInset : false,
      body: SingleChildScrollView(
<<<<<<< Updated upstream
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
          
                        itemBuilder: (context, i) {
                          var data = snapshot.data!.docs[i];
                          email = data['email'];
                          name = data['name'];
                          age = data['age'];
                          img=data['imgurl'];
                          
                          phone = data['number'];
          //                        return Text("Full Name and Email: ${data['fullName']} ${data['email']}");
                          return Center(
                          
                            child: Container(
                              margin: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                   CircleAvatar(
                                            radius: 50,
                                            backgroundColor:Color.fromARGB(255, 236, 239, 250),
                                            child: ClipOval(
                                              child:   SizedBox(
                                                width: 190.0,
                                                height: 190.0,
                                                child: Image.network(
                              img!,                            
                                                  fit: BoxFit.fill,
=======
        child: Expanded(
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
                      return Text("Something went wrong");
                    }

                    if (snapshot.hasData) {
                            

                      return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          shrinkWrap: true,

                          itemBuilder: (context, i) {
                            print(context);
                            var data = snapshot.data!.docs[i];
                            email = data['email'];
                            name = data['name'];
                            age = data['age'];
                            phone = data['number'];
//                        return Text("Full Name and Email: ${data['fullName']} ${data['email']}");
                            return Expanded(
                              child: Center(
                                child: Container(
                                  margin: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        name!,
                                        style: TextStyle(
                                            fontSize: 22, fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0, bottom: 4.0),
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                "User Information",
                                                style: TextStyle(
                                                  color: Colors.black87,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16,
>>>>>>> Stashed changes
                                                ),
                                              ),
                                            ),
                                          ),
                                        
                                const  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    name!,
                                    style: const TextStyle(
                                        fontSize: 22, fontWeight: FontWeight.bold),
                                  ),
                                 const SizedBox( 
                                    height: 20,
                                  ),
                                  Container(
                                    padding:const  EdgeInsets.all(10),
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
                                                          leading:
                                                          Icon(Icons.person),
                                                          title: Text("Age"),
                                                          subtitle:
                                                          Text(age!),
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
            ), Center( child:
            user.displayName != null?
            
           Column
        (
        mainAxisAlignment: MainAxisAlignment.center ,
        children: [
          Container(
                                            padding: const EdgeInsets.only(
                                                left: 20.0, bottom: 4.0),
                                            alignment: Alignment.topLeft,
                                            child:const Text(
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
                                              padding:const  EdgeInsets.all(15),
                                              child: Column(
                                                children: <Widget>[
                                                  Column(
                                                    children: <Widget>[
                                                      SizedBox(
                                      height: 20,
                                    ),
                                      CircleAvatar(
                                            radius: 50,
                                            backgroundColor:Color.fromARGB(255, 236, 239, 250),
                                            child: ClipOval(
                                              child:   SizedBox(
                                                width: 190.0,
                                                height: 190.0,
                                                child: Image.network(
                              user.photoURL!,                            
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            ),
                                          ),
                                        
                                    Text(
                                      user.displayName!,
                                      style:const  TextStyle(
                                          fontSize: 22, fontWeight: FontWeight.bold),
                                    ),
                                                      ...ListTile.divideTiles(
                                                        color: Colors.grey,
                                                        tiles: [
                                                          ListTile(
                                                            leading:const 
                                                            Icon( Icons.email),
                                                            title:const  Text("Email"),
                                                            subtitle: Text(
                                                                user.email!),
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
        
        ) : const Text("")
           ,
           
           ),
           user.displayName != null?
           Center(child: GoogleSignOut,): Center(child:SignOut)
          ],
        ),
      ),
    );
  }
}
