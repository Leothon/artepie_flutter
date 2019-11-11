import 'package:artepie/api/api.dart';
import 'package:artepie/model/user_info.dart';
import 'package:artepie/utils/net_utils.dart';

class DataUtils{

  /**
   * 使用密码账户登录
   */
  static Future doLoginUsePassword(Map<String,String> params) async {
    var response = await NetUtils.get(Api.usePasswordLogin, params);
    try{
      UserInformation userInfo = UserInformation.fromJson(response['data']);
      return userInfo;
    }catch (err){
      return response['message'];
    }
  }

}