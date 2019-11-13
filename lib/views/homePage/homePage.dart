import 'package:artepie/model/user_info.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget{

  final UserInformation userInfo;
  final bool hasLogined;

  HomePage(this.userInfo,this.hasLogined);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _MyHomePageState();
  }
}

class _MyHomePageState extends State<HomePage>{


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Center(
        child: Text('首页'),
      ),
    );
  }

}