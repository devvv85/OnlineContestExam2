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

class TestPage2 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _State();
}

class _State extends State<TestPage2> {
  TextEditingController editingController = TextEditingController();
/*
  List<String> images = [
    "https://static.javatpoint.com/tutorial/flutter/images/flutter-logo.png",
    "https://static.javatpoint.com/tutorial/flutter/images/flutter-logo.png",
    "https://static.javatpoint.com/tutorial/flutter/images/flutter-logo.png",
    "https://static.javatpoint.com/tutorial/flutter/images/flutter-logo.png"
  ];
*/

  @override
  Widget build(BuildContext context)
  {
    return new Scaffold(
      body: new GestureDetector(
        onTap: ()
        {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Container(
          color: MyColor.orange12,
          child: Column(
            children: <Widget>[
              Container(
                color: Colors.black87,
                height: 50,
                /// margin: const EdgeInsets.only(bottom: 2),
                child: Container(
                  color: Colors.black87,
                  height: 25,
                  margin: const EdgeInsets.only(bottom: 5 ,left: 8,right:8),
                  // margin: const EdgeInsets.only(left: 2, right: 2),
                  child: TextField(
                    style: TextStyle(color: Colors.black),
                    onChanged: (value) {
                      setState(() {});
                    },
                    controller: editingController,
                    decoration: InputDecoration(
                        fillColor: Colors.white, filled: true,
                        labelText: "Search",
                        hintText: "Search",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(5.0)))),
                  ),
                ),
              ),
              Container
                (
                  alignment: Alignment.topLeft,
                  margin: const EdgeInsets.only(left: 10.0,top:20.0,bottom: 5),
                  child:Text('Trading Exams',  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),)
              ),
              Expanded(
                child: Container(

                    padding: EdgeInsets.all(5.0),
                    child: GridView.builder(
                      itemCount:18,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount
                        (
                          crossAxisCount: 3,
                          crossAxisSpacing: 4.0,
                          mainAxisSpacing: 4.0
                      ),
                      itemBuilder: (BuildContext context, int index)
                      {
                        return new Card(
                          shadowColor: Colors.grey,
                            margin: EdgeInsets.symmetric(
                                vertical: 4, horizontal: 2),
                            color: Theme.of(context).cardColor,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(0.5)),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                InkWell(
                                  onTap: () {},
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        child: Row(
                                          children: <Widget>[
                                            Container(
                                              alignment: Alignment.center,
                                              padding: EdgeInsets.all(10.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Container(
                                                      alignment: Alignment.center,
                                                      width: 40,
                                                      height: 40,
                                                      child: Image.asset('assets/images/train.png')),
                                                  Container(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                        'SSC Exams',
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 5,
                                                        style: new TextStyle(
                                                          fontSize: 13.0,
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          color: Colors.black,
                                                        )),
                                                  ),

                                                  Container(

                                                    child: Text(
                                                        '24 Exams',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 5,
                                                        style: new TextStyle(
                                                          fontSize: 11.0,
                                                          color: Colors.black54,
                                                          fontWeight:
                                                          FontWeight.bold,
                                                        )),
                                                  ),


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
                        },
                    )),),
            ],
          ),
        ),
      ),

    );
  }}