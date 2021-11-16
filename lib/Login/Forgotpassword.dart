import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onlineexamcontest/Constants/MyColor.dart';
import 'package:onlineexamcontest/Constants/uidata.dart';
import 'package:onlineexamcontest/Login/NewPassword.dart';
import 'package:onlineexamcontest/Login/Registration.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
class Forgotpass extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _State();
}

class _State extends State<Forgotpass> {
  TextEditingController mobileController = TextEditingController();
bool isLoading=false;

  @override
  Widget build(BuildContext context) {
    final logo = Container(
        margin: const EdgeInsets.only(left: 20.0, right: 20, top: 130),


            child: Container(
                margin: const EdgeInsets.only(top: 20,bottom: 10),
                width: 75,
                height: 75,
             /*   child: Image.asset('assets/images/profile.png'))));*/
                child: Image.asset('assets/images/key.png')));
    final Title = Container(
      margin: const EdgeInsets.only(left: 29.0, right: 29),
     /* color: Colors.black.withOpacity(.4),*/
      child: Center(
        child: Container(
            margin: const EdgeInsets.only(left: 25.0, right: 25),

                child: Container(
                  height: 45,
                  margin: const EdgeInsets.only(left: 30, right: 30, top: 10,bottom: 35),
                  child: Text(
                    'Forgot Password',
                    style: TextStyle(
                      fontSize: 24,
                      color: MyColor.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ))),

    );

    final mobileNo = Container(
        margin: const EdgeInsets.only(left: 20.0, right: 20),


            child: Container(
              height: 45,
              margin: const EdgeInsets.only(left: 25, right: 25),
              child: TextField(
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
    final getotpbtn = Container(
        margin: const EdgeInsets.only(left: 20.0, right: 20),

        child: Container(
            height: 42,
            margin:
                const EdgeInsets.only(left: 25, right: 25, bottom: 50, top: 15),
            child: RaisedButton(
              textColor: Colors.white,
              color: MyColor.yellow,
              shape: RoundedRectangleBorder(
                  side: BorderSide(
                      color: MyColor.yellow, width: 1, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(2)),
              child: Text(
                'Get OTP',
                style: TextStyle(
                  fontSize: 19,
                  color: Colors.white,fontWeight:FontWeight.bold
                ),
              ),
              onPressed: ()
              {

                if(mobileController.text.isEmpty)
                  {
                    Toast.show("Please enter mobile No.", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  }
                else if (mobileController.text.length < 10 || mobileController.text.length > 10)
                {
                  Toast.show("Please enter 10 digit mobile No.", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                }
                else
                  {
                    setState(() {
                      isLoading=true;
                    });
                   apiOtpSend(mobileController.text);

                  }

                },
            )));
    final informationtext =  Container(
        margin: const EdgeInsets.only(left: 29.0, right: 29),
        color: Colors.black.withOpacity(.4),child:Container(
    //  margin: const EdgeInsets.only(left: 15.0, right: 15, top: 10),
      child: Center(
        child: Container(
            margin: const EdgeInsets.only(left: 25.0, right: 25,bottom: 10),
            child: Container(
              //height: 45,
             // margin: const EdgeInsets.only(left: 10, right: 10, top: 30),
              child: Text(
                "By continuing, you agree to online exam contest's Privacy Policy and Terms Of Service",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            )),
      ),
    ));

    return Container(
     /* decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/img1.JPEG'),
          fit: BoxFit.cover,
        ),
      ),*/
      child: Scaffold(
        backgroundColor: MyColor.themecolor,
        body: ListView(
          children: <Widget>[
            logo,
            Title,
            mobileNo,
            isLoading
                ? Container(
              margin: const EdgeInsets.only(left: 29.0, right: 29),
             // color: Colors.black.withOpacity(.4),
              child: Align(
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              ),
            )
                :getotpbtn,
           //informationtext,
          ],
        ),
      ),
    );
  }
  apiOtpSend(String mob) async
  {
    Map data = {"phone_no": mob};
    print(data);
    var jsonData = null;
    var response = await http.post(uidata.forgotpassword, body: data);

    if (response.statusCode == 200)
    {
      jsonData = json.decode(response.body);
      var status = jsonData['status'];
      var msg = jsonData['Message'];

      print(jsonData);
      setState(() {
        isLoading=false;
      });
      if (status == "1")
      {
        Toast.show(msg, context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        String user_id=jsonData['user_id'];
        var otp = jsonData['otp'];

        setState(()
        {
          Navigator.push(context, MaterialPageRoute(builder: (context) => NewPass(user_id,otp,mob)),);
        });
      } else {
        Toast.show(msg, context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    } else {}
  }

}
