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
bool isLoading = true;
String userId, status, token1,type;

class NotiPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _State();
  NotiPage(String type1)
  {
    type=type1;
  }
}

class _State extends State<NotiPage> {
  TextEditingController editingController = TextEditingController();
  List<User> users = new List<User>();

  @override
  void initState()
  {
    setState(()
    {
      initializeSF();
    });
  }

  initializeSF() async {
    setState(() async {
      prefs = await SharedPreferences.getInstance();
      userId = prefs.getString("uId");
      token1 = prefs.getString("token");
      getNotificationList();
      print("notiUserId> $userId");
    });
  }

  Future<Album> getNotificationList() async {
    isLoading = true;
    Map data = {"user_id": userId};
    print(data);
    var jsonData = null;
    final response = await http.post(uidata.notification,
        body: data, headers: {'Authorization': token1});
    if (response.statusCode == 200)
    {
      var res = Album.fromJson(jsonDecode(response.body));
      jsonData = json.decode(response.body);
      setState(() {
        status = jsonData['status'];
        //  status="0";
        if (status == "0") {
          isLoading = false;
        }
      });

      setState(() {
        users = res.data;
      });
    } else {
      throw Exception('Failed to load winners');
    }
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () {
        if(type=="noti")
          {
            Navigator.pop(context);
          }
        else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MainDashboard(userId, true)));
        }
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Notifications'),
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
/*              Container(
              color: My,
                height: 10,
                margin: const EdgeInsets.only(bottom: 6),

              ),*/
                isLoading
                    ? Container(
                        margin: const EdgeInsets.only(
                            left: 29.0, right: 29, top: 200),
                        //  color: Colors.white,
                        child: Align(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : status == "0"
                        ? Container(
                            margin: const EdgeInsets.only(
                                left: 29.0, right: 29, top: 10),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                "No data available !!",
                                style: TextStyle(
                                    fontSize: 18, color: Colors.black38),
                              ),
                            ),
                          )
                        : Expanded(
                            child: ListView.builder(
                                shrinkWrap: true,
                                /* // primary: false,
                    itemCount: 2,
                    // itemCount: 3,*/
                                itemCount: users.length,
                                itemBuilder: (context, index) {
                                  if (editingController.text.isEmpty) {
                                    return new Card(
                                        margin: EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 10),
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
                                                children: <Widget>[
                                                  Container(
                                                    margin: EdgeInsets.all(8.0),
                                                    child: Row(
                                                      children: <Widget>[
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 10.0),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: <Widget>[
                                                              Container(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.7,
                                                                child: Text(
                                                                    users[index]
                                                                        .message,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    maxLines: 5,
                                                                    style:
                                                                        new TextStyle(
                                                                      fontSize:
                                                                          17.0,
                                                                      fontWeight: FontWeight.bold,
                                                                      color: Colors.black,
                                                                    )),
                                                              ),
                                                              SizedBox(
                                                                height: 5.0,
                                                              ),
                                                              Container(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.7,
                                                                child: Text(
                                                                    users[index]
                                                                        .date,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    maxLines: 5,
                                                                    style:
                                                                        new TextStyle(
                                                                      fontSize:
                                                                          12.0,
                                                                      color: Colors
                                                                          .black54,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
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
                                  } else {
                                    return Container();
                                  }
                                }),
                          ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Album {
  String status, message, date;
  List<User> data;

  Album({this.status, this.message, this.date});

  Album.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = new List<User>();
      json['data'].forEach((v) {
        data.add(new User.fromJson(v));
        isLoading = false;
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
  String message, date;

  User({
    this.message,
    this.date,
  });

  User.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['message'] = this.message;
    data['date'] = this.date;

    return data;
  }
}
