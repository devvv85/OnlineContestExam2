import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onlineexamcontest/Dashboard/MainDashboard.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'Dashboard/HomePage1.dart';
import 'Login/StartScreen.dart';
import 'Login/login5.dart';
FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
var devicetoken;SharedPreferences prefs;

class SplashPage1 extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<SplashPage1> {
  @override
  void initState() {
    super.initState();

    _firebaseMessaging.getToken().then((token)
    async {

      prefs = await SharedPreferences.getInstance();
      setState(()
      {
        devicetoken=token;
        prefs.setString('devicetoken',devicetoken);
        print('Token>>>>$devicetoken');

      });
    });
    Timer(Duration(seconds: 3), () => _isLogin());
  }

  @override
  Widget build(BuildContext context) {
/*
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/images/startscreen.JPEG',
          width: 320,
          height: 280,
        ),
      ),
    );
*/
    return new Scaffold(
      body: new Image.asset(
        'assets/images/startscreen.JPEG',
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.center,
      ),
    );
  }



  _isLogin()
  async {
    prefs = await SharedPreferences.getInstance();
    String islogin=prefs.getString('isLogin');
    if(islogin=="true")
      {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainDashboard(prefs.getString('uId'),true)));
      }
    else
      {

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => StartscreeenPage()));
      }


  }


}
