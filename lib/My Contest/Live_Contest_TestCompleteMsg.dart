import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:onlineexamcontest/Dashboard/DeclareResultPage.dart';
import 'package:onlineexamcontest/Dashboard/MainDashboard.dart';
import 'package:onlineexamcontest/My%20Contest/MyContest.dart';
import 'package:onlineexamcontest/payment/mypayment.dart';
import 'package:shared_preferences/shared_preferences.dart';


String id;
SharedPreferences prefs;
var mysubtest_id;String userId;
class Live_Contest_TestCompletePage extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() => new _State();
  Live_Contest_TestCompletePage(String uId)
  {
    id=uId;print("nnnnnnnn>>$id");
  }
  initializeSF() async {

    prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("uId");
    print("aaaa $userId");


  }
  @override
  void initState()
  {

    initializeSF();
  }
}

class _State extends State<Live_Contest_TestCompletePage> {
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Center(
              child: GestureDetector(
                onTap: ()
                 {
                  print("Container clicked");

                 // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DeclareResultPage("noti")));
                //  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainDashboard(userId, true)));
                /*  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MainDashboard(userId, true)));*/
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              MainDashboard(id, true)));

                    },
                  child: Container(
                  margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 150),
                  child: Image.asset("assets/images/sucesscontest.png"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

