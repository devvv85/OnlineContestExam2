import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:onlineexamcontest/Constants/MyColor.dart';
import 'package:http/http.dart' as http;
import 'package:onlineexamcontest/Constants/uidata.dart';
import 'package:shared_preferences/shared_preferences.dart';

String subtopic_id1,language,token;
SharedPreferences prefs;
class LiveTest extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _State();

  LiveTest(String subtopic_id,String lang)
  {
    subtopic_id1 = subtopic_id;
    language=lang;
    print('subtopic_id1>> $subtopic_id1>>lang>>$language');
  }
}
class _State extends State<LiveTest> {
  List<User> users = new List<User>();

  Widget build(BuildContext context)
  {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Test'),
        backgroundColor:Colors.black,
      ),
      body: new GestureDetector(
        onTap:()
        {
          FocusScope.of(context).requestFocus(new FocusNode());
          },
        child: Container(
          color: MyColor.orange12,
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: 1,
                    itemBuilder: (context, index)
                    {
                      return new Card(
                            //margin: EdgeInsets.symmetric(vertical: 25, horizontal: 10),
                          margin: const EdgeInsets.only(top: 35.0,left: 10,right: 10),
                            color: Theme.of(context).cardColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(0.5)),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                              EdgeInsets.only(left: 10.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Container( margin: const EdgeInsets.only(top: 25.0,bottom: 25.0),
                                                    width: MediaQuery.of(context).size.width * 0.7,
                                                    child: Text(
                                                        'Ouestion :\n'+users[index].question,
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 5,
                                                        style: new TextStyle(
                                                          fontSize: 18.0,
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.black,
                                                        )
                                                    ),
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
                                                        users[index].option_1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 5,
                                                        style: new TextStyle(
                                                          fontSize: 12.0,
                                                          color: Colors.black54,
                                                          fontWeight:
                                                          FontWeight.bold,
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

                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }


  void initState()
  {
    setState(() {
      initializeSF();

    });
  }
  initializeSF() async {
    setState(() async {
      prefs = await SharedPreferences.getInstance();
      token = prefs.getString("token");
      print("aaaa $token");
      _apiGetTest();
    });

  }

  Future<Album> _apiGetTest() async {
    Map data = {"subtopic_id": subtopic_id1, "lang": "English"};
    print(data);
    final response = await http.post(uidata.testquestions, body: data,headers: {'Authorization': token});
    if (response.statusCode == 200) {
      var res = Album.fromJson(jsonDecode(response.body));
      setState(() {
        users = res.data;
      });

      print("test Response $res");
      print("test Responce2 $users");

    } else {
      throw Exception('Failed to load test');
    }
  }
}

class DetailPage extends StatelessWidget {
  final User user;

  DetailPage(this.user);

  @override
  Widget build(BuildContext context)
  {
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

class Album
{
  String status;
  List<User> data;
  Album({this.status});
  Album.fromJson(Map<String, dynamic> json)
  {
    status = json['status'];
    if (json['data'] != null)
    {
      data = new List<User>();
      json['data'].forEach((v)
      {
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
  String question_id,
      question,
      option_1,
      option_2,
      option_3,
      option_4,
      explanation;
  User({
    this.question_id,
    this.question,
    this.option_1,
    this.option_2,
    this.option_3,
    this.option_4,
    this.explanation,
  });
  User.fromJson(Map<String, dynamic> json)
  {
    question_id = json['question_id'].toString();
    question = json['question'];
    option_1 = json['option_1'];
    option_2 = json['option_2'];
    option_3 = json['option_3'];
    option_4 = json['option_4'];
    explanation = json['explanation'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['question_id'] = this.question_id;
    data['question'] = this.question;
    data['option_1'] = this.option_1;
    data['option_2'] = this.option_2;
    data['option_3'] = this.option_3;
    data['option_4'] = this.option_4;
    data['explanation'] = this.explanation;
    return data;
  }
}
