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
String userId, status;
bool isPhonepay = true, isgpay = false, isacc = false;
bool isdata = false;
String acc_hname = "",
    account_no = "",
    ifsc_code = "",
    google_pay = "",
    phone_pay = "",
    bank_name = "",
    token;

class AccountDetails extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _State();
}

class _State extends State<AccountDetails> {
  TextEditingController acc_hnamecontroller = TextEditingController();
  TextEditingController account_nocontroller = TextEditingController();
  TextEditingController bank_namecontroller = TextEditingController();

  TextEditingController ifsc_codecontroller = TextEditingController();
  TextEditingController phone_paycontroller = TextEditingController();
  TextEditingController google_paycontroller = TextEditingController();
  TextEditingController paytmcontroller = TextEditingController();

  // List<User> users = new List<User>();

  @override
  void initState() {
    setState(() {
      isPhonepay = true;
      isgpay = false;
      isacc = false;
      initializeSF();
    });

  }

  initializeSF() async {
    setState(() async {
      prefs = await SharedPreferences.getInstance();
      userId = prefs.getString("uId");
      token = prefs.getString("token");
      print("notiUserId> $userId $token");
      apiacdetails(userId);
    });

  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Account'),
        backgroundColor: MyColor.themecolor,
      ),
      body: Padding(
          padding: EdgeInsets.all(10),
          child: ListView(children: <Widget>[
            Visibility(
              visible: !isdata,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  //crossAxisAlignment: CrossAxisAlignment.stretch,

                  children: <Widget>[
                    Container(
                        margin: const EdgeInsets.only(
                            left: 20, top: 20, bottom: 10),
                        child: Text(
                          'Select any one Account for payment',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      //crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            // crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  //  color: Colors.red,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isPhonepay = true;
                                        isgpay = false;
                                        isacc = false;
                                      });
                                    },
                                    child: Container(
                                        height: 100,
                                        child: Image.asset(
                                            'assets/images/phonpay.png')),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  // color: Colors.green,
                                  margin:
                                      const EdgeInsets.only(bottom: 9, top: 9),

                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isPhonepay = false;
                                        isgpay = true;
                                        isacc = false;
                                      });
                                    },
                                    child: Container(
                                        height: 100,
                                        child: Image.asset(
                                            'assets/images/gpy.png')),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  //color: Colors.green,
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        left: 29.0, right: 29, top: 9),
                                    height: 100,
                                    child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isPhonepay = false;
                                            isgpay = false;
                                            isacc = true;
                                          });
                                        },

                                        // width: 80,
                                        child: Image.asset(
                                          'assets/images/bank.png',
                                          color: Colors.deepOrange,
                                        )),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@Account details
                    Visibility(
                      visible: isacc,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                                //  height: 45,
                                margin: const EdgeInsets.only(
                                    left: 25, right: 25, top: 25, bottom: 15),
                                child: Text(
                                  "Account Details",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                )),
                            Container(
                              height: 45,
                              margin: const EdgeInsets.only(
                                  left: 25, right: 25, bottom: 2),
                              child: TextField(
                                keyboardType: TextInputType.text,
                                controller: acc_hnamecontroller,
                                decoration: new InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 1.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1.0),
                                  ),
                                  labelStyle:
                                      new TextStyle(color: Colors.black),
                                  labelText: 'Account Holder Name *',
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                              ),
                            ),
                            Container(
                              height: 45,
                              margin: const EdgeInsets.only(
                                  left: 25, right: 25, top: 5, bottom: 2),
                              child: TextField(
                                keyboardType: TextInputType.text,
                                controller: ifsc_codecontroller,
                                decoration: new InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 1.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1.0),
                                  ),
                                  labelStyle:
                                      new TextStyle(color: Colors.black),
                                  labelText: 'IFSC Code *',
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                              ),
                            ),
                            Container(
                              height: 45,
                              margin: const EdgeInsets.only(
                                  left: 25, right: 25, top: 5, bottom: 2),
                              child: TextField(
                                keyboardType: TextInputType.number,
                                controller: account_nocontroller,
                                decoration: new InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 1.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1.0),
                                  ),
                                  labelStyle:
                                      new TextStyle(color: Colors.black),
                                  labelText: 'Account No. *',
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                              ),
                            ),
                            Container(
                              height: 45,
                              margin: const EdgeInsets.only(
                                  left: 25, right: 25, top: 5, bottom: 2),
                              child: TextField(
                                keyboardType: TextInputType.text,
                                controller: bank_namecontroller,
                                decoration: new InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 1.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1.0),
                                  ),
                                  labelStyle: new TextStyle(color: Colors.black),
                                  labelText: 'Bank Name *',
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                              ),
                            ),
                            isLoading
                                ? Container(
                              margin: const EdgeInsets.only(left: 29.0, right: 29),
                              // color: Colors.black.withOpacity(.4),
                              child: Align(
                                alignment: Alignment.center,
                                child: CircularProgressIndicator(),
                              ),
                            )
                                :Container(
                                margin: EdgeInsets.only(
                                    left: 15, right: 15, top: 10, bottom: 2),
                                //  height: 100,
                                child: Row(children: <Widget>[
/*                                  Expanded(
                                    child: Container(
                                        height: 40,
                                        margin: const EdgeInsets.only(
                                            left: 10.0, right: 10),
                                        child: RaisedButton(
                                            onPressed: () {
                                              setState(() {});
                                            },
                                            color: Colors.black,
                                            child: Text(
                                              "Edit",
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ))),
                                  ),*/
                                  Expanded(
                                    child: Container(
                                        height: 40,
                                        margin: const EdgeInsets.only(
                                            left: 10.0, right: 10),
                                        child: RaisedButton(
                                            onPressed: () {
                                              setState(() {
                                                if (acc_hnamecontroller
                                                    .text.isEmpty) {
                                                  Toast.show(
                                                      "Account holder name should not empty",
                                                      context,
                                                      duration:
                                                          Toast.LENGTH_LONG,
                                                      gravity: Toast.BOTTOM);
                                                } else if (ifsc_codecontroller
                                                    .text.isEmpty) {
                                                  Toast.show(
                                                      "IFSC code should not empty",
                                                      context,
                                                      duration:
                                                          Toast.LENGTH_LONG,
                                                      gravity: Toast.BOTTOM);
                                                }
                                                else if (ifsc_codecontroller.text.length < 11) {
                                                  Toast.show(
                                                      "IFSC code should be 11 digit",
                                                      context,
                                                      duration:
                                                      Toast.LENGTH_LONG,
                                                      gravity: Toast.BOTTOM);
                                                } else if (account_nocontroller
                                                    .text.isEmpty) {
                                                  Toast.show(
                                                      "Account  number should not empty",
                                                      context,
                                                      duration:
                                                          Toast.LENGTH_LONG,
                                                      gravity: Toast.BOTTOM);
                                                } else {
                                                  setState(() {
                                                    isLoading = true;
                                                  });
                                                  acc_hname =
                                                      acc_hnamecontroller.text;
                                                  account_no =
                                                      account_nocontroller.text;
                                                  ifsc_code =
                                                      ifsc_codecontroller.text;
                                                  bank_name=bank_namecontroller.text;
                                                  //apiSubmitAccountDet(userId, acc_hname,account_no,ifsc_code,google_pay,phone_pay,bank_name, "");
                                                  apiSubmitAccountDet(
                                                      userId,
                                                      acc_hname,
                                                      account_no,
                                                      ifsc_code,
                                                      "",
                                                      "",
                                                      bank_name,
                                                      "");

                                                  acc_hnamecontroller.clear();
                                                  account_nocontroller.clear();
                                                  ifsc_codecontroller.clear();
                                                  bank_namecontroller.clear();

                                                }
                                              });
                                            },
                                            color: MyColor.yellow,
                                            child: Text(
                                              "Save",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ))),
                                  )
                                ]))
                          ]),
                    ),

                    //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@Phone Pay**************************************************************

                    Visibility(
                      visible: isPhonepay,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                                //  height: 45,
                                margin: const EdgeInsets.only(
                                    left: 25, right: 25, top: 25, bottom: 15),
                                child: Text(
                                  "PhonePe Details",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                )),
                            Container(
                              height: 45,
                              margin: const EdgeInsets.only(
                                  left: 25, right: 25, top: 5, bottom: 2),
                              child: TextField(
                                keyboardType: TextInputType.number,
                                controller: phone_paycontroller,
                                decoration: new InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 1.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1.0),
                                  ),
                                  labelStyle:
                                      new TextStyle(color: Colors.black),
                                  labelText: 'PhonePe Mobile No.*',
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                              ),
                            ),

                            isLoading
                                ? Container(
                              margin: const EdgeInsets.only(left: 29.0, right: 29),
                              child: Align(
                                alignment: Alignment.center,
                                child: CircularProgressIndicator(),
                              ),
                            )
                                :
                            Container(margin: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 2),
                                child: Row(children: <Widget>[
/*                                  Expanded(
                                    child: Container(
                                        margin: const EdgeInsets.only(
                                            left: 10.0, right: 10),
                                        child: RaisedButton(
                                            onPressed: () {
                                              setState(() {});
                                            },
                                            color: Colors.black,
                                            child: Text(
                                              "Edit",
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ))),
                                  ),*/
                                  Expanded(
                                    child: Container(
                                        height: 40,
                                        margin: const EdgeInsets.only(
                                            left: 10.0, right: 10),
                                        child: RaisedButton(
                                            onPressed: () {
                                              setState(() {
                                                if (phone_paycontroller
                                                    .text.isEmpty) {
                                                  Toast.show(
                                                      "PhonePe no. should not empty",
                                                      context,
                                                      duration:
                                                          Toast.LENGTH_LONG,
                                                      gravity: Toast.BOTTOM);
                                                } else if (phone_paycontroller
                                                        .text.length <
                                                    10) {
                                                  Toast.show(
                                                      "Mobile no should be 10 digit",
                                                      context,
                                                      duration:
                                                          Toast.LENGTH_LONG,
                                                      gravity: Toast.BOTTOM);
                                                } else {
                                                  setState(() {
                                                    isLoading = true;
                                                  });
                                                  phone_pay =
                                                      phone_paycontroller.text;
                                                  apigooglepay(
                                                      userId,
                                                      phone_pay,
                                                      google_pay,
                                                      "");
                                                  phone_paycontroller.clear();
                                                }
                                              });
                                            },
                                            color: MyColor.yellow,
                                            child: Text(
                                              "Save",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ))),
                                  )
                                ])),
                          ]),
                    ),

                    //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  Google  Pay**************************************************************

                    Visibility(
                      visible: isgpay,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                                //  height: 45,
                                margin: const EdgeInsets.only(
                                    left: 25, right: 25, top: 25, bottom: 15),
                                child: Text(
                                  "Google Pay Details",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                )),
                            Container(
                              height: 45,
                              margin: const EdgeInsets.only(
                                  left: 25, right: 25, top: 5, bottom: 2),
                              child: TextField(
                                keyboardType: TextInputType.number,
                                controller: google_paycontroller,
                                decoration: new InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 1.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 1.0),
                                  ),
                                  labelStyle:
                                      new TextStyle(color: Colors.black),
                                  labelText: 'Google Pay Mobile No.*',
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                              ),
                            ),
                            Container(
                                margin: EdgeInsets.only(
                                    left: 15, right: 15, top: 10, bottom: 2),
                                //  height: 100,
                                child: Row(children: <Widget>[
                                  Expanded(
                                    child: Container(
                                        height: 40,
                                        margin: const EdgeInsets.only(
                                            left: 10.0, right: 10),
                                        child: RaisedButton(
                                            onPressed: () {
                                              setState(() {
                                                if (google_paycontroller
                                                    .text.isEmpty) {
                                                  Toast.show(
                                                      "Google pay no. should not empty",
                                                      context,
                                                      duration:
                                                          Toast.LENGTH_LONG,
                                                      gravity: Toast.BOTTOM);
                                                } else if (google_paycontroller
                                                        .text.length <
                                                    10) {
                                                  Toast.show(
                                                      "Mobile no should be 10 digit",
                                                      context,
                                                      duration:
                                                          Toast.LENGTH_LONG,
                                                      gravity: Toast.BOTTOM);
                                                } else {
                                                  setState(() {
                                                    isLoading = true;
                                                  });
                                                  google_pay =
                                                      google_paycontroller.text;

                                                  apigooglepay(userId,phone_pay,google_pay, "");
                                                  google_paycontroller.clear();
                                                }
                                              });
                                            },
                                            color: MyColor.yellow,
                                            child: Text(
                                              "Save",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ))),
                                  )
                                ])),
                          ]),
                    ),
                  ]),
            ),
            Visibility(
                visible: isdata,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              flex: 5,
                              child: Container(
                                  margin: const EdgeInsets.only(bottom: 20),
                                  child: Text(
                                    "Account Details",
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  )),
                            ),
                          ]),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              flex: 5,
                              child: Container(
                                  margin: const EdgeInsets.only(bottom: 5),
                                  child: Text(
                                    "Account Holder name : ",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  )),
                            ),
                            Expanded(
                              flex: 5,
                              child: Container(
                                  child: Text(acc_hname!=null?acc_hname:"",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ))),
                            ),
                          ]),
                      Row(mainAxisAlignment: MainAxisAlignment.start,
                          //crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                  margin: const EdgeInsets.only(bottom: 5),
                                  child: Text('Account No : ',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ))),
                            ),
                            Expanded(
                              child: Container(
                                  child: Text(account_no!=null?account_no:"",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ))),
                            ),
                          ]),
                      Row(mainAxisAlignment: MainAxisAlignment.start,
                          //crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Expanded(
                                child: Container(
                                    margin: const EdgeInsets.only(bottom: 5),
                                    child: Text('IFSC Code : ',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                        )))),
                            Expanded(
                                child: Container(
                                    child: Text(ifsc_code!=null ?ifsc_code:"",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black)))),
                          ]),
                      Row(mainAxisAlignment: MainAxisAlignment.start,
                          //crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Expanded(
                                child: Container(
                                    margin: const EdgeInsets.only(bottom: 5),
                                    child: Text('Google pay No. : ',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                        )))),
                            Expanded(
                                child: Container(
                                    child: Text(google_pay!=null? google_pay:"",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                        )))),
                          ]),
                      Row(mainAxisAlignment: MainAxisAlignment.start,
                          //crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Expanded(
                                child: Container(
                                    margin: const EdgeInsets.only(bottom: 5),
                                    child: Text('PhonePe  number : ',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                        )))),
                            Expanded(
                                child: Container(
                                    child: Text(phone_pay!=null?phone_pay:"",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                        )))),
                          ]),
/*                      Row(mainAxisAlignment: MainAxisAlignment.start,
                          //crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Expanded(
                                child: Container(
                                    child: Text('Bank name : ',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                        )))),
                            Expanded(
                                child: Container(
                                    child: Text(bank_name,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                        )))),
                          ]),*/
                      Container(
                          height: 40,
                          margin: const EdgeInsets.only(
                              left: 10.0, right: 10, top: 30),
                          child: RaisedButton(
                              onPressed: () {
                                setState(() {
                                  isdata = false;
                                });
                              },
                              color: MyColor.yellow,
                              child: Text(
                                "Edit",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ))),
                    ])),

/*            Visibility(
                visible: isdata,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[

                      Container(child: Text("Account Holder name :"+acc_hname)),
                      Container(child: Text('Account No :         '+account_no)),
                      Container(child: Text('IFSC Code :          '+ifsc_code)),
                      Container(child: Text('Google pay No. :     '+google_pay)),
                      Container(child: Text('Phone pay No. :      '+phone_pay)),
                      Container(child: Text('Bank name :           '+bank_name)),
                    ])),*/
          ])),
    );
  }

  apiSubmitAccountDet(String user_id, String acc_hname, String account_no,
      String ifsc_code, google_pay, phone_pay, bank_name, paytm) async {
      Map data = {
      "user_id": user_id,
      "acc_hname": acc_hname,
      "account_no": account_no,
      "bank_name": bank_name,
      "ifsc_code": ifsc_code,
      "phone_pay": phone_pay,
      "google_pay": google_pay,
      "paytm": paytm,
    };
    print("input>>$data");
    var jsonData = null;
    var response = await http.post(uidata.account_details,
        body: data, headers: {'Authorization': token});

    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      var status = jsonData['status'];
      var msg = jsonData['Message'];
      print(jsonData);
      print('status $status');
      if (status == "1") {
        setState(()
        {
          isLoading = false;
        });
        setState(() {
          isLoading = false;
          apiacdetails(userId);
        });
        Toast.show(msg, context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      } else {
        setState(() {
          isLoading = false;
        });
        Toast.show(msg, context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    } else {}
  }

//@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  apigooglepay(String user_id, phone_pay, google_pay, paytm) async
  {
    Map data =
    {
      "user_id": user_id,
      "phone_pay": phone_pay,
      "google_pay": google_pay,
      "paytm": paytm,
    };
    print("input>>$data");
    var jsonData = null;
    var response = await http.post(uidata.update_phone_googlepay,
        body: data, headers: {'Authorization': token});

    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      var status = jsonData['status'];
      var msg = jsonData['Message'];
      print(jsonData);
      print('status $status');
      if (status == "1") {
        setState(()
        {
          isLoading = false;
        });
        setState(() {
          isLoading = false;
          apiacdetails(userId);
        });
        Toast.show(msg, context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      } else {
        setState(() {
          isLoading = false;
        });
        Toast.show(msg, context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    } else {}
  }

  apiacdetails(String user_id) async {
    Map data = {
      "user_id": user_id,
    };
    print("input$data$token");
    var jsonData = null;
    var response = await http.post(uidata.get_account_details,
        body: data, headers: {'Authorization': token});

    if (response.statusCode == 200)
    {
      jsonData = json.decode(response.body);
      var status = jsonData['status'];

      print("Res>>$jsonData");
      print('status $status');
      if (status == "1")
      {
        setState(() {
          isdata = true;

          acc_hname = jsonData['acc_hname'];
          account_no = jsonData['account_no'];
          bank_name = jsonData['bank_name'];
          ifsc_code = jsonData['ifsc_code'];
          phone_pay = jsonData['phone_pay'];
          google_pay = jsonData['google_pay'];
          if(acc_hname!=null)
            {
              acc_hname="";
            }
          else if(account_no!=null)
          {
            account_no="";
          }
        });
      } else {
        setState(()
        {
          isdata = false;
          acc_hname = "";
          account_no = "";
          ifsc_code = "";
          google_pay = "";
          phone_pay = "";
          bank_name = "";
        });

      }
    } else {
      print("Exception");

    }
  }
}
