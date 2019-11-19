import 'dart:io';

import 'package:artepie/model/user_info.dart';
import 'package:artepie/routers/Application.dart';
import 'package:artepie/routers/routers.dart';
import 'package:artepie/utils/shared_preferences.dart';
import 'package:artepie/views/homePage/homePage.dart';
import 'package:artepie/views/loginPage/LoginPage.dart';
import 'package:common_utils/common_utils.dart';
import 'package:event_bus/event_bus.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:artepie/views/Home.dart';
import 'package:flutter/services.dart';

SpUtil sp;

class MyApp extends StatefulWidget {

  MyApp(){
    final router = new Router();
    Routes.configureRoutes(router);
    Application.router = router;
  }
  @override
  State<StatefulWidget> createState() {
    return new _MyAppState();
  }
}


class _MyAppState extends State<MyApp> {

  bool _hasLogin = false;

  //TODO 极光推送设置

  _MyAppState(){
    final eventBus = new EventBus();
    Application.event = eventBus;
  }

  @override
  void initState() {
    super.initState();
    if(Application.spUtil.hasKey("login")){
      if(Application.spUtil.getBool("login")){
        //TODO 登录，显示登录情况,从数据库拿出数据
        setState(() {
          _hasLogin = true;
        });


      }else{
        setState(() {
          _hasLogin = false;
        });
      }
    }else{
      setState(() {
        _hasLogin = false;
      });
    }
  }

  showFirstPage(){
    if(_hasLogin){
      return AppPage(_hasLogin);
    }else{
      return LoginPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    int lastTime = 0;

    return AnnotatedRegion<SystemUiOverlayStyle>(

        value: SystemUiOverlayStyle.dark,
        child: MaterialApp(
          home: showFirstPage(),
          onGenerateRoute: Application.router.generator,


        ),





//      onWillPop: () {
//          int newTime = DateTime.now().millisecondsSinceEpoch;
//          int result = newTime - lastTime;
//          lastTime = newTime;
//          if (result > 2000) {
//            Fluttertoast.showToast(msg: "再按一次退出",
//                toastLength: Toast.LENGTH_SHORT,
//                gravity: ToastGravity.BOTTOM,
//                timeInSecForIos: 1);
//          } else {
//            SystemNavigator.pop();
//          }
//          return null;
//        }
        //navigatorObservers: <NavigatorObserver>[Analytics.observer],
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  sp = await SpUtil.getInstance();
  Application.spUtil = sp;
  runApp(new MyApp());
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    );
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}
