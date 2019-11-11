import 'package:artepie/model/user_info.dart';
import 'package:flutter/material.dart';

class AppPage extends StatefulWidget {
  final UserInformation userInfo;
  final bool _hasLogin;
  AppPage(this.userInfo,this._hasLogin);

  @override
  State<StatefulWidget> createState() {
    return _MyAppPageState();
  }
}

class _MyAppPageState extends State<AppPage>{

  List<Widget> _widgetList = List();
  int _currentIndex = 0;
  List tabData = [
    {'text':'首页','icon':Icon(Icons.audiotrack)},
    {'text':'艺条','icon':Icon(Icons.library_books)},
    {'text':'秀吧','icon':Icon(Icons.ondemand_video)},
    {'text':'我的','icon':Icon(Icons.account_circle)},
  ];
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }


}