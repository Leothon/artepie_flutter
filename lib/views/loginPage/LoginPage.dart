import 'package:artepie/model/user_info.dart';
import 'package:artepie/routers/Application.dart';
import 'package:artepie/views/Home.dart';
import 'package:artepie/views/commonAppBar/CommonAppBar.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _MyLoginPageState();
  }
}

class _MyLoginPageState extends State<LoginPage> {


//  TextEditingController phoneController = TextEditingController();
//
//  TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Column(
        children: <Widget>[
          CommonAppBar(
            title: '',
            subTitle: '暂不登录',
            subTitleColor: Colors.black,
            onPressSubTitle: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => AppPage(null,false)),
                  (route) => route == null);
            },
            isBackLastPage: false,
          ),

          new Container(

            margin: EdgeInsets.fromLTRB(0.0, 50, 0.0, 50),
            child: new Text(
              '登录艺派，发掘艺术之美',
              style: new TextStyle(
                  fontSize: 28,
                  color: Colors.black
              ),
            ),
          ),

          new Container(
            margin: EdgeInsets.all(20),
            child:  TextField(
              keyboardType: TextInputType.phone,
              maxLength: 11,
              decoration: InputDecoration(
                icon: Icon(Icons.phone),
                labelText: '输入手机号',
                labelStyle: new TextStyle(
                  fontSize: 18
                ),
                hintText: '输入手机号,未注册的手机号会在验证后注册并登录',
                hintStyle: new TextStyle(
                  fontSize: 12
                )
              ),
            ),
          )

        ],
      ),
    );
  }
}
