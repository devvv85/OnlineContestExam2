import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:onlineexamcontest/Constants/MyColor.dart';
import 'package:onlineexamcontest/Constants/uidata.dart';
import 'package:onlineexamcontest/Dashboard/MainDashboard.dart';
import 'package:onlineexamcontest/Dashboard/WinnersPage.dart';
import 'package:onlineexamcontest/Login/Forgotpassword.dart';
import 'package:onlineexamcontest/Login/Registration.dart';
import 'package:onlineexamcontest/My%20Contest/ContestTermsAndCondition.dart';
import 'package:onlineexamcontest/My%20Contest/MyContest.dart';
import 'package:onlineexamcontest/My%20Contest/SyllabusPage.dart';
import 'package:onlineexamcontest/My%20Contest/screendevide.dart';
import 'package:onlineexamcontest/Result/DeclareResult1.dart';
import 'package:onlineexamcontest/Result/LeaderBoard.dart';
import 'package:onlineexamcontest/subcontest/TestResultQueAns.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

import 'countdowntimer.dart';
Timer timerloopingapi;
SharedPreferences prefs;
bool isLoadingpaid = false;
bool isLoadingfree = false;
String userId,a1;
String wallet = "",contestFees,type="",status,status1;

String msg="Data Not available";String msg1="Data Not available",token1;
class DeclareResultPage extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() => new _State();
  DeclareResultPage(String a)
  {
    a1 = a;
  }
}

class _State extends State<DeclareResultPage>
{
  TextEditingController editingController = TextEditingController();
  List<User> users = new List<User>();
  List<User1> test = new List<User1>();
  bool isclick = true;
  bool isclick1 = false;
  bool isPaid = true, isFree = false;

  @override
  void initState()
  {
    setState(()
    {
      initializeSF();
    });

  }
  initializeSF()async  {
    setState(()
    async {
      prefs = await SharedPreferences.getInstance();
      userId = prefs.getString("uId");
      token1 = prefs.getString("token");
      print("aaaa $userId");
      _apiGetMyContest();
  //    timerloopingapi = Timer.periodic(Duration(seconds: 15), (Timer t) => _apiGetMyContestlooping());
    });

  }
  @override
  void dispose()
  {
    if(timerloopingapi!=null)
      {
        timerloopingapi.cancel();
      }

    super.dispose();
  //  timerloopingapi.cancel();
  }
  Future<Album> _apiGetMyContest() async {

    Map data = {"user_id": userId};
    print("Respon>>>$data");
    final response = await http.post(uidata.result_queue, body:data,headers: {'Authorization': token1});
    if (response.statusCode == 200)
    {
      var res = Album.fromJson(jsonDecode(response.body));
      var jsonData = json.decode(response.body);
      setState(() {
        status = jsonData['status'];
        //  status="0";
        if (status == "0")
        {
          isLoadingpaid = false;
          msg1="";
          msg="Data Not available";
        }
      });
      setState(()
      {
        msg1="";
        msg="";
        users = res.data;
      });
    } else {
      throw Exception('Failed to load test');
    }
  }
/*
  Future<Album> _apiGetMyContestlooping() async {
    isLoadingpaid = false;
    Map data = {"user_id": userId};
    print("Respon>>>$data");
    final response = await http.post(uidata.result_queue, body:data,headers: {'Authorization': token1});
    if (response.statusCode == 200)
    {
      var res = Album.fromJson(jsonDecode(response.body));
      var jsonData = json.decode(response.body);
      setState(() {
        status = jsonData['status'];
        //  status="0";
        if (status == "0")
        {
          isLoadingpaid = false;
          msg="";
          msg="Data Not available";
        }
      });
      setState(()
      {
        users = res.data;
      });
    } else {
      throw Exception('Failed to load test');
    }
  }
*/

  Future<Album> _getFreeTest() async {
    Map data = {"user_id": userId};
    print("Respon>>>$data");
    final response = await http.post(uidata.test_result_queue, body:data,headers: {'Authorization': token1});
    if (response.statusCode == 200) {
      var res = Album1.fromJson(jsonDecode(response.body));
      var jsonData = json.decode(response.body);
      print("Res>>>$jsonData");
      setState(() {
        status1 = jsonData['status'];
        //  status="0";
        if (status1 == "0")
        {
          isLoadingfree = false;
          msg="";
          msg="Data Not available";
        }
      });
      setState(()
      {
        msg1="";
        msg="";
        test = res.data;
      });
    } else {
      throw Exception('Failed to load test');
    }
  }


  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: ()
    {
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) => MainDashboard(userId,true)));
      return Future.value(true);
    },
    child: Scaffold(
      appBar: a1=="noti"?AppBar(
        title: Text("Result"),
        backgroundColor:MyColor.themecolor,
      ):null,
      body: new GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Container(
          color: MyColor.orange12,
          child: Column(
            children: <Widget>[
/*              Container(
                color: Colors.black87,
                height: 50,

                /// margin: const EdgeInsets.only(bottom: 2),
                child: Container(
                  color: Colors.black87,
                  height: 25,
                  margin: const EdgeInsets.only(bottom: 5, left: 8, right: 8),
                  // margin: const EdgeInsets.only(left: 2, right: 2),
                  child: TextField(
                    style: TextStyle(color: Colors.black),
                    onChanged: (value) {
                      setState(() {});
                    },
                    controller: editingController,
                    decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        labelText: "Search",
                        // hintText: "Search",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(5.0)))),
                  ),
                ),
              )*/

              Container(
                  padding:
                  EdgeInsets.only(left: 30, right: 30, top: 2, bottom: 2),
                  //  height: 100,
                  child: Row(children: <Widget>[
                    Expanded(
                        child: RaisedButton(
                            onPressed: ()
                            {
                              setState(()
                              {
                                isclick = true;
                                isclick1 = false;
                                isPaid = true;
                                isFree = false;
                                _apiGetMyContest();
                                isLoadingfree = false;
                              });
                            },
                            color: isclick ? MyColor.yellow  : Colors.white,
                            child: Text(
                              "My Contest",
                              style: TextStyle(
                                color: isclick ? Colors.white : Colors.black,fontWeight: FontWeight.bold
                              ),
                            ))),
                    Expanded(
                        child: RaisedButton(
                            onPressed: ()
                            {
                              setState(() {
                                isclick1 = true;
                                isclick = false;
                                isFree = true;
                                isPaid = false;
                                _getFreeTest();
                                isLoadingpaid = false;
                              });
                            },
                            color: isclick1 ? MyColor.yellow : Colors.white,
                            child: Text(
                              "My Test",
                              style: TextStyle(
                                color: isclick1 ? Colors.white : Colors.black,fontWeight: FontWeight.bold
                              ),
                            ))),
                  ])),


              Expanded(
                  child: Column(children: [
                    isLoadingpaid
                        ? Container(
                      margin: const EdgeInsets.only(left: 29.0, right: 29),
                     // color: Colors.white.withOpacity(.4),
                      child: Align(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(),
                      ),
                    )
                    :status=="0"
                        ? Container(
                      margin: const EdgeInsets.only(
                          left: 29.0, right: 29, top: 20),

                      child: Align(
                        alignment: Alignment.center,
                        child: Text(msg),
                      ),
                    )
                          : Visibility(
                      visible: isPaid,
                      child: Flexible(
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: users.length,
                            itemBuilder: (context, index) {
                              if(editingController.text.isEmpty)
                              {
                                //Paid
                                return new Card(
                                    margin:EdgeInsets.only(left: 7,right: 7,top: 10),
                                    //s  margin: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
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
                                          Container(
                                              child: Container(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                      Container(
                                                        padding: EdgeInsets.only(
                                                            top: 5,
                                                            bottom: 5,
                                                            //  left: 15,
                                                            right: 15),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                          children: <Widget>[
                                                            Padding(
                                                              padding:
                                                              const EdgeInsets.only(
                                                                // left: 15,
                                                                //top: 10,

                                                              ),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment.start,
                                                                children: <Widget>[
                                                                  Container(
                                                                    color: Colors.red,
                                                                    width: 60,
                                                                    height: 17,
                                                                    child:Padding(
                                                                      padding: const EdgeInsets.only(),
                                                                      child:Container(
                                                                        padding: const EdgeInsets.all(3.0),
                                                                        decoration: BoxDecoration(border: Border.all(color: Colors.red)),
                                                                        child: Row(
                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                          children: <Widget>[
                                                                            Text(
                                                                              users[index].tag,
                                                                              style: TextStyle(
                                                                                  fontSize: 8.0,
                                                                                  fontWeight: FontWeight.bold,
                                                                                  color: Colors.white),
                                                                            ),
                                                                          ],),),),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 30.0,
                                                            ),
                                                            Container(
                                                                height: 22,
                                                                padding: EdgeInsets.only(top: 10),
                                                                child: Align(alignment: Alignment.centerRight,
                                                                    child: Text(
                                                                      users[index].date+' '+users[index].from_time+' to '+users[index].to_time,
                                                                      maxLines: 5,
                                                                      style: TextStyle(
                                                                          fontSize: 12.0,
                                                                          fontWeight:
                                                                          FontWeight.bold,
                                                                          color: Colors.blue),
                                                                    )
                                                                )


                                                            ),
/*                                                            Padding(
                                                              padding:
                                                              const EdgeInsets.only(

                                                                top: 10,
                                                              ),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment.start,
                                                                children: <Widget>[
                                                                  Icon(
                                                                    Icons.access_time,
                                                                    color: Colors.black,
                                                                    size: 17,
                                                                  ),
                                                                  Text(
                                                                    " " + "5:04",
                                                                    style: TextStyle(
                                                                        fontSize: 12.0,
                                                                        fontWeight:
                                                                        FontWeight.bold,
                                                                        color: Colors.red),
                                                                  )
                                                                ],
                                                              ),
                                                            ),*/

                                                          ],
                                                        ),
                                                      ),
                                                      ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



                                                      Container(
                                                        padding: EdgeInsets.only(top: 5, bottom: 5, left: 15, right: 25),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment.spaceBetween,
                                                          children: <Widget>[
                                                            Text(users[index].tilte,
                                                                overflow:
                                                                TextOverflow.ellipsis,
                                                                maxLines: 5,
                                                                style: new TextStyle(
                                                                  fontSize: 15.0,
                                                                  fontWeight:
                                                                  FontWeight.bold,
                                                                  color: Colors.black,
                                                                )
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        padding: EdgeInsets.only(
                                                            bottom: 5,
                                                            left: 15,
                                                            right: 25),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: <Widget>[
/*                                                Text(users[index].win_price,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 5,
                                                    style: new TextStyle(
                                                      fontSize: 13.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                    )),*/
                                                            Padding(
                                                              padding:
                                                              const EdgeInsets.only(),
                                                              child: Container(
                                                                padding:
                                                                const EdgeInsets.all(
                                                                    3.0),

                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                                  children: <Widget>[
                                                                    Text(users[index].win_price,
                                                                        overflow:
                                                                        TextOverflow.ellipsis,
                                                                        maxLines: 5,
                                                                        style: new TextStyle(
                                                                          fontSize: 13.0,
                                                                          fontWeight:
                                                                          FontWeight.bold,
                                                                          color: Colors.black,
                                                                        )),
                                                                    Visibility(visible:users[index].gift_icon!="",child:Container(
                                                                      margin:EdgeInsets.only(left: 5,right: 5),
                                                                      alignment:
                                                                      Alignment.topLeft,
                                                                      //width: 10,
                                                                      height: 20,
                                                                      child: Image.network(users[index].gift_icon),
                                                                    ),),
                                                                    Text(
                                                                      users[index].gift_title,
                                                                      style: TextStyle(
                                                                          fontSize: 12.0,
                                                                          fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                          color: Colors
                                                                              .black),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            Text(
                                                              '₹ '+users[index].fees,
                                                              style: TextStyle(
                                                                fontSize: 12.0,
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        padding: EdgeInsets.only(
                                                            top: 5,
                                                            // bottom: 5,
                                                            left: 5,
                                                            right: 5),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                          children: <Widget>[

                                                            /*  SizedBox(
                                              width: 18.0,
                                            ),*/
                                                            Container(
                                                                height: 27,
                                                                width: 70,
                                                               // margin: const EdgeInsets.only(left: 5),
                                                                child: RaisedButton(
                                                                  textColor: Colors.white,
                                                                  color: Colors.black38,
                                                                  shape: RoundedRectangleBorder(
                                                                      side: BorderSide(
                                                                          color: Colors.black38,
                                                                          width: 1,
                                                                          style: BorderStyle.solid),
                                                                      borderRadius: BorderRadius.circular(5)),
                                                                  child: Text('Syllabus', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white,),
                                                                  ),
                                                                  onPressed: ()
                                                                  {
                                                                    setState(() {
                                                                      print('contestid>>> $users[index].contest_id');
                                                                      Navigator.push(context, MaterialPageRoute(builder: (context) => SyllabusPage(users[index].contest_id)),);
                                                                    });


                                                                    // Navigator.push(context, MaterialPageRoute(builder: (context) => SyllabusPage("1")),);
                                                                  },
                                                                )),
                                                            Visibility(
                                                              visible: users[index].is_delcared=="True",
                                                              child:Container(
                                                                height: 27,
                                                                width: 61,
                                                                child: RaisedButton(
                                                                  textColor: Colors.white,
                                                                  color: Colors.green,
                                                                  shape: RoundedRectangleBorder(
                                                                      side: BorderSide(
                                                                          color:Colors.green,
                                                                          width: 1,
                                                                          style: BorderStyle.solid),
                                                                      borderRadius: BorderRadius.circular(5)),
                                                                  child: Text('Result', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white,),),
                                                                  onPressed: ()
                                                                  {


                                                                    Navigator.push(context, MaterialPageRoute(builder: (context) => DeclareResultPage1(users[index].tilte,users[index].my_contest_id,users[index].contest_id)));
                                                                   // Navigator.push(context, MaterialPageRoute(builder: (context) => DeclareResultPage1(users[index].tilte,users[index].contest_id)));
                                                                  },
                                                                )),),

                                                            GestureDetector(
                                                              onTap: () {
                                                                print("Container clicked");
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          WinnersPage(users[index].contest_id)),
                                                                );
                                                              },
                                                              child: Padding(
                                                                padding:
                                                                const EdgeInsets.only(),
                                                                child: Container(
                                                                  padding:
                                                                  const EdgeInsets.all(
                                                                      3.0),
                                                                  decoration: BoxDecoration(
                                                                      border: Border.all(
                                                                          color: Colors
                                                                              .black45)),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                    children: <Widget>[
                                                                      Text(
                                                                        "Winners:"+users[index].winners,
                                                                        style: TextStyle(
                                                                            fontSize: 12.0,
                                                                            fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                            color: Colors
                                                                                .black),
                                                                      ),
                                                                      Icon(
                                                                        Icons
                                                                            .arrow_drop_down_sharp,
                                                                        color: Colors.black,
                                                                        size: 17,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
/*
                                                                  },
                                                                )),*/
                                                          ],
                                                        ),
                                                      ),

                                                      /////////////////////// ////////////////////////////////////////////////////////////////
                                                      Container(
                                                        padding: EdgeInsets.only(
                                                            top: 5,
                                                            bottom: 5,
                                                            left: 15,
                                                            right: 15),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                          children: <Widget>[
                                                            Padding(
                                                              padding:
                                                              const EdgeInsets.only(
                                                                // left: 15,
                                                                //top: 10,

                                                              ),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment.start,
                                                                children: <Widget>[
                                                                  Icon(
                                                                    Icons.assignment,
                                                                    color: Colors.black54,
                                                                    size: 17,
                                                                  ),
                                                                  Text(
                                                                    " " +users[index].no_questions,
                                                                    style: TextStyle(
                                                                        fontSize: 12.0,
                                                                        fontWeight:
                                                                        FontWeight.bold,
                                                                        color: Colors.grey),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            /* SizedBox(
                                              width: 18.0,
                                            ),*/
                                                          /*  Padding(
                                                              padding:
                                                              const EdgeInsets.only(
                                                                left: 20,
                                                                top: 10,
                                                              ),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment.start,
                                                                children: <Widget>[
                                                                  Icon(
                                                                    Icons.access_time,
                                                                    color: Colors.black54,
                                                                    size: 17,
                                                                  ),
*//*
                                                                  Text(
                                                                    " " +users[index].duration,
                                                                    style: TextStyle(
                                                                        fontSize: 12.0,
                                                                        fontWeight:
                                                                        FontWeight.bold,
                                                                        color: Colors.grey),
                                                                  )
*//*
                                                                ],
                                                              ),
                                                            ),*/
                                                            Container(
                                                                height: 22,
                                                                //  width: 100,
                                                                padding: EdgeInsets.only(top: 10),
                                                                child: Align(alignment: Alignment.center,
                                                                    child: Text(
                                                                      "Total Join:"+users[index].total_joining,
                                                                      style: TextStyle(
                                                                          fontSize: 10.0,
                                                                          fontWeight:
                                                                          FontWeight.bold,
                                                                          color: Colors.grey),
                                                                    )
                                                                )


                                                            ),
                                                          ],
                                                        ),
                                                      ),



                                                      /////////////////////////////////////////////////////////////////////////////////////////////////
                                                    ],
                                                  )))
                                        ]));
                              } else {
                                return Container();
                              }
                            }),
                      ),
                    ),
                    //),
//***********************************************Test Section******************************************************************************

                    isLoadingfree
                        ? Container(
                      margin: const EdgeInsets.only(left: 29.0, right: 29),
                    //  color: Colors.white.withOpacity(.4),
                      child: Align(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(),
                      ),
                    )
                        :status1=="0"
                        ? Container(
                      margin: const EdgeInsets.only(
                          left: 29.0, right: 29, top: 20),

                      child: Align(
                        alignment: Alignment.center,
                        child: Text(msg1),
                      ),
                    ) : Visibility(
                      visible: isFree,
                      child: Flexible(
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: test.length,
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
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => TestResultQueAnsPage(test[index].my_subtest_id,test[index].my_test_id)));
                                          },
                                          child: Column(
                                            children: <Widget>[
                                             Row(
                                                 mainAxisAlignment: MainAxisAlignment.end,
                                                  children: <Widget>[
                                                    Text(test[index].testdate+" ",
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 5,
                                                        style: new TextStyle(
                                                          fontSize: 12.0,
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          color: Colors.blue,
                                                        )),
                                                  ]
                                              ),
                                              Container(
                                                child: Row(
                                                  children: <Widget>[
                                                Expanded(flex :2,child:IconButton(
                                                  iconSize: 28.0,
                                                      icon: Image.network(test[index].img),
                                                      onPressed: () {},
                                                ),),
                                                    Expanded(flex :8,child: Container(

                                                     /* padding: EdgeInsets.only(
                                                          top: 2,
                                                          bottom: 2,

                                                      ),*/
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: <Widget>[
                                                          Container(
                                                            width: MediaQuery.of(context).size.width * 0.6,
                                                            child: Text(test[index].title,
                                                                overflow: TextOverflow.ellipsis,
                                                                maxLines: 15,
                                                                style: new TextStyle(
                                                                  fontSize: 16.0,
                                                                  fontWeight:
                                                                  FontWeight.bold,
                                                                  color: Colors.black,
                                                                )),
                                                          ),


                                                        ],
                                                      ),
                                                    ),

                                                    ),
                                                    //////////////////

                                                  ],
                                                ),
                                              ),
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
                    ),
                    //  )
                  ]))

              //*****************************************************************************************************************
            ],
          ),
        ),
      ),),
    );
  }

  //*************************************************************************************************************

}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class Album {
  String status;
  List<User> data;

  Album({this.status});

  Album.fromJson(Map<String, dynamic> json)
  {
    status = json['status'];
    /*  win_price=json['win_price'];
    winners=json['winners'];
    fees=json['fees'];*/

    if (json['data'] != null)
    {
      data = new List<User>();
      json['data'].forEach((v) {
        data.add(new User.fromJson(v));

        isLoadingpaid=false;
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class User {
  String contest_id,
      tag,
      tilte,
      date,
      from_time,
      to_time,
      win_price,
      gift_icon,
      gift_title,
      no_questions,
      duration,
      time_remaining,
      fees,
      total_joining,
      winners,my_contest_id,is_delcared;

  User({
    this.contest_id,
    this.tag,
    this.tilte,
    this.date,
    this.from_time,
    this.to_time,
    this.win_price,
    this.gift_icon,
    this.gift_title,
    this.no_questions,
    this.duration,
    this.time_remaining,
    this.fees,
    this.total_joining,
    this.winners,this.my_contest_id,this.is_delcared
  });

  User.fromJson(Map<String, dynamic> json) {
    contest_id = json['contest_id'].toString();
    tag = json['tag'];
    tilte = json['tilte'];
    date = json['date'];

    from_time = json['from_time'];
    to_time = json['to_time'];
    win_price = json['win_price'];

    gift_icon = json['gift_icon'];
    gift_title = json['gift_title'];
    no_questions = json['no_questions'];

    duration = json['duration'];
    time_remaining = json['time_remaining'];
    fees = json['fees'];
    total_joining = json['total_joining'];
    winners = json['winners'];
    my_contest_id = json['my_contest_id'];
    is_delcared = json['is_delcared'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['contest_id'] = this.contest_id;
    data['tag'] = this.tag;
    data['tilte'] = this.tilte;
    data['date'] = this.date;

    data['from_time'] = this.from_time;
    data['to_time'] = this.to_time;
    data['win_price'] = this.win_price;
    data['gift_icon'] = this.gift_icon;

    data['gift_title'] = this.gift_title;
    data['no_questions'] = this.no_questions;
    data['duration'] = this.duration;
    data['time_remaining'] = this.time_remaining;

    data['no_questions'] = this.no_questions;
    data['duration'] = this.duration;
    data['time_remaining'] = this.time_remaining;

    data['fees'] = this.fees;
    data['total_joining'] = this.total_joining;
    data['winners'] = this.winners;
    data['my_contest_id'] = this.my_contest_id;
    data['is_delcared'] = this.is_delcared;
    return data;
  }


}
//////////////////////////////////////////////////////Test List
class Album1 {
  String status;
  List<User1> data;

  Album1({this.status});

  Album1.fromJson(Map<String, dynamic> json)
  {
    status = json['status'];


    if (json['data'] != null)
    {
      data = new List<User1>();
      json['data'].forEach((v) {
        data.add(new User1.fromJson(v));

        isLoadingfree=false;
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
   // data['status'] = this.status;

    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class User1 {
  String my_subtest_id, subtopic_id,img,title,testdate,start_time,end_time,my_test_id;

  User1({
    this.my_subtest_id,
    this.subtopic_id,
    this.img,
    this.title,
    this.testdate,
    this.start_time,
    this.end_time,
    this.my_test_id,
  });

  User1.fromJson(Map<String, dynamic> json)
  {
    my_subtest_id = json['my_subtest_id'];
    subtopic_id = json['subtopic_id'];
    img = json['img'];
    title = json['title'];
    start_time = json['start_time'];
    end_time = json['end_time'];
    testdate = json['date'];
    my_test_id = json['my_test_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['my_subtest_id'] = this.my_subtest_id;
    data['subtopic_id'] = this.subtopic_id;

    data['img'] = this.img;
    data['title'] = this.title;
    data['start_time'] = this.start_time;
    data['end_time'] = this.end_time;
    data['date'] = this.testdate;
    data['my_test_id'] = this.my_test_id;

    return data;
  }
}