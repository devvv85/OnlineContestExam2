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

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _State();
}

class _State extends State<LoginPage> {
  TextEditingController mobileController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _showPassword = false;
  bool isLoading = false;
String islogin="false";String token = "";
  @override
  Widget build(BuildContext context) {
    final loginTitle = Container(
      margin: const EdgeInsets.only(left: 29.0, right: 29, top: 110),
      /*   margin: const EdgeInsets.only(top: 140),*/
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
    final mobileNo =
    Container(
        margin: const EdgeInsets.only(left: 29.0, right: 29),
        color: Colors.black.withOpacity(.4),
        child: Opacity(
            opacity: 0.5,
            child:
            Container(
              height: 45,
              margin: const EdgeInsets.only(left: 25, right: 25, top: 20),
              child: TextField(
                keyboardType: TextInputType.number,
                controller: mobileController,
                /*   decoration: InputDecoration(
                  border: OutlineInputBorder(),*/
                decoration: new InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                  labelStyle: new TextStyle(color: Colors.black),
                  /* decoration: InputDecoration(
                  border: OutlineInputBorder(),*/

                  labelText: 'Mobile No. *',
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            )));
    final password = Container(
        margin: const EdgeInsets.only(left: 29.0, right: 29),
        color: Colors.black.withOpacity(.5),
        child: Opacity(
            opacity: 0.5,
            child: Container(
              height: 45,
              margin: const EdgeInsets.only(left: 25, right: 25, top: 10),
              child: TextField(
                obscureText: !this._showPassword,
                controller: passwordController,

                /*  decoration: new InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black, width: 0.0),
                    ),
                    border: const OutlineInputBorder(),
                    labelStyle: new TextStyle(color: Colors.black),*/
                decoration: new InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                  labelStyle: new TextStyle(color: Colors.black),
                  /* decoration: InputDecoration(
                  border: OutlineInputBorder(),*/
                  labelText: 'Password *',
                  hintStyle: TextStyle(
                    fontSize: 20.0,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  //prefixIcon: Icon(Icons.security),
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
            )));

    final forgottitle = Container(
      margin: const EdgeInsets.only(left: 29.0, right: 29),
      color: Colors.black.withOpacity(.4),
      child: Container(
          margin: const EdgeInsets.only(left: 25.0, right: 25),
          child: Opacity(
              opacity: 0.5,
              child: Container(
                margin: const EdgeInsets.only(left: 30, top: 10, bottom: 10),
                child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Forgot password',
                      style: TextStyle(
                        fontSize: 15,
                        color: MyColor.white,
                      ),
                    )),
              ))),
    );
    final forgoypasswordtitle1 = Container(
        margin: const EdgeInsets.only(left: 29.0, right: 29),
        color: Colors.black.withOpacity(.4),
        child: Container(
            margin: const EdgeInsets.only(right: 15),
            child: Row(
              children: <Widget>[
                FlatButton(
                  child: Text(
                    'Forgot password',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Forgotpass()),
                    );
                  },
                )
              ],
              mainAxisAlignment: MainAxisAlignment.end,
            )));
    final loginbtn =
    Container(
        margin: const EdgeInsets.only(left: 29.0, right: 29),
        color: Colors.black.withOpacity(.4),
        child: Container(
            height: 45,
            margin: const EdgeInsets.only(left: 30, right: 30, bottom: 40),
            child: RaisedButton(
              textColor: Colors.white,
              color: Colors.black,
              shape: RoundedRectangleBorder(
                  side: BorderSide(
                      color: MyColor.white, width: 1, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(2)),
              child: Text(
                'Login',
                style: TextStyle(
                  fontSize: 19,
                  color: Colors.white,
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

                  // Navigator.push(context, MaterialPageRoute(builder: (context) => DashboardActivity("","","1")),);
                  if (token == null) {
                    token = "";
                  }
                  else {
                    apiLogin(mobileController.text, passwordController.text,token);
                  }
                }
              },
            )));
    final registertitle = Container(
        margin: const EdgeInsets.only(top: 20),
        child: Row(
      children: <Widget>[
        FlatButton(
          /*   textColor: MyColor.colorprimary,*/
          child: Text(
            'New User ? Register here',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
          onPressed: ()
          {
            //signup screen
            Navigator.push(context,MaterialPageRoute(builder: (context) => Registration()),
            );
          },
        )
      ],
      mainAxisAlignment: MainAxisAlignment.center,
    ));

/* Container(
  margin: const EdgeInsets.only(left: 25.0, right: 25, top: 10),
  child: Center(
    child: Container(
        margin: const EdgeInsets.only(left: 25.0, right: 25),

            child: Container(
              height: 45,
              margin: const EdgeInsets.only(left: 30, right: 30, top: 10),
             */ /* child: Text(
                'New User ? Register here',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,

                ),
              ),
              onPressed: () {
                //signup screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Registration()),
                );
              },*/ /*
            ),

            )
    ),
  ),*/
//);
    final informationtext = Container(
      margin: const EdgeInsets.only(left: 15.0, right: 15, top: 10),
      child: Center(
        child: Container(
            margin: const EdgeInsets.only(left: 25.0, right: 25),
            child: Container(
              height: 45,
              margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
              child: Text(
                "By continuing, you agree to online exam contest's Privacy Policy and Terms Of Service",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
            )),
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
            registertitle,
            informationtext,
          ],
        ),
      ),
    );
  }

  ///api call phone_no:admin
// password:12345
  apiLogin(String mob, String pass,String token) async {
    Map data = {"phone_no": mob, "password": pass,"device_token":token,"device_type":"android"};
    print("paralogin$data");
    var jsonData = null;
    var response = await http.post(uidata.login, body: data);

    if (response.statusCode == 200)
    {
      jsonData = json.decode(response.body);
      var status = jsonData['status'];
      var msg = jsonData['Message'];

      print(jsonData);
      if (status == "1")
      {
        setState(() {
          isLoading = false;
        });

        addIsLoginTrueToSF();
        Toast.show(msg, context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        var uId = jsonData['id'].toString();

        prefs = await SharedPreferences.getInstance();
        setState(() {
          islogin="true";
          prefs.setString('uId', uId);
          prefs.setString('isLogin', islogin);
          prefs.setBool('start', true);
          Navigator.push(context, MaterialPageRoute(builder: (context) => MainDashboard(uId,true)));
        });
      } else {
        setState(()
        {
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
}
