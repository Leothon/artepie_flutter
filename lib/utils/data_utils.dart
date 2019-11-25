import 'package:artepie/constants/api.dart';
import 'package:artepie/model/user_info.dart';
import 'package:artepie/utils/net_utils.dart';

class DataUtils{

  static Future doLoginUsePassword(Map<String,String> params) async {
    var response = await NetUtils.get(Api.usePasswordLogin, params);

    return response;

  }

  static Future getUserInfo(Map<String,String> params) async{
    return await NetUtils.get(Api.getUserInfo,params);
  }

  static Future getHomeData(Map<String,String> params) async{
    return await NetUtils.get(Api.getHomeData,params);
  }

  static Future getHomeMoreData(Map<String,String> params) async{
    return await NetUtils.get(Api.getHomeMoreData,params);
  }

  static Future getArticleData(Map<String,String> params) async{
    return await NetUtils.get(Api.getArticleData,params);
  }

  static Future getArticleMoreData(Map<String,String> params) async{
    return await NetUtils.get(Api.getArticleMoreData,params);
  }


  static Future getVideoData(Map<String,String> params) async{
    return await NetUtils.get(Api.getVideoData,params);
  }


  static Future getVideoMoreData(Map<String,String> params) async{
    return await NetUtils.get(Api.getVideoMoreData,params);
  }


  static Future getInform(Map<String,String> params) async{
    return await NetUtils.get(Api.getInform,params);
  }
}