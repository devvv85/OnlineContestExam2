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
bool isLoading = false;
String contestId1;  List<User> users = new List<User>();
String status,token1;
class LeaderboardPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _State();
  LeaderboardPage(String contestId)
  {
    contestId1 = contestId;
    print('declarecontest id> $contestId1');
  }
}

class _State extends State<LeaderboardPage> {
  TextEditingController editingController = TextEditingController();
//******************************************
  @override
  void initState() {
    setState(() {
      initializeSF();
    });


  }
  initializeSF()  async{
    setState(()
    async {
      prefs = await SharedPreferences.getInstance();
      token1 = prefs.getString("token");
      print("token>>$token1");
      getDetails();
    });

  }

  Future<Album> getDetails() async {
    isLoading = true;

    Map data = {"contest_id":contestId1};
    print("map$data");
    var jsonData = null;
    final response = await http.post(uidata.leaderboard, body: data,headers: {'Authorization': token1});
    if (response.statusCode == 200) {
      var res = Album.fromJson(jsonDecode(response.body));
      jsonData = json.decode(response.body);
      print("Responce12>>>$jsonData");
      setState(() {
        status = jsonData['status'];

      });

      setState(() {
        users = res.data;
      });
    } else {
      throw Exception('Failed to load test');
    }
  }
  //***************************************************
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Leaderboard'),
        backgroundColor: MyColor.themecolor,
      ),
      body: status =="0"
          ? Container(
        margin: const EdgeInsets.only(left: 29.0, right: 29,top: 10),
        child: Align(
          alignment: Alignment.center,
          child: Text("No data available !!",style: TextStyle(fontSize: 18,color: Colors.black38),),
        ),
      ):
      new GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Container(
          color: MyColor.orange12,
          child: Column(
            children: <Widget>[
              Container(
                 // padding: EdgeInsets.only(left: 5, right: 5, top: 1,bottom: 2),
                  margin: const EdgeInsets.only(left: 12,right:12,top: 15),
                  //color: Colors.yellow,
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(border: Border.all(color: Colors.black45)),
                  child: Row(children: <Widget>[
                    Expanded(
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Text("All Members",
                                style: new TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                )))),
                    Expanded(
                        child: Align(
                            alignment: Alignment.center,
                            child: Text("Marks",
                                style: new TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                )))),
                    Expanded(
                        child: Align(
                            alignment: Alignment.center,
                            child: Text("Time",
                                style: new TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                )))),
                    Expanded(
                        child: Align(
                            alignment: Alignment.topRight,
                            child: Text("# Rank",
                                style: new TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                )))),
                  ])),


              ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

              Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    /* // primary: false,
                    itemCount: 2,
                    // itemCount: 3,*/
                    itemCount: users.length,
                    itemBuilder: (context, index)
                    {
                      if(editingController.text.isEmpty)
                      {
                        return new Card(
                            margin: EdgeInsets.symmetric(vertical: 3, horizontal: 15),
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
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        // padding: EdgeInsets.only(left: 5, right: 5, top: 1,bottom: 2),
                                          margin: const EdgeInsets.only(left: 3,right:3,top: 15,bottom: 15),
                                          //color: Colors.yellow,
                                        //  padding: const EdgeInsets.all(8.0),
                                          //decoration: BoxDecoration(border: Border.all(color: Colors.black45)),
                                          child: Row(children: <Widget>[
                                            Expanded(
                                               /* child: Align(
                                                    alignment: Alignment.topLeft,
                                                    child: Text("Person 1",
                                                        style: new TextStyle(
                                                          fontSize: 14.0,
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.bold,
                                                        )))*/
                                              child:Container(

                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Container(
                                                      margin: EdgeInsets.only(left: 2.0),
                                                      width: MediaQuery.of(context).size.width * 0.7,
                                                      child: Text(users[index].person,
                                                          style: new TextStyle(
                                                            fontSize: 14.0,
                                                            color: Colors.black,
                                                            fontWeight: FontWeight.bold,
                                                          )),
                                                    ),
                                                    SizedBox(
                                                      height: 5.0,
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(left: 2.0),
                                                      width: MediaQuery.of(context).size.width * 0.7,
                                                      child: Text('# '+users[index].rank,
                                                          overflow: TextOverflow.ellipsis,
                                                          maxLines: 5,
                                                          style: new TextStyle(
                                                            fontSize: 12.0,
                                                            color: Colors.black54,
                                                            fontWeight: FontWeight.bold,
                                                          )),
                                                    ),
                                                   /* SizedBox(
                                                      height: 5.0,
                                                    ),*/

                                                    /* Text("Date - "+newDate,
                                          style: new TextStyle(fontSize: 13.0, color: Colors.grey[600])),*/
                                                    SizedBox(
                                                      height: 5.0,
                                                    ),
                                                  ],
                                                ),
                                              ),

                                            ),
                                            Expanded(
                                                child: Align(
                                                    alignment: Alignment.center,
                                                    child: Text(users[index].marks,
                                                        style: new TextStyle(
                                                          fontSize: 14.0,
                                                          color: Colors.black54,
                                                          fontWeight: FontWeight.bold,
                                                        )))),
                                            Expanded(
                                                child: Align(
                                                    alignment: Alignment.center,
                                                    child: Text(users[index].time,
                                                        style: new TextStyle(
                                                          fontSize: 14.0,
                                                          color: Colors.black54,
                                                          fontWeight: FontWeight.bold,
                                                        )))),
                                            Expanded(
                                                child: Align(
                                                    alignment: Alignment.center,
                                                    child: Text(users[index].rank,
                                                        style: new TextStyle(
                                                          fontSize: 14.0,
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.bold,
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
  String status, win_price, winners, fees;
  List<User> data;

  Album({this.status, this.win_price, this.winners, this.fees, this.data});

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

  String person, marks,rank,time;

  User({
    this.person, this.marks,this.rank,this.time,
  });

  User.fromJson(Map<String, dynamic> json) {
    person = json['person'];
    marks = json['marks'];
    rank = json['rank'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['person'] = this.person;
    data['marks'] = this.marks;
    data['rank'] = this.rank;
    data['time'] = this.time;

    return data;
  }
}

