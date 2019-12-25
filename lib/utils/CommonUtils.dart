import 'package:artepie/views/loginPage/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

class CommonUtils {


  static Future getPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String appName = packageInfo.appName;

    String packageName = packageInfo.packageName;

    String version = packageInfo.version;

    String buildNumber = packageInfo.buildNumber;

    Map<String, String> packageInfoResult = {
      'appName': appName,
      'packageName': packageName,
      'version': version,
      'buildNumber': buildNumber,
    };

    return packageInfoResult;
  }

  static int isVip(String authInfo){
    String role = authInfo.substring(0, 1);
    if (role == "0") {
      return 0;
    } else if (role == "1") {
      return 1;
    } else {
      return 2;
    }
  }

  static String msTomin(double ms) {
    return ((ms / 1000) / 60).toStringAsFixed(2);
  }


  static int daysBetween(DateTime a, DateTime b, [bool ignoreTime = false]) {
    if (ignoreTime) {
      int v = a.millisecondsSinceEpoch ~/ 86400000 -
          b.millisecondsSinceEpoch ~/ 86400000;
      if (v < 0) return -v;
      return v;
    } else {
      int v = a.millisecondsSinceEpoch - b.millisecondsSinceEpoch;
      if (v < 0) v = -v;
      return v ~/ 86400000;
    }
  }

  static String getAgeByBirthday(String birthday){
    if(birthday == ''){
      return birthday;
    }
    int days = daysBetween(DateTime.now(), DateTime.parse(birthday));
    double age = days / 365;
    return age.toStringAsFixed(0);
  }

  ///格式化文件大小
  static renderSize(double value) {
    if (null == value) {
      return 0;
    }
    List<String> unitArr = List()
      ..add('B')
      ..add('K')
      ..add('M')
      ..add('G');
    int index = 0;
    while (value > 1024) {
      index++;
      value = value / 1024;
    }
    String size = value.toStringAsFixed(2);
    return size + unitArr[index];
  }

  static toLogin(BuildContext context){
    showDialog<Null>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: new Text('提醒'),
            content: new SingleChildScrollView(
              child: new ListBody(
                children: <Widget>[
                  new Text('您尚未登录，请登录'),
                ],
              ),
            ),
            actions: <Widget>[

              new FlatButton(
                child: new Text('取消'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text('登录'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => LoginPage()),
                          (route) => route == null);
                },
              ),
            ],
          );
        });
  }

}
