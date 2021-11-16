import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onlineexamcontest/Constants/MyColor.dart';
import 'package:onlineexamcontest/Constants/uidata.dart';
import 'package:onlineexamcontest/Dashboard/MainDashboard.dart';
import 'package:onlineexamcontest/Login/Forgotpassword.dart';
import 'package:onlineexamcontest/Login/Registration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

SharedPreferences prefs;

class TransactionPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _State();
}

class _State extends State<TransactionPage> {
  TextEditingController editingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Transaction'),
        backgroundColor: MyColor.themecolor,
      ),
      body: new GestureDetector(
        onTap: ()
        {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Container(
          color: MyColor.orange12,
          padding: EdgeInsets.only(
            top: 5,
          ),
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    /* // primary: false,
                    itemCount: 2,
                    // itemCount: 3,*/

                    itemBuilder: (context, index) {
                      if (editingController.text.isEmpty) {
                        return new Card(
                            margin: EdgeInsets.symmetric(
                                vertical: 3, horizontal: 15),
                            color: Theme.of(context).cardColor,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(0.5)),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                InkWell(
                                  onTap: () {},
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                          padding: EdgeInsets.only(
                                              left: 5,
                                              right: 5,
                                              top: 5,
                                              bottom: 5),
                                          height: 45,
                                          child: Row(children: <Widget>[
                                            Expanded(
                                                child: Text("+ ₹ 48",
                                                    style: new TextStyle(
                                                      fontSize: 12.0,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ))),
                                            Expanded(
                                                child: Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Text(
                                                        "Joined A Contest",
                                                        style: new TextStyle(
                                                          fontSize: 12.0,
                                                          color: Colors.black54,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        )))),
                                            Expanded(
                                                child: Align(
                                              alignment: Alignment.centerRight,
                                              child: SizedBox(
                                                height: 10.0,
                                                width: 10.0,
                                                // child: Image.asset("assets/images/exam.png"),
                                               // child: Icon(Icons.arrow_drop_down_outlined, color: Colors.black,),
                                                child: Image.asset("assets/images/uparrow.png"),
                                              ),
                                            ))
                                            //  child: Icon(Icons.arrow_drop_down_outlined,))),
                                          ])),
                                    ],
                                  ),
                                ),
                                //  Divider(color: Colors.grey,),
                              ],
                            ));
                      } else {
                        return Container();
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
