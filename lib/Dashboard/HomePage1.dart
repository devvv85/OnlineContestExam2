import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:onlineexamcontest/Constants/MyColor.dart';
import 'package:onlineexamcontest/Constants/demoTimer.dart';
import 'package:onlineexamcontest/Constants/uidata.dart';
import 'package:onlineexamcontest/Dashboard/MainDashboard.dart';
import 'package:onlineexamcontest/Dashboard/WinnersPage.dart';
import 'package:onlineexamcontest/Login/Forgotpassword.dart';
import 'package:onlineexamcontest/Login/Registration.dart';
import 'package:onlineexamcontest/My%20Contest/ContestTermsAndCondition.dart';
import 'package:onlineexamcontest/My%20Contest/Live_Contest_TestCompleteMsg.dart';
import 'package:onlineexamcontest/My%20Contest/MyContest.dart';
import 'package:onlineexamcontest/My%20Contest/SyllabusPage.dart';
import 'package:onlineexamcontest/My%20Contest/screendevide.dart';
import 'package:onlineexamcontest/slider/ContestInfo.dart';
import 'package:onlineexamcontest/slider/slider.dart';
import 'package:onlineexamcontest/slider/sliderdemo1.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

import 'countdowntimer.dart';
import 'package:firebase_core/firebase_core.dart';


int timediff;
int timestamp = 600000000;
SharedPreferences prefs;
bool isLoadingpaid = false;
bool isLoadingfree = false;
String userId2;
String wallet = "", contestFees, contest_id, type = "";
String status = "", status1 = "", statuspaid = "";
Timer timer, timerPaidLooping, timerFreeLooping;
bool isall = true;
String strCatagoryType = "";
String time_remaining = "86400", category_id = "";

final interval = const Duration(seconds: 1);

int currentSeconds = 1;
int currentSecondsFree = 0;
var timerMaxSeconds = "";
var tappedIndex;
String token = "";

String timerText(timerMaxSeconds) {
  print("timerSec>>$currentSeconds");
  print("timerSecMax>>$timerMaxSeconds");
  timediff = timerMaxSeconds - currentSeconds;
  print("timerSecDiff<<$timediff");
  print(timerMaxSeconds - currentSeconds);
  return '${((timerMaxSeconds - currentSeconds) ~/ 86400).toString().padLeft(2, '0')},'
      ' ${(((timerMaxSeconds - currentSeconds) ~/ 3600) % 24).toString().padLeft(2, '0')}:'
      '${(((timerMaxSeconds - currentSeconds) ~/ 60) % 60).toString().padLeft(2, '0')}: '
      '${((timerMaxSeconds - currentSeconds) % 60).toString().padLeft(2, '0')}';
}

class HomePage1 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _State();

  HomePage1(String uId)
  {
    userId2 = uId;
  }
/*  startTimeoutDemo()
  {
    var duration = interval;
    Timer.periodic(duration, (timer)
    {

      currentSeconds++;
      print("time>$currentSeconds");
      Fluttertoast.showToast(msg:currentSeconds.toString());


    });
  }*/

}

class _State extends State<HomePage1> with WidgetsBindingObserver {
  TextEditingController editingController = TextEditingController();
  List<User> users = new List<User>();
  List<User> users_free = new List<User>();
  List<UserCatagory> userCatagory = new List<UserCatagory>();
  bool isclick = true;
  bool isclick1 = false;
  bool isPaid = true, isFree = false;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    //throw Exception("This is a crash!");


    setState(() {
      /* currentSeconds=0;
      Fluttertoast.showToast(msg: currentSeconds.toString());*/
      initializeSF();
    });
  }
 /* Future<void> _setupCrashlytics() async {
    await Firebase.initializeApp();
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    Function originalOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails errorDetails) async {
      await FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
      originalOnError(errorDetails);
    };
  }*/
  initializeSF() async {
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    apigetCatagory();
    // category_id="";
    setState(()
    {
      users.clear();
      users = new List<User>();
      _getCatagoriwise(category_id, "Paid");
    });

    if (timerFreeLooping != null) {
      timerFreeLooping.cancel();
    }
    if (timerPaidLooping != null)
    {
      timerPaidLooping.cancel();
    }
    setState(()
    {
      timerPaidLooping = Timer.periodic(Duration(seconds: 1), (Timer t) => _getCatagoriwise(category_id, "Paid"));
    });

    // timerPaidLooping = Timer.periodic(Duration(seconds: 1), (Timer t) => _getCatagoriwise(category_id,strCatagoryType));

    /* currentSeconds=0;
    Fluttertoast.showToast(msg:"Sec>>"+currentSeconds.toString());*/
    setState(() {
      if (timer != null) {
        timer.cancel();
      }
    });
    //   currentSeconds=0;
    // startTimeout();
  }

  @override
  void dispose() {
    if(timerPaidLooping!=null ||timerFreeLooping!=null)
      {
        timerPaidLooping.cancel();
        timerFreeLooping.cancel();
      }

    timer.cancel();
    /* timer=null;*/
    if (timer != null) {
      currentSeconds = 0;
      timer.cancel();
      Fluttertoast.showToast(msg: "cancel timer");
    }
    Fluttertoast.showToast(msg: "dispose");
    timerPaidLooping.cancel();
    timerFreeLooping.cancel();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      timer.cancel();
    });
    timer?.cancel();
    // timer1?.cancel();
    timer.cancel();
    _cancelTimer();
    super.dispose();
  }

  void clearTimer() {
    if (timer != null) {
      Timer.periodic(const Duration(seconds: 1), (timer) {
        timer.cancel();
      });
      timer?.cancel();
      // timer1?.cancel();
      timer.cancel();
      _cancelTimer();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      //  Fluttertoast.showToast(msg: "resume");
      _cancelTimer();
    }
    if (state == AppLifecycleState.paused) {
      // Fluttertoast.showToast(msg:"pause");
      // _cancelTimer();

      //  Fluttertoast.showToast(msg: "pause");

    }
    if (state == AppLifecycleState.inactive) {}
  }

  startTimeout() {
    var duration = interval;
    Timer.periodic(duration, (timer) {
      setState(() {
        currentSeconds++;
        /* currentSeconds+=1;*/
        print("time>$currentSeconds");
        //  Fluttertoast.showToast(msg:currentSeconds.toString());
        /* if (currentSeconds > 10)
        {
          timer.cancel();
        }*/
        /*currentSeconds = (timer.tick % 10) + 1;
        print("tick>>>>$currentSeconds");
        if(currentSeconds==10)
          {
            timerMaxSeconds=timediff.toString();
           print("timerMaxSeconds>>$timerMaxSeconds");

          }*/
      });
    });
  }

  startTimeoutFree() {
    var duration = interval;
    Timer.periodic(duration, (timer) {
      setState(() {
        currentSecondsFree++;
        print("time>$currentSecondsFree");
        /*currentSeconds = (timer.tick % 10) + 1;
        print("tick>>>>$currentSeconds");
        if(currentSeconds==10)
          {
            timerMaxSeconds=timediff.toString();
           print("timerMaxSeconds>>$timerMaxSeconds");

          }*/
      });
    });
  }

/*
  startTimeout()
  {
    var duration = interval;
    Timer.periodic(duration, (timer)
    {
      setState(()
      {
        currentSeconds = (timer.tick % 10) + 1;
        print("tick>>>>$currentSeconds");
        if(currentSeconds==10)
          {
            timerMaxSeconds=timediff.toString();
           print("timerMaxSeconds>>$timerMaxSeconds");

          }
      });
    });
  }
*/

  _cancelTimer() {
    if (currentSeconds > 0) {
      // timer.cancel();
      Timer.periodic(const Duration(seconds: 1), (timer) {
        timer.cancel();
      });
    } else {
      // Fluttertoast.showToast(msg:"in else"+currentSeconds.toString());
    }
  }

/*
  Future<Album> _getPaidTest(String flag) async {
   // Fluttertoast.showToast(msg: "paid");
    if (flag == "true") {
      isLoadingpaid = false;
    } else {
      isLoadingpaid = true;
    }
    Map data = {
      "user_id": userId2,
    };
    final response = await http.post(uidata.paidcontest,
        body: data, headers: {'Authorization': token});
    if (response.statusCode == 200)
    {
      currentSeconds = 0;
     // startTimeout();
      var res = Album.fromJson(jsonDecode(response.body));
      print("paid>>>>>>>>$res");
      var jsonData = json.decode(response.body);
      print("paid>>$jsonData");
      setState(() {
        status = jsonData['status'];
        print("paidstatus>>$status");
        currentSeconds = 0;
        if (status == "0") {
          isLoadingpaid = false;
        } else {
          setState(() {
            users = res.data;
          });
        }
      });
    } else {
      throw Exception('Failed to load test');
    }
  }
*/

/*
  Future<Album> _getFreeTest(String flag) async {
    // Fluttertoast.showToast(msg: "free");

     if (timerPaidLooping != null)
     {
       timerPaidLooping.cancel();
     }
    if (flag == "true")
    {
      isLoadingfree = false;
    }
    else
      {
      isLoadingfree = true;
    }

    Map data = {
      "user_id": userId2,
    };
    final response = await http.post(uidata.freecontest,
        body: data, headers: {'Authorization': token});
    if (response.statusCode == 200) {

      var res = Album.fromJson(jsonDecode(response.body));
      var jsonData = json.decode(response.body);
      print("paidfree>>$jsonData");
      setState(() {
        status1 = jsonData['status'];
        currentSecondsFree=0;
        if (status1 == "0") {
          isLoadingfree = false;
        } else {
          setState(() {
            if (timerPaidLooping != null) {
              timerPaidLooping.cancel();
            }
            users = res.data;
          */
/*  startTimeoutFree();
            timerFreeLooping = Timer.periodic(Duration(seconds: 10), (Timer t) => _getFreeTest("true"));*/ /*

          });
        }
      });
    } else {
      throw Exception('Failed to load test');
    }
  }
*/

//@@@@@@@@@@@@@@@@@catagories
  Future<Album2> apigetCatagory() async {
    tappedIndex = "";
    final response = await http
        .get(uidata.contest_categories, headers: {'Authorization': token});
    if (response.statusCode == 200) {
      var res = Album2.fromJson(jsonDecode(response.body));
      print("cat>>$res");
      var jsonData = json.decode(response.body);
      print("cat>>$jsonData");
      setState(() {
        var status4 = jsonData['status'];
        print("paidstatus>>$status4");
        if (status4 == "0") {
        } else {
          setState(()
          {
            userCatagory = res.data;
          });
        }
      });
    } else {
      throw Exception('Failed to load test');
    }
  }

//@@@@@@@@@@@@@@@@@@@@@@
  Future<Album> _getCatagoriwise(String category_id, String type) async {
    // Fluttertoast.showToast(msg: "api call");
    Map data = {
      "user_id": userId2,
      "contest_type": type,
      "category_id": category_id
    };
    print("catagory>>$data");
    final response = await http.post(uidata.contest_filter,
        body: data, headers: {'Authorization': token});
    print("catagory>>");

    if (response.statusCode == 200) {
      var res = Album.fromJson(jsonDecode(response.body));

      var jsonData = json.decode(response.body);
      print("catagory>>$jsonData");
      setState(() {
        if (isPaid) {
          status = jsonData['status'];
          status1 = "1";
        } else {
          status1 = jsonData['status'];
          status = "1";
        }
        //  currentSeconds = 0;
        print("paidstatus>>$status $status1");
        if (status == "0") {
          if (isPaid) {
            setState(() {
              status1 = "1";
              isLoadingpaid = false;
            });
          }
        } else if (status1 == "0") {
          if (isFree) {
            setState(() {
              status = "1";
              isLoadingfree = false;
            });
          }
        } else {
         setState(() {
            users = res.data;
          });
        }
      });
    } else {
      throw Exception('Failed to load test');
    }
  }
///
  /// free
  Future<Album> _getCatagoriwise_free(String category_id, String type) async
  {
    Map data = {
      "user_id": userId2,
      "contest_type": type,
      "category_id": category_id
    };
    print("catagory>>$data");
    final response = await http.post(uidata.contest_filter,
        body: data, headers: {'Authorization': token});
    print("catagory>>");

    if (response.statusCode == 200)
    {
      var res = Album.fromJson(jsonDecode(response.body));
      var jsonData = json.decode(response.body);
      print("catagory>>$jsonData");
      setState(() {
        if (isPaid) {
          status = jsonData['status'];
          status1 = "1";
        } else {
          status1 = jsonData['status'];
          status = "1";
        }
        //  currentSeconds = 0;
        print("paidstatus>>$status $status1");
        if (status == "0") {
          if (isPaid) {
            setState(() {
              status1 = "1";
              isLoadingpaid = false;
            });
          }
        } else if (status1 == "0") {
          if (isFree) {
            setState(() {
              status = "1";
              isLoadingfree = false;
            });
          }
        } else {
          setState(() {
            users_free = res.data;
          });
        }
      });
    } else {
      throw Exception('Failed to load test');
    }
  }
  //***********************************Dialog*****************************************************
  Future<void> dialogSelectWallet(
      BuildContext context, String cId, fees) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select Wallet',
              style: new TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              )),
          content: Container(
            height: 75,
            //  margin: EdgeInsets.only(left: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Divider(
                  color: Colors.white,
                  height: 1,
                ),
                GestureDetector(
                  // onTap: Navigator.pop(context); ,
                  onTap: () {
                    wallet = "Wallet1";
                    Navigator.pop(context);

                    apiTransaction(
                        userId2, "abcd", "Join Contest", contestFees, wallet);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        Icons.wallet_giftcard,
                        color: Colors.yellow,
                        size: 25,
                      ),
                      Text('  Wallet   ',
                          style: new TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          )),
                    ],
                  ),
                ),
                SizedBox(
                  height: 7.0,
                ),
                Divider(
                  color: Colors.black54,
                  height: 1,
                ),
                SizedBox(
                  height: 7.0,
                ),
                GestureDetector(
                  // onTap: Navigator.pop(context); ,
                  onTap: () {
                    wallet = "Wallet2";
                    Navigator.pop(context);
                    apiTransaction(
                        userId2, "abcd", "Join Contest", contestFees, wallet);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        Icons.wallet_giftcard,
                        color: Colors.yellow,
                        size: 25,
                      ),
                      Text('  Bonus Wallet  ',
                          style: new TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          )),
                    ],
                  ),
                ),
                SizedBox(
                  height: 7.0,
                ),
                /* Divider(
                  color: Colors.black54,
                  height: 1,
                ),*/
              ],
            ),
          ),

/*          actions: <Widget>[
            FlatButton(
              child: Text('OK',style: new TextStyle(
        fontSize: 15.0,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        )),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
           */ /* FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            )*/ /*
          ],*/
        );
      },
    );
  }

  @override
  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () {
                  exit(0);
                },
                /* Navigator.of(context).pop(true);
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => StartscreeenPage()), (route) => false);},*/

                //exit(0),
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

//****************************************************************************************

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: new GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Container(
            // children: <Widget>[
            color: MyColor.orange12,
            child: Column(
              children: <Widget>[
                Container(
                  color: MyColor.themecolor,
                  height: 50,

                  /// margin: const EdgeInsets.only(bottom: 2),
                  child: Container(
                    // color: Colors.black87,
                    color: MyColor.themecolor,
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
                        contentPadding: EdgeInsets.symmetric(horizontal: 6),
                        fillColor: Colors.white,
                        filled: true,
                        labelText: "Search",
                        prefixIcon: Icon(Icons.search),
                        suffixIcon: editingController.text.isNotEmpty
                            ? IconButton(
                                onPressed: () {
                                  FocusScope.of(context).unfocus();
                                  editingController.clear();
                                },
                                icon: Icon(Icons.clear),
                              )
                            : null,

                        //  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(1.0)))
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 145,
                  child: slidernew(),
                ),
                /*  Align(
                alignment: Alignment.centerLeft,*/
                // child:
                Container(
                  margin: EdgeInsets.only(left: 7),
                  height: 40,
                  child: catagories(),
                  // ),
                ),
                Container(
                  margin: EdgeInsets.all(3),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Note: Contest Registration will end before 30 min !",
                      style: TextStyle(fontSize: 12, color: Colors.red),
                    ),
                  ),
                ),

/*          Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(10),
                child: Text("fgbfg"),
              ),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(), ///
                shrinkWrap: true, ///
                scrollDirection: Axis.horizontal, ///
                itemCount: 5,
                itemBuilder: (BuildContext context, int index) => Card(
                  child: Column(
                    children: <Widget>[
                     // Image.asset('assets/food.jpg'),
                      Text("fgbhfh")
                    ],
                  ),
                ),
              )
            ],
          )*/
                Container(
                    padding: EdgeInsets.only(left: 30, right: 30, bottom: 2),
                    //  height: 100,
                    child: Row(children: <Widget>[
                      Expanded(
                          child: RaisedButton(
                              onPressed: () {
                                setState(() {
                                  isall = true;
                                  isclick = true;
                                  isclick1 = false;
                                  isPaid = true;
                                  isFree = false;

                                  _cancelTimer();
                                  if (timerFreeLooping != null)
                                  {
                                    timerFreeLooping.cancel();
                                  }
                                  if (timerPaidLooping != null)
                                  {
                                    timerPaidLooping.cancel();
                                  }
                                 /* users.clear();
                                  users = new List<User>();*/
                                  _getCatagoriwise(category_id, "Paid");
                                  timerPaidLooping = Timer.periodic(Duration(seconds: 1), (Timer t) => _getCatagoriwise(category_id, "Paid"));
                                  isLoadingfree = false;
                                  status1 = "1";
                                 // _cancelTimer();
                                  apigetCatagory();
                                });
                              },
                              color: isclick ? MyColor.yellow : Colors.white,
                              child: Text(
                                "Paid",
                                style: TextStyle(
                                    color:
                                        isclick ? Colors.white : Colors.black,
                                    fontWeight: FontWeight.bold),
                              ))),
                      Expanded(
                          child: RaisedButton(
                              onPressed: () {
                                setState(() {
                                  isall = true;
                                  isclick1 = true;
                                  isclick = false;
                                  isFree = true;
                                  isPaid = false;
                                  if(timerPaidLooping != null)
                                  {
                                    timerPaidLooping.cancel();
                                  }
                                  setState(()
                                  {
                                    users.clear();
                                    users = new List<User>();
                                    _getCatagoriwise_free(category_id, "Free");
                                  });
                                  setState(() {
                                    // currentSeconds=0;
                                    if(timerFreeLooping != null)
                                    {
                                      timerFreeLooping.cancel();
                                    }
                                   /* if(timerPaidLooping != null)
                                    {
                                      timerPaidLooping.cancel();
                                    }*/

                                    _cancelTimer();
                                  /*  setState(()
                                    {
                                        users.clear();
                                        users = new List<User>();
                                       _getCatagoriwise(category_id, "Free");
                                    });*/
                                    timerFreeLooping = Timer.periodic(Duration(seconds: 1), (Timer t) => _getCatagoriwise_free(category_id, "Free"));
                                  });

                                  isLoadingpaid = false;
                                  status = "1";
                               //   _cancelTimer();
                                  apigetCatagory();
                                });
                              },
                              color: isclick1 ? MyColor.yellow : Colors.white,
                              child: Text(
                                "Free",
                                style: TextStyle(
                                    color:
                                        isclick1 ? Colors.white : Colors.black,
                                    fontWeight: FontWeight.bold),
                              ))),
                    ])),

                Expanded(
                    child: Column(children: [
                  isLoadingpaid
                      ? Container(
                          margin: const EdgeInsets.only(left: 29.0, right: 29),
                          //  color: Colors.white.withOpacity(.4),
                          child: Align(
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : status == "0"
                          ? Container(
                              margin: const EdgeInsets.only(
                                  left: 29.0, right: 29, top: 30),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "No contest available !!",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.black38),
                                ),
                              ),
                            )
                          : Visibility(
                              visible: isPaid,
                              child: Flexible(
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: users.length,
                                    itemBuilder: (context, index) {
                                      if (editingController.text.isEmpty) {
                                        return new Card(
                                            margin: EdgeInsets.symmetric(
                                                vertical: 4, horizontal: 10),
                                            color: Theme.of(context).cardColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(0.5)),
                                            ),
                                            child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Container(
                                                      child: Container(
                                                          child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                      Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 5,
                                                                bottom: 5,
                                                                //  left: 15,
                                                                right: 2),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: <Widget>[
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      // left: 15,
                                                                      //top: 10,
                                                                      ),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: <
                                                                    Widget>[
                                                                  Container(
                                                                    color: Colors
                                                                        .red,
                                                                    width: 60,
                                                                    height: 17,
                                                                    child:
                                                                        Padding(
                                                                      padding:
                                                                          const EdgeInsets
                                                                              .only(),
                                                                      child:
                                                                          Container(
                                                                        padding:
                                                                            const EdgeInsets.all(3.0),
                                                                        decoration:
                                                                            BoxDecoration(border: Border.all(color: Colors.red)),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          children: <
                                                                              Widget>[
                                                                            Text(
                                                                              users[index].tag,
                                                                              style: TextStyle(fontSize: 8.0, fontWeight: FontWeight.bold, color: Colors.white),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            /*  SizedBox(
                                                  width: 30.0,
                                                ),*/
                                                            Container(
                                                                height: 22,
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        top:
                                                                            10),
                                                                child: Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .centerLeft,
                                                                    child: Text(
                                                                      users[index].date +
                                                                          ' ' +
                                                                          users[index]
                                                                              .from_time +
                                                                          ' to ' +
                                                                          users[index]
                                                                              .to_time,
                                                                      maxLines:
                                                                          5,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              12.0,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color:
                                                                              Colors.blue),
                                                                    ))),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                top: 10,
                                                              ),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: <
                                                                    Widget>[
                                                                  Icon(
                                                                    Icons
                                                                        .access_time,
                                                                    color: Colors
                                                                        .black,
                                                                    size: 14,
                                                                  ),
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) => OtpTimer()));
                                                                    },
                                                                    child: Text(
                                                                      ///" " + timerText ,
                                                                      users[index].time_remaining1 ==
                                                                              "0"
                                                                          ? "In progress"
                                                                          : " " +
                                                                              timerText(int.parse(users[index].time_remaining1)),
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      maxLines:
                                                                          5,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              11.0,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color:
                                                                              Colors.red),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                      Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 5,
                                                                bottom: 5,
                                                                left: 15,
                                                                right: 25),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: <Widget>[
                                                          Expanded(child:Text(
                                                                users[index]
                                                                    .tilte,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 7,
                                                                style:
                                                                    new TextStyle(
                                                                  fontSize:
                                                                      15.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .black,
                                                                ))),
                                                            Text(
                                                                users[index].c_status ==
                                                                        "Running"
                                                                    ? users[index]
                                                                        .c_status
                                                                    : "",
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 2,
                                                                style:
                                                                    new TextStyle(
                                                                  fontSize:
                                                                      10.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .red,
                                                                )),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                bottom: 5,
                                                                left: 15,
                                                                right: 25),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
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
                                                                  const EdgeInsets
                                                                      .only(),
                                                              child: Container(
                                                                /* padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        3.0),*/
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        1.0),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: <
                                                                      Widget>[
                                                                    Image.asset(
                                                                      'assets/images/wincup.jpg',
                                                                      height:
                                                                          15,
                                                                      width: 15,
                                                                    ),
                                                                    Text(
                                                                        users[index]
                                                                            .win_price,
                                                                        overflow:
                                                                            TextOverflow
                                                                                .ellipsis,
                                                                        maxLines:
                                                                            5,
                                                                        style:
                                                                            new TextStyle(
                                                                          fontSize:
                                                                              13.0,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          color:
                                                                              Colors.black,
                                                                        )),
                                                                    Visibility(
                                                                      visible: users[
                                                                              index]
                                                                          .gift_icon
                                                                          .isNotEmpty,
                                                                      child:
                                                                          Container(
                                                                        margin: EdgeInsets.only(
                                                                            left:
                                                                                5,
                                                                            right:
                                                                                5),
                                                                        alignment:
                                                                            Alignment.topLeft,
                                                                        //width: 10,
                                                                        height:
                                                                            20,
                                                                        child: Image.network(
                                                                            users[index].gift_icon),
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      users[index]
                                                                          .gift_title,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              12.0,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color:
                                                                              Colors.black),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            Text(
                                                              '₹ ' +
                                                                  users[index]
                                                                      .fees,
                                                              style: TextStyle(
                                                                fontSize: 12.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),

                                                      Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 5,
                                                                // bottom: 5,
                                                                left: 5,
                                                                right: 5),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: <Widget>[
                                                            Container(
                                                                height: 27,
                                                                width: 70,
                                                                child:
                                                                    RaisedButton(
                                                                  textColor:
                                                                      Colors
                                                                          .white,
                                                                  color: Colors
                                                                      .black,
                                                                  shape: RoundedRectangleBorder(
                                                                      side: BorderSide(
                                                                          color: Colors
                                                                              .black,
                                                                          width:
                                                                              1,
                                                                          style: BorderStyle
                                                                              .solid),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5)),
                                                                  child: Text(
                                                                    'Syllabus',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          9,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator
                                                                        .push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              SyllabusPage(users[index].contest_id)),
                                                                    );
                                                                  },
                                                                )),
/*                                                Container(
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
                                                      child: Text('Result', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white,),
                                                      ),
                                                      onPressed: ()
                                                      {
                                                        Navigator.push(context,
                                                            MaterialPageRoute(builder: (context) => ResultPage()));
                                                        // Toast.show("Payment Option", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                                                      },
                                                    )),*/
                                                            GestureDetector(
                                                              onTap: () {
                                                                print(
                                                                    "Container clicked");
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          WinnersPage(
                                                                              users[index].contest_id)),
                                                                );
                                                              },
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(),
                                                                child:
                                                                    Container(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          3.0),
                                                                  decoration: BoxDecoration(
                                                                      border: Border.all(
                                                                          color:
                                                                              Colors.black45)),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: <
                                                                        Widget>[
                                                                      Text(
                                                                        "Winners:" +
                                                                            users[index].winners,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                12.0,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color: Colors.black),
                                                                      ),
                                                                      Icon(
                                                                        Icons
                                                                            .arrow_drop_down_sharp,
                                                                        color: Colors
                                                                            .black,
                                                                        size:
                                                                            17,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Container(
                                                                height: 27,
                                                                width: 60,
                                                                child:
                                                                    RaisedButton(
                                                                  textColor:
                                                                      Colors
                                                                          .white,
                                                                  color: Colors
                                                                      .grey,
                                                                  shape: RoundedRectangleBorder(
                                                                      side: BorderSide(
                                                                          color: Colors
                                                                              .grey,
                                                                          width:
                                                                              1,
                                                                          style: BorderStyle
                                                                              .solid),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5)),
                                                                  child: Text(
                                                                    'T & C',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          9,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    setState(
                                                                        () {
                                                                      Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) => MyContestTermscondition(users[index].contest_id)));
                                                                    });
                                                                  },
                                                                )),
                                                            Visibility(
                                                              visible: users[index]
                                                                          .j_status ==
                                                                      "0" &&
                                                                  users[index]
                                                                          .c_status ==
                                                                      "Pending",
                                                              child: Container(
                                                                  height: 27,
                                                                  width: 52,
                                                                  child:
                                                                      RaisedButton(
                                                                    textColor:
                                                                        Colors
                                                                            .white,
                                                                    color: Colors
                                                                        .green,
                                                                    shape: RoundedRectangleBorder(
                                                                        side: BorderSide(
                                                                            color: MyColor
                                                                                .white,
                                                                            width:
                                                                                1,
                                                                            style: BorderStyle
                                                                                .solid),
                                                                        borderRadius:
                                                                            BorderRadius.circular(5)),
                                                                    child: Text(
                                                                      'Join',
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            9,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                    ),
                                                                    onPressed:
                                                                        () {
                                                                      type =
                                                                          "paid";
                                                                      contestFees =
                                                                          users[index]
                                                                              .fees;
                                                                      contest_id =
                                                                          users[index]
                                                                              .contest_id;
                                                                      Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) => MyApp9(users[index].contest_id, contestFees, type)));
                                                                      /*  apiJoin(
                                                                        userId2,
                                                                        users[index].contest_id,
                                                                        users[index].c_status);*/
                                                                      // dialogSelectWallet(context,users[index].contest_id,contestFees);
/*                                                                    setState(()
                                                                    {
                                                                      if (users[index].c_status == "Pending")
                                                                      {
                                                                        Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp9(users[index].contest_id, contestFees, type)));
                                                                      }
                                                                      else {
                                                                        Fluttertoast.showToast(msg: "Contest is " + users[index].c_status);
                                                                      }
                                                                    });*/
                                                                      //dialogSelectWallet(context);
                                                                    },
                                                                  )),
                                                            )
                                                          ],
                                                        ),
                                                      ),

                                                      /////////////////////// ////////////////////////////////////////////////////////////////
                                                      Container(
                                                        padding:
                                                            EdgeInsets.only(
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
                                                                  const EdgeInsets
                                                                          .only(
                                                                      // left: 15,
                                                                      //top: 10,

                                                                      ),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: <
                                                                    Widget>[
                                                                  Icon(
                                                                    Icons
                                                                        .assignment,
                                                                    color: Colors
                                                                        .black54,
                                                                    size: 17,
                                                                  ),
                                                                  Text(
                                                                    " " +
                                                                        users[index]
                                                                            .no_questions,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            12.0,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .grey),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            /* SizedBox(
                                              width: 18.0,
                                            ),*/
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                left: 20,
                                                                top: 10,
                                                              ),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: <
                                                                    Widget>[
                                                                  Icon(
                                                                    Icons
                                                                        .access_time,
                                                                    color: Colors
                                                                        .black54,
                                                                    size: 17,
                                                                  ),
                                                                  Text(
                                                                    " " +
                                                                        users[index]
                                                                            .d_duration +
                                                                        " ",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            12.0,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .grey),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                                height: 22,
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        top:
                                                                            10),
                                                                child: Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    child: Text(
                                                                      "Total Join:" +
                                                                          users[index]
                                                                              .total_joining,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              10.0,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color:
                                                                              Colors.grey),
                                                                    ))),
                                                          ],
                                                        ),
                                                      ),

                                                      /////////////////////////////////////////////////////////////////////////////////////////////////
                                                    ],
                                                  )))
                                                ]));
                                      } else if (users[index]
                                          .tilte
                                          .toLowerCase()
                                          .contains(editingController.text
                                              .toLowerCase())) {
                                        ///@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ else if {
                                        return new Card(
                                            margin: EdgeInsets.symmetric(
                                                vertical: 4, horizontal: 10),
                                            color: Theme.of(context).cardColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(0.5)),
                                            ),
                                            child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Container(
                                                      child: Container(
                                                          child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                      Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 5,
                                                                bottom: 5,
                                                                //  left: 15,
                                                                right: 2),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: <Widget>[
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      // left: 15,
                                                                      //top: 10,
                                                                      ),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: <
                                                                    Widget>[
                                                                  Container(
                                                                    color: Colors
                                                                        .red,
                                                                    width: 60,
                                                                    height: 17,
                                                                    child:
                                                                        Padding(
                                                                      padding:
                                                                          const EdgeInsets
                                                                              .only(),
                                                                      child:
                                                                          Container(
                                                                        padding:
                                                                            const EdgeInsets.all(3.0),
                                                                        decoration:
                                                                            BoxDecoration(border: Border.all(color: Colors.red)),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          children: <
                                                                              Widget>[
                                                                            Text(
                                                                              users[index].tag,
                                                                              style: TextStyle(fontSize: 8.0, fontWeight: FontWeight.bold, color: Colors.white),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            /*  SizedBox(
                                                  width: 30.0,
                                                ),*/
                                                            Container(
                                                                height: 22,
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        top:
                                                                            10),
                                                                child: Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .centerLeft,
                                                                    child: Text(
                                                                      users[index].date +
                                                                          ' ' +
                                                                          users[index]
                                                                              .from_time +
                                                                          ' to ' +
                                                                          users[index]
                                                                              .to_time,
                                                                      maxLines:
                                                                          5,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              12.0,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color:
                                                                              Colors.blue),
                                                                    ))),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                top: 10,
                                                              ),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: <
                                                                    Widget>[
                                                                  Icon(
                                                                    Icons
                                                                        .access_time,
                                                                    color: Colors
                                                                        .black,
                                                                    size: 14,
                                                                  ),
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) => OtpTimer()));
                                                                    },
                                                                    child: Text(
                                                                      users[index].time_remaining1 ==
                                                                              "0"
                                                                          ? "In progress"
                                                                          : " " +
                                                                              timerText(int.parse(users[index].time_remaining1)),
                                                                      //  " " + timerText ,
                                                                      // users[index].time_remaining1,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      maxLines:
                                                                          5,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              11.0,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color:
                                                                              Colors.red),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                      Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 5,
                                                                bottom: 5,
                                                                left: 15,
                                                                right: 25),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: <Widget>[
                                                            Expanded(child:Text(
                                                                users[index]
                                                                    .tilte,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 7,
                                                                style:
                                                                    new TextStyle(
                                                                  fontSize:
                                                                      15.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .black,
                                                                )),),
                                                            Text(
                                                                users[index].c_status ==
                                                                        "Running"
                                                                    ? users[index]
                                                                        .c_status
                                                                    : "",
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 2,
                                                                style:
                                                                    new TextStyle(
                                                                  fontSize:
                                                                      10.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .red,
                                                                )),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                bottom: 5,
                                                                left: 15,
                                                                right: 25),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
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
                                                                  const EdgeInsets
                                                                      .only(),
                                                              child: Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        3.0),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: <
                                                                      Widget>[
                                                                    Image.asset(
                                                                      'assets/images/wincup.jpg',
                                                                      height:
                                                                          15,
                                                                      width: 15,
                                                                    ),
                                                                    Text(
                                                                        users[index]
                                                                            .win_price,
                                                                        overflow:
                                                                            TextOverflow
                                                                                .ellipsis,
                                                                        maxLines:
                                                                            5,
                                                                        style:
                                                                            new TextStyle(
                                                                          fontSize:
                                                                              13.0,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          color:
                                                                              Colors.black,
                                                                        )),
                                                                    Visibility(
                                                                      visible: users[
                                                                              index]
                                                                          .gift_icon
                                                                          .isNotEmpty,
                                                                      child:
                                                                          Container(
                                                                        margin: EdgeInsets.only(
                                                                            left:
                                                                                5,
                                                                            right:
                                                                                5),
                                                                        alignment:
                                                                            Alignment.topLeft,
                                                                        //width: 10,
                                                                        height:
                                                                            20,
                                                                        child: Image.network(
                                                                            users[index].gift_icon),
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      users[index]
                                                                          .gift_title,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              12.0,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color:
                                                                              Colors.black),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            Text(
                                                              '₹ ' +
                                                                  users[index]
                                                                      .fees,
                                                              style: TextStyle(
                                                                fontSize: 12.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),

                                                      Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 5,
                                                                // bottom: 5,
                                                                left: 5,
                                                                right: 5),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: <Widget>[
                                                            Container(
                                                                height: 27,
                                                                width: 70,
                                                                child:
                                                                    RaisedButton(
                                                                  textColor:
                                                                      Colors
                                                                          .white,
                                                                  color: Colors
                                                                      .black,
                                                                  shape: RoundedRectangleBorder(
                                                                      side: BorderSide(
                                                                          color: Colors
                                                                              .black,
                                                                          width:
                                                                              1,
                                                                          style: BorderStyle
                                                                              .solid),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5)),
                                                                  child: Text(
                                                                    'Syllabus',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          9,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator
                                                                        .push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              SyllabusPage(users[index].contest_id)),
                                                                    );
                                                                  },
                                                                )),
/*                                                Container(
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
                                                      child: Text('Result', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white,),
                                                      ),
                                                      onPressed: ()
                                                      {
                                                        Navigator.push(context,
                                                            MaterialPageRoute(builder: (context) => ResultPage()));
                                                        // Toast.show("Payment Option", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                                                      },
                                                    )),*/
                                                            GestureDetector(
                                                              onTap: () {
                                                                print(
                                                                    "Container clicked");
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          WinnersPage(
                                                                              users[index].contest_id)),
                                                                );
                                                              },
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(),
                                                                child:
                                                                    Container(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          3.0),
                                                                  decoration: BoxDecoration(
                                                                      border: Border.all(
                                                                          color:
                                                                              Colors.black45)),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: <
                                                                        Widget>[
                                                                      Text(
                                                                        "Winners:" +
                                                                            users[index].winners,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                12.0,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color: Colors.black),
                                                                      ),
                                                                      Icon(
                                                                        Icons
                                                                            .arrow_drop_down_sharp,
                                                                        color: Colors
                                                                            .black,
                                                                        size:
                                                                            17,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Container(
                                                                height: 27,
                                                                width: 60,
                                                                child:
                                                                    RaisedButton(
                                                                  textColor:
                                                                      Colors
                                                                          .white,
                                                                  color: Colors
                                                                      .grey,
                                                                  shape: RoundedRectangleBorder(
                                                                      side: BorderSide(
                                                                          color: Colors
                                                                              .grey,
                                                                          width:
                                                                              1,
                                                                          style: BorderStyle
                                                                              .solid),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5)),
                                                                  child: Text(
                                                                    'T & C',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          9,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    setState(
                                                                        () {
                                                                      Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) => MyContestTermscondition(users[index].contest_id)));
                                                                    });
                                                                  },
                                                                )),
                                                            Visibility(
                                                              visible: users[index]
                                                                          .j_status ==
                                                                      "0" &&
                                                                  users[index]
                                                                          .c_status ==
                                                                      "Pending",
                                                              child: Container(
                                                                  height: 27,
                                                                  width: 50,
                                                                  child:
                                                                      RaisedButton(
                                                                    textColor:
                                                                        Colors
                                                                            .white,
                                                                    color: Colors
                                                                        .green,
                                                                    shape: RoundedRectangleBorder(
                                                                        side: BorderSide(
                                                                            color: MyColor
                                                                                .white,
                                                                            width:
                                                                                1,
                                                                            style: BorderStyle
                                                                                .solid),
                                                                        borderRadius:
                                                                            BorderRadius.circular(5)),
                                                                    child: Text(
                                                                      'Join',
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            9,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                    ),
                                                                    onPressed:
                                                                        () {
                                                                      type = "paid";
                                                                      contestFees = users[index].fees;
                                                                      Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp9(users[index].contest_id, contestFees, type)));
/*                                                                    apiJoin(
                                                                        userId2,
                                                                        users[index]
                                                                            .contest_id,
                                                                        users[index]
                                                                            .c_status);*/
                                                                      //   dialogSelectWallet(context,users[index].contest_id,contestFees);
/*



 setState(() {
                                                                      if (users[index]
                                                                          .c_status ==
                                                                          "Pending") {
                                                                        Navigator
                                                                            .push(
                                                                            context,
                                                                            MaterialPageRoute(
                                                                                builder: (
                                                                                    context) =>
                                                                                    MyApp9(
                                                                                        users[index]
                                                                                            .contest_id,
                                                                                        contestFees,
                                                                                        type)));
                                                                      }
                                                                      else {
                                                                        Fluttertoast
                                                                            .showToast(
                                                                            msg: "Contest is " +
                                                                                users[index]
                                                                                    .c_status);
                                                                      }
                                                                    });*/
                                                                      //  dialogSelectWallet(context);
                                                                    },
                                                                  )),
                                                            ),
                                                          ],
                                                        ),
                                                      ),

                                                      /////////////////////// ////////////////////////////////////////////////////////////////
                                                      Container(
                                                        padding:
                                                            EdgeInsets.only(
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
                                                                  const EdgeInsets
                                                                          .only(
                                                                      // left: 15,
                                                                      //top: 10,

                                                                      ),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: <
                                                                    Widget>[
                                                                  Icon(
                                                                    Icons
                                                                        .assignment,
                                                                    color: Colors
                                                                        .black54,
                                                                    size: 17,
                                                                  ),
                                                                  Text(
                                                                    " " +
                                                                        users[index]
                                                                            .no_questions,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            12.0,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .grey),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            /* SizedBox(
                                              width: 18.0,
                                            ),*/
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                left: 20,
                                                                top: 10,
                                                              ),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: <
                                                                    Widget>[
                                                                  Icon(
                                                                    Icons
                                                                        .access_time,
                                                                    color: Colors
                                                                        .black54,
                                                                    size: 17,
                                                                  ),
                                                                  Text(
                                                                    " " +
                                                                        users[index]
                                                                            .d_duration +
                                                                        " ",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            12.0,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .grey),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                                height: 22,
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        top:
                                                                            10),
                                                                child: Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    child: Text(
                                                                      "Total Join:" +
                                                                          users[index]
                                                                              .total_joining,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              10.0,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color:
                                                                              Colors.grey),
                                                                    ))),
                                                          ],
                                                        ),
                                                      ),

                                                      /////////////////////////////////////////////////////////////////////////////////////////////////
                                                    ],
                                                  )))
                                                ]));
                                      }

                                      ///@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

                                      else {
                                        return Container(
                                            /*  margin: const EdgeInsets.only(
                                        left: 29.0, right: 29, top: 250),
                                    color: Colors.white.withOpacity(.4),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(isPaid?
                                        "No Contest Available!!":"",
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey),
                                      ),
                                    ),*/
                                            );
                                      }
                                    }),
                              ),
                            ),
                  //),
//*****************************************************************************************************************************

                  isLoadingfree
                      ? Container(
                          margin: const EdgeInsets.only(left: 29.0, right: 29),
                          //   color: Colors.white.withOpacity(.4),
                          child: Align(
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : status1 == "0"
                          ? Container(
                              margin: const EdgeInsets.only(
                                  left: 29.0, right: 29, top: 30),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "No contest available !!",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.black38),
                                ),
                              ),
                            )
                          : Visibility
                    (
                              visible: isFree,
                              child: Flexible(
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: users_free.length,
                                    itemBuilder: (context, index) {
                                      if (editingController.text.isEmpty)
                                      {
                                        //Paid
                                        return new Card(
                                            margin: EdgeInsets.symmetric(
                                                vertical: 4, horizontal: 10),
                                            color: Theme.of(context).cardColor,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0.5)),
                                            ),
                                            child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Container(
                                                      child: Container(
                                                          child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                      Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 5,
                                                                bottom: 5,
                                                                //  left: 15,
                                                                right: 2),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: <Widget>[
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      // left: 15,
                                                                      //top: 10,

                                                                      ),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: <
                                                                    Widget>[
                                                                  Container(
                                                                    color: Colors
                                                                        .red,
                                                                    width: 60,
                                                                    height: 17,
                                                                    child:
                                                                        Padding(
                                                                      padding:
                                                                          const EdgeInsets
                                                                              .only(),
                                                                      child:
                                                                          Container(
                                                                        padding:
                                                                            const EdgeInsets.all(3.0),
                                                                        decoration:
                                                                            BoxDecoration(border: Border.all(color: Colors.red)),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          children: <
                                                                              Widget>[
                                                                            Text(
                                                                              "" + users_free[index].tag,
                                                                              style: TextStyle(fontSize: 8.0, fontWeight: FontWeight.bold, color: Colors.white),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            /*  SizedBox(
                                                  width: 30.0,
                                                ),*/
                                                            Container(
                                                                height: 22,
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        top:
                                                                            10),
                                                                child: Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .centerLeft,
                                                                    child: Text(
                                                                      users_free[index].date + ' ' + users_free[index].from_time +
                                                                          ' to ' +
                                                                          users_free[index].to_time,
                                                                      maxLines:
                                                                          5,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              12.0,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color:
                                                                              Colors.blue),
                                                                    ))),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                top: 10,
                                                              ),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: <
                                                                    Widget>[
                                                                  Icon(
                                                                    Icons
                                                                        .access_time,
                                                                    color: Colors
                                                                        .black,
                                                                    size: 14,
                                                                  ),
                                                                  Text(
                                                                    // " " + timerText ,
                                                                    users_free[index].time_remaining1 ==
                                                                            "0"
                                                                        ? "In progress"
                                                                        : " " +
                                                                            timerText(int.parse(users_free[index].time_remaining1)),
                                                                    //   users[index].time_remaining1,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    maxLines: 5,
                                                                    //  "5:00",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            11.0,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .red),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                      Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 5,
                                                                bottom: 5,
                                                                left: 15,
                                                                right: 25),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: <Widget>[
                                                           Expanded(child: Text(
                                                                users_free[index]
                                                                    .tilte,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 5,
                                                                style:
                                                                    new TextStyle(
                                                                  fontSize:
                                                                      15.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .black,
                                                                )),),
                                                            Text(
                                                                users_free[index].c_status ==
                                                                        "Running"
                                                                    ? users_free[index]
                                                                        .c_status
                                                                    : " ",
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 2,
                                                                style:
                                                                    new TextStyle(
                                                                  fontSize:
                                                                      10.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .red,
                                                                )),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                bottom: 5,
                                                                left: 15,
                                                                right: 15),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: <Widget>[
                                                            /* Text(users[index].win_price,
                                                            overflow:
                                                            TextOverflow.ellipsis,
                                                            maxLines: 5,
                                                            style: new TextStyle(
                                                              fontSize: 13.0,
                                                              fontWeight:
                                                              FontWeight.bold,
                                                              color: Colors.black,
                                                            )),*/

                                                            //***************************************************************************************

                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(),
                                                              child: Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        3.0),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: <
                                                                      Widget>[
                                                                    Image.asset(
                                                                      'assets/images/wincup.jpg',
                                                                      height:
                                                                          15,
                                                                      width: 15,
                                                                    ),
                                                                    Text(
                                                                        users_free[index]
                                                                            .win_price,
                                                                        overflow:
                                                                            TextOverflow
                                                                                .ellipsis,
                                                                        maxLines:
                                                                            5,
                                                                        style:
                                                                            new TextStyle(
                                                                          fontSize:
                                                                              13.0,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          color:
                                                                              Colors.black,
                                                                        )),
                                                                    Visibility(
                                                                      visible: users_free[
                                                                              index]
                                                                          .gift_icon
                                                                          .isNotEmpty,
                                                                      child:
                                                                          Container(
                                                                        margin: EdgeInsets.only(
                                                                            left:
                                                                                5,
                                                                            right:
                                                                                5),
                                                                        alignment:
                                                                            Alignment.topLeft,
                                                                        //width: 10,
                                                                        height:
                                                                            15,
                                                                        child: Image.network(
                                                                            users_free[index].gift_icon),
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      users_free[index]
                                                                          .gift_title,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              12.0,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color:
                                                                              Colors.black),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),

                                                            //**************************************************************************************************
                                                            Text(
                                                              '₹ ' +
                                                                  users_free[index]
                                                                      .fees,
                                                              style: TextStyle(
                                                                fontSize: 12.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),

                                                      Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 5,
                                                                // bottom: 5,
                                                                left: 5,
                                                                right: 5),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: <Widget>[
                                                            Container(
                                                                height: 27,
                                                                width: 70,
                                                                child:
                                                                    RaisedButton(
                                                                  textColor:
                                                                      Colors
                                                                          .white,
                                                                  color: Colors
                                                                      .black,
                                                                  shape: RoundedRectangleBorder(
                                                                      side: BorderSide(
                                                                          color: Colors
                                                                              .black,
                                                                          width:
                                                                              1,
                                                                          style: BorderStyle
                                                                              .solid),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5)),
                                                                  child: Text(
                                                                    'Syllabus',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          9,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator
                                                                        .push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              SyllabusPage(users_free[index].contest_id)),
                                                                    );
                                                                  },
                                                                )),
/*                                                Container(
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
                                                      child: Text('Result', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white,),
                                                      ),
                                                      onPressed: ()
                                                      {
                                                        Navigator.push(context,
                                                            MaterialPageRoute(builder: (context) => ResultPage()));
                                                        // Toast.show("Payment Option", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                                                      },
                                                    )),*/
                                                            GestureDetector(
                                                              onTap: () {
                                                                print(
                                                                    "Container clicked");
                                                                Navigator.push(context, MaterialPageRoute(builder: (context) => WinnersPage(users_free[index].contest_id)),);
                                                              },
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(),
                                                                child:
                                                                    Container(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          3.0),
                                                                  decoration: BoxDecoration(
                                                                      border: Border.all(
                                                                          color:
                                                                              Colors.black45)),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: <
                                                                        Widget>[
                                                                      Text("Winners:" + users_free[index].winners,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                12.0,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color: Colors.black),
                                                                      ),
                                                                      Icon(
                                                                        Icons
                                                                            .arrow_drop_down_sharp,
                                                                        color: Colors.black,
                                                                        size:
                                                                            17,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Container(
                                                                height: 27,
                                                                width: 60,
                                                                child:
                                                                    RaisedButton(
                                                                  textColor:
                                                                      Colors.white,
                                                                  color: Colors
                                                                      .grey,
                                                                  shape: RoundedRectangleBorder(
                                                                      side: BorderSide(
                                                                          color: Colors
                                                                              .grey,
                                                                          width:
                                                                              1,
                                                                          style: BorderStyle
                                                                              .solid),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5)),
                                                                  child: Text(
                                                                    'T & C',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          9,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                  onPressed:
                                                                      ()
                                                                  {
                                                                    setState(()
                                                                    {
                                                                      Navigator.push(context, MaterialPageRoute(builder: (context) => MyContestTermscondition(users_free[index].contest_id)));
                                                                    });
                                                                  },
                                                                )),
                                                            Visibility(
                                                              visible: users_free[index].j_status ==
                                                                      "0" &&
                                                                  users_free[index]
                                                                          .c_status ==
                                                                      "Pending",
                                                              child: Container(
                                                                  height: 27,
                                                                  width: 52,
                                                                  child:
                                                                      RaisedButton(
                                                                    textColor:
                                                                        Colors
                                                                            .white,
                                                                    color: Colors
                                                                        .green,
                                                                    shape: RoundedRectangleBorder(
                                                                        side: BorderSide(
                                                                            color: MyColor
                                                                                .white,
                                                                            width:
                                                                                1,
                                                                            style: BorderStyle
                                                                                .solid),
                                                                        borderRadius:
                                                                            BorderRadius.circular(5)),
                                                                    child: Text(
                                                                      'Free',
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            9,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                    ),
                                                                    onPressed:
                                                                        () {
                                                                      type = "Free";
                                                                      Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp9(users_free[index].contest_id, contestFees, type)));
                                                                      /* apiJoinFree(
                                                                        userId2,
                                                                        users[index]
                                                                            .contest_id,
                                                                        users[index]
                                                                            .c_status);*/
/*                                                                    setState(() {
                                                                      if (users[index]
                                                                          .c_status ==
                                                                          "Pending") {
                                                                        Navigator
                                                                            .push(
                                                                            context,
                                                                            MaterialPageRoute(
                                                                                builder: (
                                                                                    context) =>
                                                                                    MyApp9(
                                                                                        users[index]
                                                                                            .contest_id,
                                                                                        contestFees,
                                                                                        type)));
                                                                      }
                                                                      else {
                                                                        Fluttertoast
                                                                            .showToast(
                                                                            msg: "Contest is " +
                                                                                users[index]
                                                                                    .c_status);
                                                                      }
                                                                    });*/
                                                                    },
                                                                  )),
                                                            ),
                                                          ],
                                                        ),
                                                      ),

                                                      /////////////////////// ////////////////////////////////////////////////////////////////
                                                      Container(
                                                        padding:
                                                            EdgeInsets.only(
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
                                                                  const EdgeInsets
                                                                          .only(
                                                                      // left: 15,
                                                                      //top: 10,

                                                                      ),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: <
                                                                    Widget>[
                                                                  Icon(
                                                                    Icons
                                                                        .assignment,
                                                                    color: Colors
                                                                        .black54,
                                                                    size: 17,
                                                                  ),
                                                                  Text(
                                                                    " " +
                                                                        users_free[index].no_questions,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            12.0,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .grey),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            /* SizedBox(
                                              width: 18.0,
                                            ),*/
                                                            Padding(
                                                              padding: const EdgeInsets.only(
                                                                left: 20,
                                                                top: 10,
                                                              ),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: <
                                                                    Widget>[
                                                                  Icon(
                                                                    Icons
                                                                        .access_time,
                                                                    color: Colors
                                                                        .black54,
                                                                    size: 17,
                                                                  ),
                                                                  Text(
                                                                    " " +
                                                                        users_free[index]
                                                                            .d_duration +
                                                                        " ",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            12.0,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .grey),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                                height: 22,
                                                                //  width: 100,
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        top:
                                                                            10),
                                                                child: Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    child: Text(
                                                                      "Total Join:" +
                                                                          users_free[index]
                                                                              .total_joining,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              10.0,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color:
                                                                              Colors.grey),
                                                                    ))),
                                                          ],
                                                        ),
                                                      ),

                                                      /////////////////////////////////////////////////////////////////////////////////////////////////
                                                    ],
                                                  )))
                                                ]));
                                      } else if (users_free[index].tilte.toLowerCase().contains(editingController.text.toLowerCase()))
                                      {
                                        ///@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ else if {
                                        return new Card(
                                            margin: EdgeInsets.symmetric(
                                                vertical: 4, horizontal: 10),
                                            color: Theme.of(context).cardColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(0.5)),
                                            ),
                                            child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Container(
                                                      child: Container(
                                                          child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                      Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 5,
                                                                bottom: 5,
                                                                //  left: 15,
                                                                right: 2),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: <Widget>[
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      // left: 15,
                                                                      //top: 10,

                                                                      ),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: <
                                                                    Widget>[
                                                                  Container(
                                                                    color: Colors
                                                                        .red,
                                                                    width: 60,
                                                                    height: 17,
                                                                    child:
                                                                        Padding(
                                                                      padding:
                                                                          const EdgeInsets
                                                                              .only(),
                                                                      child:
                                                                          Container(
                                                                        padding:
                                                                            const EdgeInsets.all(3.0),
                                                                        decoration:
                                                                            BoxDecoration(border: Border.all(color: Colors.red)),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          children: <
                                                                              Widget>[
                                                                            Text(
                                                                              "" + users_free[index].tag,
                                                                              style: TextStyle(fontSize: 8.0, fontWeight: FontWeight.bold, color: Colors.white),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            /*  SizedBox(
                                                  width: 30.0,
                                                ),*/
                                                            Container(
                                                                height: 22,
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        top:
                                                                            10),
                                                                child: Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .centerLeft,
                                                                    child: Text(
                                                                      users_free[index].date +
                                                                          ' ' +
                                                                          users_free[index]
                                                                              .from_time +
                                                                          ' to ' +
                                                                          users_free[index]
                                                                              .to_time,
                                                                      maxLines:
                                                                          5,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              12.0,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color:
                                                                              Colors.blue),
                                                                    ))),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                top: 10,
                                                              ),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: <
                                                                    Widget>[
                                                                  Icon(
                                                                    Icons
                                                                        .access_time,
                                                                    color: Colors
                                                                        .black,
                                                                    size: 14,
                                                                  ),
                                                                  Text(
                                                                    // " " + timerText ,
                                                                    users_free[index].time_remaining1 ==
                                                                            "0"
                                                                        ? "In progress"
                                                                        : " " +
                                                                            timerText(int.parse(users_free[index].time_remaining1)),
                                                                    //   users[index].time_remaining1,
                                                                    overflow: TextOverflow.ellipsis,
                                                                    maxLines: 5,
                                                                    //  "5:00",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            11.0,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .red),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                                      Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 5,
                                                                bottom: 5,
                                                                left: 15,
                                                                right: 25),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: <Widget>[
                                                           Expanded(child:Text(
                                                                users_free[index]
                                                                    .tilte,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 5,
                                                                style:
                                                                    new TextStyle(
                                                                  fontSize:
                                                                      15.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .black,
                                                                )),),
                                                            Text(
                                                                users_free[index].c_status ==
                                                                        "Running"
                                                                    ? users_free[index]
                                                                        .c_status
                                                                    : " ",
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 2,
                                                                style:
                                                                    new TextStyle(
                                                                  fontSize:
                                                                      10.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .red,
                                                                )),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                bottom: 5,
                                                                left: 15,
                                                                right: 15),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: <Widget>[
                                                            /* Text(users[index].win_price,
                                                            overflow:
                                                            TextOverflow.ellipsis,
                                                            maxLines: 5,
                                                            style: new TextStyle(
                                                              fontSize: 13.0,
                                                              fontWeight:
                                                              FontWeight.bold,
                                                              color: Colors.black,
                                                            )),*/

                                                            //***************************************************************************************

                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(),
                                                              child: Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        3.0),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: <
                                                                      Widget>[
                                                                    Image.asset(
                                                                      'assets/images/wincup.jpg',
                                                                      height:
                                                                          15,
                                                                      width: 15,
                                                                    ),
                                                                    Text(
                                                                        users_free[index]
                                                                            .win_price,
                                                                        overflow:
                                                                            TextOverflow
                                                                                .ellipsis,
                                                                        maxLines:
                                                                            5,
                                                                        style:
                                                                            new TextStyle(
                                                                          fontSize:
                                                                              13.0,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          color:
                                                                              Colors.black,
                                                                        )),
                                                                    Visibility(
                                                                      visible: users_free[
                                                                              index]
                                                                          .gift_icon
                                                                          .isNotEmpty,
                                                                      child:
                                                                          Container(
                                                                        margin: EdgeInsets.only(
                                                                            left:
                                                                                5,
                                                                            right:
                                                                                5),
                                                                        alignment:
                                                                            Alignment.topLeft,
                                                                        //width: 10,
                                                                        height:
                                                                            15,
                                                                        child: Image.network(
                                                                            users_free[index].gift_icon),
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      users_free[index].gift_title,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              12.0,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color:
                                                                              Colors.black),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),

                                                            //**************************************************************************************************
                                                            Text(
                                                              '₹ ' +
                                                                  users_free[index].fees,
                                                              style: TextStyle(
                                                                fontSize: 12.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),

                                                      Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 5,
                                                                // bottom: 5,
                                                                left: 5,
                                                                right: 5),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: <Widget>[
                                                            Container(
                                                                height: 27,
                                                                width: 70,
                                                                child:
                                                                    RaisedButton(
                                                                  textColor:
                                                                      Colors
                                                                          .white,
                                                                  color: Colors
                                                                      .black,
                                                                  shape: RoundedRectangleBorder(
                                                                      side: BorderSide(
                                                                          color: Colors
                                                                              .black,
                                                                          width:
                                                                              1,
                                                                          style: BorderStyle
                                                                              .solid),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5)),
                                                                  child: Text(
                                                                    'Syllabus',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          9,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator
                                                                        .push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              SyllabusPage(users_free[index].contest_id)),
                                                                    );
                                                                  },
                                                                )),
/*                                                Container(
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
                                                      child: Text('Result', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white,),
                                                      ),
                                                      onPressed: ()
                                                      {
                                                        Navigator.push(context,
                                                            MaterialPageRoute(builder: (context) => ResultPage()));
                                                        // Toast.show("Payment Option", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                                                      },
                                                    )),*/
                                                            GestureDetector(
                                                              onTap: () {
                                                                print(
                                                                    "Container clicked");
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          WinnersPage(
                                                                              users_free[index].contest_id)),
                                                                );
                                                              },
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(),
                                                                child:
                                                                    Container(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          3.0),
                                                                  decoration: BoxDecoration(
                                                                      border: Border.all(
                                                                          color:
                                                                              Colors.black45)),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: <
                                                                        Widget>[
                                                                      Text(
                                                                        "Winners:" +
                                                                            users_free[index].winners,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                12.0,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color: Colors.black),
                                                                      ),
                                                                      Icon(
                                                                        Icons
                                                                            .arrow_drop_down_sharp,
                                                                        color: Colors
                                                                            .black,
                                                                        size:
                                                                            17,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Container(
                                                                height: 27,
                                                                width: 60,
                                                                child:
                                                                    RaisedButton(
                                                                  textColor:
                                                                      Colors
                                                                          .white,
                                                                  color: Colors
                                                                      .grey,
                                                                  shape: RoundedRectangleBorder(
                                                                      side: BorderSide(
                                                                          color: Colors
                                                                              .grey,
                                                                          width:
                                                                              1,
                                                                          style: BorderStyle
                                                                              .solid),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5)),
                                                                  child: Text(
                                                                    'T & C',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          9,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    setState(
                                                                        () {
                                                                      Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) => MyContestTermscondition(users_free[index].contest_id)));
                                                                    });
                                                                  },
                                                                )),
                                                            Visibility(
                                                              visible: users_free[index]
                                                                          .j_status ==
                                                                      "0" &&
                                                                  users_free[index]
                                                                          .c_status ==
                                                                      "Pending",
                                                              child: Container(
                                                                  height: 27,
                                                                  width: 52,
                                                                  child:
                                                                      RaisedButton(
                                                                    textColor:
                                                                        Colors
                                                                            .white,
                                                                    color: Colors
                                                                        .green,
                                                                    shape: RoundedRectangleBorder(
                                                                        side: BorderSide(
                                                                            color: MyColor
                                                                                .white,
                                                                            width:
                                                                                1,
                                                                            style: BorderStyle
                                                                                .solid),
                                                                        borderRadius:
                                                                            BorderRadius.circular(5)),
                                                                    child: Text(
                                                                      'Free',
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            9,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                    ),
                                                                    onPressed:
                                                                        () {
                                                                      type =
                                                                          "Free";
                                                                      print(
                                                                          "vv>>$users_free[index].contest_id");
                                                                      Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) => MyApp9(users_free[index].contest_id, contestFees, type)));
/*                                                                    apiJoinFree(
                                                                        userId2,
                                                                        users[index]
                                                                            .contest_id,
                                                                        users[index]
                                                                            .c_status);*/
/*                                                                     setState(() {
                                                                       if (users[index]
                                                                           .c_status ==
                                                                           "Pending") {
                                                                         Navigator
                                                                             .push(
                                                                             context,
                                                                             MaterialPageRoute(
                                                                                 builder: (
                                                                                     context) =>
                                                                                     MyApp9(
                                                                                         users[index]
                                                                                             .contest_id,
                                                                                         contestFees,
                                                                                         type)));
                                                                       }
                                                                       else {
                                                                         Fluttertoast
                                                                             .showToast(
                                                                             msg: "Contest is " +
                                                                                 users[index]
                                                                                     .c_status);
                                                                       }
                                                                     });*/
                                                                    },
                                                                  )),
                                                            ),
                                                          ],
                                                        ),
                                                      ),

                                                      /////////////////////// ////////////////////////////////////////////////////////////////
                                                      Container(
                                                        padding:
                                                            EdgeInsets.only(
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
                                                                  const EdgeInsets
                                                                          .only(
                                                                      // left: 15,
                                                                      //top: 10,

                                                                      ),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: <
                                                                    Widget>[
                                                                  Icon(
                                                                    Icons
                                                                        .assignment,
                                                                    color: Colors
                                                                        .black54,
                                                                    size: 17,
                                                                  ),
                                                                  Text(
                                                                    " " +
                                                                        users_free[index]
                                                                            .no_questions,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            12.0,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .grey),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            /* SizedBox(
                                              width: 18.0,
                                            ),*/
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                left: 20,
                                                                top: 10,
                                                              ),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: <
                                                                    Widget>[
                                                                  Icon(
                                                                    Icons
                                                                        .access_time,
                                                                    color: Colors
                                                                        .black54,
                                                                    size: 17,
                                                                  ),
                                                                  Text(
                                                                    " " +
                                                                        users_free[index]
                                                                            .d_duration +
                                                                        " ",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            12.0,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .grey),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                                height: 22,
                                                                //  width: 100,
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        top:
                                                                            10),
                                                                child: Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    child: Text(
                                                                      "Total Join:" +
                                                                          users_free[index]
                                                                              .total_joining,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              10.0,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color:
                                                                              Colors.grey),
                                                                    ))),
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
      ),
    );
  }

  Widget catagories() {
    return /*Container(
      child: Expanded(
        child: SizedBox(
          child:*/
        Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
      GestureDetector(
        onTap: () {
          setState(() {
            _cancelTimer();
          });
          apigetCatagory();
          category_id = "";
          isall = true;
          if (isPaid) {
            //category_id="";
            _getCatagoriwise(category_id, "Paid");
          } else {
            //_getFreeTest("false");
            // category_id="";
            _getCatagoriwise_free(category_id, "Free");
          }
        },
        child: Container(
          height: 32,
          margin: EdgeInsets.only(left: 5, right: 5),
          padding: EdgeInsets.all(7),
          color: isall ? MyColor.themecolor : MyColor.white,
          // color:MyColor.white,
          //  color: MyColor.white,
          child: Align(
            alignment: Alignment.center,
            child: Text("  All  ",
                style: TextStyle(
                    fontSize: 12, color: isall ? MyColor.white : Colors.black)),
          ),
          // width: 105,
        ),
      ),
      Expanded(
        child: ListView.builder(
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          // primary: false,
          scrollDirection: Axis.horizontal,
          itemCount: userCatagory.length,
          itemBuilder: (BuildContext context, int index) => Card(
              child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _cancelTimer();
                    });
                    setState(() {
                      isall = false;
                      tappedIndex = index;
                    });
                    if (isPaid) {
                      type = "Paid";
                    } else {
                      type = "Free";
                    }
                    category_id = userCatagory[index].category_id;
                    _getCatagoriwise(category_id, type);
                  },
                  child: Container(
                    height: 40,
                    padding: EdgeInsets.all(7),
                    // color: userCatagory[index].isCatagoryclick=="true"?MyColor.themecolor:MyColor.white,
                    color: tappedIndex == index
                        ? MyColor.themecolor
                        : MyColor.white,
                    //  color: MyColor.white,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(userCatagory[index].category,
                          style: TextStyle(
                              fontSize: 12,
                              color: tappedIndex == index
                                  ? MyColor.white
                                  : Colors.black)),
                    ),
                    // width: 105,
                  ))),
        ),
      ),
    ]);
    ////////////////////////
//////
    /* ),
      ),
    );*/
  }

  apiUpdateCatagory(String category_id, type) async {
    Map data = {
      "user_id": userId2,
      "contest_type": type,
      "category_id": category_id
    };
    print("updatecat$data");
    var jsonData = null;
    var response = await http.post(uidata.contest_filter,
        body: data, headers: {'Authorization': token});

    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      var status = jsonData['status'];
      String Message = jsonData['Message'];

      print(jsonData);
      if (status == "1") {
        setState(() {
          Fluttertoast.showToast(msg: Message);
          if (isPaid) {
            //  _getPaidTest("false");
            _getCatagoriwise(category_id, "Paid");
          } else {
            //_getFreeTest("false");
            _getCatagoriwise_free(category_id, "Free");
          }
        });
      } else {
        Fluttertoast.showToast(msg: Message);
      }
    } else {}
  }

  apiJoin(String uId, String contestid) async
  {
    Map data = {"user_id": uId, "contest_id": contestid};
    print(data);
    var jsonData = null;
    var response = await http.post(uidata.joincontest,
        body: data, headers: {'Authorization': token});

    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      var status = jsonData['status'];
      var msg = jsonData['Message'];

      print(jsonData);
      if (status == "1") {
        Fluttertoast.showToast(msg: msg);
        //  _getPaidTest("false");
        _getCatagoriwise(category_id, "Paid");
        /* setState(() {
          isLoading = false;
        });
        setState(() {
          if (c_status == "Pending")
          {
            Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp9(contestid, contestFees, type)));
          }
          else
            {
              Fluttertoast.showToast(msg: "Contest is " + c_status);
            }
        });*/
      } else {
        //  isLoading = false;
        // Toast.show(msg, context,duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        Fluttertoast.showToast(msg: msg);
      }
    } else {}
  }

  apiJoinFree(String uId, String contestid, String c_status) async {
    Map data = {"user_id": uId, "contest_id": contestid};
    print(data);
    var jsonData = null;
    var response = await http.post(uidata.joincontest,
        body: data, headers: {'Authorization': token});

    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      var status = jsonData['status'];
      var msg = jsonData['Message'];

      print(jsonData);
      if (status == "1") {
        Fluttertoast.showToast(msg: msg);
        /* _getFreeTest("false");*/
        _getCatagoriwise_free(category_id, "Free");

        /*setState(() {
          isLoading = false;
        });
        setState(() {
          if (c_status == "Pending")
          {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        MyApp9(contestid, contestFees, type)));
          } else {
            Fluttertoast.showToast(msg: "Contest is " + c_status);
          }
        });*/
      } else {
        // isLoading = false;
        // Toast.show(msg, context,duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        Fluttertoast.showToast(msg: msg);
      }
    } else {}
  }

  //*************************************************************************************************************
  apiTransaction(
    String user_id,
    String payId,
    String purpose,
    String amt,
    String wallet,
  ) async {
    var wallet1, wallet2;
    Map data = {
      "user_id": user_id,
      "transaction_id": payId,
      "purpose": purpose,
      "amount": amt,
      "wallet": wallet,
      "status": "Debit",
      "contest_id": contest_id
    };
    print("res$data");
    var jsonData = null;
    var response = await http.post(uidata.maketransaction,
        body: data, headers: {'Authorization': token});

    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      var status = jsonData['status'];
      var msg = jsonData['Message'];

      print(jsonData);
      print('status $status');
      if (status == "1") {
        setState(() {
          wallet1 = jsonData['wallet1'];
          wallet2 = jsonData['wallet2'];
        });

        Fluttertoast.showToast(msg: msg);
        apiJoin(user_id, contest_id);
        //  Navigator.push(context, MaterialPageRoute(builder: (context) => MyContest()));
        //  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => WalletPage(wallet1, wallet2)));
      } else {
        Fluttertoast.showToast(msg: msg);
      }
    } else {}
  }
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
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
  String status, win_price, winners, fees;
  List<User> data;

  Album({this.status, this.win_price, this.winners, this.fees, this.data});

  Album.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    win_price = json['win_price'];
    winners = json['winners'];
    fees = json['fees'];

    if (json['data'] != null) {
      data = new List<User>();
      json['data'].forEach((v) {
        data.add(new User.fromJson(v));
        isLoadingpaid = false;
        isLoadingfree = false;
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
      fees,
      total_joining,
      winners,
      c_status,
      time_remaining1,
      j_status,
      d_duration;

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
    time_remaining,
    this.fees,
    this.total_joining,
    this.winners,
    this.c_status,
    this.time_remaining1,
    this.j_status,
    this.d_duration,
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
    time_remaining1 = json['time_remaining'];
    fees = json['fees'];
    total_joining = json['total_joining'];
    winners = json['winners'];
    c_status = json['c_status'];
    j_status = json['j_status'];
    d_duration = json['d_duration'];
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

    data['no_questions'] = this.no_questions;
    data['duration'] = this.duration;
    data['time_remaining'] = time_remaining1;

    data['fees'] = this.fees;
    data['total_joining'] = this.total_joining;
    data['winners'] = this.winners;
    data['c_status'] = this.c_status;
    data['j_status'] = this.j_status;
    data['d_duration'] = this.d_duration;
    return data;
  }
}

////////////////@@@catagories
class Album2 {
  String status, category_id, category;
  List<UserCatagory> data;

  Album2({this.category_id, this.category, this.data});

  Album2.fromJson(Map<String, dynamic> json) {
    status = json['status'];

    if (json['data'] != null) {
      data = new List<UserCatagory>();
      json['data'].forEach((v) {
        data.add(new UserCatagory.fromJson(v));
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

class UserCatagory {
  String category_id, category;

  UserCatagory({
    this.category_id,
    this.category,
  });

  UserCatagory.fromJson(Map<String, dynamic> json) {
    category_id = json['category_id'].toString();
    category = json['category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category_id'] = this.category_id;
    data['category'] = this.category;

    return data;
  }
}
