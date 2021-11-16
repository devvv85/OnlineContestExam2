import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onlineexamcontest/Constants/MyColor.dart';
import 'package:onlineexamcontest/Constants/uidata.dart';
import 'package:onlineexamcontest/Dashboard/MainDashboard.dart';
import 'package:onlineexamcontest/Login/Forgotpassword.dart';
import 'package:onlineexamcontest/Login/Registration.dart';
import 'package:onlineexamcontest/Result/DeclareResult1.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

SharedPreferences prefs;

class ResultPage extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() => new _State();
}

class _State extends State<ResultPage>
{
  TextEditingController editingController = TextEditingController();
  @override
  Widget build(BuildContext context)
  {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Result'),
        backgroundColor:Colors.black,
      ),
      body: new GestureDetector(
        onTap: () {
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
                                vertical: 8, horizontal: 10),
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
                                  onTap: ()
                                  {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => DeclareResultPage1("","","")));
                                  },
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.all(8.0),
                                        child: Row(
                                          children: <Widget>[

                                            Container(
                                              margin:
                                              EdgeInsets.only(left: 10.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Container(
                                                    width:
                                                    MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                        0.7,
                                                    child: Text(
                                                        'hjfgf',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 5,
                                                        style: new TextStyle(
                                                          fontSize: 17.0,
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          color: Colors.black,
                                                        )),
                                                  ),
                                                  SizedBox(
                                                    height: 5.0,
                                                  ),
                                                  Container(
                                                    width:
                                                    MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                        0.7,
                                                    child: Text(
                                                        'tgtghtyh',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 5,
                                                        style: new TextStyle(
                                                          fontSize: 12.0,
                                                          color: Colors.black54,
                                                          fontWeight:
                                                          FontWeight.bold,
                                                        )),
                                                  ),
                                                  SizedBox(
                                                    height: 5.0,
                                                  ),

                                                  /* Text("Date - "+newDate,
                                          style: new TextStyle(fontSize: 13.0, color: Colors.grey[600])),*/
                                                  SizedBox(
                                                    height: 5.0,
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