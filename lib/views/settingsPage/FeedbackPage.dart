import 'package:artepie/model/FeedbackInfo.dart';
import 'package:artepie/resource/MyColors.dart';
import 'package:artepie/routers/Application.dart';
import 'package:artepie/utils/Adapt.dart';
import 'package:artepie/utils/data_utils.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';

class FeedbackPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _feedbackPageState();
  }
}

class _feedbackPageState extends State<FeedbackPage> {
  TextEditingController textController = TextEditingController();

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
    FeedbackInfo feedbackInfo = new FeedbackInfo(Application.spUtil.get('userid'),'','buildApi','机器厂商','机器型号',textController.toString(),'版本号');
    DataUtils.sendFeedback(feedbackInfo).then((result){
      if(result['']){};
      LogUtil.e(result);
    }).catchError((onError){
      LogUtil.e(onError);
    });
  }
}
