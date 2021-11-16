import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onlineexamcontest/Constants/MyColor.dart';
import 'package:onlineexamcontest/Constants/uidata.dart';
import 'package:onlineexamcontest/Dashboard/MainDashboard.dart';
import 'package:onlineexamcontest/Login/Forgotpassword.dart';
import 'package:onlineexamcontest/Login/Registration.dart';
import 'package:onlineexamcontest/Result/LeaderBoard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

import 'ContestResultQueAns.dart';

SharedPreferences prefs;
String contestnm,contestid,token1;
var attempts=" ",unattempted=" ",result_p=" ",wrong=" ",right=" ",marks=" ",date_time=" ",rank=" ",speed=" ";String strforLeaderbord1;
class DeclareResultPage1 extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() => new _State();
  DeclareResultPage1(String nm,String id,String strforLeaderbord)
  {
    contestnm=nm;
    contestid=id;
    strforLeaderbord1=strforLeaderbord;
  }

}


class _State extends State<DeclareResultPage1> {
  TextEditingController editingController = TextEditingController();
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      initializeSF();
    });

   // contestid="1";

  }
  initializeSF() async {
  setState(() async {
    prefs = await SharedPreferences.getInstance();
    token1 = prefs.getString("token");
    setState(() {
      apiGetData(contestid);
    });

  });

  }
  @override
  Widget build(BuildContext context)
  {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Result'),
        backgroundColor: MyColor.themecolor,
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
                margin: const EdgeInsets.only(left: 29.0, right: 29, top: 10),
                child: Center(
                    child: Container(
                      height: 45,
                      margin: const EdgeInsets.only(left: 30, right: 30, top: 10),
                      child: Text(
                      //  'Thank You for Live Quiz'+
                            contestnm,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )),
              ),
              Container(
                margin: const EdgeInsets.only(left: 20, right: 20, bottom: 5),
                color: Colors.black,
                height: 4,
              ),
              Card(
                  margin: const EdgeInsets.only(left: 10, right: 10,top: 20),
                  // margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  color: Theme.of(context).cardColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(0.5)),
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
                              margin: EdgeInsets.all(10.0),
                              child: Row(
                                children: <Widget>[
                                  Container(

                                    //margin: EdgeInsets.only(left: 10.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          width: MediaQuery.of(context).size.width * 0.7,
                                          child: Text("Rank "+rank,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 5,
                                              style: new TextStyle(
                                                fontSize: 19.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue,
                                                 // backgroundColor: Colors.blue,
                                              )),
                                        ),
                                        SizedBox(
                                          height: 5.0,
                                        ),
/*                                        Container(
                                          width: MediaQuery.of(context).size.width * 0.7,
                                          child: Text(
                                              'Will be announced at 9:00 AM on March 03 ,2021',
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 5,
                                              style: new TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.black45,
                                                fontWeight: FontWeight.bold,
                                              )),
                                        ),*/
                                      ],
                                    ),
                                  ),
/*                                  IconButton(
                                    icon: Image.asset(
                                      'assets/images/medal1.png',
                                      // height: 100,
                                      width: MediaQuery.of(context).size.width * 0.7,
                                    ),
                                  ),*/
                                ],
                              ),
                            ),
                            Container(
                              /*   padding: EdgeInsets.only(
                          left: 10, right: 10, top: 12, bottom: 20),*/
                                height: 38,
                                margin: const EdgeInsets.only(bottom: 26,top: 15),
                                child: Row(children: <Widget>[
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                      child: Container(
                                        /*  height: 32,*/
                                          padding: EdgeInsets.only(
                                            /* left: 10,*/
                                            right: 10,
                                          ),
                                          child: RaisedButton(
                                            onPressed: () {
                                              Navigator.push(context, MaterialPageRoute(builder: (context) => LeaderboardPage(strforLeaderbord1)),
                                              );
                                            },
                                            color: MyColor.yellow,

                                            /* color: Colors.black,
                                    child:Icon(
                                      Icons.access_time,
                                      color: Colors.black54,
                                      size: 17,
                                    ),
                                    child: Text(
                                      "Leader Board",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    )*/

                                            child: new Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                new Icon(
                                                  Icons.person,
                                                  color: Colors.white,
                                                  size: 16,
                                                ),
                                                new Text(
                                                  'Leader Board',
                                                  style: TextStyle(
                                                    color: Colors.white,fontWeight:FontWeight.bold
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ))),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                      child: Container(
                                        /*   height: 30,*/

                                        //  padding: EdgeInsets.all(3),
                                          child: RaisedButton(
                                            onPressed: () {
                                              Navigator.push(context, MaterialPageRoute(builder: (context) =>ContestResultQueAns(contestid)),
                                              );
                                            },
                                            color: MyColor.yellow,
                                            child: new Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
/*                                      new IconButton(
                                        icon: Image.asset(
                                          'assets/images/msg.png',
                                           height: 10,
                                          width: 10,
                                          color: MyColor.white,
                                        ),
                                      ),*/
                                                new Icon(
                                                  Icons.message,
                                                  color: Colors.white,
                                                  size: 16,
                                                ),
                                                new Text(
                                                  " "+'Questions',
                                                  style: TextStyle(
                                                    color: Colors.white,fontWeight:FontWeight.bold
                                                  ),
                                                ),
                                              ],
                                            ),
/*                                    child: Text(
                                      "Challange Friend",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    )*/
                                          ))),
                                  SizedBox(
                                    width: 5,
                                  ),
                                ]))
                          ],
                        ),
                      ),
                      //  Divider(color: Colors.grey,),
                    ],
                  )),

       /* Container(
      margin: const EdgeInsets.only(left: 12, top: 20, right: 10),
      color: Colors.grey,
      height: 1,
    ),*/
              Card(
                // margin: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  margin: const EdgeInsets.only(left: 10, right: 10,top: 25),
                  color: Theme.of(context).cardColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(0.5)),
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
                                padding: EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 2),
                                margin: const EdgeInsets.only(left: 10, right: 10),
                                //  color: Colors.yellow,
                                child: Row(children: <Widget>[
                                  Expanded(
                                      child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Text("Wrong",
                                              style: new TextStyle(
                                                fontSize: 17.0,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              )))),
                                  Expanded(
                                      child: Align(
                                          alignment: Alignment.center,
                                          child: Text("Correct",
                                              style: new TextStyle(
                                                fontSize: 17.0,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              )))),
                                  Expanded(
                                      child: Align(
                                          alignment: Alignment.topRight,
                                          child: Text("Skipped",
                                              style: new TextStyle(
                                                fontSize: 17.0,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              )))),
                                ])),
                            Container(
                                padding: EdgeInsets.only(left: 15, right: 15, top: 3, bottom: 3),
                                // height: 40,
                                margin: const EdgeInsets.only(left: 10, right: 10),
                                //  color: Colors.yellow,
                                child: Row(children: <Widget>[
                                  Expanded(
                                      child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(wrong,
                                              style: new TextStyle(
                                                fontSize: 15.0,
                                                color: Colors.black45,
                                                fontWeight: FontWeight.bold,
                                              )))),
                                  Expanded(
                                      child: Align(
                                          alignment: Alignment.center,
                                          child: Text(right,
                                              style: new TextStyle(
                                                fontSize: 15.0,
                                                color: Colors.black45,
                                                fontWeight: FontWeight.bold,
                                              )))),
                                  Expanded(
                                      child: Align(
                                          alignment: Alignment.topRight,
                                          child: Text(unattempted,
                                              style: new TextStyle(
                                                fontSize: 15.0,
                                                color: Colors.black45,
                                                fontWeight: FontWeight.bold,
                                              )))),
                                ])),
                            Container(
                                padding:
                                EdgeInsets.only(right: 5, top: 1, bottom: 12),
                                margin: const EdgeInsets.only(left: 10, right: 10),
                                //  color: Colors.yellow,
                                child: Row(children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      //  left: 20,
                                      top: 10,
                                      right: 40,
                                      // bottom: 10
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        Icon(
                                          Icons.edit,
                                          size: 15,
                                        ),
                                        Text(
                                          " Attempts: "+attempts,
                                          style: TextStyle(
                                              fontSize: 13.0,
                                              // fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        )
                                      ],
                                    ),
                                  ),
                                  //*******************************************************************************************************
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 20,
                                      top: 10,
                                      right: 20,
                                      // bottom: 10
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        Icon(
                                          Icons.assignment,
                                          size: 17,
                                        ),
                                        Text(
                                          " Marks:  "+marks,
                                          style: TextStyle(
                                              fontSize: 13.0,
                                              // fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        )
                                      ],
                                    ),
                                  ),
                                  //**************************************
                                ])),
                            //*********************************************************************
                            Container(
                                padding:
                                EdgeInsets.only(right: 5, top: 1, bottom: 30),
                                margin: const EdgeInsets.only(left: 10, right: 10),
                                //  color: Colors.yellow,
                                child: Row(children: <Widget>[
/*                                  Padding(
                                    padding: const EdgeInsets.only(
                                      //  left: 20,
                                      top: 10,
                                      right: 30,
                                      // bottom: 10
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        Icon(
                                          Icons.edit,
                                          size: 15,
                                        ),
                                        Text(
                                          " Accuracy:97%",
                                          style: TextStyle(
                                              fontSize: 13.0,
                                              // fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        )
                                      ],
                                    ),
                                  ),*/
                                  //*******************************************************************************************************
/*                                  Padding(
                                    padding: const EdgeInsets.only(
                                     // left: 20,
                                      top: 10,

                                      // bottom: 10
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        Icon(
                                          Icons.assignment_turned_in_rounded,
                                          size: 17,
                                        ),
                                        Text(
                                          " Speed: "+speed,
                                          style: TextStyle(
                                              fontSize: 13.0,
                                              // fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        )
                                      ],
                                    ),
                                  ),*/
                                  //**************************************
                                ]))


                            //****************************************************************

                          ],
                        ),
                      ),

                      //  Divider(color: Colors.grey,),
                    ],
                  ))

            ],
          ),
        ),
      ),
    );
  }
  apiGetData(String contestid) async
  {
    Map data = {"my_contest_id": contestid};
    print("para$data");
    var jsonData = null;
    var response = await http.post(uidata.contest_result_summary, body: data,headers: {'Authorization': token1});
    if (response.statusCode == 200)
    {
      jsonData = json.decode(response.body);
      var status = jsonData['status'];
      var msg = jsonData['Message'];
      print(jsonData);
      if (status == "1")
      {
        setState(()
        {
          attempts = jsonData['attempts'];
          unattempted = jsonData['unattempted'];
          result_p = jsonData['result_p'];
          wrong = jsonData['wrong'];
          right = jsonData['right'];
          marks = jsonData['marks'];
          date_time = jsonData['date_time'];
          rank = jsonData['rank'];
          speed = jsonData['speed'];
        });

      }
      else
        {

        Toast.show(msg, context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }
    }
  }

