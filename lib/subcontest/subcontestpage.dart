import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onlineexamcontest/Constants/MyColor.dart';
import 'package:onlineexamcontest/Constants/uidata.dart';
import 'package:onlineexamcontest/Dashboard/MainDashboard.dart';
import 'package:onlineexamcontest/Login/Forgotpassword.dart';
import 'package:onlineexamcontest/Login/Registration.dart';
import 'package:onlineexamcontest/subcontest/LanguageSelection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

import 'demo_exam.dart';

SharedPreferences prefs;
String contestnm = "Sub Topics", test_id1, token;
bool isLoading = false;
String userId,my_test_id="";

class SubContestPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _State();

  SubContestPage(String test_id)
  {
    test_id1 = test_id;
  }
}

class _State extends State<SubContestPage> {
  TextEditingController editingController = TextEditingController();
  List<User> users = new List<User>();

  @override
  void initState() {
    isLoading = true;
    initializeSF();
  }

  initializeSF() async {
    setState(() async {
      prefs = await SharedPreferences.getInstance();
      token = prefs.getString("token");
      userId = prefs.getString("uId");
      print("token> $token");
      apiGetSubContest();
    });
  }

  Future<Album> apiGetSubContest() async {
    isLoading = true;
    Map data = {"topic_id": test_id1};
    print("subtopic input>>$data");
    var jsonData = null;
    final response = await http
        .post(uidata.subtopic, body: data, headers: {'Authorization': token});
    if (response.statusCode == 200) {
      final res = Album.fromJson(json.decode(utf8.decode(response.bodyBytes)));


      setState(() {
        users = res.data;
      });
    } else {
      throw Exception('Failed to load winners');
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text(contestnm),
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
                color: MyColor.themecolor,
                height: 50,
                margin: const EdgeInsets.only(bottom: 6),
                child: Container(
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
                        hintText: "Search",
                        prefixIcon: Icon(Icons.search),
                        suffixIcon: editingController.text.isNotEmpty?IconButton(
                          onPressed: () { FocusScope.of(context).unfocus();editingController.clear();},
                          icon: Icon(Icons.clear),
                        ):null,
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5.0)))),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: users.length,
                    /* // primary: false,
                    itemCount: 2,
                    // itemCount: 3,*/
                    itemBuilder: (context, index) {
                      if (editingController.text.isEmpty) {
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
                                    setState(() {
                                      print(
                                          "parameter>>$userId, $users[index].subtopic_id");
                                      apiSubcontestRegister(
                                          userId, users[index].subtopic_id);
                                    });
                                  },
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.all(3.0),
                                        child: Row(
                                          children: <Widget>[
                                            IconButton(
                                              icon: Image.network(
                                                  users[index].img),
                                              onPressed: () {},
                                            ),
                                            Container(
                                              //   margin: EdgeInsets.only(left: 10.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.6,
                                                    child: Text(
                                                        users[index].topic,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 5,
                                                        style: new TextStyle(
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black,
                                                        )),
                                                  ),
                                                  /*  SizedBox(
                                                    height: 5.0,
                                                  ),*/
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        top: 3.0),
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.6,
                                                    child: Text(
                                                        users[index]
                                                            .description,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 5,
                                                        style: new TextStyle(
                                                          fontSize: 12.0,
                                                          color: Colors.black,
                                                        )),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10.0,
                                            ),
                                            IconButton(
                                              icon: Image.asset(
                                                'assets/images/arrow.png',
                                                height: 20,
                                                width: 20,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  apiSubcontestRegister(userId,
                                                      users[index].subtopic_id);
                                                });
                                              },
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
                      } else if (users[index]
                          .topic
                          .toLowerCase()
                          .contains(editingController.text.toLowerCase())) {
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
                                    setState(() {
                                      print(
                                          "parameter>>$userId, $users[index].subtopic_id");
                                      apiSubcontestRegister(
                                          userId, users[index].subtopic_id);
                                    });
                                  },
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.all(3.0),
                                        child: Row(
                                          children: <Widget>[
                                            IconButton(
                                              icon: Image.network(
                                                  users[index].img),
                                              onPressed: () {},
                                            ),
                                            Container(
                                              //   margin: EdgeInsets.only(left: 10.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.6,
                                                    child: Text(
                                                        users[index].topic,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 5,
                                                        style: new TextStyle(
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black,
                                                        )),
                                                  ),
                                                  /*  SizedBox(
                                                    height: 5.0,
                                                  ),*/
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        top: 3.0),
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.6,
                                                    child: Text(
                                                        users[index]
                                                            .description,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 5,
                                                        style: new TextStyle(
                                                          fontSize: 12.0,
                                                          color: Colors.black,
                                                        )),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10.0,
                                            ),
                                            IconButton(
                                              icon: Image.asset(
                                                'assets/images/arrow.png',
                                                height: 20,
                                                width: 20,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  apiSubcontestRegister(userId,
                                                      users[index].subtopic_id);
                                                });
                                              },
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
    );
  }

  apiSubcontestRegister(String user_id, String subtopic_id) async {
    Map data = {
      "user_id": user_id,
      "subtopic_id": subtopic_id,
    };
    print("subtest$data");
    var jsonData = null;
    var response = await http
        .post(uidata.mysubtest, body: data, headers: {'Authorization': token});

    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      var status = jsonData['status'];
      print("Response>>>$jsonData");
      print('status $status');
      if (status == "1") {
        setState(() {
          // isLoading = false;
          String mysubtest_id = jsonData['mysubtest_id'];
          Toast.show(jsonData['Message'], context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      //    Navigator.push(context, MaterialPageRoute(builder: (context) => LanguageSelection(mysubtest_id,my_test_id)));
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => GetJson(mysubtest_id,my_test_id,"Subtopic")));
        });
      } else {
        setState(() {
          //isLoading = false;
        });
      }
    } else {
      setState(() {
        // isLoading = false;
      });
    }
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
  String status, win_price, winners, fees;
  List<User> data;

  Album({this.status, this.win_price, this.winners, this.fees, this.data});

  Album.fromJson(Map<String, dynamic> json) {
    status = json['status'];

    if (json['subtopics'] != null) {
      data = new List<User>();
      json['subtopics'].forEach((v) {
        data.add(new User.fromJson(v));
        isLoading = false;
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;

    if (this.data != null) {
      data['subtopics'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class User {
  String topic_id, subtopic_id, img, topic, description;

  User({
    this.topic_id,
    this.subtopic_id,
    this.img,
    this.topic,
    this.description,
  });

  User.fromJson(Map<String, dynamic> json) {
    topic_id = json['topic_id'];
    subtopic_id = json['subtopic_id'];
    img = json['img'];
    topic = json['topic'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['topic_id'] = this.topic_id;
    data['subtopic_id'] = this.subtopic_id;

    data['img'] = this.img;
    data['topic'] = this.topic;
    data['description'] = this.description;

    return data;
  }
}
