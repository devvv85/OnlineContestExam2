import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:onlineexamcontest/Constants/MyColor.dart';
import 'package:onlineexamcontest/Constants/uidata.dart';
import 'package:onlineexamcontest/Dashboard/MainDashboard.dart';
import 'package:onlineexamcontest/Login/Forgotpassword.dart';
import 'package:onlineexamcontest/Login/Registration.dart';
import 'package:onlineexamcontest/Login/StartScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

import '../app_termsandconditions.dart';

SharedPreferences prefs;
String email, pass, loginnm, loginemail,photourl;
class LoginPage extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() => new _State();
}

class _State extends State<LoginPage> {
  TextEditingController mobileController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _showPassword = false;
  bool isLoading = false;
  String islogin = "false";
  String token = "";
  bool _isLoggedIn = false;
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  var devicetoken;
  SharedPreferences prefs;
  _login() async {
    try {
      await _googleSignIn.signIn();
      setState(()
      async {
      //  _isLoggedIn = true;
        loginnm = _googleSignIn.currentUser.displayName;
        loginemail = _googleSignIn.currentUser.email;
        photourl = _googleSignIn.currentUser.photoUrl;
        prefs = await SharedPreferences.getInstance();
        setState(() {
          token = prefs.getString('devicetoken');
          print('token1 $token');
        });
        apiGoogleLogin(loginemail,token,loginnm);
      });
    } catch (err) {
      print("errorrrr>>$err");
    }
  }
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

  _logout() {
    _googleSignIn.signOut();
    setState(()
    {
      _isLoggedIn = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    final loginTitle = Container(
     // color: MyColor.themecolor,
      margin: const EdgeInsets.only( bottom: 25),
    //  margin: const EdgeInsets.only(left: 20.0, right: 20, top: 10),
      /*   margin: const EdgeInsets.only(top: 140),*/
      //color: Colors.black.withOpacity(.4),
      child: Center(
        child: Container(
           // height: 200,
            margin: const EdgeInsets.only(left: 25.0, right: 25,top: 90),
            /*child: Opacity(
              opacity: 0.9,*/
              child: Container(
                      width: 150,
                      height: 140,
                      child: Image.asset('assets/images/logonew.png')),
           // )
      ),
      ),
    );
    final mobileNo = Container(
        margin: const EdgeInsets.only(left: 15.0, right: 15),


        child: Container(
          height: 65,
          margin: const EdgeInsets.only(left: 15, right: 15, top:20),
          child: TextField(
            maxLength: 10,
            keyboardType: TextInputType.number,
            controller: mobileController,
            decoration: new InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 1.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 1.0),
              ),
              labelStyle: new TextStyle(color: Colors.black),
              labelText: 'Mobile No. *',
              filled: true,

              fillColor: Colors.white,
            ),
          ),
        ));
    final password = Container(
        margin: const EdgeInsets.only(left: 15.0, right: 15),
        child: Container(
          height: 45,
          margin: const EdgeInsets.only(left: 15, right: 15, top:10),
          child: TextField(
            obscureText: !this._showPassword,
            controller: passwordController,
            decoration: new InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 1.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1.0),
              ),
              labelStyle: new TextStyle(color: Colors.black),
              labelText: 'Password *',
              filled: true,
              fillColor: Colors.white,
              suffixIcon: IconButton(
                icon: Icon(
                  Icons.remove_red_eye,
                  color: this._showPassword ? Colors.black : Colors.grey,
                ),
                onPressed: () {
                  setState(() => this._showPassword = !this._showPassword);
                },
              ),
            ),
          ),
        ));

/*    final password = Container(
        margin: const EdgeInsets.only(left: 15.0, right: 15),

            child: Container(
              color: Colors.white,
              height: 45,
              margin: const EdgeInsets.only(left: 15.0, right: 15,top: 10),
              child: TextField(
                obscureText: !this._showPassword,
                controller: passwordController,
                decoration: new InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                  labelStyle: new TextStyle(color: Colors.black),
                  labelText: 'Password*',
                  filled: true,
                  fillColor: Colors.white,
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.remove_red_eye,
                      color: this._showPassword ? Colors.black : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() => this._showPassword = !this._showPassword);
                    },
                  ),
                ),
              ),
            ))*/;

    final forgoypasswordtitle1 = Container(
        margin: const EdgeInsets.only(left: 29.0, right: 25,top: 5),
        //color: Colors.black.withOpacity(.4),
        child: Container(
            margin: const EdgeInsets.only(right: 0),
            child: Row(
              children: <Widget>[
                Opacity(
                    opacity: 0.9,
                    child: FlatButton(
                      child: Text(
                        'Forgot password',
                        style: TextStyle(
                          fontSize: 19,
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Forgotpass()),);
                      },
                    ))
              ],
              mainAxisAlignment: MainAxisAlignment.end,
            )));
    final loginbtn = Container(
        margin: const EdgeInsets.only(left: 17.0, right: 17),
        // color: Colors.black.withOpacity(.4),
        child: Container(
            height: 44,
            margin: const EdgeInsets.only(left: 17, right: 17, bottom: 10,top: 30),
            child: RaisedButton(
              textColor: Colors.white,
              color: MyColor.yellow,
              shape: RoundedRectangleBorder(
                  side: BorderSide(
                      color: MyColor.yellow, width: 1, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(6)),
              child: Text(
                'Log in',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              onPressed: () async {
                if (mobileController.text.isEmpty) {
                  Toast.show("Please enter mobile no.", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                } else if (mobileController.text.length < 10 ||
                    mobileController.text.length > 10) {
                  Toast.show("Please enter 10 digit mobile No.", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                } else if (passwordController.text.isEmpty) {
                  Toast.show("Please enter password", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                } else {
                  setState(() {
                    isLoading = true;
                  });
                  prefs = await SharedPreferences.getInstance();
                  setState(() {
                    token = prefs.getString('devicetoken');
                    print('token1 $token');
                  });
                  if (token == null) {
                    token = "";
                  } else {
                    apiLogin(
                        mobileController.text, passwordController.text, token);
                  }
                }
              },
            )));
    final registertitle1 = Container(
        margin: const EdgeInsets.only(top: 0),
        child: Row(
          children: <Widget>[
            Opacity(
                opacity: 0.9,
                child: FlatButton(
                  /*   textColor: MyColor.colorprimary,*/
                  child: Text(
                    'New User ? Register here',
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.black,
                      // fontWeight: FontWeight.bold
                    ),
                  ),
                  onPressed: () {
                    //signup screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Registration()),
                    );
                  },
                ))
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ));

    final registertitle2 = Container(
        margin: const EdgeInsets.only(top: 0),
        child: Row(
          children: <Widget>[
            Opacity(
                opacity: 0.9,
                child: FlatButton(
                  /*   textColor: MyColor.colorprimary,*/
                  child: Text(
                    'New User ? Register here',
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.black,
                      // fontWeight: FontWeight.bold
                    ),
                  ),
                  onPressed: () {
                    //signup screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Registration()),
                    );
                  },
                ))
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ));

    final registertitle = Container(
        margin: const EdgeInsets.only(left: 10.0, right: 10, top: 40),
        child: Row(
      children: <Widget>[
/*        Text(
          'New User ?',
          *//*style: TextStyle(fontSize: 17),*//*
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),*/
        FlatButton(
          textColor: Colors.blue,
          child: Text(
            'Sign up',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          onPressed: () {

            Navigator.push(context, MaterialPageRoute(builder: (context) => Registration()));
          },
        )
      ],
      mainAxisAlignment: MainAxisAlignment.center,
    ));

    final informationtext = Container(
      margin: const EdgeInsets.only(left: 10.0, right: 10, top: 100),
      child: Center(
        child: Container(
            margin: const EdgeInsets.only(left: 20.0, right: 20, top: 10),
            child: Container(
                child: RichText(
                  text: TextSpan(
                    text: "By continuing, you agree to Dream Quiz Privacy Policy and ",
                    style: TextStyle( fontSize: 16,color: Colors.white),
                    children: <TextSpan>[
                      TextSpan(
                          text: 'Terms and Conditions',
                    style: TextStyle( fontSize: 16,color: Colors.white,fontWeight: FontWeight.bold),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () =>
                            Navigator.push(context, MaterialPageRoute(
                            builder: (context) => MyHomePage55())),)


                    ],
                  ),
                )
            )),
      ),
    );





    final glogin =  Container(
     // color: Colors.pink,
      height: 45,
        margin: EdgeInsets.only(left: 35.0,right:35.0),
        child:SignInButton(Buttons.Google,
      padding: EdgeInsets.only(top: 0,left: 17.0,right:17.0),
      //  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      mini: false,
      onPressed: () async {
        //_showButtonPressDialog(context, 'Google');
        prefs = await SharedPreferences.getInstance();
        setState(() {
          token = prefs.getString('devicetoken');
          //print('token1 $a');
        });
        _login();
      },
    ) );
    final register =Container(
        height: 44,
        margin: const EdgeInsets.only(left: 34.0, right: 34),
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Registration()),);
          },
        ));
    return Container(
     /* decoration: BoxDecoration(
        image: DecorationImage(
          //image: AssetImage('assets/images/background.png'),
          image: AssetImage('assets/images/img1.JPEG'),
          fit: BoxFit.cover,
        ),
      ),*/
      child: Scaffold(
         backgroundColor: MyColor.themecolor,
           // backgroundColor: Colors.white54,
      /*  appBar: AppBar(
          title: Text('Login'),
          backgroundColor: MyColor.themecolor,
        ),*/
        body: ListView(
          children: <Widget>[
            loginTitle,
            mobileNo,
            password,
            forgoypasswordtitle1,
            isLoading
                ? Container(
                    margin: const EdgeInsets.only(left: 29.0, right: 29),
                    // color: Colors.black.withOpacity(.4),
                    child: Align(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(),
                    ),
                  )
                : loginbtn,
           // glogin,
           /// registertitle,
            register,
            informationtext,
          ],
        ),
      ),
    );
  }

  ///api call phone_no:admin
// password:12345
  apiLogin(String mob, String pass, String token) async
  {
    Map data =
    {
      "phone_no": mob,
      "password": pass,
      "device_token": token,
      "device_type": "android"
    };
    print("paralogin$data");
    var jsonData = null;
    var response = await http.post(uidata.login, body: data);

    if(response.statusCode == 200)
    {
      jsonData = json.decode(response.body);
      var status = jsonData['status'];
      var msg = jsonData['Message'];
      var token = "Token "+jsonData['token'];
      print("Logintoken$token");
      print("responce$jsonData");
      if (status == "1")
      {
        setState(()
        {
          isLoading = false;
        });

        addIsLoginTrueToSF();
        Toast.show(msg, context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        var uId = jsonData['id'].toString();

        prefs = await SharedPreferences.getInstance();
        setState(()
        {
          print("aaaasaaaaaalo $token");
          islogin = "true";
          prefs.setString('uId', uId);
          prefs.setString('isLogin', islogin);
          prefs.setString('token', token);
          prefs.setString('newVersion',jsonData['newVersion'].toString().trim().replaceAll(".", ""));




          prefs.setBool('start', true);
          Navigator.of(context).pop();
          Navigator.push(context, MaterialPageRoute(builder: (context) => MainDashboard(uId, true)));
        });
      } else {
        setState(() {
          isLoading = false;
        });
        Toast.show(msg, context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
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

    if (response.statusCode == 200)
    {
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
       print("gtoken>>$tokennew");
       prefs = await SharedPreferences.getInstance();
       prefs.setString('uName', uName);
       prefs.setString('uId', uId);
       prefs.setString('token', tokennew);
       prefs.setString('newVersion',jsonData['newVersion'].toString().trim().replaceAll(".", ""));
       prefs.setString('isLogin', islogin);
       prefs.setBool('start', true);
       Navigator.push(context, MaterialPageRoute(builder: (context) => MainDashboard(uId, true)));
     });

      } else {
        Toast.show(msg, context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    } else {}
  }

}
