import 'package:artepie/model/user_info.dart';
import 'package:artepie/resource/MyColors.dart';
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
              height: 180,
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
              height: 120,
              width: double.infinity,
            )
          ],
        ),
        Container(
          height: 210,
          width: double.infinity,
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.fromLTRB(0, 90, 0, 0),
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            child: _userInfoWidget(context),
          ),
        )
      ],
    );
  }

  Widget _userInfoWidget(BuildContext context) {
    return new Container(
      padding: EdgeInsets.fromLTRB(15, 8, 15, 8),
      child: new Column(
        children: <Widget>[
          Expanded(
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: UserIconWidget(
                    url: 'http://www.artepie.cn/image/bannertest2.jpg',
                    size: 50,
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
                          fontSize: 22,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      new Text(
                        '认证：$_authorityInfo',
                        style: new TextStyle(
                          fontSize: 12,
                          color: MyColors.colorPrimary,
                        ),
                      )
                    ],
                  ),
                  flex: 3,
                ),
                Expanded(
                  child: new Text(
                    '个人主页 >',
                    textAlign: TextAlign.end,
                    style: new TextStyle(
                      fontSize: 14,
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
                      size: 28,
                    ),
                    '我的收藏'),
                _infoChildIcon(
                    context,
                    Icon(
                      Icons.format_align_justify,
                      color: Colors.blue,
                      size: 28,
                    ),
                    '我的订单'),
                _infoChildIcon(
                    context,
                    Icon(
                      Icons.assignment_return,
                      color: Colors.orange,
                      size: 28,
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
              fontSize: 12,
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
      margin: EdgeInsets.fromLTRB(0, isTopEmpty ? 10 : 0, 0, 0),
      padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
      child: new Stack(
        children: <Widget>[
          new Container(
            height: 50,
            child: new Row(
              children: <Widget>[
                Expanded(
                  child: icon,
                  flex: 1,
                ),
                Expanded(
                  child: new Text(
                    name,
                    style: new TextStyle(fontSize: 14),
                  ),
                  flex: 8,
                ),
                Expanded(
                  child: new Text('>',style: new TextStyle(fontSize: 18),),
                  flex: 1,
                )
              ],
            ),
          ),
          new Offstage(
            offstage: !isTopLine,
            child: Container(
              margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
              height: 1,
              color: MyColors.dividerColor,
            ),
          )
        ],
      ),
    );
  }

  Widget _searchWidget(BuildContext context) {
    return new Container(
      height: 86,
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
                height: 56.0,
                child: new Container(
                  margin: EdgeInsets.fromLTRB(25, 10, 25, 10),
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: Colors.white),
                  child: new Row(
                    children: <Widget>[
                      Icon(Icons.search),
                      new Padding(
                        padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                        child: new Text('搜索艺派相关内容'),
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
