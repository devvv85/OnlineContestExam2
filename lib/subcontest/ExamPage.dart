import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onlineexamcontest/Constants/MyColor.dart';

class ExamPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _State();
}

class _State extends State<ExamPage>
{
  @override
  Widget build(BuildContext context)
  {
    final loginTitle = Container(
      margin: const EdgeInsets.only(left: 29.0, right: 29, top: 110),
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


    return Container(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: ListView(
          children: <Widget>
          [
          //  loginTitle,
          ],
        ),
      ),
    );
  }

  ///api call phone_no:admin

}
