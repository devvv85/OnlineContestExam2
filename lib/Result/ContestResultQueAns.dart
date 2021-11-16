import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onlineexamcontest/Constants/MyColor.dart';
import 'package:onlineexamcontest/Constants/uidata.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

SharedPreferences prefs;
bool isLoading = false;
var my_contest_id;
String userId,token;
String attempt, unattempted, right, wrong, result, marks, status, result_p;

class ContestResultQueAns extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _State();

  ContestResultQueAns(var my_contest_id2) {
    my_contest_id = my_contest_id2;
    print("mysubtest_id>>$my_contest_id");
  }
}

class _State extends State<ContestResultQueAns> {
  TextEditingController editingController = TextEditingController();
  List<User> users = new List<User>();

  //*****************************************************get Api data*********************************************************************
  @override
  void initState() {
    setState(() {
      initializeSF();
    });

  }

  initializeSF()async {
    setState(() async {
      prefs = await SharedPreferences.getInstance();
      userId = prefs.getString("uId");
      token = prefs.getString("token");
      print("TestResult>> $userId");
      _getTestResult();
    });

  }

  Future<Album> _getTestResult() async {
    isLoading = true;
    var jsonData = null;

    Map data = {"my_contest_id": my_contest_id};
    print("para$data");
    final response = await http.post(uidata.contest_result, body: data,headers: {'Authorization': token});
    if (response.statusCode == 200) {
      var res = Album.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
      jsonData = json.decode(response.body);
      print("res>>>$jsonData");
      status = jsonData['status'];
      print("status>>$status");
      attempt = jsonData['attempts'];
      unattempted = jsonData['unattempted'];
      right = jsonData['right'];
      wrong = jsonData['wrong'];
      result = jsonData['result'];
      marks = jsonData['marks'];
      result_p = jsonData['result_p'];
      print("result_p>>$response");

      setState(() {
        users = res.data;
      });
    } else {
      throw Exception('Failed to load ans');
    }
  }

  //***********************************Dialog*****************************************************
  Future<void> dialogUpdateReport(BuildContext context, String queId) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Report'),
          content: TextField(
            controller: editingController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(hintText: "Enter Comment."),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              onPressed: ()
              {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text('Submit'),
              onPressed: () {
                //  Navigator.pop(context);
                if (editingController.text.isEmpty) {Toast.show("Please Enter comment.", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                } else {
                  Navigator.pop(context);
                  apiReport(
                      userId, queId, my_contest_id, editingController.text);
                }
              },
            ),
          ],
        );
      },
    );
  }

//****************************************************************************************
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Exam Result'),
        backgroundColor: MyColor.themecolor,
      ),
      body: new GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Container(
          color: Colors.white54,
          child: Column(
            children: <Widget>[
              Container(
                padding:
                    EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
                margin: const EdgeInsets.only(
                    top: 5, bottom: 2, left: 10, right: 10),
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.black)),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Row(children: <Widget>[
                        Expanded(
                          child: Container(
                              padding: EdgeInsets.only(top: 5, bottom: 5),
                              child: Text(
                                attempt == null
                                    ? ""
                                    : attempt + " " + "Attempt",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              )),
                        ),
                        Expanded(
                            child: Text(
                          unattempted == null
                              ? ""
                              : unattempted + " " + "Unattempted",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        )),
                      ]),
                      Row(children: <Widget>[
                        Expanded(
                          child: Container(
                              padding: EdgeInsets.only(top: 5, bottom: 5),
                              child: Text(
                                right == null ? "" : right + " " + "Right",
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              )),
                        ),
                        Expanded(
                            child: Text(
                          wrong == null ? "" : wrong + " " + "Wrong",
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        )),
                      ]),
                      Row(children: <Widget>[
                        Expanded(
                          child: Container(
                              padding: EdgeInsets.only(top: 5, bottom: 5),
                              child: Text(
                                result_p == null ? "" : "Result : " + result_p,
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              )),
                        ),
                        Expanded(
                            child: Text(
                          marks == null ? "" : "Marks : " + marks,
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        )),
                      ])
                    ]),
              ),
              Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: users.length,
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
                                  onTap: () {},
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        // margin: EdgeInsets.all(8.0),
                                        child: Row(
                                          children: <Widget>[
                                            Container(
                                              margin:
                                                  EdgeInsets.only(left: 10.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context).size.width * 0.8,
                                                    child: Text(
                                                        users[index].question_no ==
                                                                null
                                                            ? ""
                                                            : users[index]
                                                                .question_no,
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
                                                  SizedBox(
                                                    height: 5.0,
                                                  ),
                                                  users[index].question_img !=
                                                      ""
                                                      ? Container(
                                                      margin:
                                                      EdgeInsets.only(
                                                          left: 5,
                                                          right: 5),
                                                      alignment:
                                                      Alignment.topLeft,
                                                      //  height: 55,
                                                      // child: Image.network(users[index].question_img),
                                                      child: Column(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                          children: <
                                                              Widget>[
                                                            users[index].questiontext ==
                                                                ""
                                                                ? Column(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                                children: <
                                                                    Widget>[
                                                                  Row(
                                                                    //   mainAxisAlignment: MainAxisAlignment.center,
                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                      children: <Widget>[
                                                                        Container(
                                                                          //  height: 85,
                                                                          // width: MediaQuery.of(context).size.width * 0.7,
                                                                          margin: EdgeInsets.only(left: 0, right: 5, top: 2),
                                                                          child: FittedBox(
                                                                            fit: BoxFit.fill,
                                                                            child: Image.network(
                                                                              //'http://via.placeholder.com/350x150'),
                                                                                users[index].question_img),
                                                                          ),
                                                                        ),
                                                                      ])
                                                                ])
                                                                :

                                                            Column(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                                children: <
                                                                    Widget>[
                                                                  Row(
                                                                    //  mainAxisAlignment: MainAxisAlignment.center,
                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                      children: <Widget>[
                                                                        Align(
                                                                          alignment: Alignment.topLeft,
                                                                          child: Container(
                                                                            width: MediaQuery.of(context).size.width * 0.8,
                                                                            margin: EdgeInsets.only(left: 0, right: 5),
                                                                            alignment: Alignment.topLeft,
                                                                            child: Align(
                                                                              alignment: Alignment.topLeft,
                                                                              child: Text(
                                                                                users[index].questiontext,
                                                                                overflow: TextOverflow.ellipsis,
                                                                                maxLines: 15,
                                                                                style: new TextStyle(
                                                                                  fontSize: 15.5,
                                                                                  fontWeight: FontWeight.bold,
                                                                                  color: Colors.black54,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ]),
                                                                  Row(
                                                                    //   mainAxisAlignment: MainAxisAlignment.center,
                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                      children: <Widget>[
                                                                        Container(
                                                                          width: MediaQuery.of(context).size.width * 0.7,
                                                                          // height: 65,
                                                                          margin: EdgeInsets.only(left: 0, right: 5, top: 2),
                                                                          //  alignment: Alignment.centerLeft,
                                                                          //  height: 55,

                                                                          child: FittedBox(
                                                                            fit: BoxFit.fill,
                                                                            child: Image.network(
                                                                              //'http://via.placeholder.com/350x150'),
                                                                                users[index].question_img),
                                                                          ),
                                                                        ),
                                                                      ])
                                                                ]),
                                                          ]))
                                                      : Align(
                                                    alignment:
                                                    Alignment.topLeft,
                                                    child: Container(
                                                      width: MediaQuery.of(
                                                          context)
                                                          .size
                                                          .width *
                                                          0.8,
                                                      child: Text(
                                                          users[index].questiontext ==
                                                              null
                                                              ? ""
                                                              : users[index]
                                                              .questiontext,
                                                          overflow:
                                                          TextOverflow
                                                              .ellipsis,
                                                          maxLines: 5,
                                                          style:
                                                          new TextStyle(
                                                            fontSize:
                                                            15.5,
                                                            fontWeight:
                                                            FontWeight
                                                                .bold,
                                                            color: Colors
                                                                .black54,
                                                          )),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 5.0,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      print(
                                                          "Container clicked");
                                                      setState(() {
                                                        dialogUpdateReport(
                                                            context,
                                                            users[index]
                                                                .question_id);
                                                      });
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors.green),
                                                      child: Text('  Report  ',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 5,
                                                          style: new TextStyle(
                                                            fontSize: 14.0,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            /*  backgroundColor:
                                                              Colors.green,*/
                                                          )),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 8.0,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      left: 5,
                                                      top: 5,
                                                      right: 0,
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                          "A." + "  ",
                                                          style: TextStyle(
                                                              fontSize: 15.5,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                        /* Image.asset(
                                                          'assets/images/circle.png',
                                                          width: 16,
                                                          height: 16,
                                                        ),*/
                                                        Icon(
                                                          Icons.circle,
                                                          //  color:users[index].result=="Wrong"? Colors.red:users[index].result=="Right"?Colors.green:Colors.white,
                                                          color: users[index]
                                                                      .correct_ans ==
                                                                  "option_1"
                                                              ? Colors.green
                                                              : users[index]
                                                                          .ans ==
                                                                      "option_1"
                                                                  ? Colors.red
                                                                  : Colors
                                                                      .black12,
                                                          size: 20.0,
                                                        ),
                                                        users[index].option_1_img!=""?
                                                        Container(
                                                          margin: EdgeInsets.only(left: 5, right: 5),
                                                          alignment: Alignment.topLeft,
                                                          height: 55,
                                                          child: Image.network(users[index].option_1_img),
                                                        ):


                                                        Container(
                                                          margin: EdgeInsets
                                                              .only(
                                                            left: 5,
                                                          ),
                                                          width: MediaQuery.of(
                                                              context)
                                                              .size
                                                              .width *
                                                              0.7,
                                                          child:
                                                        Text(
                                                          users[index].option_1 ==
                                                                  null
                                                              ? ""
                                                              : "  " +
                                                                  users[index]
                                                                      .option_1,
                                                          overflow:
                                                          TextOverflow
                                                              .ellipsis,
                                                          maxLines: 15,
                                                          style: TextStyle(
                                                              fontSize: 14.5,
                                                              color: Colors
                                                                  .black54),
                                                        ),),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(padding: const EdgeInsets.only(
                                                      left: 5,
                                                      top: 12,
                                                      right: 0,
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                          "B." + "  ",
                                                          style: TextStyle(
                                                              fontSize: 15.5,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                        /* Image.asset(
                                                          'assets/images/circle.png',
                                                          width: 16,
                                                          height: 16,
                                                        ),*/
                                                        Icon(
                                                          Icons.circle,
                                                          //color:users[index].result=="Wrong"?Colors.red:Colors.green,
                                                          // color:users[index].result=="Wrong"? Colors.red:users[index].result=="Right"?Colors.green:Colors.white,
                                                          color: users[index]
                                                                      .correct_ans ==
                                                                  "option_2"
                                                              ? Colors.green
                                                              : users[index]
                                                                          .ans ==
                                                                      "option_2"
                                                                  ? Colors.red
                                                                  : Colors
                                                                      .black12,
                                                          size: 20.0,
                                                        ),
                                                    users[index].option_2_img!=""?
                                                    Container(
                                                      margin: EdgeInsets.only(left: 5, right: 5),
                                                      alignment: Alignment.topLeft,
                                                      height: 55,
                                                      child: Image.network(users[index].option_2_img),
                                                    ):

                                                    Container(
                                                      margin: EdgeInsets
                                                          .only(
                                                        left: 5,
                                                      ),
                                                      width: MediaQuery.of(
                                                          context)
                                                          .size
                                                          .width *
                                                          0.7,
                                                      child:Text(
                                                          users[index].option_2 ==
                                                                  null
                                                              ? ""
                                                              : "  " +

                                                                  users[index]
                                                                      .option_2,
                                                        overflow:
                                                        TextOverflow
                                                            .ellipsis,
                                                        maxLines: 15,
                                                          style: TextStyle(
                                                              fontSize: 14.5,
                                                              color: Colors
                                                                  .black54),
                                                        ),),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      left: 5,
                                                      top: 12,
                                                      right: 0,
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                          "C." + "  ",
                                                          style: TextStyle(
                                                              fontSize: 15.5,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                        /* Image.asset(
                                                          'assets/images/circle.png',
                                                          width: 16,
                                                          height: 16,
                                                        ),*/
                                                        Icon(
                                                          Icons.circle,
                                                          //color:users[index].result=="Wrong"?Colors.red:Colors.green,
                                                          // color:users[index].result=="Wrong"? Colors.red:users[index].result=="Right"?Colors.green:Colors.white,
                                                          color: users[index]
                                                                      .correct_ans ==
                                                                  "option_3"
                                                              ? Colors.green
                                                              : users[index]
                                                                          .ans ==
                                                                      "option_3"
                                                                  ? Colors.red
                                                                  : Colors
                                                                      .black12,
                                                          size: 20.0,
                                                        ),
                                                    users[index].option_3_img!=""?
                                                    Container(
                                                      margin: EdgeInsets.only(left: 5, right: 5),
                                                      alignment: Alignment.topLeft,
                                                      height: 55,
                                                      child: Image.network(users[index].option_3_img),
                                                    ):

                                                    Container(
                                                      margin: EdgeInsets
                                                          .only(
                                                        left: 5,
                                                      ),
                                                      width: MediaQuery.of(
                                                          context)
                                                          .size
                                                          .width *
                                                          0.7,
                                                      child:  Text(
                                                          users[index].option_3 ==
                                                                  null
                                                              ? ""
                                                              : "  " +
                                                                  users[index]
                                                                      .option_3,
                                                        overflow:
                                                        TextOverflow
                                                            .ellipsis,
                                                        maxLines: 15,
                                                          style: TextStyle(
                                                              fontSize: 14.5,
                                                              color: Colors
                                                                  .black54),
                                                        ),),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      left: 5,
                                                      top: 12,
                                                      right: 5,
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                          "D." + "  ",
                                                          style: TextStyle(
                                                              fontSize: 15.5,
                                                              color:
                                                                  Colors.black),
                                                        ),

                                                        Icon(
                                                          Icons.circle,
                                                          // color:users[index].result=="Wrong"?Colors.red:Colors.green,
                                                          //  color:users[index].result=="Wrong"? Colors.red:users[index].result=="Right"?Colors.green:Colors.white,
                                                          color: users[index]
                                                                      .correct_ans ==
                                                                  "option_4"
                                                              ? Colors.green
                                                              : users[index]
                                                                          .ans ==
                                                                      "option_4"
                                                                  ? Colors.red
                                                                  : Colors
                                                                      .black12,
                                                          size: 20.0,
                                                        ),
                                                        users[index].option_4_img!=""?
                                                        Container(
                                                          margin: EdgeInsets.only(left: 5, right: 5),
                                                          alignment: Alignment.topLeft,
                                                          height: 55,
                                                          child: Image.network(users[index].option_4_img),
                                                        ):
                                                        Container(
                                                          margin: EdgeInsets
                                                              .only(
                                                            left: 5,
                                                          ),
                                                          width: MediaQuery.of(
                                                              context)
                                                              .size
                                                              .width *
                                                              0.7,
                                                          child:Text(
                                                          users[index].option_4 ==
                                                                  null
                                                              ? ""
                                                              : "  " +
                                                                  users[index]
                                                                      .option_4,
                                                            overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                            maxLines: 15,
                                                          style: TextStyle(
                                                              fontSize: 14.5,
                                                              color: Colors
                                                                  .black54),
                                                        ),),
                                                      ],
                                                    ),
                                                  ),
                                                  //***************************
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      left: 20,
                                                      top: 12,
                                                      right: 40,
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text( users[index]
                                                              .ans=="NA"? "Result: Skipped" :
                                                          "Result: " +
                                                              users[index]
                                                                  .result,
                                                          style: TextStyle(
                                                              fontSize: 13.5,
                                                              color: users[index]
                                                                  .ans==""? Colors.red:
                                                                  Colors.blue),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
/*                                                  Padding(
                                                    padding:
                                                    const EdgeInsets.only(
                                                      left: 20,
                                                      top: 2,
                                                      right: 40,
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .start,
                                                      children: <Widget>[
                                                        Text(
                                                          "Explanation: "+users[index].explanation,
                                                          overflow: TextOverflow.ellipsis,
                                                          maxLines: 15,
                                                          style: TextStyle(
                                                              fontSize: 13.5,
                                                              color: Colors.black54),
                                                        ),
                                                      ],
                                                    ),
                                                  ),*/
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.8,
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 20,
                                                            top: 4,
                                                            bottom: 2),
                                                    child: Text(
                                                      "Explanation: " +
                                                          users[index]
                                                              .explanation,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 12,
                                                      style: TextStyle(
                                                          fontSize: 13.5,
                                                          color:
                                                              Colors.black54),
                                                    ),
                                                  ),
                                                  //**************************
                                                  SizedBox(
                                                    height: 8.0,
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

  apiReport(String user_id, String question_id, String my_contest_id,
      String comment) async {
    Map data = {
      "user_id": user_id,
      "question_id": question_id,
      "my_contest_id": my_contest_id,
      "comment": comment,
    };
    print("Report>>$data");
    var jsonData = null;
    var response = await http.post(uidata.contest_report, body: data,headers: {'Authorization': token});

    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      var status = jsonData['status'];
      var msg = jsonData['Message'];

      print(jsonData);
      print('status $status');
      if (status == "1") {
        Toast.show(msg, context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      } else {
        Toast.show(msg, context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
      editingController.clear();
    } else {}
  }
}

////////////////////////////////
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
  String status,
      question_no,
      mysubtest_id,
      question_id,
      question,
      option_1,
      option_2,
      option_3,
      option_4,
      correct_ans,
      ans,
      explanation,
      result;

  List<User> data;

  Album(
      {this.status,
      /* this.attempt,
      this.unattempted,
      this.right,
      this.wrong,
      this.result,
      this.marks,*/
      this.question_no,
      this.mysubtest_id,
      this.question_id,
      this.question,
      this.option_1,
      this.option_2,
      this.option_3,
      this.option_4,
      this.correct_ans,
      this.ans,
      this.result,
      this.explanation,
      this.data});

  Album.fromJson(Map<String, dynamic> json) {
    // status = json['status'];

    question_no = json['question_no'];
    mysubtest_id = json['mysubtest_id'];
    question_id = json['question_id'];
    question = json['question'];
    option_1 = json['option_1'];
    option_2 = json['option_2'];
    option_3 = json['option_3'];
    option_4 = json['option_4'];
    correct_ans = json['correct_ans'];
    ans = json['ans'];
    result = json['result'];
    explanation = json['explanation'];

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
  String status,
      question_no,
      mysubtest_id,
      question_id,
      questiontext,
      option_1,
      option_2,
      option_3,
      option_4,
      correct_ans,
      ans,
      result,
      explanation,question_img,option_1_img,option_2_img,option_3_img,option_4_img;

  User({
    this.status,
    this.question_no,
    this.mysubtest_id,
    this.question_id,
    this.questiontext,
    this.option_1,
    this.option_2,
    this.option_3,
    this.option_4,
    this.correct_ans,
    this.ans,
    this.result,
    this.explanation,
    this.question_img,
    this.option_1_img,
    this.option_2_img,
    this.option_3_img,
    this.option_4_img,
  });

  User.fromJson(Map<String, dynamic> json) {
    // status = json['status'];

    question_no = json['question_no'];
    mysubtest_id = json['mysubtest_id'];
    question_id = json['question_id'];
    questiontext = json['questiontext'];
    option_1 = json['option_1'];
    option_2 = json['option_2'];
    option_3 = json['option_3'];
    option_4 = json['option_4'];
    correct_ans = json['correct_ans'];
    ans = json['ans'];
    result = json['result'];
    explanation = json['explanation'];
    question_img=json['question_img'];
    option_1_img=json['option_1_img'];
    option_2_img=json['option_2_img'];
    option_3_img=json['option_3_img'];
    option_4_img=json['option_4_img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['question_no'] = this.question_no;
    data['mysubtest_id'] = this.mysubtest_id;

    data['question_id'] = this.question_id;
    data['questiontext'] = this.questiontext;
    data['option_1'] = this.option_1;
    data['option_2'] = this.option_2;

    data['option_3'] = this.option_3;
    data['option_4'] = this.option_4;
    data['correct_ans'] = this.correct_ans;
    data['ans'] = this.ans;

    data['result'] = this.result;
    data['explanation'] = this.explanation;

    data['question_img'] = this.question_img;
    data['option_1_img'] = this.option_1_img;
    data['option_2_img'] = this.option_2_img;
    data['option_3_img'] = this.option_3_img;
    data['option_4_img'] = this.option_4_img;
    return data;
  }
}
