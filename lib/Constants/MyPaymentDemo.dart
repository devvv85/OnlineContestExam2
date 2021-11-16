import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:onlineexamcontest/Constants/uidata.dart';
import 'package:onlineexamcontest/Dashboard/HomePage1.dart';
import 'package:onlineexamcontest/Dashboard/MainDashboard.dart';
import 'package:onlineexamcontest/Dashboard/TestPage.dart';
import 'package:onlineexamcontest/Dashboard/TestPageDemo.dart';
import 'package:onlineexamcontest/Dashboard/WalletPage.dart';

import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'MyColor.dart';
import 'package:http/http.dart' as http;

var timeInSecForIos;

void main() => runApp(MyApp2());
var amt;String userId,token;
SharedPreferences prefs;
class MyApp2 extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp2> {
  static const platform = const MethodChannel("razorpay_flutter");
  TextEditingController amtController = TextEditingController();
  Razorpay _razorpay;
  initializeSF() async {
    prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("uId");
    token = prefs.getString("token");
    print("aaaa $userId");

  }
  void _openCustomDialog()
  {
    showGeneralDialog(barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget)
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
                      Text("Your Payment is Done."),
                      IconButton(
                        icon: Image.asset('assets/images/check.png'),
                        onPressed: ()
                        {
                          Navigator.of(context).pop();

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

/*
  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('My Wallet'),
          backgroundColor:Colors.black,
        ),
        body: Center(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  RaisedButton(onPressed: openCheckout, child: Text('Open'))
                ])),
      ),
    );
  }
*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('My Wallet'),
          backgroundColor: Colors.black,
        ),
        body: Center(
            child: Padding(
                padding: EdgeInsets.all(10),
                child: ListView(
                  children: <Widget>[
                    Container(
                      height: 65,
                      margin:
                          const EdgeInsets.only(left: 25, right: 25, top: 20),
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
                    Container(
                        margin: const EdgeInsets.only(
                            left: 29.0, right: 29, top: 20),
                        child: Container(
                            height: 45,
                            margin: const EdgeInsets.only(
                                left: 30, right: 30, bottom: 40),
                            child: RaisedButton(
                              textColor: Colors.white,
                              color: Colors.black,
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: MyColor.white,
                                      width: 1,
                                      style: BorderStyle.solid),
                                  borderRadius: BorderRadius.circular(2)),
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
                                  openCheckout(amtController.text);
                                }
                              },
                            ))),
                  ],
                ))));
  }

  @override
  void initState() {
    super.initState();
    initializeSF();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout(var a) async {
    print("aaaa>>$a");
    amt = int.parse(a);
    var options = {
      'key': 'rzp_test_9iWipqAoQLYEnl',
      'amount': amt * 100,
      'name': 'Wallet',
      'description': 'Wallet Pay',
      'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    var payId = response.paymentId;
    Fluttertoast.showToast(msg: "SUCCESS: " + payId);

   apiTransaction(userId, payId, "Join Contest", amt.toString());
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(msg: "EXTERNAL_WALLET: " + response.walletName);
  }

  ////////////////////////////////////transaction
  apiTransaction(String user_id, String payId, String purpose, String amt,
    ) async {
    var wallet1, wallet2;
    Map data = {
      "user_id": user_id,
      "transaction_id": payId,
      "purpose": purpose,
      "amount": amt,
      "wallet": "Wallet1",
      "status": "Credit",
      "contest_id":""
    };
    print("res$data");
    var jsonData = null;
    var response = await http.post(uidata.maketransaction, body:data,headers: {'Authorization': token});

    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      var status = jsonData['status'];
      var msg = jsonData['Message'];

      print(jsonData);
      print('status $status');
      if (status == "1") {
        setState(() {
          wallet1 = jsonData['wallet1'];
          wallet2 = jsonData['wallet2'];
        });
        _razorpay.clear();

        Fluttertoast.showToast(msg: msg);
        setState(() {
          apiGetUser(userId);
          _openCustomDialog();
        });


      } else
        {
        Fluttertoast.showToast(msg: msg);
      }
    } else {}
  }
  apiGetUser(String user_id1) async {
    Map data = {"user_id": user_id1};
    print(data);
    var jsonData = null;
    var response = await http.post(uidata.getuser, body: data,headers: {'Authorization': token});

    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      var status = jsonData['status'];

      print(jsonData);
      if (status == "1") {

        setState(()
        {
          wallet1 = jsonData['wallet1'].toString();
          wallet2 = jsonData['wallet2'].toString();

        });
      } else {}
    } else {}
  }

}
