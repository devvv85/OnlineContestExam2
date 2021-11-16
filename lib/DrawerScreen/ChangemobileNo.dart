import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onlineexamcontest/Constants/MyColor.dart';
import 'package:http/http.dart' as http;
import 'package:onlineexamcontest/Constants/uidata.dart';
import 'package:onlineexamcontest/Dashboard/MainDashboard.dart';
import 'package:onlineexamcontest/Login/login5.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
String uID1,token;  bool isLoading = false; bool   isLoadingupdate = false;
SharedPreferences prefs;
class ChangeMobileNoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _State();

  ChangeMobileNoPage(String uId)
  {
    uID1=uId;
  }
}

class _State extends State<ChangeMobileNoPage> {
  TextEditingController uNmController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  @override
  void initState()
  {
    super.initState();
    setState(() {
      initializeSF();

    });
  }
  initializeSF() async {
    prefs = await SharedPreferences.getInstance();

    token = prefs.getString("token");
    print("aaaa $token");

  }
  @override
  Widget build(BuildContext context)
  {
    return new Scaffold(
      backgroundColor: MyColor.themecolor,
        appBar: AppBar(
          title: Text(' Update Mobile No.'),
          backgroundColor: MyColor.themecolor,
        ),
        body: ListView(children: <Widget>[

/*          Container(
            height: 45,
            margin: const EdgeInsets.only(left: 25, right: 25, top: 100),
            child: TextField(
              keyboardType: TextInputType.number,
              controller: mobileController,
              decoration: new InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 1.0),
                ),
                labelStyle: new TextStyle(color: Colors.black),
                labelText: 'Mobile No',
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          )*/
          Container(
              /*  height: 45,
              margin: const EdgeInsets.only(left: 25, right: 25, top: 10),*/
              margin: const EdgeInsets.only(left: 25, right: 25, top: 100),
              child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              InkWell(
                onTap: () {},
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        height: 65,
                        child: Row(children: <Widget>[
                          Expanded(
                            flex: 7,
                            child: TextField(
                              maxLength: 10,
                              keyboardType: TextInputType.number,
                              controller: mobileController,
                              decoration: new InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black, width: 2.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black, width: 1.0),
                                ),
                                labelStyle: new TextStyle(color: Colors.black),
                                labelText: 'Mobile No',
                                filled: true,
                                fillColor: Colors.white,
                              ),
                            ),
                          ),

                          isLoading
                              ? Container(
                            margin: const EdgeInsets.only(left: 29.0, right: 29),
                         //   color: Colors.white.withOpacity(.4),
                            child: Align(
                              alignment: Alignment.center,
                              child: CircularProgressIndicator(),
                            ),
                          ): Expanded(
                              flex: 3,
                              child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                     margin: const EdgeInsets.only(bottom: 15),
                                      height: 43,
                                      //height: 65,
                                      child: RaisedButton(
                                          onPressed: ()
                                          {
                                            setState(()
                                            {
                                              if( mobileController.text.isEmpty)
                                                {
                                                  Toast.show("Please enter mobile no.", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                                                }
                                              else
                                                {
                                                isLoading = true;
                                                apiSendOtp(uID1,
                                                    mobileController.text);
                                              }

                                            });
                                          },
                                          color: MyColor.yellow,
                                          child: Text(
                                            "Send OTP",
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.white,
                                            ),
                                          ))))),
                        ])),
                  ],
                ),
              ),
              //  Divider(color: Colors.grey,),
            ],
          )),
          Container(
            height: 45,
            margin: const EdgeInsets.only(left: 25, right: 25, top: 10),
            child: TextField(
              keyboardType: TextInputType.number,
              controller: otpController,
              decoration: new InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 1.0),
                ),
                labelStyle: new TextStyle(color: Colors.black),
                labelText: 'OTP',
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),

          isLoadingupdate
              ? Container(
             margin: const EdgeInsets.only(left: 29.0, right: 29),
            // color: Colors.white.withOpacity(.4),
             child: Align(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            ),
          ):
          Container(
              padding: const EdgeInsets.only(left: 25, right: 25, top: 25),
              //  height: 100,

              child: Container(
                  height: 42,
                  child: RaisedButton(
                      onPressed: () {
                        setState(() {
                          isLoadingupdate=true;
                          apiUpdateMobileNo(uID1, mobileController.text, otpController.text);
                        });
                      },
                      color: MyColor.yellow,
                      child: Text(
                        "Update",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,fontWeight: FontWeight.bold
                        ),
                      )))),
        ]));
  }

  ///////////////
  apiSendOtp(String uid, String mob) async {
    Map data = {
      "user_id": uid,
      "phone_no": mob,
    };
    print("para>>>$data$token");
    var jsonData = null;
    //change api url
    var response = await http.post(uidata.updatephoneverify, body:data,headers: {'Authorization': token});

    if (response.statusCode == 200)
    {
      jsonData = json.decode(response.body);
      var status = jsonData['status'];
      var msg = jsonData['Message'];

      print(jsonData);
      print('status $status');
      if (status == "1")
      {
        setState(() {
          isLoading = false;
        });
        var otp = jsonData['otp'];

      //  Toast.show(otp, context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        Toast.show(msg, context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      //  otpController.text=otp;

      }
      else {
        setState(() {
          isLoading = false;
        });
        Toast.show(
            msg, context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    } else {}
  }
////////////////************************

  apiUpdateMobileNo(String uid, String mob,String otp) async {
    Map data = {
      "user_id": uid,
      "phone_no": mob,
      "otp":otp,};
    print(data);
    var jsonData = null;

    var response = await http.post(uidata.updatephone, body: data,headers: {'Authorization': token});
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
          isLoadingupdate = false;
        });
        Toast.show(msg, context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        setState(() {

        //  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginPage()), (route) => false);
          Navigator.push(context, MaterialPageRoute(builder: (context) => MainDashboard(uID1,true)));
        });
      }
      else {
        setState(() {
          isLoadingupdate = false;
        });
        Toast.show(msg, context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    } else {}
  }

}
