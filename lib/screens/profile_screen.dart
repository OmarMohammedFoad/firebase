import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/auth.dart';

// ignore: must_be_immutable
class ProfilePage extends StatelessWidget {
  final AuthService _auth = AuthService();
  final user = FirebaseAuth.instance.currentUser!;


  String? email = '';
  String? name = '';
  String? age = '';
  String? phone = '';
  String? isSelected='';

  ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {

    


    return Scaffold(
      resizeToAvoidBottomInset : false,
      body: SingleChildScrollView(
        child: Expanded(
          child: Column(
            children: [
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .where("uid", isEqualTo: user.uid)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    //Error Handling conditions
                    if (snapshot.hasError) {
                      return Text("Something went wrong");
                    }

                    if (snapshot.hasData) {
                      
                     
                      return ListView.builder(
                          itemCount: snapshot.data!.docs.length  ,
                          shrinkWrap: true,
                          itemBuilder: (context, i) {
                            var data = snapshot.data!.docs[i];
                            
                            email = data['email'];
                            name = data['fullname'];
                            age = data['age'];
                            isSelected = data['isSelected'];
//                        return Text("Full Name and Email: ${data['fullName']} ${data['email']}");
                            return Center(
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
                                                      ...ListTile.divideTiles(
                                                        color: Colors.grey,
                                                        tiles: [
                                                          ListTile(
                                                            leading:
                                                           const  Icon(Icons.email),
                                                            title:const  Text("Email"),
                                                            subtitle: Text(
                                                                email!),
                                                          ),
                                                          ListTile(
                                                            leading:
                                                            Icon(Icons.person),
                                                            title: Text("doctor"),
                                                            subtitle:
                                                            Text(isSelected!),
                                                          ),
                                                          ListTile(
                                                            leading:
                                                           const  Icon(Icons.person),
                                                            title: const Text("Age"),
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
            return   const  CircularProgressIndicator();
  }),
            const  SizedBox(
                height: 20,
              ),
              Center( child:
              user.displayName != null? 
             Column
          (
          mainAxisAlignment: MainAxisAlignment.center ,
          children: [
            CircleAvatar(
              radius:50 ,
              backgroundImage: NetworkImage(
                
               user.photoURL!
              ),
            ),
            const SizedBox(height: 10,),
            Text("Name : ${user.displayName!}" ),
           const SizedBox(height: 10,),
            // I Can not display the Email =>>>
            Text("Email : ${user.email}"),
            
          ],
        ) : const Text("")
             ,
             
             ),
            const SizedBox(height: 22,),
              Center(child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.black,borderRadius: BorderRadius.circular(22)),
                child: MaterialButton(onPressed: () async {
                        
                        await _auth.signOut();
                      }, child:Text(
                        "Logout",
                        style: TextStyle(color: Theme
                .of(context)
                .primaryColorLight),
                        textAlign: TextAlign.center,
                      ), ),
              )),
              
            ],
          ),
        ),
      ),
    );
  }
}
