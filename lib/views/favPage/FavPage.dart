import 'package:artepie/model/user_info.dart';
import 'package:artepie/resource/MyColors.dart';
import 'package:artepie/routers/Application.dart';
import 'package:artepie/routers/routers.dart';
import 'package:artepie/utils/Adapt.dart';
import 'package:artepie/utils/CommonUtils.dart';
import 'package:artepie/utils/data_utils.dart';
import 'package:artepie/views/LoadStateLayout.dart';
import 'package:artepie/views/listview_item_bottom.dart';
import 'package:artepie/views/userIconWidget/UserIconWidget.dart';
import 'package:artepie/widgets/MyChewie/chewie_player.dart';
import 'package:artepie/widgets/MyChewie/chewie_progress_colors.dart';
import 'package:common_utils/common_utils.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:video_player/video_player.dart';

class FavPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _favPageState();
  }
}

class _favPageState extends State<FavPage> {
  LoadState _layoutState = LoadState.State_Loading;
  BottomState _loadState = BottomState.bottom_Success;
  ScrollController _scrollController = new ScrollController();

  var _itemCount = 0;
  List _favItemList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadFavData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          _loadState = BottomState.bottom_Loading;
        });
        _loadMoreFavData();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: new LoadStateLayout(
        successWidget: _commentPageWidget(context),
        errorRetry: () {
          setState(() {
            _layoutState = LoadState.State_Loading;
          });
          _loadFavData();
        },
        state: _layoutState,
      ),
    );
  }

  Widget _commentPageWidget(BuildContext context) {
    return new RefreshIndicator(
      displacement: Adapt.px(200),
      child: new CustomScrollView(
        controller: _scrollController,
        physics: AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        slivers: <Widget>[
          SliverAppBar(
            title: new Text(
              '我的收藏',
              style: new TextStyle(
                  fontSize: Adapt.px(34), color: MyColors.fontColor),
            ),
            pinned: true,
            backgroundColor: Colors.white,
            brightness: Brightness.light,
            elevation: 3,
            forceElevated: true,
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
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                if (index == _itemCount) {
                  return new ListBottomView(
                    isHighBottom: true,
                    bottomState: _loadState,
                    errorRetry: () {
                      setState(() {
                        _loadState = BottomState.bottom_Loading;
                      });
                      _loadMoreFavData();
                    },
                  );
                } else {
                  return _favItem(context, index);
                }
              },
              childCount: _itemCount + 1,
            ),
          )
        ],
      ),
      onRefresh: _loadFavData,
    );
  }

  Widget _favItem(BuildContext context, int position) {
    return new Stack(
      children: <Widget>[
        InkWell(
          onTap: () {
            Application.router.navigateTo(context,
                '${Routes.classDetailPage}?classid=${Uri.encodeComponent(
                    _favItemList[position]['selectId'])}',
                transition: TransitionType.fadeIn);
          },
          child: new Container(
            padding: EdgeInsets.all(Adapt.px(10)),
            child: new Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    height: Adapt.px(140),
                    //width: Adapt.px(300),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(Adapt.px(14)),
                      child: FadeInImage.assetNetwork(
                        placeholder: 'lib/resource/assets/img/loading.png',
                        image: _favItemList[position]['selectbackimg'],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  flex: 2,
                ),
                Expanded(
                  child: new Padding(
                    padding: EdgeInsets.fromLTRB(
                        Adapt.px(24), Adapt.px(10), Adapt.px(24), Adapt.px(10)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Text(
                          _favItemList[position]['selectlisttitle'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        new Text(
                          _favItemList[position]['selectdesc'],
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  flex: 4,
                ),
                Expanded(
                  child: new Container(
                      child: InkWell(
                    child: Icon(Icons.clear),
                    onTap: () {

                      showDialog<Null>(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return new AlertDialog(
                              title: new Text('提醒'),
                              content: new SingleChildScrollView(
                                child: new ListBody(
                                  children: <Widget>[
                                    new Text('您将取消收藏该节课程（该课程可能是您购买过的课程），取消后不能收到课程更新推送'),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                new FlatButton(
                                  child: new Text('取消收藏'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    _unFavData(position);
                                    //TODO 取消收藏
                                  },
                                ),
                                new FlatButton(
                                  child: new Text('暂不取消'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          });
                    },
                  )),
                  flex: 1,
                )
              ],
            ),
          ),
        ),
        new Container(
          height: Adapt.px(4),
          color: MyColors.dividerColor,
        )
      ],
    );
  }


  Future _loadFavData() {
    return DataUtils.getFav({
      'token': Application.spUtil.get('token'),
      'currentpage': '0',
    }).then((result) {
      var data = result['data'];

      if (data.length == 0) {
        setState(() {
          _layoutState = LoadState.State_Empty;
        });
      } else {
        setState(() {
//          _loadState = BottomState.bottom_Loading;
          _layoutState = LoadState.State_Success;
          _favItemList = data;
          _itemCount = _favItemList.length;
        });
      }
    }).catchError((onError) {
      setState(() {
        LogUtil.e(onError);
        _layoutState = LoadState.State_Error;
      });
    });
  }

  void _loadMoreFavData() {
    _loadState = BottomState.bottom_Loading;
    DataUtils.getFav({
      'token': Application.spUtil.get('token'),
      'currentpage': _itemCount.toString(),
    }).then((result) {
      var data = result['data'];
      if (data.length == 0) {
        setState(() {
          _loadState = BottomState.bottom_Empty;
        });
      } else {
        setState(() {
          _favItemList.addAll(data);
          _itemCount = _favItemList.length;
        });
      }
    }).catchError((onError) {
      setState(() {
        _loadState = BottomState.bottom_Error;
      });
    });
  }


  Future _unFavData(int position) {
    LogUtil.e('列表实际长度${_favItemList.length}');
    LogUtil.e('列表长度${_itemCount}');
    LogUtil.e('位置$position');
    return DataUtils.unFav({
      'token': Application.spUtil.get('token'),
      'classid': _favItemList[position]['selectId'],
    }).then((result) {
      Toast.show('该课程已取消收藏', context,duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
      _favItemList.removeAt(position);
      _itemCount -= 1;
      setState(() {
      });
    }).catchError((onError) {
      LogUtil.e(onError);
      Toast.show('取消收藏失败', context,duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
    });
  }
}
