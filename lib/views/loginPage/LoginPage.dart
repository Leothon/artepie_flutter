import 'dart:async';

import 'package:artepie/constants/constants.dart';
import 'package:artepie/model/user_info.dart';
import 'package:artepie/resource/MyColors.dart';
import 'package:artepie/routers/Application.dart';
import 'package:artepie/utils/Adapt.dart';
import 'package:artepie/utils/data_utils.dart';
import 'package:artepie/views/Home.dart';
import 'package:artepie/views/commonAppBar/CommonAppBar.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _MyLoginPageState();
  }
}

class _MyLoginPageState extends State<LoginPage> {
  TextEditingController phoneController = TextEditingController();

  TextEditingController passwordController = TextEditingController();
  bool isPassword = false;
  bool isVerifyCodeBtnDisable = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    hideLoadingDialog();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        resizeToAvoidBottomPadding: true,
        backgroundColor: MyColors.dividerColor,
        body: new Stack(
          children: <Widget>[
            new CustomScrollView(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              slivers: <Widget>[
                SliverAppBar(
                  brightness: Brightness.light,
                  leading: InkWell(
                    child: Icon(Icons.close,
                        color: MyColors.fontColor, size: Adapt.px(46)),
                    onTap: () {
                      SystemNavigator.pop();
                    },
                  ),
                  pinned: true,
                  backgroundColor: Colors.white,
//                elevation: Adapt.px(6),
                  actions: <Widget>[
                    new InkWell(
                      child: Container(
                        padding: EdgeInsets.only(right: Adapt.px(26)),
                        alignment: Alignment.center,
                        child: new Text(
                          '暂不登录',
                          style: new TextStyle(
                              color: MyColors.fontColor,
                              fontSize: Adapt.px(26)),
                        ),
                      ),
                      onTap: () {
                        Application.spUtil
                            .putString("token", Constants.visitorToken);
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => AppPage(false)),
                            (route) => route == null);
                      },
                    )
                  ],
                ),
                SliverToBoxAdapter(
                  child: new Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.fromLTRB(
                        0.0, Adapt.px(150), 0.0, Adapt.px(50)),
                    child: new Text(
                      '登录艺派，发掘艺术之美',
                      style: new TextStyle(
                          fontSize: Adapt.px(48), color: Colors.black),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: new Container(
                    margin: EdgeInsets.fromLTRB(
                        Adapt.px(50), Adapt.px(80), Adapt.px(50), 0),
                    child: TextField(
                      keyboardType: TextInputType.phone,
                      maxLength: 11,
                      controller: phoneController,
                      decoration: InputDecoration(
                          icon: isPassword
                              ? Icon(Icons.account_circle)
                              : Icon(Icons.phone),
                          labelText: '输入手机号',
                          labelStyle: new TextStyle(fontSize: Adapt.px(32)),
                          hintText: '输入手机号,未注册的手机号会在验证后注册并登录',
                          hintStyle: new TextStyle(fontSize: Adapt.px(22)),
                          border: InputBorder.none),
                      //autofocus: true,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: _passwordWidget(context),
                ),
                SliverToBoxAdapter(
                  child: new Container(
                    margin: EdgeInsets.fromLTRB(
                        Adapt.px(50), Adapt.px(20), Adapt.px(50), Adapt.px(20)),
                    width: double.infinity,
                    child: new MaterialButton(
                        color: Colors.green,
                        padding: EdgeInsets.fromLTRB(
                            Adapt.px(20), 0, Adapt.px(20), 0),
                        textColor: Colors.white,
                        height: Adapt.px(90),
                        child: new Text('登     录',
                            style: new TextStyle(
                                fontSize: Adapt.px(34), color: Colors.white)),
                        onPressed:
                            isPassword ? usePasswordLogin : useVerifyCodeLogin),
                  ),
                ),
                SliverToBoxAdapter(
                  child: new Container(
                    margin: EdgeInsets.fromLTRB(
                        Adapt.px(50), Adapt.px(20), Adapt.px(50), 0),
                    child: new Row(
                      children: <Widget>[
                        Expanded(
                          child: new Text(
                            '点击注册，则表示您已阅读并同意《用户协议》',
                            style: new TextStyle(
                                color: Colors.red, fontSize: Adapt.px(20)),
                          ),
                          flex: 3,
                        ),
                        Expanded(
                          child: GestureDetector(
                            child: new Center(
                              child: new Text(
                                isPassword ? '使用验证码登录' : '使用密码登录',
                                style: new TextStyle(
                                    color: Colors.green,
                                    fontSize: Adapt.px(20)),
                              ),
                            ),
                            onTap: switchPasswordOrMessage,
                          ),
                          flex: 1,
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: new Container(
                      margin: EdgeInsets.all(Adapt.px(150)),
                      child: new Row(
                        children: <Widget>[
                          Expanded(
                            child: new Center(
                              child: Icon(
                                IconData(0xe609, fontFamily: 'qqIcon'),
                                size: Adapt.px(80),
                                color: Colors.blue,
                              ),
                            ),
                            flex: 1,
                          ),
                          Expanded(
                            child: new Center(
                              child: Icon(
                                IconData(0xe6c3, fontFamily: 'wechatIcon'),
                                size: Adapt.px(80),
                                color: Colors.green,
                              ),
                            ),
                            flex: 1,
                          ),
                        ],
                      )),
                ),
              ],
            ),
            loadingDialog,
          ],
        ));
  }

  Widget _passwordWidget(BuildContext context) {
    if (!isPassword) {
      return new Container(
        margin:
            EdgeInsets.fromLTRB(Adapt.px(50), Adapt.px(15), Adapt.px(50), 0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    icon: Icon(Icons.verified_user),
                    labelText: "验证码",
                    labelStyle: new TextStyle(fontSize: Adapt.px(32)),
                    hintText: '验证码',
                    hintStyle: new TextStyle(fontSize: Adapt.px(22)),
                    border: InputBorder.none),
              ),
              flex: 1,
            ),
            Expanded(
              child: MaterialButton(
                height: Adapt.px(70),
                color: Colors.green,
                textColor: Colors.white,
                child: new Text(_codeCountdownStr),
                onPressed: isVerifyCodeBtnDisable ? null : _getVerifyCode,
                disabledColor: Colors.grey,
                disabledTextColor: Colors.white,
              ),
              flex: 1,
            ),
          ],
        ),
      );
    } else {
      return new Container(
        margin:
            EdgeInsets.fromLTRB(Adapt.px(50), Adapt.px(15), Adapt.px(50), 0),
        child: TextField(
          controller: passwordController,
          keyboardType: TextInputType.visiblePassword,
          decoration: InputDecoration(
              icon: Icon(Icons.lock),
              labelText: '输入密码',
              labelStyle: new TextStyle(fontSize: Adapt.px(32)),
              hintText: '输入密码',
              hintStyle: new TextStyle(fontSize: Adapt.px(22)),
              border: InputBorder.none),
          obscureText: true,
        ),
      );
    }
  }

  Timer _countdownTimer;
  String _codeCountdownStr = '获取验证码';
  int _countdownNum = 59;

  void reGetCountdown() {
    setState(() {
      if (_countdownTimer != null) {
        return;
      }
      isVerifyCodeBtnDisable = true;
      _codeCountdownStr = '${_countdownNum--}重新获取';
      _countdownTimer = new Timer.periodic(new Duration(seconds: 1), (timer) {
        setState(() {
          if (_countdownNum > 0) {
            _codeCountdownStr = '${_countdownNum--}秒重新获取';
          } else {
            isVerifyCodeBtnDisable = false;
            _codeCountdownStr = '获取验证码';
            _countdownNum = 59;
            _countdownTimer.cancel();
            _countdownTimer = null;
          }
        });
      });
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _countdownTimer = null;
    super.dispose();
  }

  void switchPasswordOrMessage() {
    setState(() {
      isPassword = !isPassword;
    });
  }

  //TODO 获取验证码
  void _getVerifyCode() {
    reGetCountdown();
  }

  void usePasswordLogin() {
    if (phoneController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      if (!RegexUtil.isMobileExact(phoneController.text.toString())) {
        Toast.show("请输入正确的11位手机号", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
      } else {
        showLoadingDialog();
        DataUtils.doLoginUsePassword({
          'phonenumber': phoneController.text,
          'password': EnDecodeUtil.encodeMd5(passwordController.text)
        }).then((response) {
          hideLoadingDialog();
          if (response['success']) {
            Toast.show("登录成功", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
            UserInformation userInfo =
                UserInformation.fromJson(response['data']);
            Application.spUtil.putBool('login', true);
            Application.spUtil.putString('token', userInfo.user_token);
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => AppPage(true)),
                (route) => route == null);
          } else {
            Toast.show("登录失败：" + response['msg'], context,
                duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
          }
        });
      }
    } else {
      Toast.show("请完整填写账号和密码", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
    }
  }

  void useVerifyCodeLogin() async {}

  Container loadingDialog;

  showLoadingDialog() {
    setState(() {
      loadingDialog = new Container(
          constraints: BoxConstraints.expand(),
          color: Color(0x80000000),
          child: new Center(
            child: new CircularProgressIndicator(),
          ));
    });
  }

  hideLoadingDialog() {
    setState(() {
      loadingDialog = new Container();
    });
  }
}
