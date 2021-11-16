import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:onlineexamcontest/Constants/uidata.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<User> users = new List<User>();
String token;SharedPreferences prefs;
class slider7 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _State();

}


class _State extends State<slider7>
{
  void initState()
  {
    setState(() {
      initializeSF();

    });
  }
  initializeSF() {
    setState(()
    async
    {
      prefs = await SharedPreferences.getInstance();
      token = prefs.getString("token");
      print("token> $token");
      getImages();
    });

  }
  Future<Album> getImages() async {
    var jsonData = null;
    final response = await http.get(uidata.advertisements,headers: {'Authorization': token});
    if (response.statusCode == 200)
    {
      var res = Album.fromJson(jsonDecode(response.body));
      jsonData = json.decode(response.body);

      var status = jsonData['status'];
      print("val>>> $status");
      users = res.data;
    }
    else {
      throw Exception('Failed to load winners');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: /* ListView(

        children: [*/
          ListView.builder(
          //  scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: users.length,
        itemBuilder: (context, index)
        {
          print( 'img>>> $users[index].advertise_id');
          return CarouselSlider(
            items: [
              Container(
                height: 200,
                margin: EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  image: DecorationImage(
                    /*image: NetworkImage(
                        "https://homepages.cae.wisc.edu/~ece533/images/airplane.png"),*/
                    image: NetworkImage(users[index].img),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
              options: CarouselOptions(
              height: 130.0,
              enlargeCenterPage: true,
              autoPlay: true,
              aspectRatio: 16 / 9,
              autoPlayCurve: Curves.fastOutSlowIn,
              enableInfiniteScroll: true,
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              viewportFraction: 0.8,
            ),
          );

          //],
        },

      ),
    );
  }
}

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
  String advertise_id, img, status;
  List<User> data;

  Album({this.advertise_id, this.img});

  Album.fromJson(Map<String, dynamic> json) {
    status = json['status'];

    if (json['data'] != null) {
      data = new List<User>();
      json['data'].forEach((v) {
        data.add(new User.fromJson(v));
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
  String advertise_id, img;

  User({
    this.advertise_id,
    this.img,
  });

  User.fromJson(Map<String, dynamic> json) {
    advertise_id = json['advertise_id'];
    img = json['img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['advertise_id'] = this.advertise_id;
    data['img'] = this.img;

    return data;
  }
}
