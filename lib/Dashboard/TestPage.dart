import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onlineexamcontest/Constants/MyColor.dart';
import 'package:onlineexamcontest/Constants/uidata.dart';
import 'package:onlineexamcontest/Dashboard/MainDashboard.dart';
import 'package:onlineexamcontest/Login/Forgotpassword.dart';
import 'package:onlineexamcontest/Login/Registration.dart';
import 'package:onlineexamcontest/subcontest/subcontestpage.dart';
import 'package:onlineexamcontest/subcontest/topictestpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

SharedPreferences prefs;
String token,userId;bool isclick=false;
class TestPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _State();
}

class _State extends State<TestPage>
{
  TextEditingController editingController = TextEditingController();
  List<User> users = new List<User>();

  @override
  void initState() {
   /* if (mounted) {*/
      setState(()
    {
      initializeSF();
    });


  }
  initializeSF() async {
   /* if (mounted)
    {*/
      setState(() async
    {
      prefs = await SharedPreferences.getInstance();
      token = prefs.getString("token");
      userId = prefs.getString("uId");
      print("token> $token");
      _getTest("");
    });
   // }

  }

  Future<Album> _getTest(String s) async {
    Map data = {
      "topic": s,
    };
    print("subtest$data");
    final response = await http.post(uidata.test1,body:data,headers: {'Authorization': token});
    if (response.statusCode == 200)
    {
      var res = Album.fromJson(jsonDecode(response.body));
      setState(()
      {
        users = res.data;
      });
    } else {
      throw Exception('Failed to load skills');
    }
  }

  @override
  Widget build(BuildContext context)
  {
    return new WillPopScope(
        onWillPop: ()
    {

      Navigator.push(context, MaterialPageRoute(builder: (context) => MainDashboard(userId,true)));
      return Future.value(true);
    },
    child: Scaffold(
      body: new GestureDetector(
        onTap: ()
        {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Container(
          color: MyColor.orange12,
          child: Column(
            children: <Widget>[
              Container(
                color: MyColor.themecolor,
                height: 50,
                child: Container(
                  // color: Colors.black87,
                  color: MyColor.white,
                  height: 50,
                  margin: const EdgeInsets.only(bottom: 5, left: 8, right: 8),
                  // margin: const EdgeInsets.only(left: 2, right: 2),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {

                      });
                    },
                    controller: editingController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 6),
                        labelText: "Search",
                        //hintText: "Search",
                        prefixIcon: Icon(Icons.search),
                        suffixIcon: editingController.text.isNotEmpty?
                        new SizedBox(
                            height: 60.0,
                            width: 65.0,
                            child: new
                            IconButton(
                              // suffixIcon: IconButton(
                              onPressed: () {
                                setState(()
                                {
                                  isclick=true;
                                  _getTest(editingController.text.toString());
                                  editingController.clear();
                                });
                              },
                              icon:Image.asset('assets/images/search1.png'),
                              //
                              //
                              // icon:Icon(Icons.search),
                            )):isclick==false?null: IconButton(
                          // suffixIcon: IconButton(
                          onPressed: () {
                            setState(()
                            {
                              isclick=false;
                              _getTest("");
                              editingController.clear();
                            });
                          },
                          icon:Icon(Icons.clear),
                          //
                          //
                          // icon:Icon(Icons.search),
                        ),
                      //  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5.0)))

                    ),
                  ),
                ),
              ),


              Container(
                  alignment: Alignment.topLeft,
                  margin:
                      const EdgeInsets.only(left: 10.0, top: 20.0, bottom: 5),
                  child: Text(
                    'Trending Exams',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  )),
              Divider(
                color: Colors.grey,
                height: 7,
              ),
              Expanded(
                child: Container(
                    padding: EdgeInsets.all(5.0),
                    child: GridView.builder(
                      itemCount: users.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 4.0,
                          mainAxisSpacing: 4.0),
                      itemBuilder: (BuildContext context, int index)
                      {

                      /*  if(editingController.text.isEmpty)
                        {*/
                          return new Card(
                              shadowColor: Colors.grey,
                              margin: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                              color: Theme.of(context).cardColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(0.5)),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                       // MaterialPageRoute(builder: (context) => SubContestPage(users[index].test_id)),
                                        MaterialPageRoute(builder: (context) => topictestpage(users[index].test_id)),
                                      );
                                    },
                                    child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                   Visibility(visible: users[index].img.isNotEmpty,child:Container(
                                                      alignment: Alignment.center,
                                                      width: 50,
                                                      height: 50,
                                                      child: Image.network(
                                                          users[index].img),
                                                    ),),
                                                    Container(
                                                      alignment: Alignment.center,
                                                      child: Text(
                                                          users[index].topic,
                                                          overflow: TextOverflow.ellipsis,
                                                          maxLines: 5,
                                                          style: new TextStyle(
                                                            fontSize: 12.0,
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.black,
                                                          )),
                                                    ),
                                                  ],
                                                ),
                                          /*    ),
                                            ],
                                          ),*/
                                      /*  ),
                                      ],
                                    ),*/
                                  ),
                                  //  Divider(color: Colors.grey,),
                                ],
                              ));
                       /* }  else if (
                        users[index]
                            .topic
                            .toLowerCase()
                            .contains(editingController.text.toLowerCase()) )
                        {
                          return new Card(
                              shadowColor: Colors.grey,
                              margin: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                              color: Theme.of(context).cardColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(0.5)),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                      //  MaterialPageRoute(builder: (context) => SubContestPage(users[index].test_id)),
                                        MaterialPageRoute(builder: (context) => topictestpage(users[index].test_id)),
                                      );
                                    },
                                    *//* child: Column(
                                      children: <Widget>[
                                        Container(
                                          child: Row(
                                            children: <Widget>[
                                              Container(

                                                alignment: Alignment.center,
                                                padding: EdgeInsets.all(10.0),*//*
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                    Visibility(visible: users[index].img.isNotEmpty,child:Container(
                                          alignment: Alignment.center,
                                          width: 50,
                                          height: 50,
                                          child: Image.network(
                                              users[index].img),
                                        ),),
                                        Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                              users[index].topic,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 5,
                                              style: new TextStyle(
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              )),
                                        ),
                                      ],
                                    ),
                                    *//*    ),
                                            ],
                                          ),*//*
                                    *//*  ),
                                      ],
                                    ),*//*
                                  ),
                                  //  Divider(color: Colors.grey,),
                                ],
                              ));
                        } else {
                          return Container(
                          );
                        }*/
                      },
                    )),
              ),
            ],
          ),
        ),
      ),),
    );
  }
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
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
  String test_id;
  String img;
  String topic, description;

  User({
    this.test_id,
    this.img,
    this.topic,
    this.description,
  });

  User.fromJson(Map<String, dynamic> json) {
    test_id = json['test_id'].toString();
    img = json['img'];
    topic = json['topic'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['test_id'] = this.test_id;
    data['img'] = this.img;
    data['topic'] = this.topic;
    data['description'] = this.description;

    return data;
  }
}
