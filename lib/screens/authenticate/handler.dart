import 'package:flutter/material.dart';

import '../login_screen.dart';
import '../registration_screen.dart';
import '../widgets/onBoarding.dart';

class Handler extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Handler();
  }
}

class _Handler extends State<Handler> {

  bool showSignin = true;

  void toggleView(){
    setState(() {
      showSignin = !showSignin;
    });
  }
  @override
  Widget build(BuildContext context) {
    if(showSignin)
    {
      return onBoadring();
    }else
    {
      return RegistrationScreen(toggleView : toggleView);
    }
  }
}