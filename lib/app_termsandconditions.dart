
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import 'Constants/MyColor.dart';

void main()=> runApp(MaterialApp(
    home:MyHomePage55(),
    debugShowCheckedModeBanner: false,
    theme:ThemeData(
        primarySwatch: Colors.blue
    )
));

class MyHomePage55 extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State {

  TextEditingController controller=TextEditingController();
  FlutterWebviewPlugin flutterWebviewPlugin= FlutterWebviewPlugin();
  var url= "http://tejas.mediqwick.com/terms&conditions/";

  @override
  void initState() {
    super.initState();
    flutterWebviewPlugin.onStateChanged.listen((WebViewStateChanged wvs) {});
  }
  searchURL(){
    setState(() {
      url = "https://www."+controller.text;
      flutterWebviewPlugin.reloadUrl(url);
      controller.text=url;
    });
  }
  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: url,
      withZoom: true,
      hidden: true,
      // initialChild: Container(
      //   child:Center(child: Text("Loading"),)
      // ),
      appBar: AppBar(
        /*backgroundColor: Colors.green,
        title: Text("Terms and Conditions"),*/
        // appBar: AppBar(
        backgroundColor:MyColor.themecolor,
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: Text("Terms and Conditions",style: TextStyle(color: Colors.white,
            fontSize: 19.0)),
        elevation: 0,
      ),
      /*  leading: Icon(Icons.search),
        title: TextField(
          controller: controller,
          textInputAction: TextInputAction.search,
          onSubmitted:(url)=>searchURL(),
          style: TextStyle(
              color: Colors.white
          ),
          decoration: InputDecoration(
              hintText: "Search Here",
              hintStyle: TextStyle(color: Colors.white)
          ),
        ),
        actions: [
          IconButton(icon: Icon(Icons.arrow_back),
              onPressed: (){
                flutterWebviewPlugin.goBack();
                controller.text="";
              }
          ),
          IconButton(icon: Icon(Icons.arrow_forward),
            onPressed: searchURL,),
        ],*/
      //),
    );
  }
}