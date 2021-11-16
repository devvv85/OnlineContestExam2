import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onlineexamcontest/Constants/MyColor.dart';
import 'package:onlineexamcontest/Constants/uidata.dart';
import 'package:onlineexamcontest/Dashboard/MainDashboard.dart';
import 'package:onlineexamcontest/Login/Forgotpassword.dart';
import 'package:onlineexamcontest/Login/Registration.dart';
import 'package:onlineexamcontest/Result/DeclareResult1.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

SharedPreferences prefs;
List<User> users = new List<User>();
String contestid2,token;
bool isLoadings1 = false;

class SyllabusPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _State();

  SyllabusPage(String contestid) {
    contestid2 = contestid;
  }
}

class _State extends State<SyllabusPage> {
  void initState() {
    setState(() {
      initializeSF();
      isLoadings1 = true;

    });
  }
  initializeSF() async {
    setState(() async {
      prefs = await SharedPreferences.getInstance();
      token = prefs.getString("token");
      print("token> $token");
      getSyllabus();
    });

  }
  Future<Album> getSyllabus() async {
    Map data = {"contest_id": contestid2};
    print('syllabus $data');
    var jsonData = null;
    var response = await http.post(uidata.syllabus, body: data,headers: {'Authorization': token});
    if (response.statusCode == 200)
    {
      var res = Album.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      jsonData = json.decode(utf8.decode(response.bodyBytes));
      print("jsonData>>>>$jsonData");
      var status = jsonData['status'];
      print("stt>>> $status");

      setState(() {
        isLoadings1=false;
        users = res.data;
      });

    } else {
      throw Exception('Failed to load winners');
    }
  }

  TextEditingController editingController = TextEditingController();
  @override
  Widget build(BuildContext context)
  {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Syllabus'),
        backgroundColor: MyColor.themecolor,


      ),
      body: new GestureDetector(
        onTap: ()
        {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Container(
          color: MyColor.orange12,
          child: Column(
            children: <Widget>[
/*              Container(
                color: Colors.black87,
                height: 7,
                margin: const EdgeInsets.only(bottom: 6),
              ),*/
              isLoadings1
                  ? Container(
                      margin: const EdgeInsets.only(
                          left: 29.0, right: 29, top: 250),
                     // color: Colors.white.withOpacity(.4),
                      child: Align(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: users.length,
                          /* // primary: false,
                    itemCount: 2,
                    // itemCount: 3,*/
                          itemBuilder: (context, index) {
                            if (editingController.text.isEmpty) {
                              var index1 = index + 1;
                              return new Card(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 6, horizontal: 10),
                                  color: Theme.of(context).cardColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(0.5)),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      InkWell(
                                        onTap: () {},
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                              margin: EdgeInsets.all(2.0),
                                              child: Row(
                                                children: <Widget>[
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 10.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Container(
                                                          //  margin: EdgeInsets.all(5.0),
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.7,
                                                          child: Text(
                                                              index1.toString() +
                                                                  " . " +
                                                                  users[index]
                                                                      .topic,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              maxLines: 5,
                                                              style:
                                                                  new TextStyle(
                                                                fontSize: 14.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black,
                                                              )),
                                                        ),
                                                        SizedBox(
                                                          height: 5.0,
                                                        ),
                                                        Container(
                                                          margin:
                                                              EdgeInsets.all(
                                                                  2.0),
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.7,
                                                          child: Text(
                                                              users[index]
                                                                  .description,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              maxLines: 5,
                                                              style:
                                                                  new TextStyle(
                                                                fontSize: 14.0,
                                                                color: Colors
                                                                    .black54,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              )),
                                                        ),
                                                        SizedBox(
                                                          height: 3.0,
                                                        ),
                                                        Container(
                                                          margin:
                                                              EdgeInsets.all(
                                                                  2.0),
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.7,
                                                          child: Text(
                                                              "Marks -" +
                                                                  users[index]
                                                                      .marks,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              maxLines: 5,
                                                              style:
                                                                  new TextStyle(
                                                                fontSize: 14.0,
                                                                color: Colors
                                                                    .black87,
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
  String topic_no, topic, description, marks, status;
  List<User> data;

  Album({this.topic_no, this.topic, this.description, this.marks});

  Album.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null)
    {
      data = new List<User>();

      json['data'].forEach((v) {
        isLoadings1 = false;
        data.add(new User.fromJson(v));
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

class User
{
  String topic_no, topic, description, marks;
  User({this.topic_no, this.topic, this.description, this.marks});
  User.fromJson(Map<String, dynamic> json)
  {
    topic_no = json['topic_no'];
    topic = json['topic'];
    description = json['description'];
    marks = json['marks'];
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['topic_no'] = this.topic_no;
    data['topic'] = this.topic;
    data['description'] = this.description;
    data['marks'] = this.marks;

    return data;
  }
}
