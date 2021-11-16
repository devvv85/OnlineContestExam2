import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onlineexamcontest/Constants/MyColor.dart';
import 'package:onlineexamcontest/Constants/uidata.dart';
import 'package:onlineexamcontest/DrawerScreen/ChangePassword.dart';
import 'package:onlineexamcontest/Login/Registration.dart';
import 'package:onlineexamcontest/Login/login5.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
String userId1, otp1,token;
SharedPreferences prefs;
class VerifyOldPassword extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _State();

  NewPass(String userid, String otp)
  {
    userId1 = userid;
  }
}
class _State extends State<VerifyOldPassword>
{
  TextEditingController oldPassController = TextEditingController();
  bool _showPassword_old=false,isLoading=false;

  void initState() {
    initializeSF();

  }
  initializeSF() async {
    setState(() async {
      prefs = await SharedPreferences.getInstance();
      token = prefs.getString("token");
      print("aaaa $token");
    });

  }
  Widget build(BuildContext context) {
    final logo = Container(
        margin: const EdgeInsets.only(left: 29.0, right: 29, top: 120),

            child: Container(

                margin: const EdgeInsets.only(top: 10),
                width: 88,
                height: 88,
                child: Image.asset('assets/images/key.png')));

    final oldPass = Container(
        margin: const EdgeInsets.only(left: 20.0, right: 20,top: 30),

            child: Container(
              height: 47,
              margin: const EdgeInsets.only(left: 25, right: 25, top: 40),
              child: TextField(
                obscureText: !this._showPassword_old,
                controller: oldPassController,
                decoration: new InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.0),
                  ),
                  labelStyle: new TextStyle(color: Colors.black),
                  labelText: 'Old Password *',
                  hintStyle: TextStyle(fontSize: 20.0,),
                  filled: true,
                  fillColor: Colors.white,
                  //prefixIcon: Icon(Icons.security),
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.remove_red_eye,
                      color: this._showPassword_old ? Colors.black : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() => this._showPassword_old = !this._showPassword_old);
                    },
                  ),
                ),
              ),
            ));

    final getotpbtn = Container(
        margin: const EdgeInsets.only(left: 20.0, right: 20),

        child: Container(
            height: 45,
            margin:
                const EdgeInsets.only(left: 25, right: 25, bottom: 30, top: 15),
            child: RaisedButton(
              textColor: Colors.white,
              color:MyColor.yellow,
              shape: RoundedRectangleBorder(
                  side: BorderSide(
                      color: MyColor.white, width: 1, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(2)),
              child: Text(
                'Verify',
                style: TextStyle(
                  fontSize: 19,
                  color: Colors.white,
                ),
              ),
              onPressed: () async {

                if (oldPassController.text.isEmpty)
                {
                  Toast.show("Please enter old password", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                }
                else
                  {
                  setState(()
                  {
                    isLoading=true;
                  });
                  prefs = await SharedPreferences.getInstance();
                  apiVerifypass(prefs.getString('uId'),oldPassController.text);
                  }
              },
            )));


    return Container(
    /*  decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/img1.JPEG'),
          fit: BoxFit.cover,
        ),
      ),*/
      child: Scaffold(
        backgroundColor: MyColor.themecolor,
        appBar: AppBar(
          title: Text('Change Password'),
          backgroundColor:Colors.black,
        ),
        body: ListView(
          children: <Widget>[
            logo,
            oldPass,
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

          ],
        ),
      ),
    );
  }

//////////////////////////////////////////////////////api call*******************************
  apiVerifypass(userid,password) async
  {
    Map data = {"user_id": userid,"password":password};
    print('pppara $data');
    var jsonData = null;
    var response = await http.post(uidata.validateoldpassword, body: data,headers: {'Authorization': token});
    isLoading=false;
    if (response.statusCode == 200)
    {
      jsonData = json.decode(response.body);
      var status = jsonData['status'];
      var msg = jsonData['Message'];

      print(jsonData);
      setState(() {

      });
      if (status == "1")
      {
        Toast.show(msg, context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        setState(()
        {
          Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePassword()),);
        });
      } else {
        Toast.show(msg, context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    } else {
      isLoading=false;
    }
  }

}
