import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:onlineexamcontest/Constants/MyColor.dart';
import 'package:onlineexamcontest/Constants/uidata.dart';
import 'package:onlineexamcontest/Dashboard/MainDashboard.dart';
import 'package:onlineexamcontest/Login/Forgotpassword.dart';
import 'package:onlineexamcontest/Login/Registration.dart';
import 'package:onlineexamcontest/Login/login5.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

SharedPreferences prefs;
String email, pass, loginnm, loginemail, photourl,tokennew;
String msg="",flag;
class paymentDone extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() => new _State();
  paymentDone(String s,String f)
  {
    msg=s;
    flag=f;
  }
}

class _State extends State<paymentDone> {

  @override
  void initState() {
    super.initState();



  }



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: ()
    {

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) =>  MainDashboard(userId,true)),
              (route) => false);
      return Future.value(true);
    },
    child:Scaffold(
        body: Column(children: <Widget>[
          Container(
            color: MyColor.themecolor,
            child: Center(
              child: Container(
                  height: 260,
            margin: const EdgeInsets.only(left: 25.0, right: 25),
            child: Icon(
                    Icons.account_balance_wallet_rounded,
                    color: Colors.white,
                    size: 75,
                  ),
),
            ),
          ),
          Expanded(  child: Center(
            child: Container(
              child: ListView(children: <Widget>[
                 Visibility(visible: flag=="true",child:Container(
                  width: 100,
                  height: 50,
                  child: Image.asset('assets/images/check.png')),
                 ),
                Visibility(visible: flag=="false",child:Container(
                    margin: const EdgeInsets.only(bottom: 10,top: 40),
                    width: 40,
                    height: 40,
                    child: Image.asset('assets/images/info.png'),),


                ),

                Container(

                    margin: const EdgeInsets.only(left: 67, right: 67, bottom: 40),
                  child: Align(
                    alignment: Alignment.center,child: Text(
                    msg,
                    style: TextStyle(
                        fontSize: 19,
                        color: Colors.black,fontWeight:FontWeight.bold
                    ),),
                  ),),
                Container(
                    height: 49,
                    margin: const EdgeInsets.only(top:10,left: 67, right: 67, bottom: 10),
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: MyColor.yellow,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: MyColor.yellow, width: 2, style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(6)),
                      child: Text(
                        'Done',
                        style: TextStyle(
                            fontSize: 19,
                            color: Colors.black,fontWeight:FontWeight.bold
                        ),
                      ),
                      onPressed: ()  {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => MainDashboard(userId,true)));
                      },
                    )),

              ]),
            ),
          ),),



        ])));
  }


}
