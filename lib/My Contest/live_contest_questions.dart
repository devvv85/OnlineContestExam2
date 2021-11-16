import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:onlineexamcontest/Constants/MyColor.dart';
import 'package:onlineexamcontest/Constants/uidata.dart';
import 'package:onlineexamcontest/Dashboard/MainDashboard.dart';
import 'package:onlineexamcontest/My%20Contest/Live_Contest_TestCompleteMsg.dart';
import 'package:onlineexamcontest/My%20Contest/MyContest.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

String ans = "1";
String my_contest_id, language;
List _answerList = [];
String userId, token1, questionId, ans_id = "";
var option = null;
SharedPreferences prefs;
String mysubtest_id;
bool isPre = false;
String status;
//String ans_id
//List<String> _answerList = [];
String duration = "";
final interval = const Duration(seconds: 1);
var timerMaxSeconds = Duration(seconds: int.parse(duration)).inSeconds;
int currentSeconds = 0;
var otp = "";
String mob1 = "";

String timerText(timerMaxSeconds) {
  print("secondssss>>$timerMaxSeconds");
  return '${(((timerMaxSeconds - currentSeconds) ~/ 60) ~/ 60).toString().padLeft(2, '0')}:${(((timerMaxSeconds - currentSeconds) ~/ 60) % 60).toString().padLeft(2, '0')}: ${((timerMaxSeconds - currentSeconds) % 60).toString().padLeft(2, '0')}';
}

String get timerText2 => '${(((timerMaxSeconds - currentSeconds) ~/ 60) ~/ 60).toString().padLeft(2, '0')}:${(((timerMaxSeconds - currentSeconds) ~/ 60) % 60).toString().padLeft(2, '0')}: ${((timerMaxSeconds - currentSeconds) % 60).toString().padLeft(2, '0')}';

//String get timerText => '${((timerMaxSeconds - currentSeconds) ~/ 60).toString().padLeft(2, '0')}: ${((timerMaxSeconds - currentSeconds) % 60).toString().padLeft(2, '0')}';
class LiveContest_questions extends StatefulWidget
{
  static final routeName = 'exam';
  bool isSubmit = false;

  @override
  //_EmployeesState createState() => _EmployeesState();
  qq createState() => qq();

  LiveContest_questions(String contestid) {
    my_contest_id = contestid;
    //   language = lang;

    print('subtopic_id1>> $my_contest_id');
  }
}

class qq extends State<LiveContest_questions> {
  String assettoload;
  List snap = [];
  String token, trainingName;
  String examid;
  bool _isLoading = false;
  int i = 0;
  BoxDecoration _decoration = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(10)),
      border: Border.all(color: MyColor.themecolor));
  BoxDecoration _decoration1 = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(10)),
      border: Border.all(color: MyColor.themecolor));
  BoxDecoration _decoration2 = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(10)),
      border: Border.all(color: MyColor.themecolor));
  BoxDecoration _decoration3 = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(10)),
      border: Border.all(color: MyColor.themecolor));
  BoxDecoration _decoration00 = BoxDecoration(
      color: MyColor.themecolor,
      borderRadius: BorderRadius.all(Radius.circular(10)),
      border: Border.all(color: MyColor.themecolor));
  BoxDecoration _decoration01 = BoxDecoration(
      color: MyColor.themecolor,
      borderRadius: BorderRadius.all(Radius.circular(10)),
      border: Border.all(color: MyColor.themecolor));
  BoxDecoration _decoration02 = BoxDecoration(
      color: MyColor.themecolor,
      borderRadius: BorderRadius.all(Radius.circular(10)),
      border: Border.all(color: MyColor.themecolor));
  BoxDecoration _decoration03 = BoxDecoration(
      color: MyColor.themecolor,
      borderRadius: BorderRadius.all(Radius.circular(10)),
      border: Border.all(color: MyColor.themecolor));
  bool _isPrevious = false;

  @override
  void initState() {
    super.initState();
    _answerList.clear();
    ans_id = "";
    initializeSF();
  }

  initializeSF() async {
    setState(() async {
      prefs = await SharedPreferences.getInstance();
      userId = prefs.getString("uId");
      token1 = prefs.getString("token");
      print("test>UserId>$userId $token1");

      getEmployees1(my_contest_id, language);
    });
  }

  _cancelTimer() {
    if (currentSeconds > 0) {
      Timer.periodic(const Duration(seconds: 1), (timer) {
        timer.cancel();
      });
    }
  }

  @override
  void dispose() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      timer.cancel();
    });
    _cancelTimer();
    super.dispose();
  }

////*********

  @override
  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => new AlertDialog(
            title: new Text(
              'My Contest',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: MyColor.themecolor),
            ),
            content: new Text(
                'Questions not available \nPlease contact to admin !!!',
                style: TextStyle(fontSize: 16, color: Colors.black54)),
            actions: <Widget>[
              Container(
                  // width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(right: 0, left: 30),
                  alignment: Alignment.centerRight,
                  /*  height: 120.0,
            width: 120.0,
            color: Colors.blue[50],*/
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      children: [
                        GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                              // Navigator.of(context).pop();
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyContest("noti")));
                            },
                            child: Align(
                                alignment: Alignment.center,
                                child: Container(
                                    margin:
                                        EdgeInsets.only(left: 10, right: 10),
                                    padding: EdgeInsets.all(3),
                                    height: 30,
                                    width: 50,
                                    color: MyColor.themecolor,
                                    child: Align(
                                        alignment: Alignment.center,
                                        child: Text(" OK ",
                                            style: TextStyle(
                                                fontSize: 11,
                                                color: MyColor.white)))))),
                      ],
                    ),
                  )),
            ],
          ),
        )) ??
        false;
  }

  //////*****************************
  getEmployees1(String subtopic_id1, String language) async {
    Map data = {"my_contest_id": my_contest_id};
    print("para>>$data");
    var jsonData = null;
    final res = await http.post(uidata.contestquestions,
        body: data, headers: {'Authorization': token1});
    var responsBody = json.decode(utf8.decode(res.bodyBytes));
    setState(() {
      duration = responsBody['duration'].toString();
      if (duration == null || duration.isEmpty) {
        duration = "00";
      }
      status = responsBody['status'];
      print("duration>>$duration");
    });
    print("Resss>>>$responsBody['data']");

    if (status == "0") {
      _isLoading = false;
      _onWillPop();
    } else {
      setState(() {
        //  timerText(duration);
        startTimeout();
      });
      setState(() {
        _isLoading = false;
        snap = responsBody['data'];
      });
    }
  }

  startTimeout([int milliseconds]) {
    var duration2 = interval;
    Timer.periodic(duration2, (timer) {
      setState(() {
        print(timer.tick);
        currentSeconds = timer.tick;
        if (timer.tick >= Duration(seconds: int.parse(duration)).inSeconds) {
          timer.cancel();
          setState(() {
            apiEndTest();
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () {
        if (status == "0") {
          _onWillPop();
        }
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: MyColor.themecolor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: MyColor.themecolor,
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          title: Text("My Contest",
              style: TextStyle(color: Colors.white, fontSize: 20.0)),
          elevation: 0,
          //Container(

          /*  padding:
         const EdgeInsets
             .all(3.0),*/
          /* child: Row(
           mainAxisAlignment:
           MainAxisAlignment
               .start,
           children: <
               Widget>[
           */ /*  Expanded(flex:3,child:Text("Test",style: TextStyle(color: Colors.white,
                 fontSize: 20.0)),),
            Expanded(flex:7,child: Text(timerMaxSeconds.toString(),style: TextStyle(color: Colors.white,
                 fontSize: 20.0)),),*/ /*
           ],
         ),*/
          //),
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 30.0),
                    height: 0.0,
                    color: MyColor.themecolor,
                  ),
                  Expanded(
                    child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0),
                          ),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              snap == null
                                  ? Center(
                                      child: Container(
                                        margin: EdgeInsets.only(top: 100.0),
                                        child: Text("No data available",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18.0)),
                                      ),
                                    )
                                  : snap.length == 0
                                      ? Center(
                                          child: Container(
                                            margin: EdgeInsets.only(top: 100.0),
                                            child: Text("No data available",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18.0)),
                                          ),
                                        )
                                      : Container(
                                          // margin: EdgeInsets.only(top:15.0),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          // height: MediaQuery.of(context).size.height,
                                          child: Column(
                                            children: [
                                              cc(i),
                                              SizedBox(height: 25.0),
                                              new Container(
                                                height: 60.0,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Center(
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Center(
                                                          child: Container(
                                                            height: 60.0,
                                                            child: RaisedButton
                                                                .icon(
                                                              onPressed: () {
                                                                setState(() {
                                                                  setState(() {
                                                                    if (isPre !=
                                                                        true) {
                                                                      //   ans_id="";
                                                                    }
                                                                  });
                                                                  // apiAnswerSubmit( "${snap[i]['question_id']}", option, my_contest_id);

                                                                  // apiAnswerSubmit("${snap[i]['ans_id']}", option);

                                                                  /*     apiAnswerSubmit("${snap[i]['ans_id']}", "${snap[i]['ans']}");
                                                                  isPre = false;
                                                                  i++;

                                                                  print("I=$i");
                                                                  print("Length=${snap.length}");*/
                                                                  _isPrevious =
                                                                      true;
                                                                  _decoration = BoxDecoration(
                                                                      color: Colors
                                                                          .white,
                                                                      borderRadius:
                                                                          BorderRadius.all(Radius.circular(
                                                                              10)),
                                                                      border: Border.all(
                                                                          color:
                                                                              MyColor.themecolor));
                                                                  _decoration1 = BoxDecoration(
                                                                      color: Colors
                                                                          .white,
                                                                      borderRadius:
                                                                          BorderRadius.all(Radius.circular(
                                                                              10)),
                                                                      border: Border.all(
                                                                          color:
                                                                              MyColor.themecolor));
                                                                  _decoration2 = BoxDecoration(
                                                                      color: Colors
                                                                          .white,
                                                                      borderRadius:
                                                                          BorderRadius.all(Radius.circular(
                                                                              10)),
                                                                      border: Border.all(
                                                                          color:
                                                                              MyColor.themecolor));
                                                                  _decoration3 = BoxDecoration(
                                                                      color: Colors
                                                                          .white,
                                                                      borderRadius:
                                                                          BorderRadius.all(Radius.circular(
                                                                              10)),
                                                                      border: Border.all(
                                                                          color:
                                                                              MyColor.themecolor));
                                                                  _decoration00 = BoxDecoration(
                                                                      color: Colors
                                                                          .white,
                                                                      borderRadius:
                                                                          BorderRadius.all(Radius.circular(
                                                                              10)),
                                                                      border: Border.all(
                                                                          color:
                                                                              MyColor.themecolor));
                                                                  _decoration01 = BoxDecoration(
                                                                      color: Colors
                                                                          .white,
                                                                      borderRadius:
                                                                          BorderRadius.all(Radius.circular(
                                                                              10)),
                                                                      border: Border.all(
                                                                          color:
                                                                              MyColor.themecolor));
                                                                  _decoration02 = BoxDecoration(
                                                                      color: Colors
                                                                          .white,
                                                                      borderRadius:
                                                                          BorderRadius.all(Radius.circular(
                                                                              10)),
                                                                      border: Border.all(
                                                                          color:
                                                                              MyColor.themecolor));
                                                                  _decoration03 = BoxDecoration(
                                                                      color: Colors
                                                                          .white,
                                                                      borderRadius:
                                                                          BorderRadius.all(Radius.circular(
                                                                              10)),
                                                                      border: Border.all(
                                                                          color:
                                                                              MyColor.themecolor));

                                                                  if (i <
                                                                      snap.length -
                                                                          1) {
                                                                    apiAnswerSubmit(
                                                                        "${snap[i]['ans_id']}",
                                                                        "${snap[i]['ans']}");
                                                                    isPre =
                                                                        false;
                                                                    i++;

                                                                    print(
                                                                        "LengthI=$i");
                                                                    print(
                                                                        "Lengthsnap=${snap.length}");
                                                                    cc(i);
                                                                  } else {
                                                                    apiAnswerSubmit(
                                                                        "${snap[i]['ans_id']}",
                                                                        "${snap[i]['ans']}");
                                                                    isPre =
                                                                        false;
                                                                    i--;
                                                                    /* print("LengthI=$i");
                                                      print("Lengthsnap=${snap
                                                          .length}");*/
                                                                    apiEndTest();
                                                                  }
                                                                });
                                                              },
                                                              color: MyColor
                                                                  .themecolor,
                                                              icon: Icon(
                                                                Icons
                                                                    .navigate_next,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              label: i <
                                                                      snap.length -
                                                                          1
                                                                  ? Text(
                                                                      "NEXT",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              16.0),
                                                                    )
                                                                  : Text(
                                                                      "SUBMIT",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              16.0),
                                                                    ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )),
                            ],
                          ),
                        )),
                  ),
                ],
              ),
      ),
    );
  }

  Widget cc(int i) {
    return Column(
      children: [
        SizedBox(height: 25.0),
        Container(
            margin: EdgeInsets.only(left: 0.0, bottom: 10.0),
            //  child: Text(timerText(int.parse(duration)),
            child: Text(timerText2,
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 21.0,
                    fontWeight: FontWeight.bold))),
        snap[i]['question_img'] != ""
            ? Container(
                //  height: MediaQuery.of(context).size.width * 0.7,
                // height: MediaQuery.of(context).size.height,
                margin: EdgeInsets.only(left: 0, right: 5),
                alignment: Alignment.topLeft,
                //  height: 70,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      snap[i]['questiontext'] == ""
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text('${snap[i]['index']})  ',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18.0)),
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: 5, right: 5),
                                          alignment: Alignment.topLeft,
                                          //  height: 200,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.7,
                                          child: FittedBox(
                                            fit: BoxFit.fill,
                                            child: Image.network(
                                                //'http://via.placeholder.com/350x150'),
                                                snap[i]['question_img']),
                                          ),
                                        ),
                                      ]),
                                ])
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text('${snap[i]['index']})  ',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18.0)),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.7,
                                          margin: EdgeInsets.only(
                                              left: 0, right: 5),
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            snap[i]['questiontext'],
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 5,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18.0),
                                          ),
                                        ),
                                      ]),
                                  Row(
                                      //   mainAxisAlignment: MainAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          //height: 200,
                                          margin: EdgeInsets.only(
                                              left: 0, right: 5, top: 2),
                                          alignment: Alignment.topLeft,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.7,
                                          child: FittedBox(
                                            fit: BoxFit.fill,
                                            child: Image.network(
                                                snap[i]['question_img']),
                                          ),
                                        ),
                                      ])
                                ])
                    ]))
            : Text('${snap[i]['index']})  ${snap[i]['questiontext']}',
                style: TextStyle(color: Colors.black, fontSize: 18.0)),
        SizedBox(height: 25.0),
        snap[i]['option_1_img'] != ""
            ? InkWell(
                child: snap[i]['YourAnswer'] == 'A'
                    ? Container(
                        height: 77.0,
                        margin:
                            EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
                        decoration: BoxDecoration(
                            color: MyColor.themecolor,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            border: Border.all(color: MyColor.themecolor)),
                        child: Center(
                            child: Row(
                          children: [
                            SizedBox(
                              width: 15.0,
                            ),
                            Text(
                              "A)",
                              style: TextStyle(
                                  color: Colors.black, fontSize: 16.0),
                            ),
                            SizedBox(
                              width: 15.0,
                            ),
                            snap[i]['option_1_img'] != ""
                                ? Container(
                                    margin: EdgeInsets.only(left: 5, right: 5),
                                    alignment: Alignment.topLeft,
                                    height: 77,
                                    child:
                                        Image.network(snap[i]['option_1_img']),
                                  )
                                : Container(
                                    height: 50,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "${snap[i]['option_1']}",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16.0),
                                    ),
                                  )
                          ],
                        )))
                    : Container(
                        // height: 77.0,
                        margin:
                            EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
                        decoration: _decoration,
                        child: Center(
                            child: Row(
                          children: [
                            SizedBox(
                              width: 15.0,
                            ),
                            Text(
                              "A)",
                              style: TextStyle(
                                  color: Colors.black, fontSize: 16.0),
                            ),
                            SizedBox(
                              width: 15.0,
                            ),
                            snap[i]['option_1_img'] != ""
                                ? Container(
                                    margin: EdgeInsets.only(left: 5, right: 5),
                                    alignment: Alignment.topLeft,
                                    height: 77,
                                    child:
                                        Image.network(snap[i]['option_1_img']),
                                  )
                                : Container(
                                    // height: 50,
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "${snap[i]['option_1']}",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16.0),
                                    ),
                                  ),
                          ],
                        ))),
                onTap: () {
                  setState(() {
                    option = "option_1";
                    snap[i]['ans'] = 'option_1';
                    //  option = "${snap[i]['option_1']}";
                    _decoration = BoxDecoration(
                        color: MyColor.themecolor,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: MyColor.themecolor));
                    _decoration1 = BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: MyColor.themecolor));
                    _decoration2 = BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: MyColor.themecolor));
                    _decoration3 = BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: MyColor.themecolor));
                    _decoration01 = BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: MyColor.themecolor));
                    _decoration02 = BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: MyColor.themecolor));
                    _decoration03 = BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: MyColor.themecolor));
                  });
                  //  apiAnswerSubmit(ans_id, userId, "${snap[i]['question_id']}", option,mysubtest_id);
                },
              )
            : InkWell(
                child: snap[i]['YourAnswer'] == 'A'
                    ? Container(
                        // height: 50.0,
                        margin:
                            EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
                        decoration: BoxDecoration(
                            color: MyColor.themecolor,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            border: Border.all(color: MyColor.themecolor)),
                        child: Center(
                            child: Row(
                          children: [
                            SizedBox(
                              width: 15.0,
                            ),
                            Text(
                              "A)",
                              style: TextStyle(
                                  color: Colors.black, fontSize: 16.0),
                            ),
                            SizedBox(
                              width: 15.0,
                            ),
                            snap[i]['option_1_img'] != ""
                                ? Container(
                                    margin: EdgeInsets.only(left: 5, right: 5),
                                    alignment: Alignment.topLeft,
                                    height: 77,
                                    child:
                                        Image.network(snap[i]['option_1_img']),
                                  )
                                : Container(
                                    //  height: 50,
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    margin: EdgeInsets.only(
                                        bottom: 12.0, top: 12.0),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "${snap[i]['option_1']}",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16.0),
                                    ),
                                  )
                          ],
                        )))
                    : Container(
                        //  height: 50.0,
                        margin:
                            EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
                        decoration: _decoration,
                        child: Center(
                            child: Row(
                          children: [
                            SizedBox(
                              width: 15.0,
                            ),
                            Text(
                              "A)",
                              style: TextStyle(
                                  color: Colors.black, fontSize: 16.0),
                            ),
                            SizedBox(
                              width: 15.0,
                            ),
                            snap[i]['option_1_img'] != ""
                                ? Container(
                                    margin: EdgeInsets.only(left: 5, right: 5),
                                    alignment: Alignment.topLeft,
                                    height: 77,
                                    child:
                                        Image.network(snap[i]['option_1_img']),
                                  )
                                : Container(
                                    margin: EdgeInsets.only(
                                        bottom: 12.0, top: 12.0),
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "${snap[i]['option_1']}",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16.0),
                                    ),
                                  ),
                          ],
                        ))),
                onTap: () {
                  setState(() {
                    option = "option_1";
                    snap[i]['ans'] = 'option_1';
                    //  option = "${snap[i]['option_1']}";
                    _decoration = BoxDecoration(
                        color: MyColor.themecolor,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: MyColor.themecolor));
                    _decoration1 = BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: MyColor.themecolor));
                    _decoration2 = BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: MyColor.themecolor));
                    _decoration3 = BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: MyColor.themecolor));
                    _decoration01 = BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: MyColor.themecolor));
                    _decoration02 = BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: MyColor.themecolor));
                    _decoration03 = BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: MyColor.themecolor));
                  });
                  //  apiAnswerSubmit(ans_id, userId, "${snap[i]['question_id']}", option,mysubtest_id);
                },
              ),
        snap[i]['option_2_img'] != ""
            ? InkWell(
                child: snap[i]['YourAnswer'] == 'B'
                    ? Container(
                        height: 77.0,
                        margin:
                            EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
                        decoration: BoxDecoration(
                            color: MyColor.themecolor,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            border: Border.all(color: MyColor.themecolor)),
                        child: Center(
                            child: Row(
                          children: [
                            SizedBox(
                              width: 15.0,
                            ),
                            Text(
                              "B)",
                              style: TextStyle(
                                  color: Colors.black, fontSize: 16.0),
                            ),
                            SizedBox(
                              width: 15.0,
                            ),
                            snap[i]['option_2_img'] != ""
                                ? Container(
                                    margin: EdgeInsets.only(left: 5, right: 5),
                                    alignment: Alignment.topLeft,
                                    height: 77,
                                    child:
                                        Image.network(snap[i]['option_2_img']),
                                  )
                                : Container(
                                    margin: EdgeInsets.only(
                                        bottom: 12.0, top: 12.0),
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "${snap[i]['option_2']}",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16.0),
                                    ),
                                  ),
                          ],
                        )))
                    : Container(
                        height: 77.0,
                        margin:
                            EdgeInsets.only(left: 30.0, right: 30.0, top: 15.0),
                        decoration: _decoration1,
                        child: Center(
                            child: Row(
                          children: [
                            SizedBox(
                              width: 15.0,
                            ),
                            Text(
                              "B)",
                              style: TextStyle(
                                  color: Colors.black, fontSize: 16.0),
                            ),
                            SizedBox(
                              width: 15.0,
                            ),
                            snap[i]['option_2_img'] != ""
                                ? Container(
                                    margin: EdgeInsets.only(left: 5, right: 5),
                                    alignment: Alignment.topLeft,
                                    height: 77,
                                    child:
                                        Image.network(snap[i]['option_2_img']),
                                  )
                                : Container(
                                    margin: EdgeInsets.only(
                                        bottom: 12.0, top: 12.0),
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "${snap[i]['option_2']}",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16.0),
                                    ),
                                  ),
                          ],
                        ))),
                onTap: () {
                  setState(() {
                    option = "option_2";
                    snap[i]['ans'] = 'option_2';
                    // option = "${snap[i]['option_2']}";
                    _decoration1 = BoxDecoration(
                        color: MyColor.themecolor,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: MyColor.themecolor));
                    _decoration = BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: MyColor.themecolor));
                    _decoration2 = BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: MyColor.themecolor));
                    _decoration3 = BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: MyColor.themecolor));
                    _decoration00 = BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: MyColor.themecolor));
                    _decoration02 = BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: MyColor.themecolor));
                    _decoration03 = BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: MyColor.themecolor));
                  });
                  //   apiAnswerSubmit(ans_id, userId, "${snap[i]['question_id']}", option,mysubtest_id);
                },
              )
            : InkWell(
                child: snap[i]['YourAnswer'] == 'B'
                    ? Container(
                        margin:
                            EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
                        decoration: BoxDecoration(
                            color: MyColor.themecolor,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            border: Border.all(color: MyColor.themecolor)),
                        child: Center(
                            child: Row(
                          children: [
                            SizedBox(
                              width: 15.0,
                            ),
                            Text(
                              "B)",
                              style: TextStyle(
                                  color: Colors.black, fontSize: 16.0),
                            ),
                            SizedBox(
                              width: 15.0,
                            ),
                            snap[i]['option_2_img'] != ""
                                ? Container(
                                    margin: EdgeInsets.only(left: 5, right: 5),
                                    alignment: Alignment.topLeft,
                                    height: 77,
                                    child:
                                        Image.network(snap[i]['option_2_img']),
                                  )
                                : Container(
                                    margin: EdgeInsets.only(
                                        bottom: 12.0, top: 12.0),
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "${snap[i]['option_2']}",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16.0),
                                    ),
                                  ),
                          ],
                        )))
                    : Container(
                        margin:
                            EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
                        decoration: _decoration1,
                        child: Center(
                            child: Row(
                          children: [
                            SizedBox(
                              width: 15.0,
                            ),
                            Text(
                              "B)",
                              style: TextStyle(
                                  color: Colors.black, fontSize: 16.0),
                            ),
                            SizedBox(
                              width: 15.0,
                            ),
                            snap[i]['option_2_img'] != ""
                                ? Container(
                                    margin: EdgeInsets.only(left: 5, right: 5),
                                    alignment: Alignment.topLeft,
                                    height: 77,
                                    child:
                                        Image.network(snap[i]['option_2_img']),
                                  )
                                : Container(
                                    margin: EdgeInsets.only(
                                        bottom: 12.0, top: 12.0),
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "${snap[i]['option_2']}",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16.0),
                                    ),
                                  ),
                          ],
                        ))),
                onTap: () {
                  setState(() {
                    option = "option_2";
                    snap[i]['ans'] = 'option_2';
                    // option = "${snap[i]['option_2']}";
                    _decoration1 = BoxDecoration(
                        color: MyColor.themecolor,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: MyColor.themecolor));
                    _decoration = BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: MyColor.themecolor));
                    _decoration2 = BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: MyColor.themecolor));
                    _decoration3 = BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: MyColor.themecolor));
                    _decoration00 = BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: MyColor.themecolor));
                    _decoration02 = BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: MyColor.themecolor));
                    _decoration03 = BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: MyColor.themecolor));
                  });
                  //   apiAnswerSubmit(ans_id, userId, "${snap[i]['question_id']}", option,mysubtest_id);
                },
              ),
        snap[i]['option_3_img'] != ""
            ? InkWell(
                child: snap[i]['YourAnswer'] == 'C'
                    ? Container(
                        height: 77.0,
                        margin:
                            EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
                        decoration: BoxDecoration(
                            color: MyColor.themecolor,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            border: Border.all(color: MyColor.themecolor)),
                        child: Center(
                            child: Row(
                          children: [
                            SizedBox(
                              width: 15.0,
                            ),
                            Text(
                              "C)",
                              style: TextStyle(
                                  color: Colors.black, fontSize: 16.0),
                            ),
                            SizedBox(
                              width: 15.0,
                            ),
                            snap[i]['option_3_img'] != ""
                                ? Container(
                                    margin: EdgeInsets.only(left: 5, right: 5),
                                    alignment: Alignment.topLeft,
                                    height: 77,
                                    child:
                                        Image.network(snap[i]['option_3_img']),
                                  )
                                : Container(
                                    height: 50,
                                    alignment: Alignment.center,
                                    child: Text(
                                      "${snap[i]['option_3']}",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16.0),
                                    ),
                                  ),
                          ],
                        )))
                    : Container(
                        height: 77.0,
                        margin:
                            EdgeInsets.only(left: 30.0, right: 30.0, top: 15.0),
                        decoration: _decoration2,
                        child: Center(
                            child: Row(
                          children: [
                            SizedBox(
                              width: 15.0,
                            ),
                            Text(
                              "C)",
                              style: TextStyle(
                                  color: Colors.black, fontSize: 16.0),
                            ),
                            SizedBox(
                              width: 15.0,
                            ),
                            snap[i]['option_3_img'] != ""
                                ? Container(
                                    margin: EdgeInsets.only(left: 5, right: 5),
                                    alignment: Alignment.topLeft,
                                    height: 77,
                                    child:
                                        Image.network(snap[i]['option_3_img']),
                                  )
                                : Container(
                                    height: 50,
                                    alignment: Alignment.center,
                                    child: Text(
                                      "${snap[i]['option_3']}",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16.0),
                                    ),
                                  ),
                          ],
                        ))),
                onTap: () {
                  setState(() {
                    option = "option_3";
                    snap[i]['ans'] = 'option_3';
                    //option = "${snap[i]['option_3']}";
                    _decoration2 = BoxDecoration(
                        color: MyColor.themecolor,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: MyColor.themecolor));
                    _decoration = BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: MyColor.themecolor));
                    _decoration1 = BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: MyColor.themecolor));
                    _decoration3 = BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: MyColor.themecolor));
                    _decoration00 = BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: MyColor.themecolor));
                    _decoration01 = BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: MyColor.themecolor));
                    _decoration03 = BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: MyColor.themecolor));
                  });
                  //  apiAnswerSubmit(ans_id, userId, "${snap[i]['question_id']}", option,mysubtest_id);
                },
              )
            : InkWell(
                child: snap[i]['YourAnswer'] == 'C'
                    ? Container(
                        //   height: 50.0,
                        margin:
                            EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
                        decoration: BoxDecoration(
                            color: MyColor.themecolor,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            border: Border.all(color: MyColor.themecolor)),
                        child: Center(
                            child: Row(
                          children: [
                            SizedBox(
                              width: 15.0,
                            ),
                            Text(
                              "C)",
                              style: TextStyle(
                                  color: Colors.black, fontSize: 16.0),
                            ),
                            SizedBox(
                              width: 15.0,
                            ),
                            snap[i]['option_3_img'] != ""
                                ? Container(
                                    margin: EdgeInsets.only(left: 5, right: 5),
                                    alignment: Alignment.topLeft,
                                    height: 77,
                                    child:
                                        Image.network(snap[i]['option_3_img']),
                                  )
                                : Container(
                                    margin: EdgeInsets.only(
                                        bottom: 12.0, top: 12.0),
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "${snap[i]['option_3']}",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16.0),
                                    ),
                                  ),
                          ],
                        )))
                    : Container(
                        //  height: 50.0,
                        margin:
                            EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
                        decoration: _decoration2,
                        child: Center(
                            child: Row(
                          children: [
                            SizedBox(
                              width: 15.0,
                            ),
                            Text(
                              "C)",
                              style: TextStyle(
                                  color: Colors.black, fontSize: 16.0),
                            ),
                            SizedBox(
                              width: 15.0,
                            ),
                            snap[i]['option_3_img'] != ""
                                ? Container(
                                    margin: EdgeInsets.only(left: 5, right: 5),
                                    alignment: Alignment.topLeft,
                                    height: 77,
                                    child:
                                        Image.network(snap[i]['option_3_img']),
                                  )
                                : Container(
                                    margin: EdgeInsets.only(
                                        bottom: 12.0, top: 12.0),
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "${snap[i]['option_3']}",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16.0),
                                    ),
                                  ),
                          ],
                        ))),
                onTap: () {
                  setState(() {
                    option = "option_3";
                    snap[i]['ans'] = 'option_3';
                    //option = "${snap[i]['option_3']}";
                    _decoration2 = BoxDecoration(
                        color: MyColor.themecolor,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: MyColor.themecolor));
                    _decoration = BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: MyColor.themecolor));
                    _decoration1 = BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: MyColor.themecolor));
                    _decoration3 = BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: MyColor.themecolor));
                    _decoration00 = BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: MyColor.themecolor));
                    _decoration01 = BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: MyColor.themecolor));
                    _decoration03 = BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: MyColor.themecolor));
                  });
                  //  apiAnswerSubmit(ans_id, userId, "${snap[i]['question_id']}", option,mysubtest_id);
                },
              ),
        snap[i]['option_4_img'] != ""
            ? InkWell(
                child: snap[i]['YourAnswer'] == 'D'
                    ? Container(
                        height: 77.0,
                        margin:
                            EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
                        decoration: BoxDecoration(
                            color: MyColor.themecolor,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            border: Border.all(color: MyColor.themecolor)),
                        child: Center(
                            child: Row(
                          children: [
                            SizedBox(
                              width: 15.0,
                            ),
                            Text(
                              "D)",
                              style: TextStyle(
                                  color: Colors.black, fontSize: 16.0),
                            ),
                            SizedBox(
                              width: 15.0,
                            ),
                            snap[i]['option_4_img'] != ""
                                ? Container(
                                    margin: EdgeInsets.only(left: 5, right: 5),
                                    alignment: Alignment.topLeft,
                                    height: 77,
                                    child:
                                        Image.network(snap[i]['option_4_img']),
                                  )
                                : Container(
                                    height: 50,
                                    alignment: Alignment.center,
                                    child: Text(
                                      "${snap[i]['option_4']}",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16.0),
                                    ),
                                  ),
                          ],
                        )))
                    : Container(
                        height: 77.0,
                        margin:
                            EdgeInsets.only(left: 30.0, right: 30.0, top: 15.0),
                        decoration: _decoration3,
                        child: Center(
                            child: Row(
                          children: [
                            SizedBox(
                              width: 15.0,
                            ),
                            Text(
                              "D)",
                              style: TextStyle(
                                  color: Colors.black, fontSize: 16.0),
                            ),
                            SizedBox(
                              width: 15.0,
                            ),
                            snap[i]['option_4_img'] != ""
                                ? Container(
                                    margin: EdgeInsets.only(left: 5, right: 5),
                                    alignment: Alignment.topLeft,
                                    height: 77,
                                    child:
                                        Image.network(snap[i]['option_4_img']),
                                  )
                                : Container(
                                    height: 50,
                                    alignment: Alignment.center,
                                    child: Text(
                                      "${snap[i]['option_4']}",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16.0),
                                    ),
                                  ),
                          ],
                        ))),
                onTap: () {
                  setState(() {
                    option = "option_4";
                    snap[i]['ans'] = 'option_4';
                    // option = "${snap[i]['option_4']}";
                    _decoration3 = BoxDecoration(
                        color: MyColor.themecolor,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: MyColor.themecolor));
                    _decoration = BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: MyColor.themecolor));
                    _decoration1 = BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: MyColor.themecolor));
                    _decoration2 = BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: MyColor.themecolor));
                    _decoration00 = BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: MyColor.themecolor));
                    _decoration01 = BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: MyColor.themecolor));
                    _decoration02 = BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: MyColor.themecolor));
                  });
                  //   apiAnswerSubmit(ans_id, userId, "${snap[i]['question_id']}", option,mysubtest_id);
                  // submitAns("${snap[i]['ExamQuetionId']}","D");
                },
              )
            : InkWell(
                child: snap[i]['YourAnswer'] == 'D'
                    ? Container(
                        //  height: 50.0,
                        margin:
                            EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
                        decoration: BoxDecoration(
                            color: MyColor.themecolor,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            border: Border.all(color: MyColor.themecolor)),
                        child: Center(
                            child: Row(
                          children: [
                            SizedBox(
                              width: 15.0,
                            ),
                            Text(
                              "D)",
                              style: TextStyle(
                                  color: Colors.black, fontSize: 16.0),
                            ),
                            SizedBox(
                              width: 15.0,
                            ),
                            snap[i]['option_4_img'] != ""
                                ? Container(
                                    margin: EdgeInsets.only(left: 5, right: 5),
                                    alignment: Alignment.topLeft,
                                    height: 77,
                                    child:
                                        Image.network(snap[i]['option_3_img']),
                                  )
                                : Container(
                                    margin: EdgeInsets.only(
                                        bottom: 12.0, top: 12.0),
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "${snap[i]['option_4']}",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16.0),
                                    ),
                                  ),
                          ],
                        )))
                    : Container(
                        //  height: 50.0,
                        margin:
                            EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
                        decoration: _decoration3,
                        child: Center(
                            child: Row(
                          children: [
                            SizedBox(
                              width: 15.0,
                            ),
                            Text(
                              "D)",
                              style: TextStyle(
                                  color: Colors.black, fontSize: 16.0),
                            ),
                            SizedBox(
                              width: 15.0,
                            ),
                            snap[i]['option_4_img'] != ""
                                ? Container(
                                    margin: EdgeInsets.only(left: 5, right: 5),
                                    alignment: Alignment.topLeft,
                                    height: 77,
                                    child:
                                        Image.network(snap[i]['option_4_img']),
                                  )
                                : Container(
                                    margin: EdgeInsets.only(
                                        bottom: 12.0, top: 12.0),
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "${snap[i]['option_4']}",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16.0),
                                    ),
                                  ),
                          ],
                        ))),
                onTap: () {
                  setState(() {
                    option = "option_4";
                    snap[i]['ans'] = 'option_4';
                    // option = "${snap[i]['option_4']}";
                    _decoration3 = BoxDecoration(
                        color: MyColor.themecolor,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: MyColor.themecolor));
                    _decoration = BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: MyColor.themecolor));
                    _decoration1 = BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: MyColor.themecolor));
                    _decoration2 = BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: MyColor.themecolor));
                    _decoration00 = BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: MyColor.themecolor));
                    _decoration01 = BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: MyColor.themecolor));
                    _decoration02 = BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: MyColor.themecolor));
                  });
                  //   apiAnswerSubmit(ans_id, userId, "${snap[i]['question_id']}", option,mysubtest_id);
                  // submitAns("${snap[i]['ExamQuetionId']}","D");
                },
              ),
      ],
    );
  }

  apiAnswerSubmit(String ansid, String option) async {
    //  Toast.show("api ans", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    Map data = {
      "ans_id": ansid,
      "option": option,
    };
    print("red>>$data");
    var jsonData = null;
    var response = await http.post(uidata.submitcontestans,
        body: data, headers: {'Authorization': token1});

    if (response.statusCode == 200) {
      setState(() {
        option = " ";
        option = null;
      });
      //    Toast.show("op222>>>"+option.toString(), context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      jsonData = json.decode(response.body);
      var status = jsonData['status'];
      var msg = jsonData['Message'];
      print("ressss>>$jsonData");

      if (status == "1") {
        setState(() {
          option = " ";
          option = null;
        });
      } else {
        Toast.show(msg, context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        print("in else");
      }
    } else {}
  }

  /////end test api
  apiEndTest() async {
    // Toast.show("end api", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    Map data = {
      "my_contest_id": my_contest_id,
    };
    print("para$data");
    var jsonData = null;
    var response = await http.post(uidata.endcontest,
        body: data, headers: {'Authorization': token1});

    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      var status = jsonData['status'];
      String Message = jsonData['Message'];
      print("endTest$jsonData");
      print('status $status');
      if (status == "1") {
        setState(() {
          option = " ";
          option = null;
          _cancelTimer();
          setState(() {
            //   Navigator.push(context, MaterialPageRoute(builder: (context) => MainDashboard(userId, true)));
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        Live_Contest_TestCompletePage(userId)));
          });
        });
      } else {
        Toast.show(Message, context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    } else {}
  }
}
