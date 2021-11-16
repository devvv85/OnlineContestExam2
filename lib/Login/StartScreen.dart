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

class StartscreeenPage extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() => new _State();
}

class _State extends State<StartscreeenPage> {
  TextEditingController mobileController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _showPassword = false;
  bool isLoading = false;
  String islogin = "false";
  String token = "";
  bool _isLoggedIn = false;
  //GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  var devicetoken;
  SharedPreferences prefs;
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

  }

  _login() async {
    try {
      GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
      await _googleSignIn.signIn();
      setState(() async {
        _isLoggedIn = true;
        loginnm = _googleSignIn.currentUser.displayName;
        loginemail = _googleSignIn.currentUser.email;
        photourl = _googleSignIn.currentUser.photoUrl;
        prefs = await SharedPreferences.getInstance();
        setState(()
        {
          token = prefs.getString('devicetoken');
          print('token1 $token');
        });
        apiGoogleLogin(loginemail, token, loginnm);
      });
    } catch (err) {
      print("errorrrr>>$err");
    }
  }

/*  _logout() {
    _googleSignIn.signOut();
    setState(() {
      _isLoggedIn = false;
    });
  }*/


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Column(children: <Widget>[
      Container(
        color: MyColor.themecolor,
        child: Center(
          child: Container(
              height: 260,
              margin: const EdgeInsets.only(left: 25.0, right: 25),
              child: Opacity(
                opacity: 0.9,
                child: Container(
                    width: 150,
                    height: 140,
                    child: Image.asset('assets/images/logonew.png')),
              )),
        ),
      ),
      Expanded(  child: Center(
        child: Container(
          child: ListView(children: <Widget>[
             Container(
                height: 49,
                margin: const EdgeInsets.only(top:70,left: 67, right: 67, bottom: 10),
                child: RaisedButton(
                  textColor: Colors.black,
                  color: MyColor.white,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: MyColor.yellow, width: 2, style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(6)),
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 19,
                      color: Colors.black,fontWeight:FontWeight.bold
                    ),
                  ),
                  onPressed: ()  {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Registration()),);

                  },
                )),
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
                    'Log in',
                    style: TextStyle(
                        fontSize: 19,
                        color: Colors.black,fontWeight:FontWeight.bold
                    ),
                  ),
                  onPressed: ()  {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),);
                  },
                )),

          ]),
        ),
      ),),
     Container(

          margin: const EdgeInsets.only(left: 25.0, right: 25),
          child: Opacity(
            opacity: 0.9,
            child: Container(
                child: Text(
              'Login with',
              style: TextStyle(
                color: MyColor.themecolor,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            )),
          )),
        GestureDetector(
            onTap: () async {
              //_showButtonPressDialog(context, 'Google');
              prefs = await SharedPreferences.getInstance();
              setState(() {
                token = prefs.getString('devicetoken');
                //print('token1 $a');
              });
              _login();
            },
            child: Container(
          height: 40,
          margin: const EdgeInsets.only(left: 25.0, right: 25,bottom: 10),
          child: Container(
                    child: Container(
                        width: 40,
                        height: 40,
                        child: Image.asset('assets/images/loginlogo.png'))),),
              )

      /*  Expanded(
              child: Container(
                color: Colors.blueGrey,
              )
          ),*/
    ]));
  }

  ///api call phone_no:admin
// password:12345
  apiLogin(String mob, String pass, String token) async {
    Map data = {
      "phone_no": mob,
      "password": pass,
      "device_token": token,
      "device_type": "android"
    };
    print("paralogin$data");
    var jsonData = null;
    var response = await http.post(uidata.login, body: data);

    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      var status = jsonData['status'];
      var msg = jsonData['Message'];
      print(jsonData);
      if (status == "1") {
        setState(() {
          isLoading = false;
        });

        addIsLoginTrueToSF();
        Toast.show(msg, context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        var uId = jsonData['id'].toString();

        prefs = await SharedPreferences.getInstance();
        setState(() {
          islogin = "true";
          prefs.setString('uId', uId);
          prefs.setString('isLogin', islogin);
          prefs.setBool('start', true);
          Navigator.push(context, MaterialPageRoute(builder: (context) => MainDashboard(uId, true)));
        });
      } else {
        setState(() {
          isLoading = false;
        });
        Toast.show(msg, context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  addIsLoginTrueToSF() async {
    prefs = await SharedPreferences.getInstance();
    prefs.setBool('SFIsLogin', true);
  }

  apiGoogleLogin(String email, String token,String nm) async {
    Map data = {"email": email, "device_type": "android", "device_token": token,"name":nm};
    print(data);
    var jsonData = null;
    var response = await http.post(uidata.social_login, body: data);

    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      var status = jsonData['status'];
      var msg = jsonData['Message'];
      var tokennew = "Token "+jsonData['token'];
      print("loginres>>$jsonData");
      if (status == "1")
      {
        setState(() async {
          Toast.show(msg, context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          var uId = jsonData['user_id'];
          var uName = nm;
          islogin = "true";
          print("aaaasaaaaaalo $tokennew");
          print("gtoken>>$tokennew");
          prefs = await SharedPreferences.getInstance();
          prefs.setString('uName', uName);
          prefs.setString('uId', uId);
          prefs.setString('token', tokennew);
          prefs.setString('isLogin', islogin);
          prefs.setBool('start', true);
          prefs.setBool('_isLoggedIn', true);
          Navigator.push(context, MaterialPageRoute(builder: (context) => MainDashboard(uId, true)));
        });



      } else {
        Toast.show(msg, context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    } else {}
  }
}
