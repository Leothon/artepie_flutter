import 'package:artepie/model/user_info.dart';
import 'package:artepie/views/userIconWidget/UserIconWidget.dart';
import 'package:flutter/material.dart';

class VideoPage extends StatefulWidget{

  final bool hasLogined;

  VideoPage(this.hasLogined);
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
        child: UserIconWidget(
          url: 'http://www.artepie.cn/image/bannertest2.jpg',
          size: 80,
          authority: 0,
        ),
      )
    );
  }

}