import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:onlineexamcontest/Constants/MyColor.dart';
import 'package:onlineexamcontest/Constants/uidata.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'TestCompleteMsg.dart';

bool isfirsttime = false;
String ans = "1";
String subtopic_id1, language;
List _answerList = [];
String userId, questionId, option = " ", ans_id = "";
SharedPreferences prefs;
String mysubtest_id;
bool isPre = false;

String duration = "";
final interval = const Duration(seconds: 1);
//var timerMaxSeconds = Duration(seconds: int.parse(duration)).inMinutes;
var timerMaxSeconds = Duration(seconds: int.parse(duration)).inSeconds;
int currentSeconds = 0;
var otp = "";
String mob1 = "";
String mysubtest_id1 = "", my_test_id1 = "", test_option;

String get timerText2 =>
    '${(((timerMaxSeconds - currentSeconds) ~/ 60) ~/ 60).toString().padLeft(2, '0')}:${(((timerMaxSeconds - currentSeconds) ~/ 60) % 60).toString().padLeft(2, '0')}: ${((timerMaxSeconds - currentSeconds) % 60).toString().padLeft(2, '0')}';
String timerTextvalue;
/*String timerText(timerMaxSeconds)
{
  print("secondssss>>$timerMaxSeconds");
 String  timerTextvalue ='${(((timerMaxSeconds - currentSeconds) ~/ 60) ~/ 60).toString().padLeft(2, '0')}:${(((timerMaxSeconds - currentSeconds) ~/ 60) % 60).toString().padLeft(2, '0')}: ${((timerMaxSeconds - currentSeconds) % 60).toString().padLeft(2, '0')}';
}*/

String token1;
/*main() async {

  WidgetsFlutterBinding.ensureInitialized();

  runApp(GetJson());
}*/
main() async {
  WidgetsFlutterBinding.ensureInitialized();
}

class GetJson extends StatefulWidget {
  // accept the langname as a parameter
  static final routeName = 'demo';

  @override
  qq createState() => qq();

/*  GetJson(String subtopic_id, String lang, String mysubtest_id1) {
    subtopic_id1 = subtopic_id;
    language = lang;
    mysubtest_id = mysubtest_id1;
    print('subtopic_id1>> $subtopic_id1>>lang>>$language');
  }*/

  GetJson(String mysubtest_id, String my_test_id, String test_option1) {
    mysubtest_id1 = mysubtest_id;
    my_test_id1 = my_test_id;
    test_option = test_option1;
    print('subtopic_id1>> $subtopic_id1>>lang>>$mysubtest_id');
  }
}

_cancelTimer() {
  if (currentSeconds > 0) {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      timer.cancel();
    });
  }
}

class qq extends State<GetJson> {
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

  initializeSF() async {
    setState(() async {
      currentSeconds = 1;
      prefs = await SharedPreferences.getInstance();
      userId = prefs.getString("uId");
      token1 = prefs.getString("token");
      print("test>UserId> $userId");
      getEmployees(mysubtest_id1, my_test_id1);
      ans_id = "";
    });
  }

  @override
  void dispose() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      timer.cancel();
    });
    _cancelTimer();
    super.dispose();
  }

  @override
  void initState() {
    /*   // TODO: implement initState
    super.initState();*/

    initializeSF();
  }

  getEmployees(String mysubtest_id1, my_test_id1) async {
    Map data = {"my_subtest_id": mysubtest_id1, "my_test_id": my_test_id1};
    print(data);
    var status;
    final res = await http.post(uidata.testquestions,
        body: data, headers: {'Authorization': token1});
    var responsBody = json.decode(utf8.decode(res.bodyBytes));
    setState(() {
      duration = responsBody['duration'];
      status = responsBody['status'];
      print("duration>>$duration");
      setState(() {
        // timerText(int.parse(duration));
      });
    });
    print(responsBody['data']);

    if (status == "0") {
      _isLoading = false;
    } else {
      setState(() {
        //  timerText(duration);
        //  timer.cancel();
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
      /*if (mounted) {*/ setState(() {
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
        if (snap.length <= 0) {
          return Future.value(true);
        } else {
          _showMyDialog();
          return Future.value(true);
        }
      },
      child: Scaffold(
        backgroundColor: MyColor.themecolor,
        appBar: AppBar(
          backgroundColor: MyColor.themecolor,
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          title: Text("Exam",
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

                                          //height: MediaQuery.of(context).size.height,
                                          child: Column(
                                            children: [
                                              cc(i),
                                              SizedBox(height: 25.0),

                                              //////clear option
/*                                              GestureDetector(
                                                onTap:()
                                                  {
                                                    setState(()
                                                    {

                                                      option="";
                                                      snap[i]['ans']="";
                                                      print("gfbhhnfrgdfrg");
                                                      cc(i);
                                                    });


                                                  },

                                                child: Container(
                                                  color: MyColor.themecolor,
                                                  height: 43.0,
                                                  margin: const EdgeInsets.only(left: 15.0, right: 15, top: 0,bottom:5),
                                                  child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [

                                                        Container(

                                                      child:Text("Clear Option")
                                                  ),


                                                      ])),)*/

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
                                                                    onPressed:
                                                                        () {
                                                                      if (i >
                                                                          0) {
                                                                        setState(
                                                                            () {
                                                                          print(
                                                                              "vall>>$i");
                                                                          i--;
                                                                          isPre =
                                                                              true;
                                                                          print(
                                                                              "I=$i");
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
                                                                          _decoration02 = BoxDecoration(
                                                                              color: Colors.white,
                                                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                                                              border: Border.all(color: MyColor.themecolor));
                                                                          _decoration03 = BoxDecoration(
                                                                              color: Colors.white,
                                                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                                                              border: Border.all(color: MyColor.themecolor));

                                                                          if (i <=
                                                                              0) {
                                                                            _isPrevious =
                                                                                false;
                                                                          } else {
                                                                            _isPrevious =
                                                                                true;
                                                                            cc(i);
                                                                            //  getEmployees(subtopic_id1, language);
                                                                          }
                                                                        });
                                                                      }
                                                                    },
                                                                    elevation:
                                                                        0,
                                                                    color: _isPrevious
                                                                        ? MyColor
                                                                            .themecolor
                                                                        : Colors
                                                                            .white,
                                                                    icon: _isPrevious
                                                                        ? Icon(
                                                                            Icons.navigate_before,
                                                                            color:
                                                                                Colors.white,
                                                                          )
                                                                        : Container(height: 60, width: 60),
                                                                    label: _isPrevious
                                                                        ? Text(
                                                                            "PREVIOUS",
                                                                            style:
                                                                                TextStyle(color: Colors.white, fontSize: 16.0),
                                                                          )
                                                                        : Container(height: 60, width: 60)),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
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
                                                                  /*  if ("${snap[i]['ans']}"
                                                                    .isNotEmpty) {*/
                                                                  setState(() {
                                                                    if (isPre !=
                                                                        true) {
                                                                      // ans_id="";
                                                                    }
                                                                  });

                                                                  /*      apiAnswerSubmit(
                                                                      "${snap[i]['ans_id']}", userId,
                                                                      "${snap[i]['question_id']}",
                                                                      "${snap[i]['ans']}", mysubtest_id);
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
                                                                  /*      if (i <
                                                                      snap.length) {
                                                                    cc(i);
                                                                    //  getEmployees(subtopic_id1, language);
                                                                  } else {
                                                                    i--;
                                                                    _showMyDialog();
                                                                  }
*/

                                                                  if (i <
                                                                      snap.length -
                                                                          1) {
                                                                    apiAnswerSubmit(
                                                                        "${snap[i]['ans_id']}",
                                                                        userId,
                                                                        "${snap[i]['question_id']}",
                                                                        "${snap[i]['ans']}",
                                                                        mysubtest_id);
                                                                    isPre =
                                                                        false;
                                                                    i++;

                                                                    print(
                                                                        "LengthI=$i");
                                                                    /*  print("Lengthsnap=${snap
                                                                        .length}");*/
                                                                    cc(i);
                                                                  } else {
                                                                    apiAnswerSubmit(
                                                                        "${snap[i]['ans_id']}",
                                                                        userId,
                                                                        "${snap[i]['question_id']}",
                                                                        "${snap[i]['ans']}",
                                                                        mysubtest_id);
                                                                    isPre =
                                                                        false;
                                                                    // i--;
                                                                    _showMyDialog();
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
            margin: EdgeInsets.only(left: 0.0, bottom: 15.0),
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
                child: snap[i]['ans'] == 'option_1'
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
                                  ),
                          ],
                        )))
                    : Container(
                        //  height: 77.0,
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
                },
              )
            : InkWell(
                child: snap[i]['ans'] == 'option_1'
                    ? Container(
                        //height: 50.0,
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
                                  ),
                          ],
                        )))
                    : Container(
                        // height: 50.0,
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
                },
              ),
        snap[i]['option_2_img'] != ""
            ? InkWell(
                child: snap[i]['ans'] == 'option_2'
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
                                    // height: 50,
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
                        //  height: 77.0,
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
                                    //  height: 50,
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
                },
              )
            : InkWell(
                child: snap[i]['ans'] == 'option_2'
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
                                    height: 50,
                                    child:
                                        Image.network(snap[i]['option_2_img']),
                                  )
                                : Container(
                                    // height: 50,
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
                        // height: 50.0,
                        //  width: MediaQuery.of(context).size.width * 0.7,
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
                                    height: 50,
                                    child:
                                        Image.network(snap[i]['option_2_img']),
                                  )
                                : Container(
                                    // height: 50,
                                    margin: EdgeInsets.only(
                                        bottom: 12.0, top: 12.0),
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "${snap[i]['option_2']}",
                                      /*  overflow: TextOverflow.ellipsis,
                                      maxLines: 5,*/
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
                },
              ),
        snap[i]['option_3_img'] != ""
            ? InkWell(
                child: snap[i]['ans'] == 'option_3'
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
                },
              )
            : InkWell(
                child: snap[i]['ans'] == 'option_3'
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
                                    //  height: 50,
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
                        // height: 50.0,
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
                                    // width: MediaQuery.of(context).size.width * 0.6,
                                    margin: EdgeInsets.only(
                                        bottom: 12.0, top: 12.0),
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    //  height: 50,
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
                },
              ),
        snap[i]['option_4_img'] != ""
            ? InkWell(
                child: snap[i]['ans'] == 'option_4'
                    ? Container(
                        height: 77.0,
                        margin:
                            EdgeInsets.only(left: 30.0, right: 30.0, top: 15.0),
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
                },
              )
            : InkWell(
                child: snap[i]['ans'] == 'option_4'
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
                        )))
                    : Container(
                        //   height: 50.0,
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
                },
              ),
      ],
    );
  }

  apiAnswerSubmit(String ans_id1, String user_id, String question_id,
      String option, String mysubtest_id) async {
    setState(() {
      isfirsttime = true;
    });

    Map data = {
      /*   "ans_id": ans_id1,
      "user_id": user_id,
      "question_id": question_id,
      "option": option,
      "mysubtest_id": mysubtest_id*/
      "ans_id": ans_id1,
      "option": option,
      "test_option": test_option
    };
    print("redeeeeee>>$data");
    var jsonData = null;
    var response = await http.post(uidata.testanswer,
        body: data, headers: {'Authorization': token1});

    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      var status = jsonData['status'];
      option = " ";
      if (status == "1") {
        setState(() {
          ans_id = jsonData['ans_id'];
          String question_id = jsonData['question_id'];
          setState(() {
            /* option = " ";*/
            // Fluttertoast.showToast(msg:"onres"+ option);
            ans_id = jsonData['ans_id'];
            print("red>>1$ans_id");
            // Fluttertoast.showToast(msg: "api res");
          });
        });
      } else {
        option = " ";
        /* Toast.show(msg, context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);*/
        print("in else");
      }
    } else {}
  }

  /////end test api
  apiEndTest() async {
    Map data = {
      "mysubtest_id": mysubtest_id1,
      "my_test_id": my_test_id1,
    };
    setState(() {
      isfirsttime = false;
    });

    print("EndTestData>> $data");
    var jsonData = null;
    var response = await http.post(uidata.endmysubtest,
        body: data, headers: {'Authorization': token1});

    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      var status = jsonData['status'];
      String Message = jsonData['Message'];
      print(jsonData);
      print('status $status');
      if (status == "1") {
        setState(() {
          _cancelTimer();
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      TestCompletePage(mysubtest_id1, my_test_id1)));
        });
      } else {}
    } else {}
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Do you want to submit test',
            style: TextStyle(fontSize: 18),
          ),
          content: SingleChildScrollView(),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Confirm',
                style: TextStyle(fontSize: 16),
              ),
              onPressed: () {
                print('Confirmed');
                Navigator.of(context).pop();
                apiEndTest();
              },
            ),
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(fontSize: 16),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
