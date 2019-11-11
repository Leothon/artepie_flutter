import 'package:artepie/model/user_info.dart';
import 'package:artepie/routers/Application.dart';
import 'package:artepie/routers/routers.dart';
import 'package:artepie/utils/shared_preferences.dart';
import 'package:artepie/views/homePage/homePage.dart';
import 'package:artepie/views/loginPage/LoginPage.dart';
import 'package:event_bus/event_bus.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

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
  bool _isLoading = true;
  UserInformation _userInfo;

  //TODO 极光推送设置

  _MyAppState(){
    final eventBus = new EventBus();
    Application.event = eventBus;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(Application.spUtil.hasKey("login")){
      if(Application.spUtil.getBool("login")){
        //TODO 登录，显示登录情况,从数据库拿出数据
        setState(() {
          _hasLogin = true;
          _isLoading = false;
        });


      }else{
        setState(() {
          _hasLogin = false;
          _isLoading = false;
        });
      }
    }else{
      setState(() {
        _hasLogin = false;
        _isLoading = false;
      });
    }
  }

  showFirstPage(){
    if(_hasLogin){
      return HomePage(_userInfo,_hasLogin);
    }else{
      return LoginPage();
    }
  }

  @override
  Widget build(BuildContext context) {

    return new MaterialApp(

      home: showFirstPage(),


      onGenerateRoute: Application.router.generator,
//      navigatorObservers: <NavigatorObserver>[Analytics.observer],
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sp = await SpUtil.getInstance();

  runApp(new MyApp());

}
