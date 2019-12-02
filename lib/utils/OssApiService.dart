/*
 * 接口请求方法
 * 封装了传参方式及参数
 */


import 'dart:io';

import 'package:artepie/constants/api.dart';
import 'package:artepie/utils/OssUtils.dart';
import 'package:artepie/utils/net_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ApiService {
  /*
  * 获取OSS Token
  */
  static Future getOssToken(BuildContext context,
      {cancelToken}) async {
    return NetUtils.getInstance().ossPost(context, Api.URL_TOKEN, data: null, cancelToken: cancelToken);
  }

  static Future uploadImage(
      BuildContext context, String uploadName, String filePath,
      {cancelToken}) async {
    BaseOptions options = new BaseOptions();
    options.responseType = ResponseType.plain; //必须,否则上传失败后aliyun返回的提示信息(非JSON格式)看不到
    FormData data = new FormData.fromMap({
      'Filename': uploadName,//文件名，随意
      'key': uploadName, //"可以填写文件夹名（对应于oss服务中的文件夹）/" + fileName
      'policy': OssUtil.policy,
      'OSSAccessKeyId':OssUtil.accesskeyId,//Bucket 拥有者的AccessKeyId。
      'success_action_status': '200',//让服务端返回200，不然，默认会返回204
      'signature': OssUtil.instance.getSignature(OssUtil.accessKeySecret),
      'x-oss-security-token': OssUtil.stsToken,//临时用户授权时必须，需要携带后台返回的security-token
//      'file': await MultipartFile.fromFile(OssUtil.instance.getImageNameByPath(filePath))//必须放在参数最后
      'file': await MultipartFile.fromFile(filePath)//必须放在参数最后
    });
    return NetUtils.getInstance().ossPost(context, Api.URL_UPLOAD_IMAGE_OSS, data: data, options: options);
  }
}

