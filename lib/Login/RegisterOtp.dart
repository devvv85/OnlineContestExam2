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
var user_id1,otp1;
final interval = const Duration(seconds: 1);
final int timerMaxSeconds = 30;
int currentSeconds = 0;
bool click=false,isFinish=false;  var otp="";  String mob1 = "";
String get timerText => '${((timerMaxSeconds - currentSeconds) ~/ 60).toString().padLeft(2, '0')}: ${((timerMaxSeconds - currentSeconds) % 60).toString().padLeft(2, '0')}';
class RegisterOtp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _State();

  RegisterOtp(var user_id,String otp,String mob)
  {
    user_id1 = user_id;
    otp1=otp;
    mob1=mob;

  }
}

class _State extends State<RegisterOtp> {
  TextEditingController otpController = TextEditingController();
  bool isLoading=false;

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
  Widget build(BuildContext context)
  {
    final Title = Container(
      margin: const EdgeInsets.only(left: 29.0, right: 29, top: 110),

      child: Center(
        child: Container(
            margin: const EdgeInsets.only(left: 25.0, right: 25),

                child: Container(
                  height: 45,
                  margin: const EdgeInsets.only(left: 30, right: 30, top: 20),
                  child: Text(
                    'Verification Code',
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
        margin: const EdgeInsets.only(left: 29.0, right: 29),
        color: Colors.black.withOpacity(.4),
        child: Opacity(
            opacity: 0.9,
            child: Container(
              height: 45,
              margin: const EdgeInsets.only(left: 25, right: 25, top: 10),
              child: TextField(
                keyboardType: TextInputType.number,
                controller: otpController,
                decoration: new InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                  labelStyle: new TextStyle(color: Colors.black),
                  labelText: 'OTP',
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            )));

    final nextbtn = Container(
        margin: const EdgeInsets.only(left: 20.0, right: 20),

        child: Container(
            height: 42,
            margin: const EdgeInsets.only(left: 23, right: 23, bottom: 40, top: 40),
            child: RaisedButton(
              textColor: Colors.white,
              color: MyColor.yellow,
              shape: RoundedRectangleBorder(
                  side: BorderSide(
                      color: MyColor.white, width: 1, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(2)),
              child: Text(
                'Next',
                style: TextStyle(
                  fontSize: 19,
                  color: Colors.white,
                ),
              ),
              onPressed: () {

                if (otpController.text.isEmpty) {
                  Toast.show("Please enter Otp", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                } else {
                  setState(()
                  {
                    isLoading=true;
                  });
                  apiOtpVerification(user_id1, otpController.text);
                }
              },
            )));


    final otpPanel = Container(
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
                    labelText: 'OTP',
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
/*                            Visibility(
                              visible:click,
                            child:Text(click==false?
                            'RESEND OTP': timerText,
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                              ),
                            ),
                            ),*/

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
  //  return Container(
    return WillPopScope(
    onWillPop: ()
    {
      print('Backbutton pressed (device or appbar button), do whatever you want.');
      return Future.value(false);
    },
      child: Scaffold(
        backgroundColor: MyColor.themecolor,
        appBar: AppBar(
          title: Text(''),
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
        ),
        body: ListView(
          children: <Widget>[
            Title,
            otpPanel,
            isLoading ? Container(
              margin: const EdgeInsets.only(left: 29.0, right: 29),
             // color: Colors.black.withOpacity(.4),
              child: Align(
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              ),
            )
                :nextbtn,
           // informationtext,
          ],
        ),
      ),
    );
  }

  apiOtpVerification(String uId, String otp) async {
    Map data = {"user_id": uId, "otp": otp};
    print(data);
    var jsonData = null;
    var response = await http.post(uidata.verify, body: data);

    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      var status = jsonData['status'];
      var msg = jsonData['Message'];
      setState(()
      {
        isLoading=false;
      });
      print(jsonData);
      if (status == "1") {
        Toast.show(msg, context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        setState(()
        {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginPage()), (route) => false);
        });
      } else {
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
    if(response.statusCode == 200)
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
