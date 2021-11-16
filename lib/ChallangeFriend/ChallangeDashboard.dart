import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChallangeFriendPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _State();
}

class _State extends State<ChallangeFriendPage> {
  TextEditingController editingController = TextEditingController();

  @override
  Widget build(BuildContext context)
  {
    return new Scaffold(
        appBar: AppBar(
        title: Text('Challange Friend'),
    backgroundColor: Colors.black,
    ),
    );
  }}