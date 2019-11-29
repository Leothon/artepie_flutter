import 'package:artepie/model/user_info.dart';
import 'package:artepie/resource/MyColors.dart';
import 'package:artepie/routers/Application.dart';
import 'package:artepie/utils/Adapt.dart';
import 'package:artepie/utils/CommonUtils.dart';
import 'package:artepie/utils/data_utils.dart';
import 'package:artepie/views/LoadStateLayout.dart';
import 'package:artepie/views/loginPage/LoginPage.dart';
import 'package:artepie/views/userIconWidget/UserIconWidget.dart';
import 'package:common_utils/common_utils.dart';
import 'package:fluro/fluro.dart';
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
  var _authorityInfo = '';
  var _userIconurl = '';
  var _userName = '';
  var _userSignal = '';

  bool _isAnthority = false;
  bool _isWriter = false;

  LoadState _layoutState = LoadState.State_Loading;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        backgroundColor: MyColors.dividerColor,
        body:LoadStateLayout(
          state: _layoutState,
          errorRetry: () {
            setState(() {
              _layoutState = LoadState.State_Loading;
            });
            loadUserInfo();
          },
          successWidget: _aboutPageWidget(context)
        ));
  }


  Widget _aboutPageWidget(BuildContext context){
    return new Stack(
      children: <Widget>[
        CustomScrollView(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: _headWidget(context),
              ),
//              SliverToBoxAdapter(
//                child: Material(
//                  color: Colors.white,
//                  child: InkWell(
//                    child: _aboutItemWidget(
//                        context,
//                        Image.asset(
//                          'lib/resource/assets/img/buy_about.png',
//                          width: Adapt.px(48),
//                          height: Adapt.px(48),
//                        ),
//                        '我的订阅',
//                        false),
//                    onTap: () {},
//                  ),
//                ),
//              ),
              SliverToBoxAdapter(
                child: Material(
                  color: Colors.white,
                  child: InkWell(
                    child: _aboutItemWidget(
                        context,
                        Image.asset(
                          'lib/resource/assets/img/bullet.png',
                          width: Adapt.px(48),
                          height: Adapt.px(48),
                        ),
                        '我的钱包',
                        true),
                    onTap: () {
                      Application.spUtil.get('login') ? '' : CommonUtils.toLogin(context);
                    },
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Material(
                  color: Colors.white,
                  child: InkWell(
                    child: _aboutItemWidget(
                        context,
                        Image.asset(
                          'lib/resource/assets/img/message.png',
                          width: Adapt.px(48),
                          height: Adapt.px(48),
                        ),
                        '消息提醒',
                        true),
                    onTap: () {
                      Application.spUtil.get('login') ? '' : CommonUtils.toLogin(context);
                    },
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Material(
                  color: Colors.white,
                  child: InkWell(
                    child: _aboutItemWidget(
                        context,
                        Image.asset(
                          'lib/resource/assets/img/settings.png',
                          width: Adapt.px(48),
                          height: Adapt.px(48),
                        ),
                        '设置',
                        true),
                    onTap: () {
                      Application.router.navigateTo(
                          context, "/settingsPage",
                          transition: TransitionType.material);
                    },
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                    margin: EdgeInsets.only(top: Adapt.px(25)),
                    child: Material(
                        color: Colors.white,
                        child: InkWell(
                          child: _aboutItemWidget(
                              context,
                              Image.asset(
                                'lib/resource/assets/img/about.png',
                                width: Adapt.px(48),
                                height: Adapt.px(48),
                              ),
                              '关于我们',
                              false),
                          onTap: () {
                            Application.router.navigateTo(
                                context, "/appInfoPage",
                                transition: TransitionType.material);
                          },
                        ))),
              ),
            ]),
        _searchWidget(context)
      ],
    );
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
                '$_userIconurl',
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
      padding: EdgeInsets.fromLTRB(
          Adapt.px(28), Adapt.px(14), Adapt.px(28), Adapt.px(14)),
      child: new Column(
        children: <Widget>[
          Expanded(
            child: InkWell(
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: UserIconWidget(
                      url: '$_userIconurl',
                      size: Adapt.px(90),
                      isAuthor: _isWriter,
                      authority: _isAnthority,
                    ),
                    flex: 1,
                  ),
                  Expanded(
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Text(
                          '$_userName',
                          style: new TextStyle(
                            fontSize: Adapt.px(40),
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        new Text(
                          _isAnthority ? '认证：$_authorityInfo' : '$_userSignal',
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
              onTap: () {
                Application.spUtil.get('login') ? Application.router.navigateTo(
                    context, "/personalPage",
                    transition: TransitionType.material) : CommonUtils.toLogin(context);
              },
            ),
            flex: 1,
          ),
          Expanded(
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                InkWell(
                  child: _infoChildIcon(
                      context,
                      Image.asset(
                        'lib/resource/assets/img/favicon.png',
                        width: Adapt.px(60),
                        height: Adapt.px(60),
                      ),
                      '我的收藏'),
                  onTap: () {
                    Application.spUtil.get('login') ? '' : CommonUtils.toLogin(context);
                  },
                ),
                InkWell(
                  child: _infoChildIcon(
                      context,
                      Image.asset(
                        'lib/resource/assets/img/order.png',
                        width: Adapt.px(60),
                        height: Adapt.px(60),
                      ),
                      '我的订单'),
                  onTap: () {
                    Application.spUtil.get('login') ? '' : CommonUtils.toLogin(context);
                  },
                ),
                InkWell(
                  child: _infoChildIcon(
                      context,
                      Image.asset(
                        'lib/resource/assets/img/buy_about.png',
                        width: Adapt.px(60),
                        height: Adapt.px(60),
                      ),
                      '我的订阅'),
                  onTap: () {
                    Application.spUtil.get('login') ? '' : CommonUtils.toLogin(context);
                  },
                ),
              ],
            ),
            flex: 1,
          )
        ],
      ),
    );
  }

  Widget _infoChildIcon(BuildContext context, Image image, String name) {
    return new Container(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          image,
          new Text(
            name,
            style: new TextStyle(
              fontSize: Adapt.px(22),
            ),
          )
        ],
      ),
    );
  }

  Widget _aboutItemWidget(
      BuildContext context, Image image, String name, bool isTopLine) {
    return new Container(
//      color: Colors.white,
      padding: EdgeInsets.fromLTRB(Adapt.px(16), 0, 0, 0),
      child: new Stack(
        children: <Widget>[
          new Container(
            height: Adapt.px(100),
            child: new Row(
              children: <Widget>[
                Expanded(
                  child: image,
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
                  margin: EdgeInsets.fromLTRB(
                      Adapt.px(40), Adapt.px(20), Adapt.px(40), 0),
                  padding:
                      EdgeInsets.fromLTRB(Adapt.px(18), 0, Adapt.px(18), 0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Adapt.px(80)),
                      color: Colors.white),
                  child: new Row(
                    children: <Widget>[
                      Icon(Icons.search),
                      new Padding(
                        padding: EdgeInsets.fromLTRB(
                            Adapt.px(14), 0, Adapt.px(14), 0),
                        child: new Text(
                          '搜索艺派相关内容',
                          style: new TextStyle(fontSize: Adapt.px(24)),
                        ),
                      )
                    ],
                  ),
                ),
              ))
        ],
      ),
    );
  }

  void loadUserInfo() {

    DataUtils.getUserInfo({'token' : Application.spUtil.get('token')}).then((result){

      var data = result['data'];

      if(data.length == 0){
        setState(() {
          _layoutState = LoadState.State_Empty;
        });

      }else{

        var role = CommonUtils.isVip(data['user_role']);
        var authorInfo = data['user_role'];
        if(role == 0){
          setState(() {
            _isAnthority = true;
            _isWriter = false;
            _authorityInfo = authorInfo.substring(1);
          });
        }else if(role == 1){
          setState(() {
            _isAnthority = true;
            _isWriter = true;
            _authorityInfo = authorInfo.substring(1);

          });
        }else{
          setState(() {
            _isAnthority = false;
            _isWriter = false;
            _userSignal = data['user_signal'];
          });
        }
        setState(() {
          _layoutState = LoadState.State_Success;
          _userIconurl = data['user_icon'];
          _userName = data['user_name'];
        });


      }
    }).catchError((onError) {
      LogUtil.e(onError);
      setState(() {
        _layoutState = LoadState.State_Error;
      });
    });
  }
}
