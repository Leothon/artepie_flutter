import 'package:artepie/model/user_info.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget{


  final bool hasLogined;

  AboutPage(this.hasLogined);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _MyAboutPageState();
  }
}

class _MyAboutPageState extends State<AboutPage>{


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Center(
        child: Text('我的'),
      ),
    );
  }

}