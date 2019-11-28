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
}
