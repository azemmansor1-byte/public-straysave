import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:straysave/models/user.dart' as suser;
import 'package:straysave/screens/splash.dart';
import 'package:straysave/screens/home/home.dart';
//import 'package:straysave/screens/home/home.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<suser.User?>(context);
    debugPrint(user?.uid);

    //return either Home or Authenticate widget
    if(user == null){
      return SplashScreen();
    } else {
      return Home();
    }
  }
}