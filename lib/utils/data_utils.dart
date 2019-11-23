import 'package:artepie/constants/api.dart';
import 'package:artepie/model/user_info.dart';
import 'package:artepie/utils/net_utils.dart';

class DataUtils{

  /**
   * 使用密码账户登录
   */
  static Future doLoginUsePassword(Map<String,String> params) async {
    var response = await NetUtils.get(Api.usePasswordLogin, params);

    return response;

  }

  static Future getUserInfo(Map<String,String> params) async{
    return await NetUtils.get(Api.getUserInfo,params);
  }

  static Future test(Map<String,String> params) async{
    return await NetUtils.get(Api.test,params);
  }
}