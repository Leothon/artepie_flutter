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
}
