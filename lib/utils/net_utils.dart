import 'dart:io';
import 'package:artepie/constants/api.dart';
import 'package:common_utils/common_utils.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

//Map<String,dynamic> optHeader = {
//  'accept-language' : 'zh-cn',
//  'content-type' : 'application/json'
//};
//
//var dio = new Dio(BaseOptions(connectTimeout: 5000,headers: optHeader));


//BaseOptions options = BaseOptions(
//  baseUrl: Api.Base_URL,
//  connectTimeout: 5000,
//  receiveTimeout: 3000,
//);
//var dio = new Dio(options);
class NetUtils{
//  static Future get(String url,[Map<String,dynamic> params]) async {
//    var response;
//
//    Directory documentsDir = await getApplicationDocumentsDirectory();
//    String documentsPath = documentsDir.path;
//    var dir = new Directory("$documentsPath/cookies");
//    await dir.create();
//    dio.interceptors.add(CookieManager(PersistCookieJar(dir:dir.path)));
//    if(params != null){
//      response = await dio.get(url,queryParameters: params);
//    }else{
//      response = await dio.get(url);
//    }
//    return response.data;
//  }
//
//  static Future post(String url,Map<String,dynamic> params) async{
//    Directory documentsDir = await getApplicationDocumentsDirectory();
//    String documentsPath = documentsDir.path;
//    var dir = new Directory("$documentsPath/cookies");
//    await dir.create();
//    dio.interceptors.add(CookieManager(PersistCookieJar(dir: dir.path)));
//
//    var response = await dio.post(url,queryParameters: params);
//    return response.data;
//  }


  static NetUtils _instance;

  static NetUtils getInstance() {
    if (_instance == null) {
      _instance = NetUtils();
    }
    return _instance;
  }
  Dio dio = new Dio();
  NetUtils() {
    // Set default configs
    dio.options.headers = {
      "version":'2.0.9',
      "Authorization":'_token',
    };
    dio.options.baseUrl = Api.Base_URL;
    dio.options.connectTimeout = 5000;
    dio.options.receiveTimeout = 3000;
    dio.interceptors.add(LogInterceptor(responseBody: true)); //是否开启请求日志
    dio.interceptors.add(CookieManager(CookieJar()));//缓存相关类，具体设置见https://github.com/flutterchina/cookie_jar
  }

  //get请求
  get(String url,  [Map<String,dynamic> params]) async {
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

  //post请求
  post(String url, [Map<String,dynamic> params]) async {
    Directory documentsDir = await getApplicationDocumentsDirectory();
    String documentsPath = documentsDir.path;
    var dir = new Directory("$documentsPath/cookies");
    await dir.create();
    dio.interceptors.add(CookieManager(PersistCookieJar(dir: dir.path)));

    var response = await dio.post(url,queryParameters: params);
    return response.data;
  }

  postByJson(String url, String data) async {
    Directory documentsDir = await getApplicationDocumentsDirectory();
    String documentsPath = documentsDir.path;
    var dir = new Directory("$documentsPath/cookies");
    await dir.create();
    dio.interceptors.add(CookieManager(PersistCookieJar(dir: dir.path)));

    var response = await dio.post(url,data: data);
    return response.data;
  }

   Future ossPost(BuildContext context, url, {data, BaseOptions options,cancelToken}) async{

      LogUtil.v('启动post请求 url：$url ,body: $data');
      Response response;
      try {
//        if (url != null &&
//            (url.startsWith("http://") || url.startsWith("https://"))) {
//          dio = getDio(url: url,options: options);
//        }
        response = await dio.post(url, data: data, cancelToken: cancelToken);
        LogUtil.v('post请求成功 response.data：${response.toString()}');
      } on DioError catch (e) {
        if (CancelToken.isCancel(e)) {
          LogUtil.v('post请求取消:' + e.message);
        }
        LogUtil.v('post请求发生错误：$e');
      }
      return response.data; //response.data.toString()这种方式不是标准json,不能使用
  }
}
