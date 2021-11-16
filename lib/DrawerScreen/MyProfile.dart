import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:onlineexamcontest/Constants/MyColor.dart';
import 'package:onlineexamcontest/Constants/uidata.dart';
import 'package:onlineexamcontest/Dashboard/HomePage1.dart';
import 'package:onlineexamcontest/Dashboard/MainDashboard.dart';
import 'package:onlineexamcontest/DrawerScreen/ChangemobileNo.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

String userId;
SharedPreferences prefs;
File _image = null;
String token;
String name,
    email,
    address,
    mobileno,
    state,
    profile_photo,
    uId,
    path,
    state_id = "1";
String _mySelection = null;
bool isLoading = false;

class MyProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _State();

  MyProfilePage(String uId1) {
    uId = uId1;
  }
}

class _State extends State<MyProfilePage> {
  TextEditingController uNmController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  bool _isEnable = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      isLoading = true;
      //  apiGetUser(uId);
      //this.getSWData();
      initializeSF();
    });
  }

  initializeSF() async {
    setState(() async {
      prefs = await SharedPreferences.getInstance();
      userId = prefs.getString("uId");
      token = prefs.getString("token");
      print("aaaa $userId");
      apiGetUser(userId);
      this.getSWData();
    });
  }

///////////////////States
  List data = List(); //edited line
  Future<String> getSWData() async {
    var res = await http
        .get(Uri.encodeFull(uidata.states), headers: {'Authorization': token});
    var resBody = (json.decode(res.body));
    setState(() {
      data = resBody['data'];
    });
    print("sttttt>>$resBody");
    return "Sucess";
  }

  ///////////////////////////////////////////////Image Picker////////////////////////////////////////////////////////////////////////////

  final picker = ImagePicker();

  Future getImageFromCamera() async {
    final pickedFile =
        await picker.getImage(source: ImageSource.camera, imageQuality: 25);
    path = pickedFile.path;
    print("path :$path");
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _asyncFileUpload(uId, path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future getImageFromGallary() async {
    final pickedFile =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 25);
    path = pickedFile.path;
    print("path :$path");
    setState(() {
      if (pickedFile != null)
      {
        _image = File(pickedFile.path);
        _asyncFileUpload(uId, path);
      } else {
        print('No image selected.');
      }
    });
  } //popup

  void _showPicker() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        getImageFromGallary();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      getImageFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  } //////////////////////////////////////////////////////////////////////////////////////////////////////////

  _asyncFileUpload(String text, String path) async {
    //create multipart request for POST or PATCH method
    var request =
        http.MultipartRequest("POST", Uri.parse(uidata.updateprofilephoto));
    request.headers["Authorization"] = token;
    //add text fields
    request.fields["user_id"] = text;
    //create multipart using filepath, string or bytes
    var pic = await http.MultipartFile.fromPath("img", path);
    //add multipart to request
    request.files.add(pic);
    var response = await request.send();

    //Get the response from the server
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    print("responce img upload $responseString");
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text('My Profile'),
          backgroundColor: MyColor.themecolor,
        ),
        body:
            /* isLoading
            ? Container(
          margin: const EdgeInsets.only(left: 29.0, right: 29),
          color: Colors.white.withOpacity(.4),
          child: Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          ),
        )
            :*/

            ListView(children: <Widget>[
          Stack(alignment: Alignment.bottomCenter, children: <Widget>[
            InkWell(
              onTap: () {
                if (_isEnable) _showPicker();
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: 95,
                    height: 95,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50.0),
                      color: Colors.grey,
                      image: DecorationImage(
                          image: _image != null
                              ? FileImage(_image)
                              : profile_photo != null
                                  ? NetworkImage(profile_photo)
                                  : AssetImage('assets/images/profile.png'),
                          fit: BoxFit.fill),
                    ),
                  ),
                ),
                height: MediaQuery.of(context).size.width - 220,
                width: MediaQuery.of(context).size.width - 220,
              ),
            ),
            Visibility(
              visible: _isEnable,
              child: InkWell(
                onTap: () {
                  if (_isEnable) _showPicker();
                },
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Icon(
                    Icons.edit,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ]),
          Container(
            height: 53,
            margin: const EdgeInsets.only(left: 25, right: 25),
            // padding: const EdgeInsets.all(5),
            child: TextField(
              enabled: _isEnable,
              keyboardType: TextInputType.text,
              controller: uNmController,
              decoration: new InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 1.0),
                ),
                labelStyle: new TextStyle(color: Colors.black),
                labelText: 'User Name ',
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          Container(
            height: 53,
            margin: const EdgeInsets.only(left: 25, right: 25, top: 10),
            child: TextField(
              enabled: _isEnable,
              keyboardType: TextInputType.text,
              controller: emailController,
              decoration: new InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 1.0),
                ),
                labelStyle: new TextStyle(color: Colors.black),
                labelText: 'Email ID.',
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          Container(
            height: 125,
            margin: const EdgeInsets.only(left: 25, right: 25, top: 10),
            child: TextField(
              maxLines: 5,
              enabled: _isEnable,
              keyboardType: TextInputType.text,
              controller: addController,
              decoration: new InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 1.0),
                ),
                labelStyle: new TextStyle(color: Colors.black),
                labelText: 'Address',
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          Container(
              /*  height: 45,
              margin: const EdgeInsets.only(left: 25, right: 25, top: 10),*/
              child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              InkWell(
                onTap: () {},
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        height: 45,
                        margin:
                            const EdgeInsets.only(left: 25, right: 25, top: 10),
                        padding: const EdgeInsets.all(3.0),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: _isEnable == true
                                    ? Colors.black
                                    : Colors.white)),
                        /*  padding: EdgeInsets.only(
                                left: 30, right: 30, top: 2, bottom: 2),*/
                        //height: 40,
                        child: Row(children: <Widget>[
                          Expanded(
                           /* child: GestureDetector(
                              onTap: ()
                              {
                                if(_isEnable==true) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ChangeMobileNoPage(uId)));
                                }
                              },*/
                              child: TextField(
                                autofocus: false,
                                enabled: _isEnable,
                                readOnly: true,
                                keyboardType: TextInputType.text,
                                controller: mobileController,
                                //  decoration: new InputDecoration(
/*                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 2.0),
                                  ),*/
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 1.0),
                                  ),
                                  labelStyle:
                                      new TextStyle(color: Colors.black),
                                  // labelText: 'Edit Mobile No.',
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                              ),
                            ),
                          //),
                         Visibility(visible:_isEnable,child:Expanded(
                              child: Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              icon: Icon(
                                Icons.edit_outlined,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ChangeMobileNoPage(uId)));
                              },
                            ),
                          )),),
                        ])),
                  ],
                ),
              ),
              //  Divider(color: Colors.grey,),
            ],
          )),
          /* GestureDetector(
            onTap: () {
              print("Container clicked");
            },
            child: */
          Visibility(
            visible: _isEnable,
            child: Padding(
              padding: const EdgeInsets.only(),
              child: Container(
                height: 45,
                margin: const EdgeInsets.only(left: 25, right: 25, top: 10),
                //  padding: const EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                    border: Border.all(
                        color:
                            _isEnable == true ? Colors.black : Colors.white)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(left: 7),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          dropdownColor: MyColor.white,
                          isDense: true,
                          hint: new Text("Select State",
                              textAlign: TextAlign.center),
                          items: data.map((item) {
                            return new DropdownMenuItem(
                              child: new Text(
                                  item['name'] != "" ? item['name'] : "state"),
                              value: item['state_id'].toString() != ""
                                  ? item['state_id'].toString()
                                  : "0",
                            );
                          }).toList(),
                          onChanged: (newVal) {
                            setState(() {
                              _mySelection = newVal;
                              print(_mySelection);
                            });
                          },
                          value: _mySelection,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Visibility(
            visible: !_isEnable,
            child: Container(
              margin: const EdgeInsets.only(left: 40, top: 5),
              child: Text(
                state != null ? state : "",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          //  ),
          Container(
              padding: const EdgeInsets.only(left: 25, right: 25, top: 20),
              //  height: 100,

              child: Row(children: <Widget>[
                Expanded(
                    child: Container(
                        height: 42,
                        child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: MyColor.white,
                                    width: 1,
                                    style: BorderStyle.solid),
                                borderRadius: BorderRadius.circular(2)),
                            onPressed: () {
                              setState(() {
                                _isEnable = true;
                                uNmController.text = name;
                                emailController.text = email;
                                addController.text = address;
                                mobileController.text = mobileno;
                                stateController.text = state;
                              });
                            },
                            color: MyColor.yellow,
                            child: Text(
                              "Edit",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )))),
                SizedBox(
                  width: 7,
                ),
                Expanded(
                    child: Container(
                        height: 42,
                        child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    color: MyColor.white,
                                    width: 1,
                                    style: BorderStyle.solid),
                                borderRadius: BorderRadius.circular(2)),
                            onPressed: () {
                              setState(() {
                                /* _isEnable = false;*/
                                isLoading = true;
                                //  print("_mySelection>> $_mySelection");
                                if (_mySelection == null ||
                                    _mySelection == "") {
                                  if (state_id == null || state_id == "") {
                                    Toast.show("Please Select State", context,
                                        duration: Toast.LENGTH_LONG,
                                        gravity: Toast.BOTTOM);
                                  } else {
                                    _mySelection = state_id;
                                    apiUpdate(
                                        uId,
                                        _mySelection,
                                        emailController.text,
                                        uNmController.text,
                                        addController.text);
                                  }
                                } else {
                                  apiUpdate(
                                      uId,
                                      _mySelection,
                                      emailController.text,
                                      uNmController.text,
                                      addController.text);
                                }

                                // }
                              });
                            },
                            color: MyColor.yellow,
                            child: Text(
                              "Save",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )))),
              ])),
          Container(
            height: 30,
          ),
          /* SizedBox(
            width: 100,
          ),*/

          /*   Container(
              height: 45,
              margin: const EdgeInsets.only(left: 30, right: 30, bottom: 40),
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
                    'Save',
                    style: TextStyle(
                      fontSize: 19,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {}))*/
        ]));
  }

//**********************************get user profile

  apiGetUser(String user_id1) async {
    Map data = {"user_id": user_id1};
    print(data);
    var jsonData = null;
    var response = await http.post(uidata.getuser, body: data, headers: {'Authorization': token});

    if (response.statusCode == 200) {
      isLoading = false;
      jsonData = json.decode(response.body);
      var status = jsonData['status'];

      print(jsonData);
      if (status == "1") {
        setState(() {
          state = jsonData['state'].toString();
          name = jsonData['user_name'].toString();
          email = jsonData['email'].toString();
          address = jsonData['address'].toString();
          mobileno = jsonData['phone'].toString();
          state_id = jsonData['state_id'].toString();
          profile_photo = jsonData['profile_photo'].toString();
        });
        /* uNmController.text = "\n" + name;
        emailController.text = "\n" + email;*/
        uNmController.text = name;
        emailController.text = email;
        addController.text = address;
        if (mobileno == "") {
          mobileController.text = "Edit Mobile No.";
        } else {
          mobileController.text = mobileno;
        }

        stateController.text = state != "" ? state : "Select";
      } else {}
    } else {}
  }

  //***************************************
  apiUpdate(String user_id, String state_id, String email, String user_name,
      String address) async {
    Map data = {
      "user_id": user_id,
      "state_id": state_id,
      "email": email,
      "user_name": user_name,
      "address": address
    };
    print("paraupdate>>>$data");
    var jsonData = null;
    var response = await http.post(uidata.editprofile,
        body: data, headers: {'Authorization': token});

    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      var status = jsonData['status'];
      var msg = jsonData['Message'];

      print(jsonData);
      print('status $status');
      if (status == "1") {
        setState(() {
          isLoading = false;
        });

        Toast.show(msg, context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        /* apiGetUser(uId);
        _isEnable = false;*/
        setState(() {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MainDashboard(userId, true)));
        });
      } else {
        setState(() {
          Toast.show(msg, context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          /* setState(() {
            Navigator.push(context, MaterialPageRoute(
                builder: (context) => MainDashboard(userId, true)));
          } );*/
          isLoading = false;
        });
        Toast.show(msg, context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    } else {}
  }

//****************************************
}
