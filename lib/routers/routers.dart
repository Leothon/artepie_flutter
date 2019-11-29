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


  static void configureRoutes(Router router){
    router.define(homePage, handler: homeHandler);
    router.define(loginPage, handler: loginHandler);
    router.define(appInfoPage, handler: appInfoHandler);
    router.define(teacherPage, handler: teacherPageHandler);
    router.define(typePage, handler: typePageHandler);
    router.define(classDetailPage, handler: classDetailPageHandler);
    router.define(addArticlePage, handler: addArticlePageHandler);
    router.define(articleDetailPage, handler: articleDetailPageHandler);
    router.define(videoDetailPage, handler: videoDetailPageHandler);
    router.define(personalPage, handler: personalPageHandler);
  }
}