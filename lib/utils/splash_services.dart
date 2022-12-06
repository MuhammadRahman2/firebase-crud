import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../ui/auth/login_screen.dart';
import '../ui/firestore_data/home_screen.dart';
import '../ui/realtime_database/home_screen.dart';

class SplashServies {

  void login(BuildContext context) {
  final auth = FirebaseAuth.instance;
  final user = auth.currentUser;
  if (user != null){
    Timer(const Duration(seconds: 3), () {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ));
    });
  }else{
    Timer(const Duration(seconds: 3), () {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ));
    });
  }
    
  }
}
