import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:onlineexamcontest/Constants/MyColor.dart';
import 'package:onlineexamcontest/Constants/uidata.dart';
import 'package:onlineexamcontest/Dashboard/HomePage1.dart';
import 'package:onlineexamcontest/Dashboard/MainDashboard.dart';
import 'package:onlineexamcontest/Dashboard/TestPage.dart';
import 'package:onlineexamcontest/Dashboard/TestPageDemo.dart';
import 'package:onlineexamcontest/Dashboard/WalletPage.dart';

import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

var timeInSecForIos;

void main() => runApp(WithdrawWallet());
var amt;
String userId, reqStatus="";
SharedPreferences prefs;
String wallet1 = "", wallet2 = "",token;
String s_dt,w_r_amount,w_request_s,s_final;
class WithdrawWallet extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<WithdrawWallet> {
  TextEditingController amtController = TextEditingController();

  initializeSF() async {
    prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("uId");
    token = prefs.getString("token");
    print("aaaa $userId");
    setState(() {
      apiGetUser(userId);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
setState(() {
  initializeSF();
});

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.white,
        appBar: AppBar(
          title: Text('Withdraw Wallet'),
          backgroundColor: Colors.black,
        ),
        body: Center(
            child: Padding(
                padding: EdgeInsets.all(10),
                child: ListView(
                  children: <Widget>[
                    Container(
                        margin: const EdgeInsets.only(
                            left: 25, right: 25, top: 20, bottom: 5),
                        child: Text(
                          "Wallet Balance :" + wallet1,
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        )),
                    Container(
                        margin: const EdgeInsets.only(
                            left: 25, right: 25, top: 10, bottom: 5),
                        child: Text(
                          "Your previous withdraw request "+reqStatus+"  !!",
                          style: TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold,
                              color: reqStatus=="Not Approved"?Colors.red:reqStatus=="Approved"?Colors.green:Colors.white),
                        )),
                    Container(
                      height: 60,
                      margin: const EdgeInsets.only(left: 25, right: 25, top: 20,bottom: 20),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        // maxLength: 5,
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
                                'Withdraw',
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
                                } else if (int.parse(amtController.text) <
                                    100) {
                                  Fluttertoast.showToast(
                                      msg:
                                          "Withdraw amt should be greater than 100");
                                } else {
                                  if (int.parse(wallet1) <
                                      int.parse(amtController.text)) {
                                    Fluttertoast.showToast(
                                        msg:
                                            "Your Wallet does not have enough balance !!");
                                  } else {
                                    apiWithDrawReq(userId, amtController.text);
                                  }
                                }
                              },
                            ))),
                    Container(
                        margin: const EdgeInsets.only(
                            left: 20, right: 15, top: 10, bottom: 5),
                        child: Text(
                          s_final!=null ||s_final!=""?s_final:"",
                          style: TextStyle(
                              fontSize: 16.0,
                             // fontWeight: FontWeight.bold,
                              color:Colors.black),
                        )),
                  ],
                ))));
  }

  apiWithDrawReq(String user_id1, String amt) async {
    Map data = {"user_id": user_id1, "amount": amt};
    print(data);
    var jsonData = null;
    var response = await http.post(uidata.withdraw_request, body: data,headers: {'Authorization': token});

    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      var status = jsonData['status'];
      var Message = jsonData['Message'];
      print(jsonData);
      if (status == "1")
      {
        setState(()
        {
          Fluttertoast.showToast(msg: Message);
          Navigator.push(context, MaterialPageRoute(builder: (context) => MainDashboard(userId, true)));
        });
      } else {
        Fluttertoast.showToast(msg: Message);
      }
    } else {}
  }

  apiGetUser(String user_id1) async {
    Map data = {"user_id": user_id1};
    print("para$data");
    var jsonData = null;
    var response = await http.post(uidata.getuser, body: data,headers: {'Authorization': token});

    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      var status = jsonData['status'];

      print("Responce>>$jsonData");
      if (status == "1")
      {
        setState(() {
          wallet1 = jsonData['wallet1'].toString();
          wallet2 = jsonData['wallet2'].toString();
          reqStatus = jsonData['w_request_s'].toString();

          s_dt=jsonData['w_r_date'].toString();
          w_r_amount=jsonData['w_r_amount'].toString();
          w_request_s=jsonData['w_request_s'].toString();
          if(s_dt!=""||w_r_amount!="" ||w_request_s!="")
            {
              s_final="Note :  Your previous request on date "+s_dt+" for ammount "+w_r_amount+" is "+w_request_s;
            }
          else
            {
              s_final="";
            }


        });
      } else {}
    } else {}
  }
}
