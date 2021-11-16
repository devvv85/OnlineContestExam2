import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onlineexamcontest/Constants/MyColor.dart';
import 'package:onlineexamcontest/Constants/uidata.dart';
import 'package:onlineexamcontest/Dashboard/MainDashboard.dart';
import 'package:onlineexamcontest/Login/Forgotpassword.dart';
import 'package:onlineexamcontest/Login/Registration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

SharedPreferences prefs;

class pro extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() => new _State();
}

class _State extends State<pro>
{
  bool isLoading = true;
  @override
  Widget build(BuildContext context) {
    final loginTitle = Container(
      margin: const EdgeInsets.only(left: 29.0, right: 29, top: 110),

      color: Colors.black.withOpacity(.4),
      child: Center(
        child: Container(
            margin: const EdgeInsets.only(left: 25.0, right: 25),
            child: Opacity(
                opacity: 0.5,
                child: Container(
                  height: 45,
                  margin: const EdgeInsets.only(left: 30, right: 30, top: 30),
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 24,
                      color: MyColor.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ))),
      ),
    );



    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: ListView(
          children: <Widget>[
            //loginTitle,
             isLoading
                ? Align(
               alignment: Alignment.center,
              child: CircularProgressIndicator(),)

               :loginTitle


          ],
        ),
      ),
    );
  }

///api call phone_no:admin

}
