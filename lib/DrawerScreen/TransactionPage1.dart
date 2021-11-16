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
bool isLoadings2 = false;
String status, token;
List<User> users = new List<User>();
String userId;

class TransactionPage2 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _State();
}

class _State extends State<TransactionPage2> {
  TextEditingController editingController = TextEditingController();

  void initState() {
    initializeSF();
  }

  initializeSF() async {
    prefs = await SharedPreferences.getInstance();

    userId = prefs.getString("uId");
    token = prefs.getString("token");
    print("aaaa $userId");
    setState(() {
      isLoadings2 = true;
      getTransaction();
    });
  }

  Future<Album> getTransaction() async {
    Map data = {"user_id": userId};
    print("a$data");
    var jsonData = null;
    var response = await http.post(uidata.transactions,
        body: data, headers: {'Authorization': token});
    //var response = await http.post("http://tejas.mediqwick.com/api/transactions/",body: data);
    if (response.statusCode == 200) {
      var res = Album.fromJson(jsonDecode(response.body));
      jsonData = json.decode(response.body);

      status = jsonData['status'];
      if (status == "0") {
        isLoadings2 = false;
      }
      print("stt>>> $status");
      setState(() {
        users = res.data;
      });
    } else {
      throw Exception('Failed to load transaction');
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('My Transaction'),
        backgroundColor: MyColor.themecolor,
      ),
      body: new GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Container(
          color: MyColor.orange12,
          padding: EdgeInsets.only(
            top: 5,
          ),
          child: Column(
            children: <Widget>[
              isLoadings2
                  ? Container(
                      margin: const EdgeInsets.only(
                          left: 29.0, right: 29, top: 250),
                      // color: Colors.white.withOpacity(.4),
                      child: Align(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : status == "0"
                      ? Container(
                          margin: const EdgeInsets.only(
                              left: 29.0, right: 29, top: 250),
                          color: Colors.white.withOpacity(.4),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text("No Transaction Available!!"),
                          ),
                        )
                      : Expanded(
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: users.length,
                              itemBuilder: (context, index) {
                                if (editingController.text.isEmpty) {
                                  return new Card(
                                      margin: EdgeInsets.symmetric(
                                          vertical: 3, horizontal: 15),
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
                                          InkWell(
                                            onTap: () {},
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 7, right: 7),
                                                    // height: 45,
                                                    child:
                                                        Row(children: <Widget>[
                                                      Expanded(
                                                          flex: 7,
                                                          child: Align(
                                                              alignment:
                                                                  Alignment
                                                                      .topLeft,
                                                              child: Text(
                                                                users[index]
                                                                    .date_time,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 11,
                                                                  color: Colors
                                                                      .black45,
                                                                ),
                                                              ))),
                                                      Expanded(
                                                          flex: 3,
                                                          child: Align(
                                                              alignment: Alignment
                                                                  .centerRight,
                                                              child: Container(
                                                                  //  margin: const EdgeInsets.only(left: 5),
                                                                  //  height: 42,
                                                                  child: Text(
                                                                'Available Balance',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 10,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              )))),
                                                    ])),
                                              ],
                                            ),
                                          ),
//################################################
                                          Row(
                                            children: <Widget>[
                                              Expanded(
                                               /* child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[*/
                                                    child:Container(
                                                      margin: const EdgeInsets.all(
                                                         5),
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.7,
                                                      child: Text(
                                                          'Transaction ID',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 5,
                                                          style: new TextStyle(
                                                            fontSize: 15.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black87,
                                                          )),
                                                    ),),
                                                    SizedBox(
                                                      height: 5.0,
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.7,
                                                        child: Text(
                                                            users[index]
                                                                .transaction_id,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 5,
                                                            style:
                                                                new TextStyle(
                                                              fontSize: 10.0,
                                                              color: Colors
                                                                  .black45,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            )),
                                                      ),
                                                    ),
                                              Expanded(
                                                child: Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 5),
                                                  padding:
                                                      const EdgeInsets.all(3.0),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.grey),
                                                      color: Colors.grey),
                                                  child: Align(
                                                    alignment: Alignment.center,
                                                    child: Text( users[index]
                                                        .rem_balance=="None"?"0.0":
                                                      '₹ ' +
                                                          users[index]
                                                              .rem_balance,
                                                      style: TextStyle(
                                                          fontSize: 9,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),

                                          //################################################################
                                          ////////////////////////////////////////////////////////////////////////////////////////
/*                                InkWell(
                                  onTap: () {},
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        //  margin: EdgeInsets.all(10.0),
                                        child: Row(
                                          children: <Widget>[
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  left: 7, right: 7, top: 5),
                                              child: Expanded(
                                                flex: 7,
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
                                                          'Transaction ID',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 5,
                                                          style: new TextStyle(
                                                            fontSize: 15.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black87,
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
                                                          users[index]
                                                              .transaction_id,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 5,
                                                          style: new TextStyle(
                                                            fontSize: 10.0,
                                                            color:
                                                                Colors.black45,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          )),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                    right: 15),
                                                padding:
                                                    const EdgeInsets.all(3.0),
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.grey),
                                                    color: Colors.grey),
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    '₹ '+users[index].rem_balance,
                                                    style: TextStyle(
                                                        fontSize: 9,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                            ),

                                            */ /*  IconButton(
                                              icon: Image.asset('assets/images/info.png',height: 20,width: 20,),
                                              onPressed: () {},
                                            ),*/ /*
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),*/
                                          ////////////////////////////////////////////////////////////////////
                                          InkWell(
                                            onTap: () {},
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 5,
                                                            right: 7,
                                                            bottom: 15,
                                                            top: 5),
                                                    //  height: 45,
                                                    child: Row(
                                                        children: <Widget>[
                                                          Expanded(
                                                              flex: 7,
                                                              child: Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .topLeft,
                                                                  child: Text(
                                                                    users[index]
                                                                        .purpose,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        color: Colors
                                                                            .black87,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ))),
                                                          Expanded(
                                                              flex: 3,
                                                              child: Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerRight,
                                                                  child: Container(
                                                                      margin: const EdgeInsets.only(right: 15),
                                                                      /* height: 42,*/
                                                                      child: Text(
                                                                        '₹ ' +
                                                                            users[index].amount,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                15,
                                                                            color: users[index].transaction_type == "Debit"
                                                                                ? Colors.red
                                                                                : Colors.green,
                                                                            fontWeight: FontWeight.bold),
                                                                      )))),
                                                        ])),
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
  String topic_no,
      topic,
      description,
      marks,
      status,
      transaction_type,
      date_time;
  List<User> data;

  Album(
      {this.topic_no,
      this.topic,
      this.description,
      this.marks,
      this.transaction_type,
      this.date_time});

  Album.fromJson(Map<String, dynamic> json) {
    status = json['status'];

    if (json['data'] != null) {
      data = new List<User>();
      json['data'].forEach((v) {
        data.add(new User.fromJson(v));
        isLoadings2 = false;
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
  String transaction_id,
      purpose,
      amount,
      rem_balance,
      transaction_type,
      date_time;

  User(
      {this.transaction_id,
      this.purpose,
      this.amount,
      this.rem_balance,
      this.transaction_type,
      this.date_time});

  User.fromJson(Map<String, dynamic> json) {
    transaction_id = json['transaction_id'];
    purpose = json['purpose'];
    amount = json['amount'];
    rem_balance = json['rem_balance'];
    transaction_type = json['transaction_type'];
    date_time = json['date_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['transaction_id'] = this.transaction_id;
    data['purpose'] = this.purpose;

    data['amount'] = this.amount;
    data['rem_balance'] = this.rem_balance;
    data['transaction_type'] = this.transaction_type;
    data['date_time'] = this.date_time;

    return data;
  }
}
