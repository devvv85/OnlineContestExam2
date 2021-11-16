import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:onlineexamcontest/Constants/MyColor.dart';
import 'package:onlineexamcontest/Constants/uidata.dart';
import 'package:onlineexamcontest/Login/RegisterOtp.dart';
import 'package:onlineexamcontest/Login/login5.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:wc_form_validators/wc_form_validators.dart';

import '../app_termsandconditions.dart';

Validators validators;
class Registration extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _State();
}

class _State extends State<Registration> {
  TextEditingController uNmController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpassController = TextEditingController();
  TextEditingController refcontactController = TextEditingController();

  bool _showPassword = false;
  bool _showPassword1 = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final registerTitle = Container(
      margin: const EdgeInsets.only(left: 29.0, right: 29, top: 30),
      /*   margin: const EdgeInsets.only(top: 140),*/
    //  color: Colors.black.withOpacity(.4),
      child: Center(
        child: Container(
            margin: const EdgeInsets.only(left: 25.0, right: 25),

                child: Container(
                  height: 45,
                  margin: const EdgeInsets.only(left: 30, right: 30, top: 15),
                  child: Text(
                    'Register',
                    style: TextStyle(
                      fontSize: 24,
                      color: MyColor.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )),
      ),
    );
    final userName = Container(
        margin: const EdgeInsets.only(left: 20.0, right: 20),

        child: Container(
              height: 45,
              margin: const EdgeInsets.only(left: 25, right: 25, top: 5),
              child: TextField(
                keyboardType: TextInputType.text,
                controller: uNmController,
                decoration: new InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                  labelStyle: new TextStyle(color: Colors.black),
                  labelText: 'User Name *',
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ));
    final mobileNo = Container(
        margin: const EdgeInsets.only(left: 20.0, right: 20),


            child: Container(
              height: 63,
              margin: const EdgeInsets.only(left: 25, right: 25, top: 10),
              child: TextField(
                maxLength: 10,
                keyboardType: TextInputType.number,
                controller: mobileController,
                decoration: new InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                  labelStyle: new TextStyle(color: Colors.black),
                  labelText: 'Mobile No. *',
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ));
    final emailid = Container(
        margin: const EdgeInsets.only(left: 20.0, right: 20),

            child: Container(
              height: 45,
              margin: const EdgeInsets.only(left: 25, right: 25, top: 10),
              child: TextField(
                keyboardType: TextInputType.text,
                controller: emailController,
                decoration: new InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                  labelStyle: new TextStyle(color: Colors.black),
                  labelText: 'Email Address *',
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ));
    final password = Container(
        margin: const EdgeInsets.only(left: 20.0, right: 20),

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
            ));
    final confirmpassword = Container(
        margin: const EdgeInsets.only(left: 20.0, right: 20),
        child: Container(
              height: 45,
              margin: const EdgeInsets.only(left: 25, right: 25, top: 10),
              child: TextField(
                obscureText: !this._showPassword1,
                controller: confirmpassController,
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
                  labelText: 'Confirm Password *',
                  hintStyle: TextStyle(
                    fontSize: 20.0,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  //prefixIcon: Icon(Icons.security),
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.remove_red_eye,
                      color: this._showPassword1 ? Colors.black : Colors.grey,
                    ),
                    onPressed: () {
                      setState(
                          () => this._showPassword1 = !this._showPassword1);
                    },
                  ),
                ),
              ),
            ));

    final referalcontact = Container(
        margin: const EdgeInsets.only(left: 20.0, right: 20),
         child: Container(
              height: 45,
              margin: const EdgeInsets.only(left: 25, right: 25, top: 10),
              child: TextField(
                keyboardType: TextInputType.number,
                controller: refcontactController,
                decoration: new InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                  labelStyle: new TextStyle(color: Colors.black),
                  labelText: 'Refferal Contact No.',
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ));
    final loginbtn = Container(
        margin: const EdgeInsets.only(left: 20.0, right: 20),
        child: Container(
            height: 45,
            margin:
                const EdgeInsets.only(left: 25, right: 25, top: 30, bottom: 7),
            child: RaisedButton(
              textColor: Colors.white70,
              color: MyColor.yellow,
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: MyColor.white, width: 1, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(2)),
              child: Text(
                'Register',
                style: TextStyle(
                  fontSize: 19,
                  color: Colors.white,
                ),
              ),
              onPressed: () {

                bool emailValid = RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    .hasMatch(emailController.text);
                print(emailValid);
                if (uNmController.text.isEmpty) {
                  Toast.show("Please enter name", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                } else if (mobileController.text.isEmpty) {
                  Toast.show("Please enter mobile No.", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                } else if (mobileController.text.length < 10 ||
                    mobileController.text.length > 10) {
                  Toast.show("Please enter 10 digit mobile No.", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                }
                else if (emailController.text.isEmpty)
                {
                  Toast.show("Please enter email", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                }
                else if (emailValid == false)
                {
                  Toast.show("Please enter valid email", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                }

                else if (passwordController.text.isEmpty)
                {
                  Toast.show("Please enter password", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                } else if (confirmpassController.text.isEmpty) {
                  Toast.show("Please enter confirm password", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                } else if (passwordController.text !=
                    confirmpassController.text) {
                  Toast.show(
                      "Confirm password doesn't match with password", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                } else {
                  /* if( refcontactController.text.isEmpty)
                    {
                      refcontactController.text="NA";
                      str
                    }*/
                  setState(() {
                    isLoading = true;
                  });
                  apiRegister(
                      uNmController.text,
                      mobileController.text,
                      emailController.text,
                      passwordController.text,
                      refcontactController.text);
                }
              },
            )));
    final registertitle = Container(
        margin: const EdgeInsets.only(left: 29.0, right: 29,bottom: 20),

        child: Container(
            child: Row(
          children: <Widget>[
            Text(
              'Existing user ?',
              /*style: TextStyle(fontSize: 17),*/
              style: TextStyle(fontSize: 17,color: Colors.white),
            ),
            FlatButton(
              textColor: Colors.white,
              child: Text(
                'Login here',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              onPressed:()
              {

                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginPage()), (route) => false);
              },
            )
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        )));
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

    return Container(
    /*  decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/img1.JPEG'),
          fit: BoxFit.cover,
        ),
      ),*/

      child: Scaffold(
      //  backgroundColor: MyColor.themecolor,
     /*   appBar: AppBar(
          title: Text('Registration'),
          backgroundColor: MyColor.themecolor,
        ),*/
        backgroundColor: MyColor.themecolor,
        body: ListView(
          children: <Widget>[
            registerTitle,
            userName,
            mobileNo,
            emailid,
            password,
            confirmpassword,
            referalcontact,
            isLoading
                ? Container(
                    margin: const EdgeInsets.only(left: 29.0, right: 29),
               //     color: Colors.black.withOpacity(.4),
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

  //api call

  apiRegister(String nm, String mob, String email, String pass, String refContact) async {
    Map data = {
      "username": nm,
      "phone_no": mob,
      "email": email,
      "password": pass,
      "referal_contact": refContact
    };
    print(data);
    var jsonData = null;
    var response = await http.post(uidata.signup, body: data);

    if (response.statusCode == 200)
    {
      jsonData = json.decode(response.body);
      var status = jsonData['status'];
      var msg = jsonData['Message'];

      print(jsonData);
      print('status $status');
      if (status == "1")
      {

        setState(()
        {
          setState(()
          {
            isLoading = false;
          });
          var otp = jsonData['otp'];
          String user_id = jsonData['user_id'];
          Toast.show(msg, context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RegisterOtp(user_id, otp,mob)),
          );
         // clearfields();
        });
      } else {
        setState(()
        {
          isLoading = false;
        });
        Toast.show(msg, context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    } else {}
  }

  clearfields() {
    uNmController.clear();
    mobileController.clear();
    emailController.clear();
    passwordController.clear();
    confirmpassController.clear();
    refcontactController.clear();
  }
}
