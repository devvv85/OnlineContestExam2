import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


SharedPreferences prefs;
bool isLoading = false;

String first_name,
    userLastName,
    about,
    userphoto,
    role,
    requesttype,
    profile_photo,
    time,
    name,
    token,
    status,
    appointmentstatus,
    followers;
String c_first_name,c_userLastName,c_userphoto=null,c_about,c_role,c_followers,c_name,c_user_id,c_member_status;

String Contentowner_photo_username, id;
List<RecentMoviePosterList> recentmovieposterlist =
    new List<RecentMoviePosterList>();
List<Data> getrecentJoinedMembers = new List<Data>();

class OwnerPublicProfileFromUser extends StatefulWidget {
  OwnerPublicProfileFromUser(String id1) {
    id = id1;
    print("id>>>>$id");
  }

  @override
  _OwnerPublicProfileFromUserState createState() =>
      _OwnerPublicProfileFromUserState();
}

class _OwnerPublicProfileFromUserState
    extends State<OwnerPublicProfileFromUser> {
  void initState() {
    super.initState();
    setState(() {
      initializeSF();
    });
  }

  initializeSF() async {
    setState(() async {
      prefs = await SharedPreferences.getInstance();

      token = prefs.getString('token');
      user_id = prefs.getString('uId');
    //  is_Member = prefs.getString('is_member');

      print('tokenis>$token$user_id');
      setState(() {
        c_userphoto=null;
        c_first_name="";
        c_userLastName="";
        c_about="";
        c_role="";
        c_followers="";
        c_name="";
        c_member_s