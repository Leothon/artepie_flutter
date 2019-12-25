import 'dart:io';

import 'package:artepie/resource/MyColors.dart';
import 'package:artepie/routers/Application.dart';
import 'package:artepie/routers/routers.dart';
import 'package:artepie/utils/Adapt.dart';
import 'package:artepie/utils/CommonUtils.dart';
import 'package:artepie/views/loginPage/LoginPage.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:toast/toast.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _settingsPage();
  }
}

class _settingsPage extends State<SettingsPage> {
  var _cacheSizeStr = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadCache();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      backgroundColor: MyColors.dividerColor,
      appBar: new AppBar(
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        title: new Text(
          '设置',
          style:
              new TextStyle(fontSize: Adapt.px(36), color: MyColors.fontColor),
        ),
        leading: new InkWell(
          child: Icon(
            Icons.arrow_back,
            color: MyColors.fontColor,
          ),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: new CustomScrollView(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: new InkWell(
                child: Container(
                  height: Adapt.px(110),
                  color: Colors.white,
                  margin: EdgeInsets.only(top: Adapt.px(18)),
                  padding:
                      EdgeInsets.only(left: Adapt.px(28), right: Adapt.px(28)),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Text(
                        '消息设置',
                        style: new TextStyle(
                            fontSize: Adapt.px(28),
                            color: MyColors.lowfontColor),
                      ),
                      Icon(Icons.keyboard_arrow_right,
                          color: MyColors.lowfontColor)
                    ],
                  ),
                ),
                onTap: () {
                  Application.spUtil.get('login') ? '' : CommonUtils.toLogin(context);
                },
              ),
            ),
            SliverToBoxAdapter(
              child: new InkWell(
                child: Container(
                  height: Adapt.px(110),
                  color: Colors.white,
                  margin: EdgeInsets.only(top: Adapt.px(40)),
                  padding:
                      EdgeInsets.only(left: Adapt.px(28), right: Adapt.px(28)),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Text(
                        '意见反馈',
                        style: new TextStyle(
                            fontSize: Adapt.px(28),
                            color: MyColors.lowfontColor),
                      ),
                      Icon(Icons.keyboard_arrow_right,
                          color: MyColors.lowfontColor)
                    ],
                  ),
                ),
                onTap: () {
                  Application.spUtil.get('login') ? Application.router.navigateTo(context,
                      '${Routes.feedbackPage}',
                      transition: TransitionType.fadeIn) : CommonUtils.toLogin(context);
                },
              ),
            ),
            SliverToBoxAdapter(
                child: new InkWell(
              child: Container(
                height: Adapt.px(110),
                color: Colors.white,
                margin: EdgeInsets.only(top: Adapt.px(2)),
                padding:
                    EdgeInsets.only(left: Adapt.px(28), right: Adapt.px(28)),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Text(
                      '清除缓存',
                      style: new TextStyle(
                          fontSize: Adapt.px(28), color: MyColors.lowfontColor),
                    ),
                    new Text(
                      _cacheSizeStr,
                      style: new TextStyle(
                          fontSize: Adapt.px(20), color: MyColors.lowfontColor),
                    ),
                  ],
                ),
              ),
              onTap: () {
                _clearCache();
              },
            )),
            SliverToBoxAdapter(
              child: new InkWell(
                child: Container(
                  height: Adapt.px(110),
                  color: Colors.white,
                  margin: EdgeInsets.only(top: Adapt.px(2)),
                  padding:
                      EdgeInsets.only(left: Adapt.px(28), right: Adapt.px(28)),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Text(
                        '检查更新',
                        style: new TextStyle(
                            fontSize: Adapt.px(28),
                            color: MyColors.lowfontColor),
                      ),
                      new Text(
                        '已是最新版本',
                        style: new TextStyle(
                            fontSize: Adapt.px(20),
                            color: MyColors.lowfontColor),
                      ),
                    ],
                  ),
                ),
                onTap: () {},
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.only(left: Adapt.px(150),right: Adapt.px(150),top: Adapt.px(60)),
                child: SizedBox(
                  height: Adapt.px(80),
                  width: Adapt.px(200),
                  child: RaisedButton(
                    color: MyColors.colorAccent,
                    onPressed: () {

                      Application.spUtil.clear();
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => LoginPage()),
                              (route) => route == null);
                    },
                    child: new Text(
                      Application.spUtil.get('login') ? '退出登录' : '登录',
                      style: new TextStyle(
                          fontSize: Adapt.px(28), color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ]),
    );
  }

  Future<Null> loadCache() async {
    try {
      Directory tempDir = await getTemporaryDirectory();
      double value = await _getTotalSizeOfFilesInDir(tempDir);

      setState(() {
        _cacheSizeStr = CommonUtils.renderSize(value);
      });
    } catch (err) {
      print(err);
    }
  }

  Future<double> _getTotalSizeOfFilesInDir(final FileSystemEntity file) async {
    try {
      if (file is File) {
        int length = await file.length();
        return double.parse(length.toString());
      }
      if (file is Directory) {
        final List<FileSystemEntity> children = file.listSync();
        double total = 0;
        if (children != null)
          for (final FileSystemEntity child in children)
            total += await _getTotalSizeOfFilesInDir(child);
        return total;
      }
      return 0;
    } catch (e) {
      print(e);
      return 0;
    }
  }

  void _clearCache() async {
    //此处展示加载loading
    try {
      Directory tempDir = await getTemporaryDirectory();
      //删除缓存目录
      await delDir(tempDir);
      await loadCache();
      Toast.show("清除缓存成功", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
    } catch (e) {
      print(e);
      Toast.show("清除缓存失败", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
    } finally {
      //此处隐藏加载loading
    }
  }

  Future<Null> delDir(FileSystemEntity file) async {
    try {
      if (file is Directory) {
        final List<FileSystemEntity> children = file.listSync();
        for (final FileSystemEntity child in children) {
          await delDir(child);
        }
      }
      await file.delete();
    } catch (e) {
      print(e);
    }
  }
}
