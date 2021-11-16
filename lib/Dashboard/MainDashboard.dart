import 'dart:convert';
import 'dart:io';

import 'package:badges/badges.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:http/http.dart' as http;
import 'package:launch_review/launch_review.dart';
import 'package:onlineexamcontest/ChallangeFriend/ChallangeDashboard.dart';
import 'package:onlineexamcontest/Constants/MyColor.dart';
import 'package:onlineexamcontest/Constants/uidata.dart';
import 'package:onlineexamcontest/Dashboard/DeclareResultPage.dart';

import 'package:onlineexamcontest/Dashboard/NotiPage.dart';

import 'package:onlineexamcontest/Dashboard/ResultPage.dart';
import 'package:onlineexamcontest/Dashboard/TestPage.dart';
import 'package:onlineexamcontest/Dashboard/WalletPage.dart';

import 'package:onlineexamcontest/Dashboard/progressDemo.dart';
import 'package:onlineexamcontest/DrawerScreen/ChangePassword.dart';
import 'package:onlineexamcontest/DrawerScreen/MyProfile.dart';
import 'package:onlineexamcontest/DrawerScreen/ResultContest.dart';
import 'package:onlineexamcontest/DrawerScreen/TermsCondition.dart';
import 'package:onlineexamcontest/DrawerScreen/TransactionPage.dart';
import 'package:onlineexamcontest/DrawerScreen/TransactionPage1.dart';
import 'package:onlineexamcontest/DrawerScreen/TransactionPage2.dart';
import 'package:onlineexamcontest/DrawerScreen/VerifyoldPassword.dart';
import 'package:onlineexamcontest/DrawerScreen/WithdrawAccdetails.dart';
import 'package:onlineexamcontest/Login/StartScreen.dart';
import 'package:onlineexamcontest/Login/login5.dart';
import 'package:onlineexamcontest/My%20Contest/MyContest.dart';
import 'package:onlineexamcontest/main.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';
import '../app_termsandconditions.dart';
import 'HomePage1.dart';
import 'TestPageDemo.dart';

//payment live credentials
//app id-
//50668ee21cc3987b57feb422286605
//Secret key
//663ad9f03e42e64a7f4bd9a61970579c6f27bd3f

const APP_STORE_URL =
    'https://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftwareUpdate?id=YOUR-APP-ID&mt=8';
const PLAY_STORE_URL =
    'https://play.google.com/store/apps/details?id=YOUR-APP-ID';
String PLAY_STORE_APP_ID="https://play.google.com/store/apps/details?id=online.exam.onlineexamcontest";

String notificationCount="0";
GlobalKey<ScaffoldState> _scaffoldKey;
var name = "", email = "", location = "", skill = "", mob = "", userId, token;
var profile_photo = "";
bool _isLoggedIn = false;
SharedPreferences prefs;
var tcVisibility = false;
var is_updated = "";
GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
var _message;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
bool start;
String advertise_photo = "";
var a = 0;

double newVersion;
GlobalKey<NavigatorState> navigatorKey = null;

class MainDashboard extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();

  MainDashboard(String uid, bool start1) {
    userId = uid;
    print('DashBoard>>> $userId');
    start = start1;
  }

}

class _MyHomePageState extends State<MainDashboard>
{
  TextEditingController locationController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController skillController = TextEditingController();

  //***********************************************Notification*************************************************************************/
/*
  void firebaseCloudMessaging_Listeners() {
    print("bgghnghtghhgjyjn");
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
    //  if (Platform.isIOS) iOS_Permission();

    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async
        {
      print('on message $message');
      showNotification(message['notification']['title'], message['notification']['body']);
      setState(() => _message = message["notification"]["title"]);
      fcmMessageHandler(msg, navigatorKey, context);
    },

        onResume: (Map<String, dynamic> message) async {
      print('on resume $message');
      setState(() => _message = message["notification"]["title"]);
      showNotification(message['notification']['title'], message['notification']['body']);
    },
        onLaunch: (Map<String, dynamic> message) async
        {
      print('on launch $message');
      setState(() => _message = message["notification"]["title"]);
      showNotification(message['notification']['title'], message['notification']['body']);
    });
  }
*/
  void firebaseCloudMessaging_Listeners()
  {
    print("bgghnghtghhgjyjn");
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
    //  if (Platform.isIOS) iOS_Permission();

    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
      print('on message $message');
      showNotification(
          message['notification']['title'], message['notification']['body']);
      setState(() => _message = message["notification"]["title"]);
      fcmMessageHandler(message, navigatorKey, context);
    }, onResume: (Map<String, dynamic> message) async {
      print('on resume $message');
      setState(() => _message = message["notification"]["title"]);
      showNotification(
          message['notification']['title'], message['notification']['body']);
      fcmMessageHandler(message, navigatorKey, context);
    }, onLaunch: (Map<String, dynamic> message) async {
      print('on launch $message');
      setState(() => _message = message["notification"]["title"]);
      showNotification(
          message['notification']['title'], message['notification']['body']);
      fcmMessageHandler(message, navigatorKey, context);


    });
  }

  void fcmMessageHandler(msg, navigatorKey, context) {
    print("on message 1$msg['data']['screen']");
    switch (msg['data']['screen']) {
      case "transaction":
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => TransactionPage2()));
        break;
      case "my_contest":
        Navigator.push(context, MaterialPageRoute(builder: (context) => MyContest("noti")));
        break;
      case "result":
        Navigator.push(context, MaterialPageRoute(builder: (context) => DeclareResultPage("noti")));
        break;
      default:
        Navigator.push(context, MaterialPageRoute(builder: (context) => NotiPage("noti")),
        );
      /*  Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MainDashboard(userId, true)));*/
        break;
    }
  }

  /*Future onSelectNotification(String payload) async {}*/
  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }

    // here set and put condition for property id
    var response = json.decode(payload) as Map;

    print("Notification Response>>$response");

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NotiPage("noti")),
    );
  }

  void showNotification(String title, String body) async {
    await _demoNotification(title, body);
  }

  Future<void> _demoNotification(String title, String body) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'channel_ID', 'channel name', 'channel description',
        importance: Importance.max,
        playSound: true,
        showProgress: true,
        priority: Priority.high,
       // ticker: 'test ticker'

    );

    var iOSChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSChannelSpecifics);
    await flutterLocalNotificationsPlugin
        .show(0, title, body, platformChannelSpecifics, payload: 'test');
  }

  void iOS_Permission()
  {
    _firebaseMessaging.requestNotificationPermissions(IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered.listen((IosNotificationSettings settings)
    {
      print("Settings registered: $settings");
    });
  }

  //*******************************************************************************************************************************************************************
  @override
  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () {
                  exit(0);
                },
                /* Navigator.of(context).pop(true);
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => StartscreeenPage()), (route) => false);},*/

                //exit(0),
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  int _selectedIndex = 0;
  var appBarTitleText = new Text(
    "Home",
    style: TextStyle(
        fontSize: 18, fontWeight: FontWeight.bold, color: MyColor.white),
  );

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  final List<Widget> _widgetOptions = <Widget>[

    HomePage1(userId),
    TestPage(),
    MyContest(""),
    DeclareResultPage(""),
    WalletPage("", ""),
  ];

  void _onItemTapped(int index)
  {
    setState(() {
      _selectedIndex = index;
      print(_selectedIndex);
      if (_selectedIndex == 0) {
        if (_scaffoldKey.currentState.isDrawerOpen)
        {
          Navigator.of(context).pop();
        }
        appBarTitleText = Text('Home',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: MyColor.white,
            ));
      } else if (_selectedIndex == 1) {
        if (_scaffoldKey.currentState.isDrawerOpen) {
          Navigator.of(context).pop();
        }
        appBarTitleText = Text(
          'Test',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: MyColor.white),
        );
      } else if (_selectedIndex == 2) {
        if (_scaffoldKey.currentState.isDrawerOpen) {
          Navigator.of(context).pop();
        }
        appBarTitleText = Text(
          'My Contest',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: MyColor.white),
        );
      } else if (_selectedIndex == 3) {
        if (_scaffoldKey.currentState.isDrawerOpen) {
          Navigator.of(context).pop();
        }
        appBarTitleText = Text(
          'Result',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: MyColor.white),
        );
      } else {
        if (_scaffoldKey.currentState.isDrawerOpen) {
          Navigator.of(context).pop();
        }
        appBarTitleText = Text(
          'Wallet',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: MyColor.white),
        );
      }
    });
  }

//**********************************get user profile
  _logout() {
    _googleSignIn.signOut();
    setState(() {
      _isLoggedIn = false;
    });
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
      print("Prof>>>$jsonData");
      if (status == "1") {
        setState(() {
          name = jsonData['user_name'].toString();
          profile_photo = jsonData['profile_photo'].toString();
          mob = jsonData['phone'].toString();
          notificationCount = jsonData['noti_count'].toString();
          prefs.setString('newVersion',jsonData['newVersion'].toString().trim().replaceAll(".", ""));

          newVersion=double.parse(prefs.getString('newVersion'));
          print("newVersion$newVersion");
          versionCheck(context);
        });
      } else {}
    } else {}
  }

//Logout
  apiLogout(String user_id1) async {
    Map data = {"user_id": user_id1};
    print("aasas$data$token");
    var jsonData = null;
    var response = await http
        .post(uidata.logout, body: data, headers: {'Authorization': token});

    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      var status = jsonData['status'];
      print("statussss$status");
      if (status == "1") {
        setState(() {
          var Message = jsonData['Message'];
          Toast.show(Message, context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        });
        prefs = await SharedPreferences.getInstance();
        setState(() {
          prefs.setString('uId', "");
          prefs.setString('token', "");
          prefs.setString('isLogin', "false");

          setState(() {
            GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);
            googleSignIn.isSignedIn().then((s)
            {
              googleSignIn.signOut();
              //  Toast.show("signout", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            });
          });

          Navigator.pushAndRemoveUntil(
              context, MaterialPageRoute(builder: (context) => StartscreeenPage()), (route) => false);
        });
      } else {
        var Message = jsonData['Message'];
        Toast.show(Message, context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    } else {}
  }

  //****************************************Advertidsing banner******************************************************************
  dialog_advertise(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                Positioned(
                  right: -40.0,
                  top: -40.0,
                  child: GestureDetector(
                    onTap: () {
                      //  Navigator.of(context).pop();
                      setState(() {
                        print("yhgujnhyjuyh");
                        Navigator.pop(context);
                      });
                    },
                    child: CircleAvatar(
                      child: Icon(Icons.close),
                      backgroundColor: Colors.red,
                    ),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              print("yhgujnhyjuyh");
                              /*  Navigator.pop(context);
                        Navigator.of(context).pop();*/
                              // Navigator.of(context).pop(true);
                              // Navigator.of(context, rootNavigator: true).pop();
                              Navigator.pop(context);
                            });
                          },
                          child: Container(
                            height: 280,
                            //  margin: EdgeInsets.all(2.0),
                            decoration: BoxDecoration(
                              //  borderRadius: BorderRadius.circular(10.0),
                              // image: DecorationImage(image: NetworkImage("https://homepages.cae.wisc.edu/~ece533/images/airplane.png"),
                              image: DecorationImage(
                                image: NetworkImage(advertise_photo),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ))
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  //**********************************Advertise api**************************************************************************************************
  apiGetAdvertise(String user_id1) async {
    /* Map data = {"user_id": user_id1};
    print("advertise para$data");*/
    var jsonData = null;
    var response =
        await http.get(uidata.banner, headers: {'Authorization': token});

    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      var status = jsonData['status'];
      print("Res>>$jsonData");
      if (status == "1") {
        setState(() {
          advertise_photo = jsonData['img'].toString();
          if (advertise_photo != "") {
            // WidgetsBinding.instance.addPostFrameCallback((_) => dialog_advertise(context));

            showFancyCustomDialog(context);
          }
        });
      } else {}
    } else {}
  }

  ///@@@@@@@@@@@@@@@@@
  void showFancyCustomDialog(BuildContext context) {
    Dialog fancyDialog = Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
        ),
        height: 300.0,
        width: 300.0,
        child: Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 400,
/*              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12.0),
              ),*/
            ),
            /*Container(
              width: double.infinity,
              height: 50,
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),)*/
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 400,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(advertise_photo),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              // ),
            ),
            Align(
              // These values are based on trial & error method
              alignment: Alignment(1.05, -1.05),
              child: InkWell(
                onTap: () {
                  /*  Navigator.pop(context);*/
                  setState(() {
                    Navigator.of(context).pop(true);
                    // Navigator.of(context).pop(true);
                    //  Navigator.of(context, rootNavigator: false).pop();
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.close,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    showDialog(
        context: context, builder: (BuildContext context) => fancyDialog);
  }

  //***********************************************************************************************************************************
  @override
  Widget build(BuildContext context) {
/*    return new WillPopScope(
        onWillPop: _onWillPop,*/
    child:
    _scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: _scaffoldKey,
      body: Scaffold(
        body: Container(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        appBar: AppBar(
          title: appBarTitleText,
          backgroundColor: MyColor.themecolor,
          elevation: 0,
          toolbarHeight: 45,
          automaticallyImplyLeading: true,
          actions: <Widget>[
            InkWell(
              onTap: ()
              {
                Navigator.push(context, MaterialPageRoute(builder: (context) => NotiPage("")));
              },
              child: Container(
                width: 63,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.notifications,
                          color: Colors.white,
                        ),
                      ],
                    ),
                    Visibility(visible:notificationCount!="0",child:Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        padding:
                            EdgeInsets.all(6),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.red),
                        alignment: Alignment.center,
                        child: Text(notificationCount,style: TextStyle(fontSize: 12)),
                      ),)
                    )
                  ],
                ),
              ),
            )
          ],
        ),
        drawer: Drawer(
          child: ListView(
            //   padding: EdgeInsets.all(0.0),
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text("  " + name,
                    style: TextStyle(
                        color: MyColor.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold)),
                accountEmail: Text("  " + mob,
                    style: TextStyle(color: MyColor.white, fontSize: 15)),
                decoration: BoxDecoration(
                  //color: Colors.black87,
                  color: MyColor.themecolor,
                ),
                currentAccountPicture: Container(
                  width: 95,
                  height: 95,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                    color: Colors.grey,
                    image: DecorationImage(
                        image: NetworkImage(profile_photo), fit: BoxFit.fill),
                  ),
                ),

                /*  MaterialButton(
                      onPressed: () {},


                      color: Colors.white,
                      textColor: Colors.white,
                      child:
                      Image.network(profile_photo),
                      shape: CircleBorder(),
                    ),*/

                otherAccountsPictures: <Widget>[
                  new IconButton(
                    icon: new Icon(Icons.close),
                    color: Colors.white,
                    highlightColor: Colors.white,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              /*  Divider(
                    height: 25,
                  ),*/
              ListTile(
                  leading: SizedBox(
                    height: 22.0,
                    width: 22.0,
                    // child: Image.asset("assets/images/exam.png"),
                    child: Icon(
                      Icons.person,
                      color: Colors.black,
                    ),
                  ),
                  title: Text(
                    'My Profile',
                    style: TextStyle(fontSize: 14),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                  dense: true,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyProfilePage(userId)));
                  }),
              ListTile(
                  leading: SizedBox(
                    height: 27.0,
                    width: 27.0,
                    child: Image.asset("assets/images/tran.png"),
                  ),
                  /*title: Text('My Contest',style: TextStyle(fontWeight: FontWeight.bold),),*/
                  title: Text(
                    'Transaction',
                    style: TextStyle(fontSize: 14),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                  dense: true,
                  // trailing: Icon(Icons.edit),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TransactionPage2()));
                  }),
              ListTile(
                  leading: SizedBox(
                    height: 22.0,
                    width: 22.0,
                    // child: Image.asset("assets/images/exam.png"),
                    child: Icon(
                      Icons.assignment,
                      color: Colors.black,
                    ),
                  ),
                  title: Text(
                    'Withdraw Account Details',
                    style: TextStyle(fontSize: 14),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                  dense: true,
                  onTap: () {
                    setState(() {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AccountDetails()));
                    });
                  }),
/*                  ListTile(
                      leading: SizedBox(
                        height: 19.0,
                        width: 19.0,
                        child: Image.asset("assets/images/msg.png"),
                      ),
                      title: Text(
                        'Challange Friend',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      contentPadding:
                      EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                      dense: true,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChallangeFriendPage()));
                      }),*/
              ListTile(
                  leading: SizedBox(
                    height: 22.0,
                    width: 22.0,
                    child: Icon(
                      Icons.remove_red_eye,
                      color: Colors.black,
                    ),
                  ),
                  title: Text(
                    'Change Password',
                    style: TextStyle(fontSize: 14),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                  dense: true,
                  onTap: () {
                    /*Navigator.push(context, MaterialPageRoute(builder: (context) =>ChangePassword()));*/
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => VerifyOldPassword()));
                  }),
              ListTile(
                  leading: SizedBox(
                    height: 22.0,
                    width: 22.0,
                    child: Image.asset("assets/images/exam.png"),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                  dense: true,
                  title: Text(
                    'Terms & Conditions',
                    style: TextStyle(fontSize: 14),
                  ),
                  onTap: () {
                    // Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyHomePage55()));
                  }),
              ListTile(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                dense: true,
                leading: SizedBox(
                  height: 22.0,
                  width: 25.0,
                  child: Image.asset("assets/images/logout.png"),
                ),
                onTap: () {
                  apiLogout(userId);
                },
                title: Text(
                  'Logout',
                  // style: TextStyle(fontWeight: FontWeight.bold),
                  style: TextStyle(fontSize: 14),
                ),
              ),
              // Divider(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        //  backgroundColor: Colors.black87,
        backgroundColor: MyColor.themecolor,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: MyColor.white,
            ),
            title: Text(
              'Home',
              style: TextStyle(color: MyColor.white),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.assignment,
              color: MyColor.white,
            ),
            title: Text(
              'Test',
              style: TextStyle(color: MyColor.white),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.assignment_turned_in,
              color: MyColor.white,
            ),
            title: Text(
              'My Contest',
              style: TextStyle(color: MyColor.white),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.assignment,
              color: MyColor.white,
            ),
            title: Text(
              'Result',
              style: TextStyle(color: MyColor.white),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.wallet_giftcard,
              color: MyColor.white,
            ),
            title: Text(
              'Wallet',
              style: TextStyle(color: MyColor.white),
            ),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }

  initializeSF() async {
    prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("uId");
    token = prefs.getString("token");
    start = prefs.getBool("start");
   // prefs.setString('newVersion',"");





    print("aaaasaaaaaa $token");
    print("aaaa>> $start");
    print("newVersion>>$newVersion.toString()");
    apiGetUser(userId);
    apiGetAdvertise(userId);
    // showFancyCustomDialog(context);
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      initializeSF();
      // initialzing the push notification stuffs
      navigatorKey = GlobalKey(debugLabel: "Main Navigator");
      firebaseCloudMessaging_Listeners();

    });
  }
  //
  versionCheck(context) async {


    final PackageInfo info = await PackageInfo.fromPlatform();
    double currentVersion = double.parse(info.version.trim().replaceAll(".", ""));
    print("version>>>$currentVersion"+"newVersion>>$newVersion");
    if (newVersion > currentVersion)
    {

      _showVersionDialog(context);
    }


   /* PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;*/



  /*  PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      String appName = packageInfo.appName;
      String packageName = packageInfo.packageName;
      String version = packageInfo.version;
      String buildNumber = packageInfo.buildNumber;
      newVersion=double.parse(packageInfo.version);
    });*/
 /*   newVersion=double.parse(info.version);
    print("Version>>>"+currentVersion.toString()+"\n newVersion"+newVersion.toString());
    if (newVersion > currentVersion)
    {
      _showVersionDialog(context);
    }*/




  }
//Show Dialog to force user to update
  _showVersionDialog(context) async {
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String title = "New Update Available";
        String message =
            "There is a newer version of app available please update it now.";
        String btnLabel = "Update Now";
        String btnLabelCancel = "Later";
        return Platform.isIOS
            ? new CupertinoAlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text(btnLabel),
              onPressed: () => LaunchReview.launch(
                androidAppId: PLAY_STORE_APP_ID,
              ),
            ),
            FlatButton(
              child: Text(btnLabelCancel),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        )
            : new AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text(btnLabel),
              onPressed: () => _launchURL(PLAY_STORE_APP_ID,),
             /* onPressed: () => LaunchReview.launch(
                androidAppId: PLAY_STORE_APP_ID,
              ),*/
            ),
            FlatButton(
              child: Text(btnLabelCancel),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }
  _launchURL(String url) async
  {
    if (await canLaunch(url))
    {
      await launch(url);
    }
    else {
      throw 'Could not launch $url';
    }
  }
}

/////////filter ////////
class Fil extends StatelessWidget {
  const Fil({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffE5DDD5),
        body: Padding(
          padding: EdgeInsets.all(10),
          child: ListView(children: <Widget>[
            Container(
              height: 58,
              padding: EdgeInsets.all(7),
              margin: const EdgeInsets.only(top: 2.0, bottom: 3),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Search',
                ),
              ),
            ),
            IntrinsicHeight(
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Column(children: [
                        Container(
                          height: 110.0,
                          child: FlutterLogo(
                            size: 50.0,
                          ),
                        ),
                        Container(
                          height: 110.0,
                          child: FlutterLogo(
                            size: 50.0,
                          ),
                        ),
                        Container(
                          height: 110.0,
                          child: FlutterLogo(
                            size: 50.0,
                          ),
                        ),
                      ]),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        color: Colors.white60,
                      ),
                    ),
                  ]),
            ),
            Container(
                /* padding: EdgeInsets.symmetric(horizontal: 10, vertical: 1),*/
                padding: EdgeInsets.all(2),
                height: 48,
                margin: const EdgeInsets.only(top: 15.0),
                child: RaisedButton(
                  textColor: Colors.white,
                  color: MyColor.colorprimary,
                  child: Text(
                    'Set Preferences',
                    style: TextStyle(fontSize: 18),
                  ),
                  onPressed: () {
                    //   Navigator.push(context, MaterialPageRoute(builder: (context) => Registration_Step1()),);
                  },
                ))
          ]),
        ));
  }
}

/////////filter ////////
class Favourite extends StatelessWidget {
  const Favourite({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return Scaffold(
        body: Padding(
            padding: EdgeInsets.all(14),
            child: ListView(
              children: <Widget>[
                Container(
                  height: 49,
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                  ),
                ),
              ],
            )));
  }

  /*void initState()
  {
    print("init");

      apigetFavData();


  }*/
//
/*
  apigetFavData() async {
    Map data = {"id": "2"};
    print(data);
    var jsonData = null;
    var response = await http.post(uidata.Profile, body: data);

    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      var status = jsonData['status'];
      print(jsonData);
      if (status == "1")
      {
        print("in apiiiiiiiiiiiii>");
        name = jsonData['name'];
        email = jsonData['email'];
        location = jsonData['location'];
        */
/*skill=jsonData['location'];
    mob=jsonData['location'];*/ /*



      } else {
       */
/* Toast.show(status, context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);*/ /*

      }
    } else {}
  }
*/

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    //throw UnimplementedError();
  }
}

///home page
class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  void initState() {}

  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(
      children: <Widget>[
        ListView.builder(
            itemCount: 10,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text('gbhnghgb'),
                onTap: () {},
              );
            }),
      ],
    )));
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}

class mainfun extends StatefulWidget {
  _mainfunState createState() => _mainfunState();
}

class _mainfunState extends State<MainDashboard> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => MainDashboard(userId, true)));
    });
  }

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
///Forcefully update
///
 /* versionCheck(context) async {
    //Get Current installed version of app
    String version;
    double newVersion;
    final PackageInfo info = await PackageInfo.fromPlatform();
    double currentVersion = double.parse(info.version.trim().replaceAll(".", ""));

    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      String appName = packageInfo.appName;
      String packageName = packageInfo.packageName;
      String version = packageInfo.version;
      String buildNumber = packageInfo.buildNumber;
      newVersion=double.parse(packageInfo.version);
    });
print("Version>>>"+currentVersion.toString()+"\n newVersion"+newVersion.toString());
    if (newVersion > currentVersion)
    {
      _showVersionDialog(context);
    }




  }
//Show Dialog to force user to update
  _showVersionDialog(context) async {
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String title = "New Update Available";
        String message =
            "There is a newer version of app available please update it now.";
        String btnLabel = "Update Now";
        String btnLabelCancel = "Later";
        return Platform.isIOS
            ? new CupertinoAlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text(btnLabel),
              onPressed: () => LaunchReview.launch(
                androidAppId: PLAY_STORE_APP_ID,
              ),
            ),
            FlatButton(
              child: Text(btnLabelCancel),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        )
            : new AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text(btnLabel),
              onPressed: () => LaunchReview.launch(
                androidAppId: PLAY_STORE_APP_ID,
              ),
            ),
            FlatButton(
              child: Text(btnLabelCancel),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }*/

}

