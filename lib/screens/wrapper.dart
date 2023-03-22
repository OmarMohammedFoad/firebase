import 'package:firebase/screens/upload_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/firebaseuser.dart';
import 'authenticate/handler.dart';
import 'home.dart';
import '../screens/profile_screen.dart';

class Wrapper extends StatelessWidget{
  const Wrapper({super.key});


  @override
  Widget build(BuildContext context) {

    final user =  Provider.of<FirebaseUser?>(context);
    // print(user);

    if(user == null)
    {
      return Handler();
    }else
    {
      return Home();
    }
  }
}