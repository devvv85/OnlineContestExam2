import 'dart:convert';
import 'dart:typed_data';

import 'package:cashfree_pg/cashfree_pg.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:onlineexamcontest/Constants/MyColor.dart';
import 'package:onlineexamcontest/Constants/uidata.dart';
import 'package:onlineexamcontest/Dashboard/MainDashboard.dart';
import 'package:onlineexamcontest/Dashboard/WalletPage.dart';
import 'package:onlineexamcontest/payment/paymentdone.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../splash_page.dart';

String orderid, cftoken, msg = "", payId = "";
String AppID, Appsecret, userId;
var amt;
String wallet1, wallet2, token;
SharedPreferences prefs;
bool isLoading = false;

class MyPay extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyPay> {
  Uint8List _imageBytesDecoded;
  List<dynamic> appList;
  Map<dynamic, dynamic> app;
  TextEditingController amtController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      initializeSF();
      // AppID = "15573ed4f357aed651f98ba3737551";
      AppID = "50668ee21cc3987b57feb422286605";
    });
  }

  initializeSF() async {
    prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("uId");
    token = prefs.getString("token");
    print("tokenpayment $token");
  }

  void _openCustomDialog() {
    showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                  shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0)),
                  title: Text('Thank You!!'),
                  content: Row(children: <Widget>[
                    Text("Your Payment is Done."),
                    IconButton(
                      icon: Image.asset('assets/images/check.png'),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    MainDashboard(userId, true)));
                      },
                    ),
                  ])),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {});
  }

/*
  void _openCustomDialog2()
  {
    showGeneralDialog(barrierColor: Colors.black.withOpacity(0.5), transitionBuilder: (context, a1, a2, widget)
    {return Transform.scale(
      scale: a1.value,
      child: Opacity(
        opacity: a1.value,
        child: AlertDialog(
            shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0)),
            title: Text('Thank You!!'),
            content: Row(
                children: <Widget>[
                  Text("Your Payment is Fail."),
                  IconButton(
                    icon: Image.asset('assets/images/check.png'),
                    onPressed: ()
                    {
                      // Navigator.of(context).pop();
                      Navigator.push(context, MaterialPageRoute(builder: (context) => MainDashboard(userId,false)));

                    },
                  ),
                ]
            )
        ),
      ),
    );
    },
        transitionDuration: Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {});
  }
*/

  apiGetWallet(String user_id1) async {
    Map data = {"user_id": user_id1};
    print("tokennnn>>> $token");
    print(data);
    var jsonData = null;
    var response = await http
        .post(uidata.getuser, body: data, headers: {'Authorization': token});

    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      var status = jsonData['status'];
      load = false;
      print(jsonData);
      if (status == "1") {
        setState(() {
          wallet1 = jsonData['wallet1'].toString();
          wallet2 = jsonData['wallet2'].toString();
          //  Fluttertoast.showToast(msg: wallet1);
          // addIsLoginTrueToSF();

          WalletPage(wallet1, wallet2);
        });
      } else {}
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MainDashboard(userId, true)));
          return Future.value(true);
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text('My Wallet'),
              backgroundColor: MyColor.themecolor,
            ),
            body: Center(
                child: Padding(
                    padding: EdgeInsets.all(10),
                    child: ListView(
                      children: <Widget>[
                        Container(
                          height: 65,
                          margin: const EdgeInsets.only(
                              left: 25, right: 25, top: 20),
                          child: TextField(
                            keyboardType: TextInputType.number,
                            maxLength: 5,
                            controller: amtController,
                            decoration: new InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.black, width: 2.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.black, width: 1.0),
                              ),
                              labelStyle: new TextStyle(color: Colors.black),
                              labelText: 'Amount *',
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                        ),
                        isLoading
                            ? Container(
                                margin: const EdgeInsets.only(
                                    left: 29.0, right: 29),
                                // color: Colors.black.withOpacity(.4),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : Container(
                                margin: const EdgeInsets.only(
                                    left: 29.0, right: 29, top: 20),
                                child: Container(
                                    height: 45,
                                    margin: const EdgeInsets.only(
                                        left: 30, right: 30, bottom: 40),
                                    child: RaisedButton(
                                      textColor: Colors.white,
                                      color: MyColor.themecolor,
                                      shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              color: MyColor.white,
                                              width: 1,
                                              style: BorderStyle.solid),
                                          borderRadius:
                                              BorderRadius.circular(2)),
                                      child: Text(
                                        'Pay',
                                        style: TextStyle(
                                          fontSize: 19,
                                          color: Colors.white,
                                        ),
                                      ),
                                      onPressed: () {
                                        if (amtController.text.isEmpty) {
                                          Fluttertoast.showToast(
                                              msg:
                                                  "Please enter amount to add in wallet");
                                        } else {
                                          setState(() {
                                            setState(() {
                                              isLoading = true;
                                            });
                                            apigetData(
                                                amtController.text.toString());
                                          });
                                        }
                                      },
                                    ))),
                      ],
                    )))));
  }

  // WEB Intent
  makePayment(String amt) {
    String orderId = orderid;
    String stage = "PROD";
    String orderAmount = amt.toString();
    String tokenData = cftoken;
    String customerName = "";
    String orderNote = "Order_Note";
    String orderCurrency = "INR";
    String appId = AppID;
    String customerPhone = "9999999999";
    String customerEmail = "sample@gmail.com";
    // String notifyUrl = "https://test.gocashfree.com/notify";
    String notifyUrl = "https://api.cashfree.com/api/v2/cftoken/order";

    Map<String, dynamic> inputParams = {
      "orderId": orderId,
      "orderAmount": orderAmount,
      "customerName": customerName,
      "orderNote": orderNote,
      "orderCurrency": orderCurrency,
      "appId": appId,
      "customerPhone": customerPhone,
      "customerEmail": customerEmail,
      "stage": stage,
      "tokenData": tokenData,
      "notifyUrl": notifyUrl
    };
    print("input>>$inputParams");
    CashfreePGSDK.doPayment(inputParams)
        .then((value) => value?.forEach((key, value) {
              print("$key : $value");
              if (key == "txStatus") {
                msg = value;
                if (key == "referenceId") {
                  payId = value;
                }
                if (msg == "SUCCESS") {
                  print("Transaction>>>>>$msg");
                  apiTransaction(
                      userId, payId, "Wallet", amtController.text.toString());
                } else {
                  Fluttertoast.showToast(msg: "Payment Failed");
                  print("transactionf>>$msg");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              paymentDone("Payment Failed !!", "false")));
                  // _openCustomDialog2();
                }
              }
            }));
  }

  apigetData(String amt) async
  {
    Map data = {"amount": amt};
    print(data);
    var jsonData = null;
    var response = await http.post(uidata.get_payment_token,
        body: data, headers: {'Authorization': token});

    if(response.statusCode == 200)
    {
      jsonData = json.decode(response.body);
      var status = jsonData['status'];
      print("Prof>>>$jsonData");
      if (status == "1")
      {
        setState(()
        {
          orderid = jsonData['orderId'].toString();
          cftoken = jsonData['cftoken'].toString();
          makePayment(amtController.text.toString());
          print("payment>>>>>>>>>$orderid $cftoken");
          setState(()
          {
            isLoading = false;
          });
        });
      }
      else {
        setState(()
        {
          isLoading = false;
        });
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  ////////////////////////////////////transaction
  apiTransaction(
    String user_id,
    String payId,
    String purpose,
    String amt,
  ) async {
    var wallet1, wallet2;
    Map data = {
      "user_id": user_id,
      "transaction_id": payId,
      "purpose": purpose,
      "amount": amt,
      "wallet": "Wallet1",
      "status": "Credit",
      "contest_id": ""
    };
    print("res$data");
    var jsonData = null;
    var response = await http.post(uidata.maketransaction,
        body: data, headers: {'Authorization': token});

    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      var status = jsonData['status'];
      var msg = jsonData['Message'];
      print(jsonData);
      print('status $status');
      if (status == "1") {
        /* setState(()
        {
          wallet1 = jsonData['wallet1'];
          wallet2 = jsonData['wallet2'];
        });*/
        Fluttertoast.showToast(msg: msg);
        setState(() {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      paymentDone("Payment Success !!", "true")));
        });
      } else {
        Fluttertoast.showToast(msg: msg);
      }
    } else {}
  }

  apiGetUser(String user_id1) async {
    Map data = {"user_id": user_id1};
    print(data);
    var jsonData = null;
    var response = await http
        .post(uidata.getuser, body: data, headers: {'Authorization': token});

    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      var status = jsonData['status'];
      print(jsonData);
      if (status == "1") {
        setState(() {
          wallet1 = jsonData['wallet1'].toString();
          wallet2 = jsonData['wallet2'].toString();
          // Fluttertoast.showToast(msg: wallet1);
          // Navigator.push(context, MaterialPageRoute(builder: (context) => WalletPage(wallet1, wallet2)));
          // addIsLoginTrueToSF();
        });
      } else {}
    } else {}
  }
}
