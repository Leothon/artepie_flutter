import 'package:artepie/model/user_info.dart';
import 'package:artepie/resource/MyColors.dart';
import 'package:artepie/routers/Application.dart';
import 'package:artepie/views/aboutPage/aboutPage.dart';
import 'package:artepie/views/articlePage/articlePage.dart';
import 'package:artepie/views/homePage/homePage.dart';
import 'package:artepie/views/videoPage/videoPage.dart';
import 'package:artepie/views/emptyPage.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppPage extends StatefulWidget {
  //final UserInformation userInfo;
  final bool _hasLogin;
  AppPage(this._hasLogin);

  @override
  State<StatefulWidget> createState() {
    return _MyAppPageState();
  }
}

class _MyAppPageState extends State<AppPage> {
  List<Widget> _widgetList = List();
  int _currentIndex = 0;
  List tabData = [
    {'text': '首页', 'icon': Icon(Icons.audiotrack)},
    {'text': '艺条', 'icon': Icon(Icons.library_books)},
    {'text': '发布', 'icon': Icon(Icons.remove)},
    {'text': '秀吧', 'icon': Icon(Icons.ondemand_video)},
    {'text': '我的', 'icon': Icon(Icons.account_circle)},
  ];
  List<BottomNavigationBarItem> _myTabs = [];
  String appBarTitle;

  List<String> addIconItems = <String>['录课程', '发文章', '秀吧拍', '开直播'];
  List<Icon> addIcon = [
    Icon(Icons.videocam, color: Colors.white),
    Icon(Icons.library_books, color: Colors.white),
    Icon(Icons.ondemand_video, color: Colors.white),
    Icon(Icons.live_tv, color: Colors.white)
  ];

  List<Color> addIconColors = [
    Colors.lightGreen,
    Colors.blue,
    Colors.red,
    Colors.deepOrange
  ];
  bool addbackShow = false;
  @override
  void initState() {
    super.initState();
    appBarTitle = tabData[0]['text'];
    for (int i = 0; i < tabData.length; i++) {
      _myTabs.add(BottomNavigationBarItem(
        icon: tabData[i]['icon'],
        title: Text(
          tabData[i]['text'],
        ),
      ));
    }

    _widgetList
      ..add(HomePage(widget._hasLogin))
      ..add(ArticlePage(widget._hasLogin))
      ..add(EmptyPage())
      ..add(VideoPage(widget._hasLogin))
      ..add(AboutPage(widget._hasLogin));
  }

  @override
  void dispose() {
    super.dispose();
  }




  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Stack(
      children: <Widget>[
        Container(
            foregroundDecoration: BoxDecoration(
                color: addbackShow ? MyColors.alphaWhite : Colors.transparent),
            child: Scaffold(
              body: IndexedStack(
                index: _currentIndex,
                children: _widgetList,
              ),
              floatingActionButton: Container(
                height: 65,
                width: 65,

                padding: EdgeInsets.all(8),
                margin: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: Colors.white,
                ),
                child: FloatingActionButton(
                  backgroundColor: MyColors.colorPrimary,
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  elevation: 0,
                  onPressed: () {
                    if (addbackShow) {
                      _setAddBackshow(false);
                    } else {
                      _setAddBackshow(true);
                    }
                  },
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              bottomNavigationBar: BottomNavigationBar(
                items: _myTabs,
                currentIndex: _currentIndex,
                onTap: _itemTapped,
                type: BottomNavigationBarType.fixed,
                fixedColor: MyColors.colorPrimary,
                backgroundColor: Colors.white,
                elevation: 0,
              ),
            )),
        AnimatedSwitcher(
          transitionBuilder: (child,anim){
            return FadeTransition(opacity: anim,child: child);
          },
          duration: Duration(milliseconds: 200),
          child: _addWidget(context),
        )
        
      ],
    );
  }

  void _setAddBackshow(bool show) {
    setState(() {
      addbackShow = show;
      () => opacityLevel = opacityLevel == 0? 1.0 : 0.0;
    });
  }

  void _itemTapped(int index) {
    if (index == 2) return;

    setState(() {
      _currentIndex = index;
      appBarTitle = tabData[index]['text'];
    });
  }

  double opacityLevel = 1.0;

  Widget _addWidget(BuildContext context) {
    if (addbackShow) {
      return new Scaffold(
          backgroundColor: Colors.transparent,
          body: new Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new Container(),
                  new Container(),
                  new Container(),
                  new Container(),
                  new Container(),
                  new Container(),
                  new Container(),
                  new Container(),
                  new Container(),
                  new Container(),
                  new Container(),
                  new Container(),
                  new Container(),
                  new Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
                    child: new Container(
                      height: 120,
                      child: new CustomScrollView(
                        physics: BouncingScrollPhysics(),
                        slivers: <Widget>[
                          new SliverPadding(
                            padding: EdgeInsets.all(0.0),
                            sliver: new SliverList(
                              delegate: new SliverChildListDelegate(<Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    _addIconWidget(context, 0),
                                    _addIconWidget(context, 1),
                                    _addIconWidget(context, 2),
                                    _addIconWidget(context, 3),
                                  ],
                                )
                              ]),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  new Center(
                      child: GestureDetector(
                          child: new Padding(
                            padding: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
                            child: Icon(
                              Icons.clear,
                              size: 25,
                            ),
                          ),
                          onTap: () {
                            _setAddBackshow(false);
//                      Navigator.pop(context);
                          }))
                ],
              ),
            ),
          );
    } else {
      return Container(
        width: 0,
        height: 0,
      );
    }
  }

  Widget _addIconWidget(BuildContext context, int index) {
    return new Column(
      children: <Widget>[
        new Container(
          height: 50.0,
          width: 50.0,
          padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
          margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            color: addIconColors[index],
          ),
          child: addIcon[index],
        ),
        new Text(addIconItems[index],
            style: new TextStyle(
              color: Colors.black,
            )),
      ],
    );
  }
}
