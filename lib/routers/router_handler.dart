import 'package:artepie/views/Home.dart';
import 'package:artepie/views/loginPage/LoginPage.dart';
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
