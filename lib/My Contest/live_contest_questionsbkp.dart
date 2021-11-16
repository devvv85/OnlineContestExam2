import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:onlineexamcontest/Constants/uidata.dart';
import 'package:onlineexamcontest/My%20Contest/Live_Contest_TestCompleteMsg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

String ans = "1";
String my_contest_id, language;
List _answerList = [];
String userId, questionId, option = "", ans_id = "";
SharedPreferences prefs;
String mysubtest_id;
bool isPre = false;
String status;
//String ans_id
//List<String> _answerList = [];
String duration="";
final interval = const Duration(seconds: 1);
var timerMaxSeconds = Duration(seconds: int.parse(duration)).inMinutes;
int currentSeconds = 0;
var otp="";  String mob1 = "";
String get timerText => '${((timerMaxSeconds - currentSeconds) ~/ 60).toString().padLeft(2, '0')}: ${((timerMaxSeconds - currentSeconds) % 60).toString().padLeft(2, '0')}';
class LiveContest_questionsbkp extends StatefulWidget {
  static final routeName = 'exam';
  bool isSubmit = false;

  @override
  _EmployeesState createState() => _EmployeesState();

  LiveContest_questionsbkp(String contestid, String lang) {
    my_contest_id = contestid;
    language = lang;

    print('subtopic_id1>> $my_contest_id>>lang>>$language');
  }
}

class _EmployeesState extends State<LiveContest_questionsbkp> {
  PageController _controller = PageController(
    initialPage: 0,
  );
  bool _isLoading = false;
  bool _isSubmit = false;
  bool _isPrevious = false;
  String token, examid;

  List snap1 = [];
  BoxDecoration _decoration = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(10)),
      border: Border.all(color: Colors.blueAccent));
  BoxDecoration _decoration1 = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(10)),
      border: Border.all(color: Colors.blueAccent));
  BoxDecoration _decoration2 = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(10)),
      border: Border.all(color: Colors.blueAccent));
  BoxDecoration _decoration3 = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(10)),
      border: Border.all(color: Colors.blueAccent));
  BoxDecoration _decoration00 = BoxDecoration(
      color: Colors.blueAccent,
      borderRadius: BorderRadius.all(Radius.circular(10)),
      border: Border.all(color: Colors.blueAccent));
  BoxDecoration _decoration01 = BoxDecoration(
      color: Colors.blueAccent,
      borderRadius: BorderRadius.all(Radius.circular(10)),
      border: Border.all(color: Colors.blueAccent));
  BoxDecoration _decoration02 = BoxDecoration(
      color: Colors.blueAccent,
      borderRadius: BorderRadius.all(Radius.circular(10)),
      border: Border.all(color: Colors.blueAccent));
  BoxDecoration _decoration03 = BoxDecoration(
      color: Colors.blueAccent,
      borderRadius: BorderRadius.all(Radius.circular(10)),
      border: Border.all(color: Colors.blueAccent));

  int i, page;
  bool isA = false;
  bool isB = false;
  bool isC = false;
  bool isD = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _answerList.clear();
      initializeSF();
    });


  }

  initializeSF() async {
    setState(() async {
      prefs = await SharedPreferences.getInstance();
      userId = prefs.getString("uId");
      print("test>UserId> $userId");
      getEmployees1(my_contest_id, language);
      ans_id = "";
    });

  }

  getEmployees1(String subtopic_id1, String language) async {
    Map data = {"my_contest_id": my_contest_id, "lang": language};
    print(data);
    var jsonData = null;
    final res = await http.post(uidata.contestquestions, body: data);
    var responsBody = json.decode(utf8.decode(res.bodyBytes));
    //var responsBody = json.decode(res.body);
    jsonData = json.decode(res.body);

    status = jsonData['status'];

    if(status=="0")
    {
      Toast.show( "Questions not available !!", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

    }
    print(responsBody['data']);
    snap1 = responsBody['data'];
    setState(() {
      for (i = 0; i < snap1.length; i++) {
        var qid11 = responsBody['data'][i]['question_id'];

        if (responsBody['data'][i]['options'] == "A") {
          isA = true;
        } else {
          isA = false;
        }
        if (responsBody['data'][i]['options'] == "B") {
          isB = true;
        } else {
          isB = false;
        }
        if (responsBody['data'][i]['options'] == "C") {
          isC = true;
        } else {
          isC = false;
        }
        if (responsBody['data'][i]['options'] == "D") {
          isD = true;
        } else {
          isD = false;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.black,
          title: Text(
            "Live Contest",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 50.0,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: snap1.length,
                    itemBuilder: (context, index) {
                      final Map<String, dynamic> advisoryservice = snap1[index];
                      var qq = advisoryservice["index"];
                      return Container(
                          margin: EdgeInsets.all(6.0),
                          height: 50.0,
                          width: 50.0,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            color: Colors.grey,
                            onPressed: () {
                              _controller.animateToPage(
                                qq,
                                duration: Duration(milliseconds: 500),
                                curve: Curves.ease,
                              );
                              _controller
                                  .jumpToPage(advisoryservice["index"] - 1);
                              //getEmployees1();
                              print("QQ= $qq");
                            },
                            //child: Text("$qq",style: TextStyle(color: Colors.white,fontSize: 15),),
                            child: Text(
                              "${advisoryservice["index"]}",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ));
                    }),
              ),
              Container(
                  // margin: EdgeInsets.only(top:15.0),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: PageView.builder(
                    itemCount: snap1.length,
                    itemBuilder: (context, index) {
                      return PageView(
                        controller: _controller,
                        children: snap1
                            .map((e) => employeePage(e, snap1.length))
                            .toList(),
                      );
                    },
                  )),
            ],
          ),
        ));
  }

  Widget employeePage(node, length) {
    return Container(
      padding: EdgeInsets.all(5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 5.0),
                //Text("${node['ExamQuetionId']}) ${node['Question']}",style: TextStyle(fontSize: 18)),
                Text("${node['index']}) ${node['questiontext']}",
                    style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                InkWell(
                  child: /*isA == true*/ ans.contains("1")
                      ? Container(
                          height: 50.0,
                          margin: EdgeInsets.only(
                              left: 30.0, right: 30.0, top: 15.0),
                          decoration: _decoration,
                          child: Center(
                              child: Row(
                            children: [
                              SizedBox(
                                width: 15.0,
                              ),
                              Text(
                                "A)",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16.0),
                              ),
                              SizedBox(
                                width: 15.0,
                              ),
                              Flexible(
                                child: Text(
                                  "${node['option_1']}",
                                  maxLines: 3,
                                  softWrap: true,
                                  overflow: TextOverflow.fade,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16.0),
                                ),
                              ),
                            ],
                          )))
                      : Container(
                          height: 50.0,
                          margin: EdgeInsets.only(
                              left: 30.0, right: 30.0, top: 15.0),
                          decoration: _decoration00,
                          child: Center(
                              child: Row(
                            children: [
                              SizedBox(
                                width: 15.0,
                              ),
                              Text(
                                "A)",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16.0),
                              ),
                              SizedBox(
                                width: 15.0,
                              ),
                              Flexible(
                                child: Text(
                                  "${node['option_1']}",
                                  maxLines: 3,
                                  softWrap: true,
                                  overflow: TextOverflow.fade,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16.0),
                                ),
                              ),
                            ],
                          ))),
                  onTap: () {
                    setState(() {
                      option = "option_1";
                      String ans =
                          "'" + node['question_id'] + "@" + 'option_1' + "'";
                      _answerList.add(ans);
                      _decoration = BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          border: Border.all(color: Colors.blueAccent));
                      _decoration1 = BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          border: Border.all(color: Colors.blueAccent));
                      _decoration2 = BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          border: Border.all(color: Colors.blueAccent));
                      _decoration3 = BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          border: Border.all(color: Colors.blueAccent));
                      _decoration01 = BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          border: Border.all(color: Colors.blueAccent));
                      _decoration02 = BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          border: Border.all(color: Colors.blueAccent));
                      _decoration03 = BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          border: Border.all(color: Colors.blueAccent));
                    });
                    // submitAns("${node['ExamQuetionId']}","A");
                    // getEmployees1(node['ExamQuetionId']);
                  },
                ),
                InkWell(
                  child: isB == true
                      ? Container(
                          height: 50.0,
                          margin: EdgeInsets.only(
                              left: 30.0, right: 30.0, top: 15.0),
                          decoration: _decoration01,
                          child: Center(
                              child: Row(
                            children: [
                              SizedBox(
                                width: 15.0,
                              ),
                              Text(
                                "B)",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16.0),
                              ),
                              SizedBox(
                                width: 15.0,
                              ),
                              Flexible(
                                child: Text(
                                  "${node['option_2']}",
                                  maxLines: 3,
                                  softWrap: true,
                                  overflow: TextOverflow.fade,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16.0),
                                ),
                              ),
                            ],
                          )))
                      : Container(
                          height: 50.0,
                          margin: EdgeInsets.only(
                              left: 30.0, right: 30.0, top: 15.0),
                          decoration: _decoration1,
                          child: Center(
                              child: Row(
                            children: [
                              SizedBox(
                                width: 15.0,
                              ),
                              Text(
                                "B)",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16.0),
                              ),
                              SizedBox(
                                width: 15.0,
                              ),
                              Flexible(
                                child: Text(
                                  "${node['option_2']}",
                                  maxLines: 3,
                                  softWrap: true,
                                  overflow: TextOverflow.fade,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16.0),
                                ),
                              ),
                            ],
                          ))),
                  onTap: () {
                    setState(() {
                      //  _answerList.add(node['option_2']);
                      option = "option_2";
                      String ans =
                          "'" + node['question_id'] + "@" + 'option_2' + "'";
                      _answerList.add(ans);
                      _decoration1 = BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          border: Border.all(color: Colors.blueAccent));
                      _decoration = BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          border: Border.all(color: Colors.blueAccent));

                      _decoration2 = BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          border: Border.all(color: Colors.blueAccent));
                      _decoration3 = BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          border: Border.all(color: Colors.blueAccent));
                      _decoration00 = BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          border: Border.all(color: Colors.blueAccent));
                      _decoration02 = BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          border: Border.all(color: Colors.blueAccent));
                      _decoration03 = BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          border: Border.all(color: Colors.blueAccent));
                    });
                    // submitAns("${node['ExamQuetionId']}","B");
                    // getEmployees1(node['ExamQuetionId']);
                  },
                ),
                InkWell(
                  child: isC == true
                      ? Container(
                          height: 50.0,
                          margin: EdgeInsets.only(
                              left: 30.0, right: 30.0, top: 15.0),
                          decoration: _decoration02,
                          child: Center(
                              child: Row(
                            children: [
                              SizedBox(
                                width: 15.0,
                              ),
                              Text(
                                "C)",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16.0),
                              ),
                              SizedBox(
                                width: 15.0,
                              ),
                              Flexible(
                                child: Text(
                                  "${node['option_3']}",
                                  maxLines: 3,
                                  softWrap: true,
                                  overflow: TextOverflow.fade,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16.0),
                                ),
                              ),
                            ],
                          )))
                      : Container(
                          height: 50.0,
                          margin: EdgeInsets.only(
                              left: 30.0, right: 30.0, top: 15.0),
                          decoration: _decoration2,
                          child: Center(
                              child: Row(
                            children: [
                              SizedBox(
                                width: 15.0,
                              ),
                              Text(
                                "C)",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16.0),
                              ),
                              SizedBox(
                                width: 15.0,
                              ),
                              Flexible(
                                child: Text(
                                  "${node['option_3']}",
                                  maxLines: 3,
                                  softWrap: true,
                                  overflow: TextOverflow.fade,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16.0),
                                ),
                              ),
                            ],
                          ))),
                  onTap: () {
                    setState(() {
                      option = "option_3";
                      //  _answerList.add(node['option_3']);
                      String ans =
                          "'" + node['question_id'] + "@" + 'option_3' "'";
                      _answerList.add(ans);
                      _decoration2 = BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          border: Border.all(color: Colors.blueAccent));
                      _decoration = BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          border: Border.all(color: Colors.blueAccent));
                      _decoration1 = BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          border: Border.all(color: Colors.blueAccent));
                      _decoration3 = BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          border: Border.all(color: Colors.blueAccent));
                      _decoration00 = BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          border: Border.all(color: Colors.blueAccent));
                      _decoration01 = BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          border: Border.all(color: Colors.blueAccent));
                      _decoration03 = BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          border: Border.all(color: Colors.blueAccent));
                    });
                    //   submitAns("${node['ExamQuetionId']}","C");
                    // getEmployees1(node['ExamQuetionId']);
                  },
                ),
                InkWell(
                  child: isD == true
                      ? Container(
                          height: 50.0,
                          margin: EdgeInsets.only(
                              left: 30.0, right: 30.0, top: 15.0),
                          decoration: _decoration03,
                          child: Center(
                              child: Row(
                            children: [
                              SizedBox(
                                width: 15.0,
                              ),
                              Text(
                                "D)",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16.0),
                              ),
                              SizedBox(
                                width: 15.0,
                              ),
                              Flexible(
                                child: Text(
                                  "${node['option_4']}",
                                  maxLines: 3,
                                  softWrap: true,
                                  overflow: TextOverflow.fade,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16.0),
                                ),
                              ),
                            ],
                          )))
                      : Container(
                          height: 50.0,
                          margin: EdgeInsets.only(
                              left: 30.0, right: 30.0, top: 15.0),
                          decoration: _decoration3,
                          child: Center(
                              child: Row(
                            children: [
                              SizedBox(
                                width: 15.0,
                              ),
                              Text(
                                "D)",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16.0),
                              ),
                              SizedBox(
                                width: 15.0,
                              ),
                              Flexible(
                                child: Text(
                                  "${node['option_4']}",
                                  maxLines: 3,
                                  softWrap: true,
                                  overflow: TextOverflow.fade,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16.0),
                                ),
                              ),
                            ],
                          ))),
                  onTap: () {
                    setState(() {
                      option = "option_4";
                      // _answerList.add(node['option_4']);
                      String ans =
                          "'" + node['question_id'] + "@" + 'option_4' "'";
                      _answerList.add(ans);
                      _decoration3 = BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          border: Border.all(color: Colors.blueAccent));
                      _decoration = BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          border: Border.all(color: Colors.blueAccent));
                      _decoration1 = BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          border: Border.all(color: Colors.blueAccent));
                      _decoration2 = BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          border: Border.all(color: Colors.blueAccent));
                      _decoration00 = BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          border: Border.all(color: Colors.blueAccent));
                      _decoration01 = BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          border: Border.all(color: Colors.blueAccent));
                      _decoration02 = BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          border: Border.all(color: Colors.blueAccent));
                    });
                    //   submitAns("${node['ExamQuetionId']}","D");
                    //getEmployees1(node['ExamQuetionId']);
                  },
                )
              ],
            ),
          ),
          SizedBox(height: 25.0),
          new Container(
            height: 60.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
/*                    child: Center(
                      child: Container(
                        height: 60.0,
                        child: RaisedButton.icon(
                          onPressed: () {
                            isPre=true;
                            */ /* setState(() {
                              _decoration = BoxDecoration(
                                  color: Colors.blueAccent,
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  border: Border.all(color: Colors.blueAccent));
                            });
                            _decoration1 = BoxDecoration(
                                color: Colors.blueAccent,
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                border: Border.all(color: Colors.blueAccent));*/ /*

                            */ /* _answerList.removeLast();
                            print("len>>$_answerList");*/ /*
                            int page = _controller.page.toInt();
                            _controller.animateToPage(
                              page - 1,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.ease,
                            );
                            _controller.jumpToPage(page - 1);
                            setState(() {
                              _isSubmit = false;
                              if (_controller.page.toInt() == 0) {
                                _isPrevious = true;
                              } else {
                                _isPrevious = false;
                              }
                             // print("PreviousQid:  ${node['ExamQuetionId'] - 1}");
                              */ /*  getEmployees1(node['ExamQuetionId']-1);*/ /*
                              //   getEmployees1();
                              // submitAns("", ans)
                            */ /*  setState(() {
                                apiAnswerSubmit(ans_id, userId, questionId, option);
                              });*/ /*

                            });
                          },
                          color: Colors.white,
                          icon: Icon(
                            Icons.navigate_before,
                            color: Colors.white,
                          ),
                          label: Text(
                            "PREVIOUS",
                            style:
                                TextStyle(color: Colors.white, fontSize: 16.0),
                          ),
                          */ /* label: _isPrevious==true?Text("",style: TextStyle(color: Colors.white,fontSize: 16.0),):
                          Text("PREVIOUS",style: TextStyle(color: Colors.white,fontSize: 16.0),),*/ /*
                        ),
                      ),
                    ),*/
                  ),
                ),
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Container(
                        height: 60.0,
                        child: RaisedButton.icon(
                          onPressed: () {
                            if (_isSubmit == true) {
                              apiEndTest();
                            }

                            print("len>>$_answerList");
                            int page = _controller.page.toInt();
                            _controller.animateToPage(
                              page + 1,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.ease,
                            );
                            _controller.jumpToPage(page + 1);
                            if (_isSubmit == true) {
                              // Navigator.of(context).pushNamed(ExamResult.routeName);
                            } else {
                              _controller.jumpToPage(page + 1);
                            }
                            setState(() {
                              if (isPre != true) {
                                ans_id = "";
                              }

                              _isPrevious = false;

                              /*_decoration = BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  border: Border.all(color: Colors.blueAccent)
                              );
                              _decoration1 = BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  border: Border.all(color: Colors.blueAccent)
                              );
                              _decoration2 = BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  border: Border.all(color: Colors.blueAccent)
                              );
                              _decoration3 = BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  border: Border.all(color: Colors.blueAccent)
                              );*/
                              if (_controller.page.toInt() == length - 1) {
                                _isSubmit = true;
                                print("_isSubmit= $_isSubmit");
                              } else {
                                _isSubmit = false;
                              }

                              /* getEmployees1(node['ExamQuetionId']+1);*/
                              // getEmployees1();
                            });
                            print(_controller.page.toInt());
                            questionId = node['question_id'];

                            apiAnswerSubmit(questionId, option, my_contest_id);
                            isPre = false;
                          },
                          color: Colors.black,
                          icon: Icon(
                            Icons.navigate_next,
                            color: Colors.white,
                          ),
                          label: _isSubmit == true
                              ? Text(
                                  "Submit",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16.0),
                                )
                              : Text(
                                  "NEXT",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16.0),
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

/*
  submitAns(String queid,String ans)async{

    var jsonData = null;
    var response = await http.get(Constants.apiBase+"Auth/QuetionAnswerSubmitById/?"
        "ExamQuetionId=$queid&Answer=$ans&Status=1",
        headers: {
          'Authorization': "Basic $token"});
    if(response.statusCode==200)
    {
      jsonData = json.decode(response.body);
      var status = jsonData['responseCode'];
      print(jsonData);
      if(status==0)
      {


      }
      else{

      }
    }
    else{

    }
  }
*/
  apiAnswerSubmit(String question_id, String option, String contestid) async {
    Map data = {
      "question_id": question_id,
      "ans": option,
      "my_contest_id": contestid
    };
    print("red>>$data");
    var jsonData = null;
    var response = await http.post(uidata.submitcontestans, body: data);

    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      var status = jsonData['status'];
      var msg = jsonData['Message'];
      print("ressss>>$jsonData");
      if (status == "1") {
      //  Toast.show(msg, context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      } else {
        Toast.show(msg, context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        print("in else");
      }
    } else {}
  }

  /////end test api
  apiEndTest() async {
    Map data = {
      "my_contest_id": my_contest_id,
    };
    print(data);
    var jsonData = null;
    var response = await http.post(uidata.endcontest, body: data);

    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      var status = jsonData['status'];
      String Message = jsonData['Message'];
      print(jsonData);
      print('status $status');
      if (status == "1") {
        setState(() {
         //  Toast.show(Message, context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          // Navigator.push(context, MaterialPageRoute(builder: (context) =>TestCompletePage()));
             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>Live_Contest_TestCompletePage(userId)));
        });
      } else {
        Toast.show(Message, context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    } else {}
  }
}
