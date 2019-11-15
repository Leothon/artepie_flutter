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

  bool isPassword = false;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Column(
        children: <Widget>[
          CommonAppBar(
            title: '',
            subTitle: '暂不登录',
            subTitleColor: Colors.black,
            onPressSubTitle: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => AppPage(null, false)),
                  (route) => route == null);
            },
            isBackLastPage: false,
          ),
          new Container(
            margin: EdgeInsets.fromLTRB(0.0, 50, 0.0, 50),
            child: new Text(
              '登录艺派，发掘艺术之美',
              style: new TextStyle(fontSize: 28, color: Colors.black),
            ),
          ),
          new Container(
            margin: EdgeInsets.fromLTRB(30, 50, 30, 0),
            child: TextField(
              keyboardType: TextInputType.phone,
              maxLength: 11,
              decoration: InputDecoration(
                  icon: isPassword
                      ? Icon(Icons.account_circle)
                      : Icon(Icons.phone),
                  labelText: '输入手机号',
                  labelStyle: new TextStyle(fontSize: 18),
                  hintText: '输入手机号,未注册的手机号会在验证后注册并登录',
                  hintStyle: new TextStyle(fontSize: 12),
                  border: InputBorder.none),
              autofocus: true,
            ),
          ),
          _passwordWidget(context),
          new Container(
            margin: EdgeInsets.fromLTRB(30, 10, 30, 0),
            child: new Row(
              children: <Widget>[
                Expanded(
                  child: new Text(
                    '点击注册，则表示您已阅读并同意《用户协议》',
                    style: new TextStyle(color: Colors.red, fontSize: 10),
                  ),
                  flex: 3,
                ),
                Expanded(
                  child: GestureDetector(
                    child: new Center(
                      child: new Text(
                        isPassword ? '使用验证码登录' : '使用密码登录',
                        style: new TextStyle(color: Colors.green, fontSize: 12),
                      ),
                    ),
                    onTap: switchPasswordOrMessage,
                  ),
                  flex: 1,
                ),
              ],
            ),
          ),
          new Container(
              margin: EdgeInsets.all(80.0),
              child: new Row(
                children: <Widget>[
                  Expanded(
                    child: new Center(
                      child: Icon(
                        IconData(0xe609, fontFamily: 'qqIcon'),
                        size: 45,
                        color: Colors.blue,
                      ),
                    ),
                    flex: 1,
                  ),
                  Expanded(
                    child: new Center(
                      child: Icon(
                        IconData(0xe6c3, fontFamily: 'wechatIcon'),
                        size: 45,
                        color: Colors.green,
                      ),
                    ),
                    flex: 1,
                  ),
                ],
              ))
        ],
      ),
    );
  }

  Widget _passwordWidget(BuildContext context) {
    if (!isPassword) {
      return new Container(
        margin: EdgeInsets.fromLTRB(30, 8, 30, 0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    icon: Icon(Icons.verified_user),
                    labelText: "验证码",
                    labelStyle: new TextStyle(fontSize: 18),
                    hintText: '验证码',
                    hintStyle: new TextStyle(fontSize: 12),
                    border: InputBorder.none),
              ),
              flex: 1,
            ),
            Expanded(
              child: MaterialButton(
                color: Colors.green,
                textColor: Colors.white,
                child: new Text('获取验证码'),
                onPressed: _getVerifyCode,
              ),
              flex: 1,
            ),
          ],
        ),
      );
    } else {
      return new Container(
        margin: EdgeInsets.fromLTRB(30, 8, 30, 0),
        child: TextField(
          keyboardType: TextInputType.visiblePassword,
          decoration: InputDecoration(
              icon: Icon(Icons.lock),
              labelText: '输入密码',
              labelStyle: new TextStyle(fontSize: 18),
              hintText: '输入密码',
              hintStyle: new TextStyle(fontSize: 12),
              border: InputBorder.none),
          obscureText: true,
        ),
      );
    }
  }

  void switchPasswordOrMessage() {
    setState(() {
      isPassword = !isPassword;
    });
  }

  //TODO 获取验证码
  void _getVerifyCode() {}
}
