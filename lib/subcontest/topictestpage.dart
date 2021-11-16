import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onlineexamcontest/Constants/MyColor.dart';
import 'package:onlineexamcontest/Constants/uidata.dart';
import 'package:onlineexamcontest/Dashboard/MainDashboard.dart';
import 'package:onlineexamcontest/Login/Forgotpassword.dart';
import 'package:onlineexamcontest/Login/Registration.dart';
import 'package:onlineexamcontest/subcontest/LanguageSelection.dart';
import 'package:onlineexamcontest/subcontest/subcontestpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

import 'demo_exam.dart';

SharedPreferences prefs;
String contestnm = "Topics", test_id1, token, userId;
bool isLoading = false;
String title = "", no_questions = "", duration = "",mysubtest_id="";

class topictestpage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _State();

  topictestpage(String test_id) {
    test_id1 = test_id;
  }
}

class _State extends State<topictestpage> {
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
      apiGetTopics();
    });
  }

  Future<Album> apiGetTopics() async {
    isLoading = true;
    /*   test_id1 = "1";*/
    Map data = {"test_id": test_id1};
    print("para>>$data");
    var jsonData = null;
    final response = await http
        .post(uidata.topics, body: data, headers: {'Authorization': token});
    if (response.statusCode == 200) {
      var res = Album.fromJson(json.decode(utf8.decode(response.bodyBytes)));
      jsonData = json.decode(response.body);
      print("Response>>>$jsonData");
      setState(() {
        users = res.data;
      });
    } else {
      throw Exception('Failed to load winners');
    }
  }

  apichkSubtopic(String topic_id) async {
    Map data = {"topic_id": topic_id};
    print(data);
    var jsonData = null;
    var response = await http.post(uidata.check_subtopics,
        body: data, headers: {'Authorization': token});

    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      var status = jsonData['status'];
      print("subtopicchk>>>$jsonData");
      if (status == "1") {
        setState(() {
          String s_status = jsonData['s_status'].toString();
          if (s_status == "1") {
          } else {}
        });
      } else {}
    } else {}
  }

  Future<void> dialog2(BuildContext context, String topicid) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Container(
            height: 70,
            child: Column(children: <Widget>[
              Row(children: <Widget>[
                Text(" No of Questions for Exam : " + no_questions),
              ]),
              Row(children: <Widget>[
                Text(" Duration : " + duration),
              ])
            ]),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                setState(() {
                  Navigator.pop(context);
                  apiSubcontestRegister(userId, topicid);
                });
              },
            ),
          ],
        );
      },
    );
  }

  ///
  apiSubcontestRegister(String user_id, String topic_id) async {
    Map data = {
      "user_id": user_id,
      "topic_id": topic_id,
    };
    print("para>>$data");
    var jsonData = null;
    var response = await http
        .post(uidata.start_test, body: data, headers: {'Authorization': token});

    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      var status = jsonData['status'];
      print("Re>>$jsonData");
      print('status $status');
      if (status == "1") {
        setState(() {
          String my_test_id = jsonData['my_test_id'];
          Toast.show(jsonData['Message'], context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        /*  Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => LanguageSelection(my_test_id)));*/

          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => GetJson(mysubtest_id,my_test_id,"Topic")));
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      setState(() {
        isLoading = false;
      });
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
                          onPressed: () { FocusScope.of(context).unfocus();
                          editingController.clear();},
                          icon: Icon(Icons.clear),
                        ):null,
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)))),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: users.length,
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
                                  onTap: ()
                                  async {
                                    Map data = {
                                      "topic_id": users[index].topic_id
                                    };
                                    print("chkStatus$data");
                                    var jsonData = null;
                                    var response = await http.post(
                                        uidata.check_subtopics,
                                        body: data,
                                        headers: {'Authorization': token});

                                    if (response.statusCode == 200)
                                    {
                                      jsonData = json.decode(response.body);
                                      var status = jsonData['status'];
                                      print("subtopicchk>>>$jsonData");
                                      if (status == "1") {
                                        setState(() {
                                          String s_status =
                                              jsonData['s_status'].toString();
                                          title = jsonData['title'].toString();
                                          no_questions =
                                              jsonData['no_questions']
                                                  .toString();
                                          duration =
                                              jsonData['duration'].toString();

                                          if (s_status == "1")
                                          {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SubContestPage(
                                                            users[index]
                                                                .topic_id)));
                                          } else {
                                            setState(() {
                                              dialog2(context,
                                                  users[index].topic_id);
                                            });
                                          }
                                        });
                                      } else {}
                                    } else {}
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
                                                            .description!=null ?users[index]
                                                        .description:"",
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
                                              onPressed: () async {
                                                Map data = {
                                                  "topic_id": users[index].topic_id
                                                };
                                                print("chkStatus$data");
                                                var jsonData = null;
                                                var response = await http.post(
                                                    uidata.check_subtopics,
                                                    body: data,
                                                    headers: {'Authorization': token});

                                                if (response.statusCode == 200)
                                                {
                                                  jsonData = json.decode(response.body);
                                                  var status = jsonData['status'];
                                                  print("subtopicchk>>>$jsonData");
                                                  if (status == "1") {
                                                    setState(() {
                                                      String s_status =
                                                      jsonData['s_status'].toString();
                                                      title = jsonData['title'].toString();
                                                      no_questions =
                                                          jsonData['no_questions']
                                                              .toString();
                                                      duration =
                                                          jsonData['duration'].toString();

                                                      if (s_status == "1")
                                                      {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    SubContestPage(
                                                                        users[index]
                                                                            .topic_id)));
                                                      } else {
                                                        setState(() {
                                                          dialog2(context,
                                                              users[index].topic_id);
                                                        });
                                                      }
                                                    });
                                                  } else {}
                                                } else {}
                                               /* setState(() {
                                                  dialog2(context,
                                                      users[index].topic_id);
                                                });*/
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
                                  onTap: () async {
                                    Map data = {
                                      "topic_id": users[index].topic_id
                                    };
                                    print("chkStatus$data");
                                    var jsonData = null;
                                    var response = await http.post(
                                        uidata.check_subtopics,
                                        body: data,
                                        headers: {'Authorization': token});

                                    if (response.statusCode == 200) {
                                      jsonData = json.decode(response.body);
                                      var status = jsonData['status'];
                                      print("subtopicchk>>>$jsonData");
                                      if (status == "1") {
                                        setState(() {
                                          String s_status =
                                              jsonData['s_status'].toString();
                                          title = jsonData['title'].toString();
                                          no_questions =
                                              jsonData['no_questions']
                                                  .toString();
                                          duration =
                                              jsonData['duration'].toString();

                                          if (s_status == "1") {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SubContestPage(
                                                            users[index]
                                                                .topic_id)));
                                          } else {
                                            setState(() {
                                              dialog2(context,
                                                  users[index].topic_id);
                                            });
                                          }
                                        });
                                      } else {}
                                    } else {}
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
                                                  dialog2(context,
                                                      users[index].topic_id);
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

  Album({this.status, this.data});

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
