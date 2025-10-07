import 'package:flutter/material.dart';
import 'package:straysave/screens/authenticate/register.dart';
import 'package:straysave/screens/authenticate/sign_in.dart';

class Authenticate extends StatefulWidget {
  final bool startWithSignIn;

  const Authenticate({super.key, this.startWithSignIn = true});

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  late bool showSignIn;

  @override
  void initState() {
    super.initState();
    showSignIn = widget.startWithSignIn;
  }

  void toggleView(){
    setState(() => showSignIn = !showSignIn);
  }


  @override
  Widget build(BuildContext context) {
    if(showSignIn){
      return SignIn(toggleView: toggleView);
    } else {
      return Register(toggleView: toggleView);
    }
  }
}