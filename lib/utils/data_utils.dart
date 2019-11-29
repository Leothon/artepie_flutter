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

  static Future getTeacherData(Map<String,String> params) async{
    return await NetUtils.get(Api.getTeacherData,params);
  }


  static Future getTeacherMoreData(Map<String,String> params) async{
    return await NetUtils.get(Api.getTeacherMoreData,params);
  }


  static Future getTypeData(Map<String,String> params) async{
    return await NetUtils.get(Api.getTypeData,params);
  }


  static Future getTypeMoreData(Map<String,String> params) async{
    return await NetUtils.get(Api.getTypeMoreData,params);
  }


  static Future getClassDetail(Map<String,String> params) async{
    return await NetUtils.get(Api.getClassDetail,params);
  }


  static Future getMoreClassDetail(Map<String,String> params) async{
    return await NetUtils.get(Api.getMoreClassDetail,params);
  }


  static Future getArticleDetail(Map<String,String> params) async{
    return await NetUtils.get(Api.getArticleDetail,params);
  }


  static Future getVideoDetail(Map<String,String> params) async{
    return await NetUtils.get(Api.getVideoDetail,params);
  }


  static Future getVideoMoreComment(Map<String,String> params) async{
    return await NetUtils.get(Api.getVideoMoreComment,params);
  }


  static Future getPersonalVideo(Map<String,String> params) async{
    return await NetUtils.get(Api.getPersonalVideo,params);
  }


  static Future getPersonalArticle(Map<String,String> params) async{
    return await NetUtils.get(Api.getPersonalArticle,params);
  }
}