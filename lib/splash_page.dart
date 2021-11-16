import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onlineexamcontest/Dashboard/MainDashboard.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'Constants/MyColor.dart';
import 'Dashboard/HomePage1.dart';
import 'Login/StartScreen.dart';
import 'Login/login5.dart';

FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
var devicetoken;
SharedPreferences prefs;

class SplashPage extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    _firebaseMessaging.getToken().then((token) async {
      prefs = await SharedPreferences.getInstance();
      setState(() {
        devicetoken = token;
        prefs.setString('devicetoken', devicetoken);
        print('Token>>>>$devicetoken');
      });
    });
    Timer(Duration(seconds: 8), () => _isLogin());
  }

  /*@override
  Widget build(BuildContext context) {*/
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
/*    return new Scaffold(
      body: new Image.asset(
        'assets/images/startscreen.JPEG',
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.center,
      ),
    );
  }*/

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: MyColor.themecolor,
        body: Column(children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Container(
                margin: const EdgeInsets.only(top: 200.0),
                child: Image.asset(
                  'assets/images/logoanimate.GIF',
                  fit: BoxFit.cover,
                  height: 250,
                  width: 290,
                  alignment: Alignment.center,
                )),
          ),
          Container(
              margin: const EdgeInsets.only(left: 25.0, right: 25),
              child: Opacity(
                opacity: 0.9,
                child: Container(
                    child: Text(
                  'Dream Quiz',
                  style: TextStyle(
                    color: MyColor.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                )),
              ))
        ]));
  }

  _isLogin() async {
    prefs = await SharedPreferences.getInstance();
    String islogin = prefs.getString('isLogin');
    if (islogin == "true") {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  MainDashboard(prefs.getString('uId'), true)));
    } else {
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => StartscreeenPage()));
    }
  }
}
