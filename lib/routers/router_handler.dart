import 'package:artepie/views/ArticleDetailPage/articleDetailPage.dart';
import 'package:artepie/views/Home.dart';
import 'package:artepie/views/WebPage/WebPage.dart';
import 'package:artepie/views/addArticlePage/addArticlePage.dart';
import 'package:artepie/views/artepieInfoPage/artepieInfoPage.dart';
import 'package:artepie/views/buyPage/buyPage.dart';
import 'package:artepie/views/classDetailPage/ClassDetailPage.dart';
import 'package:artepie/views/editPersonalPage/EditPersonalPage.dart';
import 'package:artepie/views/favPage/FavPage.dart';
import 'package:artepie/views/loginPage/LoginPage.dart';
import 'package:artepie/views/noticePage/NoticePage.dart';
import 'package:artepie/views/orderPage/OrderPage.dart';
import 'package:artepie/views/personalPage/PersonalPage.dart';
import 'package:artepie/views/settingsPage/FeedbackPage.dart';
import 'package:artepie/views/settingsPage/SettingsPage.dart';
import 'package:artepie/views/teacherPage/teacherPage.dart';
import 'package:artepie/views/typePage/TypePage.dart';
import 'package:artepie/views/videoDetailPage/commentDetailPage.dart';
import 'package:artepie/views/videoDetailPage/videoDetailPage.dart';
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


//var addArticlePageHandler = new Handler(
//  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
//    return new addAriclePage();
//  },
//);


var articleDetailPageHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    String _articleid = params['articleid'].first;
    return new articleDetailPage(_articleid);
  },
);


var videoDetailPageHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    String _videoid = params['videoid'].first;
    return new VideoDetailPage(_videoid);
  },
);


var personalPageHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return new PersonalPage();
  },
);


var settingsPageHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return new SettingsPage();
  },
);


var commentDetailPageHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    String _commentid = params['commentid'].first;
    return new CommentDetailPage(_commentid);
  },
);

var noticePageHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return new NoticePage();
  },
);

var favPageHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return new FavPage();
  },
);


var buyPageHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return new BuyPage();
  },
);

var orderPageHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return new OrderPage();
  },
);

var webPageHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    String _url = params['url'].first;
    return new WebPage( _url);
  },
);

var editPersonalPageHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return new EditPersonalPage();
  },
);

var feedbackPageHandler = new Handler(
  handlerFunc: (BuildContext context, Map<String, List<String>> params) {
    return new FeedbackPage();
  },
);