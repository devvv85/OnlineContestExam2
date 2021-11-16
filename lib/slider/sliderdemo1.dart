import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:onlineexamcontest/Constants/uidata.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ContestInfo.dart';

List<User> users = new List<User>();
List _imageUrls1 = [];
List _imageUrls = [];
String id,token;SharedPreferences prefs;
class slidernew extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _State();
}

class _State extends State<slidernew> {
  void initState() {
    setState(() {
      initializeSF();

    });
  }
  initializeSF() async {
    setState(() async {
      prefs = await SharedPreferences.getInstance();
      token = prefs.getString("token");
      print("token> $token");
      getImages();
    });

  }

  Future<Album> getImages() async {
    var jsonData = null;
    final response = await http.get(uidata.advertisements,headers: {'Authorization': token});
    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      var status = jsonData['status'];
      print("sliderimg>>$jsonData");
      if (status == "1")
      {
        setState(() {
          var res = Album.fromJson(jsonDecode(response.body));
          users = res.data;
        });
/*        setState(() {
          *//*  _isLoading = false;*//*
          _imageUrls = (json.decode(response.body)['data']);
          for (int i = 0; i < _imageUrls.length; i++) {
            _imageUrls1.add(_imageUrls[i]['img']);


          }
          print("images $_imageUrls1");
        });*/
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: users.length,

        itemBuilder: (context, index) {
          return
            CarouselSlider.builder(
              itemCount: users.length,
              options: CarouselOptions(
                height: 145.0,
                initialPage: 0,
                enlargeCenterPage: true,
                autoPlay: true,
                reverse: false,
                enableInfiniteScroll: true,
                autoPlayInterval: Duration(seconds: 2),
                autoPlayAnimationDuration: Duration(milliseconds: 2000),
                //pauseAutoPlayOnTouch: Duration(seconds: 10),
                pauseAutoPlayOnTouch: true,
                scrollDirection: Axis.horizontal,
              ),
              itemBuilder: (context, index) {
                return
                  GestureDetector(
                    onTap: () {
                setState(() {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              contestIfo(users[index].advertise_id)));
                });

                },child: Container(

                      decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    image: DecorationImage(
                      image: NetworkImage(users[index].img==null?"":users[index].img),
                      fit: BoxFit.cover,
                    ),
                  )


                  ),
                );
              },
            );


          /*CarouselSlider(
            // options: CarouselOptions(height: 130.0,
            options: CarouselOptions(
              height: 145.0,
              initialPage: 0,
              enlargeCenterPage: true,
              autoPlay: true,
              reverse: false,
              enableInfiniteScroll: true,
              autoPlayInterval: Duration(seconds: 2),
              autoPlayAnimationDuration: Duration(milliseconds: 2000),
              //pauseAutoPlayOnTouch: Duration(seconds: 10),
              scrollDirection: Axis.horizontal,
            ),

           items: _imageUrls1.map((imgUrl)

            {
              return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 10.0),
                  child: GestureDetector(
                      onTap: ()
                      {
                        print("$imgUrl");

                        Navigator.push(context, MaterialPageRoute(builder: (context) => contestIfo("2")));
                      },
                      child: Container(
                          decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        image: DecorationImage(
                          image: NetworkImage(imgUrl),
                          fit: BoxFit.cover,
                        ),
                      ))));
              //},
              // );
            }).toList(),
          );*/

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
