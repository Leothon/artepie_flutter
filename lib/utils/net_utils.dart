import 'dart:io';
import 'package:artepie/constants/api.dart';
import 'package:common_utils/common_utils.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';

//Map<String,dynamic> optHeader = {
//  'accept-language' : 'zh-cn',
//  'content-type' : 'application/json'
//};
//
//var dio = new Dio(BaseOptions(connectTimeout: 5000,headers: optHeader));


BaseOptions options = BaseOptions(
  baseUrl: Api.Base_URL,
  connectTimeout: 5000,
  receiveTimeout: 3000,
);
var dio = new Dio(options);
class NetUtils{
  static Future get(String url,[Map<String,dynamic> params]) async {
    var response;

    Directory documentsDir = await getApplicationDocumentsDirectory();
    String documentsPath = documentsDir.path;
    var dir = new Directory("$documentsPath/cookies");
    await dir.create();
    dio.interceptors.add(CookieManager(PersistCookieJar(dir:dir.path)));
    if(params != null){
      response = await dio.get(url,queryParameters: params);
    }else{
      response = await dio.get(url);
    }
    return response.data;
  }

  static Future post(String url,Map<String,dynamic> params) async{
    Directory documentsDir = await getApplicationDocumentsDirectory();
    String documentsPath = documentsDir.path;
    var dir = new Directory("$documentsPath/cookies");
    await dir.create();
    dio.interceptors.add(CookieManager(PersistCookieJar(dir: dir.path)));

    var response = await dio.post(url,queryParameters: params);
    return response.data;
  }
}