import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onlineexamcontest/Constants/MyColor.dart';
import 'package:onlineexamcontest/Constants/uidata.dart';
import 'package:onlineexamcontest/Dashboard/MainDashboard.dart';
import 'package:onlineexamcontest/Login/Forgotpassword.dart';
import 'package:onlineexamcontest/Login/Registration.dart';
import 'package:onlineexamcontest/My%20Contest/SyllabusPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

SharedPreferences prefs;
bool isLoading = false;
String contestId1;
String win_price, winners, fees, status,token;

class WinnersPage extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() => new _State();

  WinnersPage(String contestId)
  {
    contestId1 = contestId;
    print('contest id $contestId1');
  }
}

class _State extends State<WinnersPage>
{
  TextEditingController editingController = TextEditingController();
  List<User> users = new List<User>();

  @override
  void initState() {
    setState(() {
      initializeSF();
    });


  }
  initializeSF() async {
    setState(() async {
      prefs = await SharedPreferences.getInstance();
      token = prefs.getString("token");
      print("token> $token");
      _getRank();
    });

  }
  Future<Album> _getRank() async {
    isLoading = true;
    Map data = {"contest_id":contestId1};
    print(data);
    var jsonData = null;
    final response = await http.post(uidata.winners, body: data,headers: {'Authorization': token});
    if (response.statusCode == 200)
    {
      var res = Album.fromJson(jsonDecode(response.body));
      jsonData = json.decode(response.body);
      status = jsonData['status'];
      if(status=="0")
        {
          isLoading = false;
        }
      else
        {
          isLoading = false;
          win_price = jsonData['win_price'];
          winners = jsonData['winners'];
          fees = jsonData['fees'];
          setState(() {
            users = res.data;
          });
        }

    } else {
      throw Exception('Failed to load winners');
    }
  }
  @override
  Widget build(BuildContext context)
  {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Winners'),
        backgroundColor: MyColor.themecolor,
      ),
      body: new GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Container(
          color: Colors.white70,
          child: Column(
            children: <Widget>[
              Container(
                  padding:
                      EdgeInsets.only(left: 5, right: 5, top: 1, bottom: 2),
                  margin: const EdgeInsets.only(left: 10, right: 10, top: 15),
                  color: Colors.yellow,
                  child: Row(children: <Widget>[
                    Expanded(
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Text("Total Winnings",
                                style: new TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                )))),
                    Expanded(
                        child: Align(
                            alignment: Alignment.center,
                            child: Text("Entry Fee",
                                style: new TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                )))),
                    Expanded(
                        child: Align(
                            alignment: Alignment.topRight,
                            child: Text("Winners",
                                style: new TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                )))),
                  ])),
              Container(
                  padding:
                      EdgeInsets.only(left: 15, right: 15, top: 3, bottom: 3),
                  // height: 40,
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  color: Colors.yellow,
                  child: Row(children: <Widget>[
                    Expanded(
                        child: Align(
                            alignment: Alignment.topLeft,
                            child:Text(win_price==null?"":win_price,
                                style: new TextStyle(
                                  fontSize: 13.0,
                                  color: Colors.black45,
                                  fontWeight: FontWeight.bold,
                                )))),
                    Expanded(
                        child: Align(
                            alignment: Alignment.center,
                            child: Text(fees==null?"":fees,
                                style: new TextStyle(
                                  fontSize: 13.0,
                                  color: Colors.black45,
                                  fontWeight: FontWeight.bold,
                                )))),
                    Expanded(
                        child: Align(
                            alignment: Alignment.topRight,
                            child: Text(winners==null?"":winners,
                                style: new TextStyle(
                                  fontSize: 13.0,
                                  color: Colors.black45,
                                  fontWeight: FontWeight.bold,
                                )))),
                  ])),

              ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
              Container(
                  padding:
                      EdgeInsets.only(left: 40, right: 50, top: 2, bottom: 2),
                  height: 40,
                  child: Row(children: <Widget>[
                    Expanded(
                        child: Text("Rank",
                            style: new TextStyle(
                              fontSize: 15.0,
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ))),
                    Expanded(
                        child: Align(
                            alignment: Alignment.centerRight,
                            child: Text("Price",
                                style: new TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                )))),
                  ])),
              isLoading
                  ? Container(
                margin: const EdgeInsets.only(left: 29.0, right: 29),
                //color: Colors.white.withOpacity(.4),
                child: Align(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                ),
              )
                  : status =="0"
                  ? Container(
                margin: const EdgeInsets.only(left: 29.0, right: 29,top: 10),
                child: Align(
                  alignment: Alignment.center,
                  child: Text("No data available !!",style: TextStyle(fontSize: 18,color: Colors.black38),),
                ),
              ):
              Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: users.length,
                    /* // primary: false,
                    itemCount: 2,
                    // itemCount: 3,*/
                    itemBuilder: (context, index) {
                      print( 'rank>>> $users[index].rank');
                      if (editingController.text.isEmpty) {
                        return new Card(
                            margin: EdgeInsets.symmetric(
                                vertical: 4, horizontal: 15),
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
                                  onTap: () {},
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                          padding: EdgeInsets.only(
                                              left: 30,
                                              right: 30,
                                              top: 2,
                                              bottom: 2),
                                          height: 40,
                                          child: Row(children: <Widget>[
                                            Expanded(
                                                child: Text(users[index].rank,
                                                    style: new TextStyle(
                                                      fontSize: 14.0,
                                                      color: Colors.black54,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ))),
                                            Expanded(
                                                child: Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Text(
                                                        users[index].price,
                                                        style: new TextStyle(
                                                          fontSize: 14.0,
                                                          color: Colors.black54,
                                                          fontWeight:
                                                              FontWeight.bold,
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
  String rank, price;

  User({
    this.rank,
    this.price,
  });

  User.fromJson(Map<String, dynamic> json) {
    rank = json['rank'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['rank'] = this.rank;
    data['price'] = this.price;

    return data;
  }
}
