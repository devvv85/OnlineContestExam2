import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:onlineexamcontest/Constants/MyColor.dart';
import 'package:onlineexamcontest/Constants/uidata.dart';
import 'package:onlineexamcontest/subcontest/LiveTest.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

import 'live_contest_questions.dart';


String my_contest_id,userId,token1;
bool isLoading = false;
SharedPreferences prefs;
var selectedLang="";
class LanguageSelection_LiveContest extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _State();

  LanguageSelection_LiveContest(String id) {
    my_contest_id = id;
    print('Language>SubgoupId>$my_contest_id');
  }
}

class _State extends State<LanguageSelection_LiveContest> {
  TextEditingController editingController = TextEditingController();

  @override
  void initState()
  {
    super.initState();
    setState(() {
      selectedLang="English";
      initializeSF();
    });

  }

  initializeSF() async {
    setState(() async {
      prefs = await SharedPreferences.getInstance();
      userId = prefs.getString("uId");
      token1 = prefs.getString("token");
      print("language>UserId> $userId");
    });

  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Select Language'),
        backgroundColor: MyColor.themecolor,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: MyStatefulWidget(),
      ),
    );
  }
}

enum BestTutorSite { English, Hindi }

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  BestTutorSite _site = BestTutorSite.English;

  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: ()
        {
          return Future.value(false);
        },child: Scaffold(
        body: Center(
          child: Column(
            // mainAxisAlignment : MainAxisAlignment.center,
            //  crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                  margin: const EdgeInsets.only(
                      left: 60,
                      right: 30,
                      top: 80
                  ),
                  child: ListTile(
                    title: const Text('English', style: TextStyle(
                      fontSize: 18.0,
                      fontWeight:
                      FontWeight.bold,
                      color: Colors.black,
                    )),
                    leading: Radio(
                      value: BestTutorSite.English,
                      groupValue: _site,
                      onChanged: (BestTutorSite value) {
                        setState(() {
                          _site = value;
                           selectedLang="English";
                          print("val>>$selectedLang");
                        });
                      },
                    ),
                  )),

              Container(
                  margin: const EdgeInsets.only(
                    left: 60,
                    right: 30,
                  ),
                  child: ListTile(
                    title: const Text('Hindi', style: TextStyle(
                      fontSize: 18.0,
                      fontWeight:
                      FontWeight.bold,
                      color: Colors.black,
                    )),
                    leading: Radio(
                      value: BestTutorSite.Hindi,
                      groupValue: _site,
                      onChanged: (BestTutorSite value) {
                        setState(() {
                          _site = value;
                           selectedLang="Hindi";
                          print("val>>$selectedLang");
                        });
                      },
                    ),
                  )),
//Button

              Container(
                  height: 40,
                  margin: const EdgeInsets.only(
                    left: 30,
                    right: 30,
                    top: 10,
                  ),
                  child: RaisedButton(
                    textColor: Colors.white,
                    color: MyColor.themecolor,
                    shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: MyColor.white,
                            width: 1,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.circular(7)),
                    child: Text(
                      'Next',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: ()
                    {
                      isLoading=true;
                     // Navigator.push(context, MaterialPageRoute(builder: (context) => LiveContest_questions(my_contest_id,selectedLang)));
                    },
                  )),

              //////////////
            ],
          ),),
        ));
  }

//
  apiSubcontestRegister(String user_id, String subtopic_id) async {
    Map data = {
      "user_id": user_id,
      "subtopic_id": subtopic_id,
    };
    print(data);
    var jsonData = null;
    var response = await http.post(uidata.mysubtest, body: data,headers: {'Authorization': token1});

    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      var status = jsonData['status'];
      print(jsonData);
      print('status $status');
      if (status == "1") {
        setState(() {
          isLoading = false;
          String mysubtest_id = jsonData['mysubtest_id'];
          //Navigator.push(context, MaterialPageRoute(builder: (context) => DemoTest(subgroupId, "English",mysubtest_id)));

         // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DemoTest(subgroupId, "English",mysubtest_id)));

          //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LiveContest_questions(subgroupId,selectedLang,mysubtest_id)));
        });
      }
      else {
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

}
