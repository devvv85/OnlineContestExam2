import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onlineexamcontest/Constants/MyColor.dart';
import 'package:onlineexamcontest/Constants/uidata.dart';
import 'package:onlineexamcontest/Dashboard/MainDashboard.dart';
import 'package:onlineexamcontest/Login/Registration.dart';
import 'package:onlineexamcontest/Login/login5.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

String userId1, otp1,token;
SharedPreferences prefs;
class ChangePassword extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _State();

  NewPass(String userid, String otp) {
    userId1 = userid;
  }
}

class _State extends State<ChangePassword> {
  TextEditingController oldPassController = TextEditingController();
  TextEditingController newPassController = TextEditingController();
  TextEditingController confirmOassController = TextEditingController();
  bool _showPassword_old = false,
      _showPassword_New = false,
      _showPassword_confirm = false,
      isLoading = false;

  void initState() {
    setState(() {
      initializeSF();
    });


  }
  initializeSF() async {
    prefs = await SharedPreferences.getInstance();

    token = prefs.getString("token");
    print("aaaa $token");
  }

  Widget build(BuildContext context) {
    final logo = Container(
        margin: const EdgeInsets.only(left: 29.0, right: 29, top: 100, bottom: 40),

            child: Container(
                margin: const EdgeInsets.only(top: 10),
                width: 78,
                height: 78,
                child: Image.asset('assets/images/key.png')));

    final newpass = Container(
        margin: const EdgeInsets.only(left: 20.0, right: 20),

            child: Container(
              height: 45,
              margin: const EdgeInsets.only(left: 25, right: 25, top: 10),
              child: TextField(
                obscureText: !this._showPassword_New,
                controller: newPassController,
                decoration: new InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.0),
                  ),
                  labelStyle: new TextStyle(color: Colors.black),
                  /* decoration: InputDecoration(
                  border: OutlineInputBorder(),*/
                  labelText: 'New Password *',
                  hintStyle: TextStyle(
                    fontSize: 20.0,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  //prefixIcon: Icon(Icons.security),
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.remove_red_eye,
                      color:
                          this._showPassword_New ? Colors.black : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() =>
                          this._showPassword_New = !this._showPassword_New);
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
                obscureText: !this._showPassword_confirm,
                controller: confirmOassController,
                decoration: new InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1.0),
                  ),
                  labelStyle: new TextStyle(color: Colors.black),
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
                      color: this._showPassword_confirm
                          ? Colors.black
                          : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() => this._showPassword_confirm =
                          !this._showPassword_confirm);
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
                const EdgeInsets.only(left: 25, right: 25, bottom: 20, top: 25),
            child: RaisedButton(
              textColor: Colors.white,
              color: MyColor.yellow,
              shape: RoundedRectangleBorder(
                  side: BorderSide(
                      color: MyColor.white, width: 1, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(2)),
              child: Text(
                'Change Password',
                style: TextStyle(
                  fontSize: 19,
                  color: Colors.white,
                ),
              ),
              onPressed: ()
              async {
                if (newPassController.text.isEmpty)
                {
                  Toast.show("Please enter New password", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                }
                else if (confirmOassController.text.isEmpty)
                {
                  Toast.show("Please enter confirm password", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                } else if (newPassController.text != confirmOassController.text)
                {
                  Toast.show("Confirm password doesn't match with new password", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                }
                else {
                  setState(() {
                    isLoading = true;
                  });

                  prefs = await SharedPreferences.getInstance();
                  apiChngpass(prefs.getString('uId'),newPassController.text);
                }
              },
            )));

    return Container(
     /* decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/img1.JPEG'),
          fit: BoxFit.cover,
        ),
      ),*/
      child: Scaffold(
        backgroundColor: MyColor.themecolor,
        appBar: AppBar(
          title: Text('Change Password'),
          backgroundColor: MyColor.themecolor,
        ),
        body: ListView(
          children: <Widget>[
            logo,
            // oldPass,
            newpass,
            confirmpassword,
            isLoading
                ? Container(
                    margin: const EdgeInsets.only(left: 29.0, right: 29),
                   // color: Colors.black.withOpacity(.4),
                    child: Align(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(),
                    ),
                  )
                : getotpbtn,
          ],
        ),
      ),
    );
  }
  ////////////////////////////////////////////////////////////////////////////////////////
  apiChngpass(userid,password) async
  {
    Map data = {"user_id": userid,"password":password};
    print('ppara $data');
    var jsonData = null;
    var response = await http.post(uidata.changepassword, body:data,headers: {'Authorization': token});
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

        //  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginPage()), (route) => false);

          Navigator.push(context, MaterialPageRoute(builder: (context) => MainDashboard(userId1,true)));
        });
      } else {
        Toast.show(msg, context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    } else {
      isLoading=false;
    }
  }

}
