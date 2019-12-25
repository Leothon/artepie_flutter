import 'dart:io';

import 'package:artepie/model/FeedbackInfo.dart';
import 'package:artepie/resource/MyColors.dart';
import 'package:artepie/routers/Application.dart';
import 'package:artepie/utils/Adapt.dart';
import 'package:artepie/utils/CommonUtils.dart';
import 'package:artepie/utils/data_utils.dart';
import 'package:common_utils/common_utils.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class FeedbackPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _feedbackPageState();
  }
}

class _feedbackPageState extends State<FeedbackPage> {
  TextEditingController textController = TextEditingController();

  String androidInfo = '';
  String iosInfo = '';

  String buildName = '';
  String buildCode = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDeviceInfo();
    CommonUtils.getPackageInfo().then((result){
      setState(() {
        buildName = result['version'];
        buildCode = result['buildNumber'];
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      backgroundColor: MyColors.dividerColor,
      body: new CustomScrollView(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          slivers: <Widget>[
            SliverAppBar(
              leading: new InkWell(
                child: Icon(
                  Icons.arrow_back,
                  color: MyColors.fontColor,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              backgroundColor: Colors.white,
              brightness: Brightness.light,
              title: new Text(
                '反馈意见',
                style: new TextStyle(
                    fontSize: Adapt.px(34), color: MyColors.fontColor),
              ),
              actions: <Widget>[
                new InkWell(
                  child: Container(
                    margin: EdgeInsets.only(right: Adapt.px(28)),
                    alignment: Alignment.center,
                    child: new Text(
                      '提交',
                      style: new TextStyle(
                          fontSize: Adapt.px(28), color: MyColors.fontColor),
                    ),
                  ),
                  onTap: () {
                    _sendFeedback();
                  },
                )
              ],
            ),
            SliverToBoxAdapter(
              child: new Container(
                color: MyColors.white,
                height: Adapt.px(460),
                margin: EdgeInsets.only(top: Adapt.px(26)),
                child: TextField(
                  keyboardType: TextInputType.phone,
                  controller: textController,
                  decoration: InputDecoration(
                      labelText: '请留下您的意见和建议',
                      labelStyle: new TextStyle(fontSize: Adapt.px(32)),
                      hintText: '请留下您的意见和建议',
                      hintStyle: new TextStyle(fontSize: Adapt.px(32)),
                      border: InputBorder.none),
                  //autofocus: true,
                ),
              ),
            ),
          ]),
    );
  }


  void _sendFeedback(){
    FeedbackInfo feedbackInfo = new FeedbackInfo(Application.spUtil.get('userid'),'flutter',buildName,Platform.isAndroid ? androidInfo : iosInfo,'',textController.text.toString(),buildCode);
    DataUtils.sendFeedback(feedbackInfo).then((result){
      if(result['']){};
      LogUtil.e(result);
      Toast.show("提交成功", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
      Navigator.of(context).pop();
    }).catchError((onError){
      LogUtil.e(onError);
    });
  }

  void getDeviceInfo() async{
    DeviceInfoPlugin deviceInfo = new DeviceInfoPlugin();
    if(Platform.isIOS){
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;

      setState(() {
        iosInfo = '${iosDeviceInfo.name} + ${iosDeviceInfo.systemName} + ${iosDeviceInfo.systemVersion} + ${iosDeviceInfo.model} + ${iosDeviceInfo.localizedModel} + ${iosDeviceInfo.identifierForVendor} + ${iosDeviceInfo.isPhysicalDevice} + ${iosDeviceInfo.utsname}';
      });
    }else if(Platform.isAndroid){
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      setState(() {
        androidInfo = '${androidDeviceInfo.version} + ${androidDeviceInfo.board} + ${androidDeviceInfo.bootloader} + ${androidDeviceInfo.brand} + ${androidDeviceInfo.device} + ${androidDeviceInfo.display} + ${androidDeviceInfo.fingerprint} + ${androidDeviceInfo.hardware} + ${androidDeviceInfo.host} + ${androidDeviceInfo.id} + ${androidDeviceInfo.manufacturer} + ${androidDeviceInfo.model} + ${androidDeviceInfo.product}';
      });
    }
  }
}
