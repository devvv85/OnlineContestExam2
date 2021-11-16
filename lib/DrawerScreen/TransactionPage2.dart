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

class TransactionPage1 extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() => new _State();
}

class _State extends State<TransactionPage1>
{
  TextEditingController editingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        backgroundColor:Colors.black,
      ),
      body: new GestureDetector(
        onTap:()
        {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Container(
          color: MyColor.orange12,
          child: Column(
            children: <Widget>[
              Container(
                color: Colors.black87,
                height: 10,
                margin: const EdgeInsets.only(bottom: 6),
/*                child: Container(
                  color: Colors.black87,
                  height: 25,
                  margin: const EdgeInsets.only(bottom: 5 ,left: 8,right:8),
                  // margin: const EdgeInsets.only(left: 2, right: 2),

                ),*/
              ),
              Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    /* // primary: false,
                    itemCount: 2,
                    // itemCount: 3,*/
                    itemBuilder: (context, index) {
                      if (editingController.text.isEmpty)
                      {
                        return new Card(
                            margin: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
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
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.all(8.0),
                                        child: Row(
                                          children: <Widget>[
                                            Container(
                                              margin: EdgeInsets.only(left: 10.0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Container(
                                                      margin: const EdgeInsets.only(left: 7, right: 7),
                                                      //height: 45,
                                                      child: Row(children: <Widget>[
                                                        Expanded(
                                                            flex: 7,
                                                            child: Align(
                                                                alignment: Alignment.topLeft,
                                                                child: Text(
                                                                  '5 March 2021 9:00 AM',
                                                                  style: TextStyle(
                                                                    fontSize: 11,
                                                                    color: Colors.black45,
                                                                  ),
                                                                ))),
                                                        Expanded(
                                                            flex: 3,
                                                            child: Align(
                                                                alignment:
                                                                Alignment.centerRight,
                                                                child: Container(
                                                                  //  margin: const EdgeInsets.only(left: 5),
                                                                    height: 42,
                                                                    child: Text(
                                                                      'Remaining Balance gfhytg',
                                                                      style: TextStyle(
                                                                        fontSize: 10,
                                                                        color: Colors.black,
                                                                      ),
                                                                    )))),

                                                      ])),
                                                  SizedBox(
                                                    height: 5.0,
                                                  ),

                                               /*   SizedBox(
                                                    height: 5.0,
                                                  ),

                                                  *//* Text("Date - "+newDate,
                                          style: new TextStyle(fontSize: 13.0, color: Colors.grey[600])),*//*
                                                  SizedBox(
                                                    height: 5.0,
                                                  ),*/
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                //  Divider(color: Colors.grey,),
                              ],
                            ));
                      }
                      else {
                        return Container(

                        );
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