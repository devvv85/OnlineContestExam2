import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onlineexamcontest/Constants/MyColor.dart';
import 'package:onlineexamcontest/Constants/uidata.dart';
import 'package:onlineexamcontest/Dashboard/MainDashboard.dart';
import 'package:onlineexamcontest/Dashboard/ResultPage.dart';
import 'package:onlineexamcontest/Dashboard/WinnersPage.dart';
import 'package:onlineexamcontest/Login/Forgotpassword.dart';
import 'package:onlineexamcontest/Login/Registration.dart';
import 'package:onlineexamcontest/My%20Contest/LanguageSelection_LiveContest.dart';
import 'package:onlineexamcontest/My%20Contest/SyllabusPage.dart';
import 'package:onlineexamcontest/My%20Contest/screendevide.dart';
import 'package:onlineexamcontest/My%20Contest/termsandconditions.dart';
import 'package:onlineexamcontest/Result/LeaderBoard.dart';
import 'package:onlineexamcontest/slider/slider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

SharedPreferences prefs;
bool  isLoading_contest=false;String userId;
class MyResultContest extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _State();
}

class _State extends State<MyResultContest>
{
  List<User> users = new List<User>();
  TextEditingController editingController = TextEditingController();
  bool isclick = true;
  bool isclick1 = false;String  token1;
  bool isPaid = true, isFree = false;String status="";
  @override
  void initState() {
    setState(() {
      isLoading_contest=true;
      initializeSF();
    });

  }
  initializeSF() async {
    setState(() async {
      prefs = await SharedPreferences.getInstance();
      userId = prefs.getString("uId");
      token1 = prefs.getString("token");
      print("aaaas $userId");
      _apiGetMyContest();
    });

  }
  Future<Album> _apiGetMyContest() async {

    Map data = {"user_id": userId};
    print("Respon>>>$data");
    final response = await http.post(uidata.result_queue, body:data,headers: {'Authorization': token1});
    if (response.statusCode == 200) {
      var res = Album.fromJson(jsonDecode(response.body));
     var jsonData = json.decode(response.body);
      setState(() {
        status = jsonData['status'];
        //  status="0";
        if (status == "0")
        {
          isLoading_contest = false;
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

              Expanded(
                  child: Column(children: [
                    isLoading_contest
                        ? Container(
                      margin:
                      const EdgeInsets.only(left: 29.0, right: 29, top: 200),
                   //   color: Colors.white.withOpacity(.4),
                      child: Align(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(),
                      ),
                    )
                       : status == "0" ?
                    Container(
                      margin:
                      const EdgeInsets.only(left: 29.0, right: 29, top: 200),
                      color: MyColor.orange12,
                      child: Align(
                        alignment: Alignment.center,
                        child:Text("No data available!!",style: TextStyle(fontSize: 15),),
                      ),
                    ):  Visibility(
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
                                                            Padding(
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
                                                            ),

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
                                                                    Container(
                                                                      margin:EdgeInsets.only(left: 5,right: 5),
                                                                      alignment:
                                                                      Alignment.topLeft,
                                                                      //width: 10,
                                                                      height: 20,
                                                                      child: Image.network(users[index].gift_icon),
                                                                    ),
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
                                                              '??? '+users[index].fees,
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
                                                                child: RaisedButton(
                                                                  textColor: Colors.white,
                                                                  color: Colors.black,
                                                                  shape: RoundedRectangleBorder(
                                                                      side: BorderSide(
                                                                          color: MyColor.white,
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
                                                            Container(
                                                                height: 27,
                                                                width: 60,
                                                                child: RaisedButton(
                                                                  textColor: Colors.white,
                                                                  color: Colors.black,
                                                                  shape: RoundedRectangleBorder(
                                                                      side: BorderSide(
                                                                          color: MyColor.white,
                                                                          width: 1,
                                                                          style: BorderStyle.solid),
                                                                      borderRadius: BorderRadius.circular(5)),
                                                                  child: Text('Result', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white,),),
                                                                  onPressed: ()
                                                                  {
                                                                    // Navigator.push(context, MaterialPageRoute(builder: (context) => ResultPage()));
                                                                    Navigator.push(context, MaterialPageRoute(builder: (context) => LeaderboardPage(users[index].contest_id)));
                                                                  },
                                                                )),

                                                            GestureDetector(
                                                              onTap: () {
                                                                print("Container clicked");
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          WinnersPage('1')),
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
/*                                                            Container(
                                                                height: 27,
                                                                width: 52,
                                                                child: RaisedButton(
                                                                  textColor: Colors.white,
                                                                  color: Colors.green,
                                                                  shape: RoundedRectangleBorder(
                                                                      side: BorderSide(
                                                                          color: MyColor.white,
                                                                          width: 1,
                                                                          style: BorderStyle
                                                                              .solid),
                                                                      borderRadius: BorderRadius.circular(5)),
                                                                  child: Text(
                                                                    'Submitted',
                                                                    style: TextStyle(
                                                                      fontSize: 9,
                                                                      fontWeight:
                                                                      FontWeight.bold,
                                                                      color: Colors.white,
                                                                    ),
                                                                  ),
                                                                  onPressed: () {
                                                                    setState(() {
                                                                      // Navigator.push(context, MaterialPageRoute(builder: (context) => LanguageSelection_LiveContest(users[index].my_contest_id)));
                                                                      //  Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage4()));
                                                                      Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp9(users[index].my_contest_id)));
                                                                    });


                                                                    *//* Toast.show(
                                                            "Payment Option",
                                                            context,
                                                            duration: Toast
                                                                .LENGTH_LONG,
                                                            gravity:
                                                                Toast.BOTTOM);*//*
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
                                                            Padding(
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
                                                                  Text(
                                                                    " " +users[index].duration,
                                                                    style: TextStyle(
                                                                        fontSize: 12.0,
                                                                        fontWeight:
                                                                        FontWeight.bold,
                                                                        color: Colors.grey),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
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
//*****************************************************************************************************************************
                    Visibility(
                      visible: isFree,
                      child: Flexible(
                        child: ListView.builder(
                            shrinkWrap: true,
                            //itemCount: 2,
                            itemBuilder: (context, index) {
                              if (editingController.text.isEmpty)
                              {
                                //Paid
                                return new Card(
                                    margin: EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 10),
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
                                                                              "Live Contest",
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
                                                                      "10 Mar 6:00 PM to 7:00 PM ",
                                                                      maxLines: 5,
                                                                      style: TextStyle(
                                                                          fontSize: 12.0,
                                                                          fontWeight:
                                                                          FontWeight.bold,
                                                                          color: Colors.grey),
                                                                    )
                                                                )


                                                            ),
                                                            Padding(
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
                                                            ),

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
                                                            Text('Computer Knowladge',
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
                                                            Text('??? 1.22 Lacs Win Redme 6',
                                                                overflow: TextOverflow.ellipsis,
                                                                maxLines: 5,
                                                                style: new TextStyle(fontSize: 13.0, fontWeight: FontWeight.bold, color: Colors.black,)),
                                                            Text('??? 0',style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold,),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        padding: EdgeInsets.only(
                                                            top: 5,
                                                            // bottom: 5,
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

                                                                  Text(
                                                                    " " + "",
                                                                    style: TextStyle(
                                                                        fontSize: 12.0,
                                                                        fontWeight:
                                                                        FontWeight.bold,
                                                                        color: Colors.grey),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 18.0,
                                                            ),


                                                            GestureDetector(
                                                              onTap: ()
                                                              {
                                                                print("Container clicked");
                                                                Navigator.push(context, MaterialPageRoute(builder: (context) => WinnersPage("")),
                                                                );
                                                              },
                                                              child:Padding(
                                                                padding: const EdgeInsets.only(),
                                                                child:Container(
                                                                  padding: const EdgeInsets.all(3.0),
                                                                  decoration: BoxDecoration(border: Border.all(color: Colors.black45)),
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    children: <Widget>[
                                                                      Text(
                                                                        "Winners:5000",
                                                                        style: TextStyle(
                                                                            fontSize: 12.0,
                                                                            fontWeight: FontWeight.bold,
                                                                            color: Colors.black),
                                                                      ),
                                                                      Icon(
                                                                        Icons.arrow_drop_down_sharp,
                                                                        color: Colors.black,
                                                                        size: 17,
                                                                      ),],),),),),




                                                            Container(
                                                                height: 27,
                                                                width: 50,
                                                                child: RaisedButton(
                                                                  textColor: Colors.white,
                                                                  color: Colors.black,
                                                                  shape: RoundedRectangleBorder(
                                                                      side: BorderSide(
                                                                          color: MyColor.white,
                                                                          width: 1,
                                                                          style: BorderStyle.solid),
                                                                      borderRadius: BorderRadius.circular(5)),
                                                                  child: Text('Free', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white,),
                                                                  ),
                                                                  onPressed: ()
                                                                  {
                                                                    //  Toast.show("Payment Option", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                                                                  },
                                                                )),
                                                          ],
                                                        ),
                                                      ),

                                                      /////////////////////// ////////////////////////////////////////////////////////////////
                                                      Container(
                                                        padding: EdgeInsets.only(
                                                          // top: 5,
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
                                                                    " " + "333",
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
                                                            Padding(
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
                                                                  Text(
                                                                    " " + "30 min",
                                                                    style: TextStyle(
                                                                        fontSize: 12.0,
                                                                        fontWeight:
                                                                        FontWeight.bold,
                                                                        color: Colors.grey),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                                height: 22,
                                                                //  width: 100,
                                                                padding: EdgeInsets.only(top: 10),
                                                                child: Align(alignment: Alignment.center,
                                                                    child: Text(
                                                                      "Total Joining:45",
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
                    //  )
                  ]))

              //*****************************************************************************************************************
            ],
          ),
        ),
      ),
    );
  }
}
class DetailPage extends StatelessWidget {
  final User user;

  DetailPage(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: Container(
        child: Text(""),
      ),
    );
  }
}

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

        isLoading_contest=false;
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
      winners,my_contest_id;

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
    this.winners,this.my_contest_id,
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
    return data;
  }


}

