import 'package:artepie/resource/MyColors.dart';
import 'package:artepie/utils/Adapt.dart';
import 'package:artepie/utils/CommonUtils.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

class artepieInfoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _artepieInfoState();
  }
}

class _artepieInfoState extends State<artepieInfoPage> {
  var _nowYear = '';
  var _versionName = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DateTime now = new DateTime.now();
    setState(() {
      _nowYear = '${now.year}';
    });

    CommonUtils.getPackageInfo().then((result) {
      LogUtil.e(result);
      setState(() {
        _versionName = result['version'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      backgroundColor: Colors.white,
      body: new CustomScrollView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        slivers: <Widget>[
          SliverAppBar(
            leading: GestureDetector(
              child: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onTap: () => Navigator.pop(context),
            ),
            title: new Text(
              '关于我们',
              style: new TextStyle(fontSize: Adapt.px(34), color: Colors.black),
            ),
            pinned: true,
            backgroundColor: Colors.white,
            brightness: Brightness.light,
            elevation: 3,
            forceElevated: true,
          ),
          SliverToBoxAdapter(
              child: new Container(
                  margin: EdgeInsets.only(top: Adapt.px(40)),
                  child: Column(children: <Widget>[
                    Image.asset(
                      'lib/resource/assets/img/icon.png',
                      width: Adapt.px(280),
                      height: Adapt.px(280),
                    ),
                    Padding(
                      padding: EdgeInsets.all(Adapt.px(25)),
                      child: new Text(
                        '艺派，是一所没有围墙的创新型艺术大学。将联手国内各大智慧艺术教育家推出在线视频学习、直播、问答等功能，让每个艺术爱好者都能获得公平、优质、专业的学习资源。',
                        textAlign: TextAlign.center,
                        style: new TextStyle(
                            fontSize: Adapt.px(28), color: MyColors.fontColor),
                      ),
                    )
                  ]))),
          SliverToBoxAdapter(
            child: new Container(
              height: Adapt.px(100),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new Offstage(
                    offstage: false,
                    child: Container(
                      height: Adapt.px(1.8),
                      color: MyColors.dividerColor,
                    ),
                  ),
                  new Container(
                    child: new Text(
                      '联系我们',
                      style: new TextStyle(fontSize: Adapt.px(32)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: InkWell(
              child: _infoItemWidget(context, Icon(Icons.phone), '联系电话:(010)5338 1318', true),
              onTap: (){_launchUrl('tel:010-53381318');}
            )

          ),
          SliverToBoxAdapter(

            child: InkWell(
              child:  _infoItemWidget(context, Icon(Icons.link), '访问官网', true),
              onTap: (){
                _launchUrl('http://www.artepie.cn');
              },
            ),
          ),
          SliverToBoxAdapter(
            child: InkWell(
              child: _infoItemWidget(context, Icon(Icons.email), '发送邮件', true),
              onTap: (){
                _launchUrl('mailto:cogitotec@163.com');
              },
            )
          ),
          SliverToBoxAdapter(
            child: InkWell(
              child: new Container(
                padding: EdgeInsets.fromLTRB(Adapt.px(16), 0, 0, 0),
                child: new Stack(
                  children: <Widget>[
                    new Container(
                      height: Adapt.px(110),
                      child: new Row(
                        children: <Widget>[
                          Expanded(
                            child: Icon(Icons.headset_mic),
                            flex: 1,
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(right: Adapt.px(16)),
                              child: new Text(
                                '为了更好更快的帮您解决问题，请在邮件中留下电话、艺派账号、昵称、相关截图、详细问题等信息。',
                                style: new TextStyle(fontSize: Adapt.px(26)),
                              ),
                            ),
                            flex: 9,
                          ),
                        ],
                      ),
                    ),
                    new Offstage(
                      offstage: false,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(Adapt.px(48), 0, 0, 0),
                        height: Adapt.px(1.8),
                        color: MyColors.dividerColor,
                      ),
                    ),
                  ],
                ),
              ),
              onTap: (){},
            )
          ),
          SliverToBoxAdapter(
            child: new Container(
              child: new Column(
                children: <Widget>[
                  Container(
                    height: Adapt.px(1.8),
                    color: MyColors.dividerColor,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: Adapt.px(40)),
                    child: new Text('叮点科技(北京)有限公司版权所有'),
                  ),
                  Padding(
                      padding: EdgeInsets.all(Adapt.px(20)),
                      child: new Text(
                          'Copyright©2018-$_nowYear   版本号 V$_versionName'))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _infoItemWidget(
      BuildContext context, Icon icon, String name, bool isTopLine) {
    return new Container(
      padding: EdgeInsets.fromLTRB(Adapt.px(16), 0, 0, 0),
      child: new Stack(
        children: <Widget>[
          new Container(
            height: Adapt.px(90),
            child: new Row(
              children: <Widget>[
                Expanded(
                  child: icon,
                  flex: 1,
                ),
                Expanded(
                  child: new Text(
                    name,
                    style: new TextStyle(fontSize: Adapt.px(26)),
                  ),
                  flex: 8,
                ),
                Expanded(
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: Adapt.px(26),
                  ),
                  flex: 1,
                )
              ],
            ),
          ),
          new Offstage(
            offstage: !isTopLine,
            child: Container(
              margin: EdgeInsets.fromLTRB(Adapt.px(48), 0, 0, 0),
              height: Adapt.px(1.8),
              color: MyColors.dividerColor,
            ),
          )
        ],
      ),
    );
  }

  void _launchUrl(String url) async {


    await launch(url);

  }


}
