
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:onlineexamcontest/Constants/MyColor.dart';
import 'package:onlineexamcontest/Constants/uidata.dart';
import 'package:shared_preferences/shared_preferences.dart';
SharedPreferences prefs;
List<User> users = new List<User>();
String contestid2,token1;
bool  isLoadings1 = true;
String status="";

class MyContestTermscondition extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _State();

  MyContestTermscondition(String contestid)
  {
    contestid2 = contestid;
    print("cooooooooooooo$contestid2");
  }
}

class _State extends State<MyContestTermscondition> {
  void initState()
  {
    setState(() {
      initializeSF();

    });
  }

  initializeSF() async {
    setState(() async {
      prefs = await SharedPreferences.getInstance();
      token1 = prefs.getString("token");
      print("tokennnnn>>>$token1");
      getTermslist();
    });


  }

  Future<Album> getTermslist() async {
    Map data = {"contest_id": contestid2};
    print('syllabus $data');
    var jsonData = null;
    var response = await http.post(uidata.termsandconditions, body: data,headers: {'Authorization': token1});
    if (response.statusCode == 200) {
      var res = Album.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
     // jsonData = json.decode(response.body);
    jsonData=json.decode(utf8.decode(response.bodyBytes));
      print("jsonData>>>>$jsonData");
       status = jsonData['status'];
      print("stt>>> $status");
      if (status=="1")
        {
          isLoadings1=false;
        setState(() {
          users = res.data;
        });
    }
      else
        {
          isLoadings1=false;
        }

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
        title: Text('Terms & Conditions'),
        backgroundColor: Colors.black,


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
                child: Align(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                ),
              )
                  : status =="0"
                  ? Container(
                margin: const EdgeInsets.only(left: 29.0, right: 29,top: 250),
                child: Align(
                  alignment: Alignment.center,
                  child: Text("No data available !!",style: TextStyle(fontSize: 18,color: Colors.black38),),
                ),
              ):
                   Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: users.length,

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

                                                            users[index]
                                                                .title,
                                                        overflow:
                                                        TextOverflow
                                                            .ellipsis,
                                                        maxLines: 5,
                                                        style:
                                                        new TextStyle(
                                                          fontSize: 16.0,
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
                                                            .term,
                                                        overflow:
                                                        TextOverflow
                                                            .ellipsis,
                                                        maxLines: 45,
                                                        style:
                                                        new TextStyle(
                                                          fontSize: 16.0,
                                                          color: Colors
                                                              .black54,

                                                        )),
                                                  ),
                                                  SizedBox(
                                                    height: 3.0,
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
  String title, term ,status;
  List<User> data;

  Album({this.title, this.term});

  Album.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null)
    {
      data = new List<User>();
      json['data'].forEach((v)
      {
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
  String title, term;
  User({this.title, this.term});
  User.fromJson(Map<String, dynamic> json)
  {
    title = json['title'];
    term = json['term'];
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['term'] = this.term;


    return data;
  }
}
