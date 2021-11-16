import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onlineexamcontest/Constants/MyColor.dart';
import 'package:onlineexamcontest/Constants/uidata.dart';
import 'package:onlineexamcontest/Login/Registration.dart';
import 'package:onlineexamcontest/Login/login5.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

String userId1, otp1;
final interval = const Duration(seconds: 1);
final int timerMaxSeconds = 30;
int currentSeconds = 0;
bool click=false,isFinish=false;  var otp="";  String mob1 = "";
String get timerText => '${((timerMaxSeconds - currentSeconds) ~/ 60).toString().padLeft(2, '0')}: ${((timerMaxSeconds - currentSeconds) % 60).toString().padLeft(2, '0')}';
class NewPass extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() => new _State();
  NewPass(String userid, String otp, String mob)
  {
    userId1 = userid;
    otp1 = otp;
    mob1 = mob;
  }
}

class _State extends State<NewPass>
{
  TextEditingController otpController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();
  bool _showPassword = false, isLoading = false;

  void initState()
  {
    setState(()
    {
      //Toast.show(otp1, context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      click=false;
    });
  }

  startTimeout([int milliseconds])
  {
    var duration = interval;
    Timer.periodic(duration, (timer)
    {
      setState(()
      {
        print(timer.tick);
        currentSeconds = timer.tick;
        if (timer.tick >= timerMaxSeconds)
        {
          timer.cancel();
          click = false;
          isFinish=true;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final logo = Container(
        margin: const EdgeInsets.only(left: 20.0, right: 20, top: 130),
        child: Container(
                margin: const EdgeInsets.only(top: 20),
                width: 75,
                height: 75,
                child: Image.asset('assets/images/key.png')));
    final Title = Container(
      margin: const EdgeInsets.only(left: 20.0, right: 20,top: 5),

      child: Center(
        child: Container(
           // margin: const EdgeInsets.only(left: 25.0, right: 25),
            child: Container(
                  height: 45,
                //  margin: const EdgeInsets.only(left: 30, right: 30, top: 10),
                  child: Text(
                    'New Password',
                    style: TextStyle(
                      fontSize: 24,
                      color: MyColor.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )),
      ),
    );
    final otp = Container(
        margin: const EdgeInsets.only(left: 20.0, right: 0),
        child: Row(children: <Widget>[
              Expanded(
                  flex: 6,
                  child: Container(
                    height: 45,
                    margin: const EdgeInsets.only(left: 25, right: 0, top: 10),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: otpController,
                      decoration: new InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 1.0),
                        ),
                        labelStyle: new TextStyle(color: Colors.black),
                        labelText: 'Otp',
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  )),
             Visibility(visible:click,
               child: Expanded(
                  flex: 4,
                  child: Align(
                      alignment: Alignment.centerLeft,

                     child: Container(
                          height: 44,
                          margin: const EdgeInsets.only(
                              left: 0, right: 0, bottom: 0, top: 10),
                          child: RaisedButton(
                            textColor: Colors.white,
                            color: MyColor.yellow,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: MyColor.yellow,
                                    width: 1,
                                    style: BorderStyle.solid),
                                borderRadius: BorderRadius.circular(2)),
                          /*  child: Text(click==false?
                              'RESEND OTP': timerText,*/
                            child:Text(timerText,
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                            ),
                          ),

                            onPressed: () {
                              setState(() {
                                click==true;

                                startTimeout();
                              });

                            },
                          ))
                      ),




                  ),
             ),
              Visibility(visible:!click,child: Expanded(
                flex: 4,
                child: Align(
                    alignment: Alignment.centerLeft,

                    child: Container(
                        height: 44,
                        margin: const EdgeInsets.only(
                            left: 0, right: 0, bottom: 0, top: 10),
                        child: RaisedButton(
                          textColor: Colors.white,
                          color: MyColor.yellow,
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: MyColor.yellow,
                                  width: 1,
                                  style: BorderStyle.solid),
                              borderRadius: BorderRadius.circular(2)),
                          /*  child: Text(click==false?
                              'RESEND OTP': timerText,*/
                          child:Text(
                          'RESEND OTP',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                            ),
                          ),

                          onPressed: () {
                            setState(() {
                              click=true;
                              apiOtpSend(mob1);
                              startTimeout();
                            });

                          },
                        ))
                ),




              ),
              ),
            ]));

    final otp3 = Container(
        margin: const EdgeInsets.only(left: 20.0, right: 20),
        color: Colors.black.withOpacity(.4),

            child: Container(
              height: 45,
              margin: const EdgeInsets.only(left: 25, right: 25, top: 10),
              child: TextField(
                keyboardType: TextInputType.number,
                controller: otpController,
                decoration: new InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.0),
                  ),
                  labelStyle: new TextStyle(color: Colors.black),
                  labelText: 'Otp',
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ));

    final otp1 = Container(
        margin: const EdgeInsets.only(left: 29.0, right: 29),
        color: Colors.black.withOpacity(.4),
        child: Opacity(
            opacity: 0.9,
            child: InkWell(
              onTap: () {},
              child: Column(
                children: <Widget>[
                  Container(
                    //  margin: EdgeInsets.all(10.0),
                    child: Row(
                      children: <Widget>[
                        Container(
                          margin:
                              const EdgeInsets.only(left: 7, right: 7, top: 5),
                          child: Expanded(
                            flex: 7,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  height: 45,
                                  margin: const EdgeInsets.only(
                                      left: 25, right: 25, top: 10),
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    controller: otpController,
                                    decoration: new InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.white70, width: 2.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.black, width: 1.0),
                                      ),
                                      labelStyle:
                                          new TextStyle(color: Colors.black),
                                      labelText: 'Otp',
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                  ),
                                ),
                                /* SizedBox(
                                  height: 5.0,
                                ),*/
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  child: Text('RESEND OTP',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 5,
                                      style: new TextStyle(
                                        fontSize: 10.0,
                                        color: Colors.black45,
                                        fontWeight: FontWeight.bold,
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )));
    final password = Container(
        margin: const EdgeInsets.only(left: 20.0, right: 20),


            child: Container(
              height: 45,
              margin: const EdgeInsets.only(left: 25, right: 25, top: 7),
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
              margin: const EdgeInsets.only(left: 25, right: 25, top: 7),
              child: TextField(
                obscureText: !this._showPassword,
                controller: confirmpasswordController,
                decoration: new InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                  labelStyle: new TextStyle(color: Colors.black),
                  /* decoration: InputDecoration(
                  border: OutlineInputBorder(),*/
                  labelText: ' Confirm Password *',
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
                    onPressed: ()
                    {
                      setState(() => this._showPassword = !this._showPassword);
                    },
                  ),
                ),
              ),
            ));
    final getotpbtn = Container(
        margin: const EdgeInsets.only(left: 20.0, right: 20,top: 20),
     //   color: Colors.black.withOpacity(.4),
        child: Container(
            height: 42,
            margin:const EdgeInsets.only(left: 25, right: 25, bottom: 40, top: 15),
            child: RaisedButton(
              textColor: Colors.white,
              color: MyColor.yellow,
              shape: RoundedRectangleBorder(
                  side: BorderSide(
                      color:  MyColor.yellow, width: 1, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(2)),
              child: Text(
                'Next',
                style: TextStyle(
                  fontSize: 19,
                  color: Colors.white,
                  fontWeight: FontWeight.bold
                ),
              ),
              onPressed: () {
                if (otpController.text.isEmpty) {
                  Toast.show("Please enter Otp", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                } else if (passwordController.text.isEmpty) {
                  Toast.show("Please enter New password", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                } else if (confirmpasswordController.text.isEmpty) {
                  Toast.show("Please enter confirm password", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                } else if (passwordController.text !=
                    confirmpasswordController.text) {
                  Toast.show(
                      "Confirm password doesn't match with password", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                } else {
                  setState(() {
                    isLoading = true;
                  });
                  if(isFinish)
                  {
                    otpController.clear();
                    apiUpdatepass("000", passwordController.text, userId1);
                  }
                  else
                    {
                      apiUpdatepass(otpController.text, passwordController.text, userId1);
                    }
                }
              },
            )));
    final informationtext = Container(
      margin: const EdgeInsets.only(left: 15.0, right: 15, top: 10),
      child: Center(
        child: Container(
            margin: const EdgeInsets.only(left: 25.0, right: 25),
            child: Container(
              height: 45,
              margin: const EdgeInsets.only(left: 10, right: 10, top: 30),
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

      child: Scaffold(
        backgroundColor: MyColor.themecolor,
        body: ListView(
          children: <Widget>[
            logo,
            Title,
            otp,
            // otp1,
            password,
            confirmpassword,
            isLoading
                ? Container(
                    margin: const EdgeInsets.only(left: 29.0, right: 29),
                  //  color: Colors.black.withOpacity(.4),
                    child: Align(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(),
                    ),
                  )
                : getotpbtn,
           // informationtext,
          ],
        ),
      ),
    );
  }

  apiUpdatepass(String otp, pass, userid) async {
    isFinish=false;
    Map data = {"otp": otp, "password": pass, "user_id": userid};
    print(data);
    var jsonData = null;
    var response = await http.post(uidata.resetpassword, body: data);

    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      var status = jsonData['status'];
      var msg = jsonData['Message'];

      print(jsonData);
      setState(() {
        isLoading = false;
      });
      if (status == "1")
      {
        Toast.show(msg, context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        setState(()
        {

          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginPage()), (route) => false);
        });
      } else {
        isLoading=false;
        Toast.show(msg, context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    } else {}
  }
  apiOtpSend(String mob) async
  {
    Map data = {"phone_no": mob1};
    print(data);
    var jsonData = null;
    var response = await http.post(uidata.forgotpassword, body: data);

    if (response.statusCode == 200)
    {
      jsonData = json.decode(response.body);
      var status = jsonData['status'];
      var msg = jsonData['Message'];

      print(jsonData);
      setState(()
      {
        isLoading=false;
      });
      if (status == "1")
      {
        Toast.show(msg, context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        setState(()
        {
          String user_id=jsonData['user_id'];
          otp = jsonData['otp'];
       //   Toast.show(otp, context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        });
      } else {
        Toast.show(msg, context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    } else {  //5511
  }

}

}
