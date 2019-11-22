import 'package:artepie/model/user_info.dart';
import 'package:artepie/resource/MyColors.dart';
import 'package:artepie/utils/Adapt.dart';
import 'package:artepie/views/userIconWidget/UserIconWidget.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  final bool hasLogined;

  AboutPage(this.hasLogined);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _MyAboutPageState();
  }
}

class _MyAboutPageState extends State<AboutPage> {
  var _authorityInfo = '艺派客服';
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        backgroundColor: MyColors.dividerColor,
        body: new Stack(
          children: <Widget>[
            CustomScrollView(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: _headWidget(context),
                  ),
                  SliverToBoxAdapter(
                    child: _aboutItemWidget(
                        context,
                        Icon(
                          Icons.bookmark,
                          color: Colors.blue,
                        ),
                        '我的订阅',
                        false,
                        false),
                  ),
                  SliverToBoxAdapter(
                    child: _aboutItemWidget(
                        context,
                        Icon(
                          Icons.account_balance_wallet,
                          color: Colors.brown,
                        ),
                        '我的钱包',
                        true,
                        false),
                  ),
                  SliverToBoxAdapter(
                    child: _aboutItemWidget(
                        context,
                        Icon(
                          Icons.perm_contact_calendar,
                          color: Colors.deepPurple,
                        ),
                        '消息提醒',
                        true,
                        false),
                  ),
                  SliverToBoxAdapter(
                    child: _aboutItemWidget(
                        context,
                        Icon(
                          Icons.settings,
                          color: Colors.orange,
                        ),
                        '设置',
                        true,
                        false),
                  ),
                  SliverToBoxAdapter(
                    child: _aboutItemWidget(
                        context,
                        Icon(
                          Icons.info,
                          color: Colors.green,
                        ),
                        '关于我们',
                        false,
                        true),
                  ),
                ]),
            _searchWidget(context)
          ],
        ));
  }

  Widget _headWidget(BuildContext context) {
    return new Stack(
      children: <Widget>[
        new Column(
          children: <Widget>[
            Container(
              height: Adapt.px(340),
              width: double.infinity,
              child: Image.network(
                'http://www.artepie.cn/image/bannertest2.jpg',
                fit: BoxFit.cover,
              ),
              foregroundDecoration: BoxDecoration(
                color: MyColors.alphaWhite,
              ),
            ),
            Container(
              height: Adapt.px(200),
              width: double.infinity,
            )
          ],
        ),
        Container(
          height: Adapt.px(380),
          width: double.infinity,
          padding: EdgeInsets.all(Adapt.px(18)),
          margin: EdgeInsets.fromLTRB(0, Adapt.px(160), 0, 0),
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(Adapt.px(20)))),
            child: _userInfoWidget(context),
          ),
        )
      ],
    );
  }

  Widget _userInfoWidget(BuildContext context) {
    return new Container(
      padding: EdgeInsets.fromLTRB(Adapt.px(28), Adapt.px(14), Adapt.px(28), Adapt.px(14)),
      child: new Column(
        children: <Widget>[
          Expanded(
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: UserIconWidget(
                    url: 'http://www.artepie.cn/image/bannertest2.jpg',
                    size: Adapt.px(90),
                    isAuthor: true,
                    authority: true,
                  ),
                  flex: 1,
                ),
                Expanded(
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Text(
                        '艺派',
                        style: new TextStyle(
                          fontSize: Adapt.px(40),
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      new Text(
                        '认证：$_authorityInfo',
                        style: new TextStyle(
                          fontSize: Adapt.px(24),
                          color: MyColors.colorPrimary,
                        ),
                      )
                    ],
                  ),
                  flex: 2,
                ),
                Expanded(
                  child: new Text(
                    '个人主页 >',
                    textAlign: TextAlign.end,
                    style: new TextStyle(
                      fontSize: Adapt.px(26),
                      color: MyColors.fontColor,
                    ),
                  ),
                  flex: 2,
                ),
              ],
            ),
            flex: 1,
          ),
          Expanded(
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                _infoChildIcon(
                    context,
                    Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: Adapt.px(54),
                    ),
                    '我的收藏'),
                _infoChildIcon(
                    context,
                    Icon(
                      Icons.format_align_justify,
                      color: Colors.blue,
                      size: Adapt.px(54),
                    ),
                    '我的订单'),
                _infoChildIcon(
                    context,
                    Icon(
                      Icons.assignment_return,
                      color: Colors.orange,
                      size: Adapt.px(54),
                    ),
                    '我的发布'),
              ],
            ),
            flex: 1,
          )
        ],
      ),
    );
  }

  Widget _infoChildIcon(BuildContext context, Icon icon, String name) {
    return new Container(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          icon,
          new Text(
            name,
            style: new TextStyle(
              fontSize:  Adapt.px(22),
            ),
          )
        ],
      ),
    );
  }

  Widget _aboutItemWidget(BuildContext context, Icon icon, String name,
      bool isTopLine, bool isTopEmpty) {
    return new Container(
      color: Colors.white,
      margin: EdgeInsets.fromLTRB(0, isTopEmpty ?  Adapt.px(18) : 0, 0, 0),
      padding: EdgeInsets.fromLTRB( Adapt.px(16), 0, 0, 0),
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
                  child: Icon(Icons.arrow_forward_ios,size: Adapt.px(26),),
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

  Widget _searchWidget(BuildContext context) {
    return new Container(
      height: Adapt.px(160),
      child: new Stack(
        children: <Widget>[
          new AppBar(
            elevation: 0,
            brightness: Brightness.light,
            backgroundColor: Colors.transparent,
          ),
          new SafeArea(
              top: true,
              child: new Container(
                height: Adapt.px(80),
                child: new Container(
                  margin: EdgeInsets.fromLTRB(Adapt.px(40), Adapt.px(20), Adapt.px(40),0),
                  padding: EdgeInsets.fromLTRB(Adapt.px(18), 0, Adapt.px(18), 0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Adapt.px(80)),
                      color: Colors.white),
                  child: new Row(
                    children: <Widget>[
                      Icon(Icons.search),
                      new Padding(
                        padding: EdgeInsets.fromLTRB(Adapt.px(14), 0, Adapt.px(14), 0),
                        child: new Text('搜索艺派相关内容',style: new TextStyle(fontSize: Adapt.px(24)),),
                      )
                    ],
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
