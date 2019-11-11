import 'package:artepie/routers/router_handler.dart';
import 'package:fluro/fluro.dart';

class Routes{
  static String root = "/";
  static String homePage = "/homePage";
  static String loginPage = "/loginPage";
  
  static void configureRoutes(Router router){
    //List widgetDemos
    router.define(homePage, handler: homeHandler);
    router.define(loginPage, handler: loginHandler);
  }
}