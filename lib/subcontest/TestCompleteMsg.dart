import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'TestResultQueAns.dart';

SharedPreferences prefs;
var mysubtest_id;
String mysubtest_id1,my_test_id1;
class TestCompletePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _State();

  TestCompletePage(var mysubtest_id,my_test_id)
  {
    mysubtest_id1=mysubtest_id;
    my_test_id1=my_test_id;
  }
}

class _State extends State<TestCompletePage> {
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
                  setState(()
                  {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>TestResultQueAnsPage(mysubtest_id1,my_test_id1)));
                  });},
                child: Container(
                  margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 150),
                  child: Image.asset("assets/images/sucess.png"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

