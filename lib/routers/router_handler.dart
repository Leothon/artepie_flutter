import 'package:artepie/views/ArticleDetailPage/articleDetailPage.dart';
import 'package:artepie/views/Home.dart';
import 'package:artepie/views/addArticlePage/addArticlePage.dart';
import 'package:artepie/views/artepieInfoPage/artepieInfoPage.dart';
import 'package:artepie/views/classDetailPage/ClassDetailPage.dart';
import 'package:artepie/views/loginPage/LoginPage.dart';
import 'package:artepie/views/teacherPage/teacherPage.dart';
import 'package:artepie/views/typePage/TypePage.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:artepie/model/user_info.dart';

var homeHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    bool hasLogined = params['hasLogin']?.first == "true";
    return new AppPage(hasLogined);
  },
);

var loginHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return new LoginPage();
  },
);

var appInfoHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return new artepieInfoPage();
  },
);

var teacherPageHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    String _teacherId = params['teacherId'].first;
    return new TeacherPage(_teacherId);
  },
);

var typePageHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    String _type = params['type'].first;
    return new TypePage(_type);
  },
);

var classDetailPageHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    String _classid = params['classid'].first;
    return new ClassDetailPage(_classid);
  },
);


var addArticlePageHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return new addAriclePage();
  },
);


var articleDetailPageHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    String _articleid = params['articleid'].first;
    return new articleDetailPage(_articleid);
  },
);