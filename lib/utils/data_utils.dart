import 'package:artepie/constants/api.dart';
import 'package:artepie/model/FeedbackInfo.dart';
import 'package:artepie/model/user_info.dart';
import 'package:artepie/utils/net_utils.dart';
import 'package:common_utils/common_utils.dart';
import 'package:dio/dio.dart';

class DataUtils{

  static Future doLoginUsePassword(Map<String,String> params) async {
    var response = await NetUtils.getInstance().get(Api.usePasswordLogin, params);

    return response;

  }

  static Future getUserInfo(Map<String,String> params) async{
    return await NetUtils.getInstance().get(Api.getUserInfo,params);
  }

  static Future getUserInfoById(Map<String,String> params) async{
    return await NetUtils.getInstance().get(Api.getUserInfoById,params);
  }

  static Future getHomeData(Map<String,String> params) async{
    return await NetUtils.getInstance().get(Api.getHomeData,params);
  }

  static Future getHomeMoreData(Map<String,String> params) async{
    return await NetUtils.getInstance().get(Api.getHomeMoreData,params);
  }

  static Future getArticleData(Map<String,String> params) async{
    return await NetUtils.getInstance().get(Api.getArticleData,params);
  }

  static Future getArticleMoreData(Map<String,String> params) async{
    return await NetUtils.getInstance().get(Api.getArticleMoreData,params);
  }


  static Future getVideoData(Map<String,String> params) async{
    return await NetUtils.getInstance().get(Api.getVideoData,params);
  }


  static Future getVideoMoreData(Map<String,String> params) async{
    return await NetUtils.getInstance().get(Api.getVideoMoreData,params);
  }

  static Future addLikeVideo(Map<String,String> params) async{
    return await NetUtils.getInstance().post(Api.addLikeVideo,params);
  }
  static Future removeLikeVideo(Map<String,String> params) async{
    return await NetUtils.getInstance().post(Api.removeLikeVideo,params);
  }


  static Future getInform(Map<String,String> params) async{
    return await NetUtils.getInstance().get(Api.getInform,params);
  }

  static Future getTeacherData(Map<String,String> params) async{
    return await NetUtils.getInstance().get(Api.getTeacherData,params);
  }


  static Future getTeacherMoreData(Map<String,String> params) async{
    return await NetUtils.getInstance().get(Api.getTeacherMoreData,params);
  }


  static Future getTypeData(Map<String,String> params) async{
    return await NetUtils.getInstance().get(Api.getTypeData,params);
  }


  static Future getTypeMoreData(Map<String,String> params) async{
    return await NetUtils.getInstance().get(Api.getTypeMoreData,params);
  }


  static Future getClassDetail(Map<String,String> params) async{
    return await NetUtils.getInstance().get(Api.getClassDetail,params);
  }


  static Future getMoreClassDetail(Map<String,String> params) async{
    return await NetUtils.getInstance().get(Api.getMoreClassDetail,params);
  }


  static Future getArticleDetail(Map<String,String> params) async{
    return await NetUtils.getInstance().get(Api.getArticleDetail,params);
  }


  static Future getVideoDetail(Map<String,String> params) async{
    return await NetUtils.getInstance().get(Api.getVideoDetail,params);
  }


  static Future getVideoMoreComment(Map<String,String> params) async{
    return await NetUtils.getInstance().get(Api.getVideoMoreComment,params);
  }


  static Future getPersonalVideo(Map<String,String> params) async{
    return await NetUtils.getInstance().get(Api.getPersonalVideo,params);
  }


  static Future getPersonalArticle(Map<String,String> params) async{
    return await NetUtils.getInstance().get(Api.getPersonalArticle,params);
  }

  static Future getCommentInfo(Map<String,String> params) async{
    return await NetUtils.getInstance().get(Api.getCommentInfo,params);
  }


  static Future getCommentReplyInfo(Map<String,String> params) async{
    return await NetUtils.getInstance().get(Api.getCommentReply,params);
  }


  static Future getNotice(Map<String,String> params) async{
    return await NetUtils.getInstance().get(Api.getNotice,params);
  }

  static Future getFav(Map<String,String> params) async{
    return await NetUtils.getInstance().get(Api.getFav,params);
  }

  static Future unFav(Map<String,String> params) async{

    return await NetUtils.getInstance().post(Api.unFav,params);
  }

  static Future favClass(Map<String,String> params) async{

    return await NetUtils.getInstance().post(Api.favClass,params);
  }

  static Future getBuyClass(Map<String,String> params) async{

    return await NetUtils.getInstance().get(Api.getBuyClass,params);
  }

  static Future getOrder(Map<String,String> params) async{

    return await NetUtils.getInstance().get(Api.getOrder,params);
  }


  static Future sendFeedback(FeedbackInfo feedbackInfo) async{

    return await NetUtils.getInstance().postByJson(Api.sendFeedback,feedbackInfo.toJson());
  }

  static Future updateUserInfo(UserInformation userInformation) async{

    return await NetUtils.getInstance().postByJson(Api.updateUserInfo,userInformation.toJson());
  }

  static Future deleteArticle(Map<String,String> params) async{

    return await NetUtils.getInstance().post(Api.deleteArticle,params);
  }

  static Future likeArticle(Map<String,String> params) async{

    return await NetUtils.getInstance().post(Api.likeArticle,params);
  }

  static Future unlikeArticle(Map<String,String> params) async{

    return await NetUtils.getInstance().post(Api.unlikeArticle,params);
  }

  static Future getArticleComment(Map<String,String> params) async{

    return await NetUtils.getInstance().get(Api.getArticleComment,params);
  }
}