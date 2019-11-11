import 'package:artepie/model/user_info.dart';
import 'package:flutter/material.dart';

class ArticlePage extends StatefulWidget{
  final UserInformation userInfo;
  final bool hasLogined;

  ArticlePage(this.userInfo,this.hasLogined);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _MyArticlePage();
  }

}

class _MyArticlePage extends State<ArticlePage>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }

}