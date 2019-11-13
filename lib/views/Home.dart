import 'package:artepie/model/user_info.dart';
import 'package:artepie/views/aboutPage/aboutPage.dart';
import 'package:artepie/views/articlePage/articlePage.dart';
import 'package:artepie/views/homePage/homePage.dart';
import 'package:artepie/views/videoPage/videoPage.dart';
import 'package:artepie/views/emptyPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppPage extends StatefulWidget {
  final UserInformation userInfo;
  final bool _hasLogin;
  AppPage(this.userInfo, this._hasLogin);

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
      ..add(HomePage(widget.userInfo, widget._hasLogin))
      ..add(ArticlePage(widget.userInfo, widget._hasLogin))
      ..add(EmptyPage())
      ..add(VideoPage(widget.userInfo, widget._hasLogin))
      ..add(AboutPage(widget.userInfo, widget._hasLogin));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
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
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          elevation: 0,
          onPressed: () {},
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        items: _myTabs,
        currentIndex: _currentIndex,
        onTap: _itemTapped,
        type: BottomNavigationBarType.fixed,
        fixedColor: Theme.of(context).primaryColor,
        backgroundColor: Colors.white,
      ),
    );
  }

  void _itemTapped(int index) {
    if (index == 2) return;

    setState(() {
      _currentIndex = index;
      appBarTitle = tabData[index]['text'];
    });
  }
}
