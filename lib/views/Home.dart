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
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }


}