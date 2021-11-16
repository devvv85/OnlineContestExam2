import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:onlineexamcontest/Constants/uidata.dart';
import 'package:onlineexamcontest/Dashboard/DeclareResultPage.dart';
import 'package:onlineexamcontest/My%20Contest/screendevide.dart';
import 'package:shared_preferences/shared_preferences.dart';
var advertise_id="";
SharedPreferences prefs;
var contest_id = "", info = "", img = "", fees = "", c_status, type;
String userId,token;

class contestIfo extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() => new _State();

  contestIfo(String advertise_id2)
  {
    advertise_id=advertise_id2;
  }
}

class _State extends State<contestIfo> {
  void initState() {

      initializeSF();



  }

  initializeSF() async {

      prefs = await SharedPreferences.getInstance();
      userId = prefs.getString("uId");
      token = prefs.getString("token");
      print("aaaa $userId");
      apigetData();


  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text('Contest'),
          backgroundColor: Colors.black,
        ),
        body: Padding(
            padding: EdgeInsets.all(0),
            child: ListView(children: <Widget>[
              Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  //crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                        height: 200,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(img),
                            fit: BoxFit.cover,
                          ),
                        )),
                    Container(
                      margin:
                          const EdgeInsets.only(left: 10.0, right: 10, top: 30),
                      child: Text(
                        info,
                        style: TextStyle(fontSize: 17, color: Colors.black),
                      ),
                    ),
                    Container(
                      height: 30,
                      margin:
                          const EdgeInsets.only(left: 10.0, right: 10, top: 30),
                      child: Align(
                          alignment: Alignment.center,
                          child: RaisedButton(
                              onPressed: () {
                                apiJoin(userId, contest_id);
                                setState(() {
                                  if (c_status == "Pending") {
                                    if (int.parse(fees) > 0)
                                    {
                                      type = "paid";
                                    } else {
                                      type = "Free";
                                    }
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MyApp9(
                                                contest_id, fees, type)));
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: "Contest is " + c_status);
                                  }
                                });
                                //  dialogSelectWallet(context);
                              },
                              color: Colors.green,
                              child: Text(
                                "Join",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ))),
                    ),
                  ])
            ])));
  }

  apigetData() async {
    Map data = {"advertise_id": advertise_id};
    print("param>>$data");

    var jsonData = null;
    var response = await http.post(uidata.contest_banner_info, body: data,headers: {'Authorization': token});

    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      print("param1$jsonData");
      var status = jsonData['status'];

      print(jsonData);
      if (status == "1") {
        setState(() {
          contest_id = jsonData['contest_id'].toString();
          info = jsonData['info'].toString();
          img = jsonData['img'].toString();
          fees = jsonData['fees'].toString();
          c_status = jsonData['c_status'].toString();
        });
      } else {}
    } else {}
  }

  apiJoin(String uId, String contestid) async {
    Map data = {"user_id": uId, "contest_id": contestid};
    print(data);
    var jsonData = null;
    var response = await http.post(uidata.joincontest, body: data,headers: {'Authorization': token});

    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      var status = jsonData['status'];
      var msg = jsonData['Message'];

      print(jsonData);
      if (status == "1") {
        setState(() {});

        //  Toast.show(msg, context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        // Fluttertoast.showToast(msg: msg);

      } else {
        // Toast.show(msg, context,duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        Fluttertoast.showToast(msg: msg);
      }
    } else {}
  }
}
