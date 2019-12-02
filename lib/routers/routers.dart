import 'package:artepie/routers/router_handler.dart';
import 'package:fluro/fluro.dart';

class Routes{
  static String root = "/";
  static String homePage = "/homePage";
  static String loginPage = "/loginPage";
  static String appInfoPage = "/appInfoPage";
  static String teacherPage = "/teacherPage";
  static String typePage = "/typePage";
  static String classDetailPage = "/classDetailPage";
  static String addArticlePage = "/addArticlePage";
  static String articleDetailPage = "/articleDetailPage";
  static String videoDetailPage = "/videoDetailPage";
  static String personalPage = "/personalPage";
  static String settingsPage = "/settingsPage";
  static String commentDetailPage = "/commentDetailPage";
  static String noticePage = "/noticePage";
  static String favPage = "/favPage";
  static String buyPage = "/buyPage";
  static String orderPage = "/orderPage";
  static String webPage = "/webPage";
  static String editPersonalPage = "/editPersonalPage";
  static String feedbackPage = "/feedbackPage";



  static void configureRoutes(Router router){
    router.define(homePage, handler: homeHandler);
    router.define(loginPage, handler: loginHandler);
    router.define(appInfoPage, handler: appInfoHandler);
    router.define(teacherPage, handler: teacherPageHandler);
    router.define(typePage, handler: typePageHandler);
    router.define(classDetailPage, handler: classDetailPageHandler);
//    router.define(addArticlePage, handler: addArticlePageHandler);
    router.define(articleDetailPage, handler: articleDetailPageHandler);
    router.define(videoDetailPage, handler: videoDetailPageHandler);
    router.define(personalPage, handler: personalPageHandler);
    router.define(settingsPage, handler: settingsPageHandler);
    router.define(commentDetailPage, handler: commentDetailPageHandler);
    router.define(noticePage, handler: noticePageHandler);
    router.define(favPage, handler: favPageHandler);
    router.define(buyPage, handler: buyPageHandler);
    router.define(orderPage, handler: orderPageHandler);
    router.define(webPage, handler: webPageHandler);
    router.define(feedbackPage, handler: feedbackPageHandler);
  }
}