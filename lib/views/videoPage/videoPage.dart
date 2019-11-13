import 'package:artepie/model/user_info.dart';
import 'package:flutter/material.dart';

class VideoPage extends StatefulWidget{

  final UserInformation userInfo;
  final bool hasLogined;

  VideoPage(this.userInfo,this.hasLogined);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _MyVideoPageState();
  }
}

class _MyVideoPageState extends State<VideoPage>{


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Center(
        child: Text('视频'),
      ),
    );
  }

}