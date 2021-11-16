import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:onlineexamcontest/Constants/uidata.dart';
import 'package:onlineexamcontest/Dashboard/MainDashboard.dart';
import 'package:onlineexamcontest/My%20Contest/termsandconditions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ContestTermsAndCondition.dart';
import 'LanguageSelection_LiveContest.dart';
import 'package:http/http.dart' as http;

import 'MyContest.dart';

String my_contest_id;
String contestid2, wallet, userId2, contestFees1, type1, token;
bool isCheck = false;
SharedPreferences prefs;

class MyApp9 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _State();

  MyApp9(String contestid, String contestFees, String type) {
    contestid2 = contestid;
    contestFees1 = contestFees;
    type1 = type;
    print("$contestid2");
  }
}

class _State extends State<MyApp9> {
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      initializeSF();
      isCheck = false;
    });
  }

  initializeSF() async {
    setState(() async {
      prefs = await SharedPreferences.getInstance();
      userId2 = prefs.getString("uId");
      token = prefs.getString("token");
      print("aaaa $userId2");
    });
  }

  Future<void> dialogSelectWallet(BuildContext context) async {
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

                    apiTransaction(userId2, "abcd", "Join Contest",
                        contestFees1, wallet, contestid2);
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
                    apiTransaction(userId2, "abcd", "Join Contest",
                        contestFees1, wallet, contestid2);
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

  apiTransaction(String user_id, String payId, String purpose, String amt,
      String wallet, String contest_id) async {
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

      print("REsponse>>$jsonData");
      print('status $status');
      if (status == "1") {
        setState(() {
          wallet1 = jsonData['wallet1'];
          wallet2 = jsonData['wallet2'];
        });

        Fluttertoast.showToast(msg: msg);
        apiJoin(userId2, contestid2);
        //  Navigator.push(context, MaterialPageRoute(builder: (context) => MyContest()));
        //  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => WalletPage(wallet1, wallet2)));
      } else {
        Fluttertoast.showToast(msg: msg);
        Navigator.push(context, MaterialPageRoute(builder: (context) => MainDashboard(userId2, true)));
      }
    } else {}
  }

  apiJoin(String uId, String contestid) async {
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
      if (status == "1")
      {
        Fluttertoast.showToast(msg: msg);
        Navigator.push(context, MaterialPageRoute(builder: (context) => MyContest("noti")));
       // popup();
      /*  Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MainDashboard(userId2, true)));*/
       // Navigator.push(context, MaterialPageRoute(builder: (context) => MyContest("noti")));
      } else {
        //  isLoading = false;
        // Toast.show(msg, context,duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        Fluttertoast.showToast(msg: msg);
        Navigator.push(context, MaterialPageRoute(builder: (context) => MyContest("noti")));
      }
    } else {}
  }

  apiJoinFree(String uId, String contestid) async {
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
        //  Navigator.push(context, MaterialPageRoute(builder: (context) => MainDashboard(userId2,true)));
        Navigator.push(context, MaterialPageRoute(builder: (context) => MyContest("noti")));

        //  _getFreeTest();
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
        Navigator.push(context, MaterialPageRoute(builder: (context) => MyContest("noti")));
      }
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Column(children: <Widget>[
      Expanded(
          child: Container(
        color: Colors.white,
        child: MyContestTermscondition(contestid2),
      )),
      Container(
        height: 50,
        // color: Colors.grey,
        child: Row(children: <Widget>[
          SizedBox(
            width: 4,
          ),
          Text(
            '   Accept Terms & Conditions ',
            style: TextStyle(fontSize: 16.0, color: Colors.blue),
          ),
          Checkbox(
            checkColor: Colors.greenAccent,
            activeColor: Colors.blue,
            value: isCheck,
            onChanged: (bool value) {
              setState(() {
                isCheck = value;
                if (isCheck == true) {
                  // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LanguageSelection_LiveContest(my_contest_id)));
                  if (type1 == "paid") {
                    dialogSelectWallet(context);
                  } else {
                    apiJoinFree(userId2, contestid2);
                  }
                } else {}
              });
            },
          ),
        ]),
      ),
      /*  Expanded(
              child: Container(
                color: Colors.blueGrey,
              )
          ),*/
    ]));
  }

  @override
  Future<bool> popup() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Join Contest'),
            content: new Text(
                'You have joined contest successfully, Now check in My Contest!!'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MyContest("noti")));
                },
                child: new Text('OK'),
              ),
            ],
          ),
        )) ??
        false;
  }
}
