import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:onlineexamcontest/Constants/MyColor.dart';
import 'package:onlineexamcontest/Constants/Payment_Gateway.dart';
import 'package:onlineexamcontest/Constants/uidata.dart';
import 'package:onlineexamcontest/payment/mypayment.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../Constants/MyPaymentDemo.dart';
import 'package:http/http.dart' as http;

import 'DeclareResultPage.dart';
import 'MainDashboard.dart';
import 'WithdrawWallet.dart';

SharedPreferences prefs;
Razorpay _razorpay;
TextEditingController _textFieldcontactController = TextEditingController();
String wallet1, wallet2, userId,token;
bool isLoad = false;
var amt;
bool load = false;

class WalletPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _State();

  WalletPage(wallet11, wallet22) {
    wallet1 = wallet11;
    wallet2 = wallet22;
  }
}

class _State extends State<WalletPage> {
  TextEditingController amtController = TextEditingController();

  initializeSF() async {
    setState(() async {

      prefs = await SharedPreferences.getInstance();
      userId = prefs.getString("uId");
      token = prefs.getString("token");
      print("aaaa $token");
      load = true;
      apiGetUser(userId);
    });

  }

  addIsLoginTrueToSF() async {
    prefs = await SharedPreferences.getInstance();
    prefs.setBool('start', true);
  }

  apichkStatus(String userId) async {
    Map data = {"user_id": userId};
    print("para$data");
    var jsonData = null;
    var response = await http.post(uidata.getuser, body: data,headers: {'Authorization': token});

    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      var status = jsonData['status'];

      print(jsonData);
      if (status == "1") {
        setState(() {
          var chkStatus = jsonData['wallet1'].toString();
          if (chkStatus == "1") {
            Navigator.push(context, MaterialPageRoute(builder: (context) => WithdrawWallet()));
          } else {
            Fluttertoast.showToast(
                msg: "please submit account details for withdraw!!");
          }
        });
      } else {}
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    final loginTitle = Container(
      margin: const EdgeInsets.only(left: 29.0, right: 29, top: 10),
      child: Center(
          child: Container(
        height: 45,
        margin: const EdgeInsets.only(left: 30, right: 30, top: 20),
        child: Text(
          'Wallet',
          style: TextStyle(
            fontSize: 26,
            color: MyColor.blackgradient,
            fontWeight: FontWeight.bold,
          ),
        ),
      )),
    );

    //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

    final walletnew =/* Container(
        margin: const EdgeInsets.only(top: 10),
        //  padding: EdgeInsets.only(left: 30, right: 30, top: 2, bottom: 2),
        //  height: 100,
        child:*/
    Row(children: <Widget>[
     Expanded(
       flex:5,child:InkWell(
        onTap: () {
          setState(() {
            /*   Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentGateway()));*/
            // Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp2()));
            Navigator.push(context, MaterialPageRoute(builder: (context) => MyPay()));
            // dialogUpdateContact(context);
          });
        },

          child: Container(
            margin: const EdgeInsets.only(
              left: 28,
              right: 15,
            ),
            width: 150,
            height: 50,
            child: Image.asset('assets/images/deposit.png'),
          ),
        ),
      ),
      Expanded(flex:5,child:InkWell(
        onTap: () {
          setState(() {
            //  apichkStatus(userId);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => WithdrawWallet()));
          });
        },

          child: Container(
            margin: const EdgeInsets.only(
              //left: 5,
              // right: 28,
            ),
            width: 150,
            height: 50,
            child: Image.asset('assets/images/withdraw.png'),
          ),
        ),
      ),
    ]
      //)
    );



    //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    final logo = Container(

        margin: const EdgeInsets.only(top: 50),
        height: 75,
        child: Image.asset('assets/images/wallet.png'));

    final wallet =/* Container(
        margin: const EdgeInsets.only(top: 10),
        //  padding: EdgeInsets.only(left: 30, right: 30, top: 2, bottom: 2),
        //  height: 100,
        child:*/ Row(children: <Widget>[
          InkWell(
            onTap: () {
              setState(() {
                /*   Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentGateway()));*/
               // Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp2()));
                Navigator.push(context, MaterialPageRoute(builder: (context) => MyPay()));
                // dialogUpdateContact(context);
              });
            },
            child: Expanded(
              child: Container(
                margin: const EdgeInsets.only(
                  left: 28,
                  right: 15,
                ),
                width: 150,
                height: 50,
                child: Image.asset('assets/images/deposit.png'),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              setState(() {
                //  apichkStatus(userId);
                Navigator.push(context, MaterialPageRoute(builder: (context) => WithdrawWallet()));
              });
            },
            child: Expanded(
              child: Container(
                margin: const EdgeInsets.only(
                    //left: 5,
                    // right: 28,
                    ),
                width: 150,
                height: 50,
                child: Image.asset('assets/images/withdraw.png'),
              ),
            ),
          ),
        ]
    //)
    );

    final div = Container(
      margin: const EdgeInsets.only(left: 5, top: 25, right: 5),
      color: Colors.black,
      height: 4,
    );
    final div1 = Container(
      margin: const EdgeInsets.only(left: 5, top: 5, right: 5),
      color: Colors.black,
      height: 1,
    );
    final amt1 = InkWell(
      onTap: () {},
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(10.0),
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Text('Amount Added ',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 5,
                            style: new TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            )),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Text('₹ ' + wallet1,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 5,
                            style: new TextStyle(
                              fontSize: 15.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
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
                /* SizedBox(
                width: 30,
                ),*/
                IconButton(
                  icon: Image.asset(
                    'assets/images/info.png',
                    height: 20,
                    width: 20,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
    final amt2 = InkWell(
      onTap: () {},
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(10.0),
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Text('Bonus',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 5,
                            style: new TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            )),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Text('₹ ' + wallet2,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 5,
                            style: new TextStyle(
                              fontSize: 15.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
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
                /* SizedBox(
                width: 30,
                ),*/
                IconButton(
                  icon: Image.asset(
                    'assets/images/info.png',
                    height: 20,
                    width: 20,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );

    final walletdemo = Container(
        padding: EdgeInsets.only(left: 30, right: 30, top: 2, bottom: 2),
        //  height: 100,
        child: Row(children: <Widget>[
          Expanded(
              child: RaisedButton(
                  onPressed: () {
                    setState(() {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => MyApp2()));
                    });
                  },
                  color: Colors.black,
                  child: Text(
                    "Paid",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ))),
          Expanded(
              child: RaisedButton(
                  onPressed: () {
                    setState(() {});
                  },
                  color: Colors.white,
                  child: Text(
                    "Free",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ))),
        ]));
    return new WillPopScope(
        onWillPop: ()
    {

      Navigator.push(context, MaterialPageRoute(builder: (context) => MainDashboard(userId,true)));
      return Future.value(true);
    },
    child: Container(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: ListView(
          children: <Widget>[
            load == true
                ? Container(
                    margin: const EdgeInsets.only(left: 29.0, right: 29),
                  //  color: Colors.white.withOpacity(.4),
                    child: Align(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(),
                    ),
                  )
                : logo,
            loginTitle,

           walletnew,


           // wallet,
            div,
            amt1,
            div1,
            amt2,
            div1,
          ],
        ),
      ),),
    );
  }

  apiGetUser(String user_id1) async {
    Map data = {"user_id": user_id1};
    print("tokennnn>>> $token");
    print(data);
    var jsonData = null;
    var response = await http.post(uidata.getuser, body: data,headers: {'Authorization': token});

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
        });
      } else {}
    } else {}
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      initializeSF();
    });

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

        Fluttertoast.showToast(msg: msg);
        /* setState(() {
          initializeSF();
        });*/

        //  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => WalletPage(wallet1, wallet2)));
      } else {
        Fluttertoast.showToast(msg: msg);
      }
    } else {}
  }
}

///api call phone_no:admin
