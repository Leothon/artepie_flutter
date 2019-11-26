import 'package:artepie/resource/MyColors.dart';
import 'package:artepie/routers/Application.dart';
import 'package:artepie/utils/Adapt.dart';
import 'package:artepie/utils/CommonUtils.dart';
import 'package:artepie/utils/data_utils.dart';
import 'package:artepie/views/LoadStateLayout.dart';
import 'package:artepie/views/listview_item_bottom.dart';
import 'package:artepie/views/userIconWidget/UserIconWidget.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ClassDetailPage extends StatefulWidget {
  final String _classId;
  ClassDetailPage(this._classId);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _classDetailPageState();
  }
}

class _classDetailPageState extends State<ClassDetailPage> {
  LoadState _layoutState = LoadState.State_Loading;
  BottomState _loadState = BottomState.bottom_Success;
  ScrollController _scrollController = new ScrollController();
  var _itemCount = 1;
  List _classItemList = [];
  var _classTime = '';
  var _teaClasss = {};
  bool isTop = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _loadClassDetailData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          _loadState = BottomState.bottom_Loading;
        });
        _loadMoreClassDetailData();
      }

      if (_scrollController.offset < Adapt.px(280)) {
        setState(() {
          isTop = false;
        });
      } else {
        setState(() {
          isTop = true;
        });
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

    return new Scaffold(
        backgroundColor: MyColors.dividerColor,
        body: new LoadStateLayout(
          successWidget: _classDetailPageWidget(context),
          errorRetry: () {
            setState(() {
              _layoutState = LoadState.State_Loading;
            });
            _loadClassDetailData();
          },
          state: _layoutState,
        ));
  }

  Widget _classDetailPageWidget(BuildContext context) {
    return RefreshIndicator(
      displacement: Adapt.px(200),
      child: new CustomScrollView(
        controller: _scrollController,
        physics: AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: Adapt.px(280),
            brightness: Brightness.light,
            title: new Text(
              _teaClasss.length == 0 ? '' : _teaClasss['selectlisttitle'],
              style: new TextStyle(
                  color: isTop ? MyColors.fontColor : Colors.white),
            ),
            leading: InkWell(
              child: Icon(
                Icons.arrow_back,
                color: isTop ? MyColors.fontColor : Colors.white,
              ),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
            actions: <Widget>[
              new IconButton(
                icon: Icon(_teaClasss.length == 0 ? Icons.favorite_border : (_teaClasss['isfav'] ? Icons.favorite : Icons.favorite_border),color: isTop ? MyColors.fontColor :Colors.white,),
                onPressed: () {
                  //TODO 收藏课程

                  setState(() {
                    _teaClasss['isfav'] = !_teaClasss['isfav'];
                  });
                },
              ),
              new IconButton(
                icon: Icon(Icons.repeat,color: isTop ? MyColors.fontColor : Colors.white,),
                onPressed: () {
                  //TODO 分享课程
                },
              ),
            ],
            backgroundColor: Colors.white,
            floating: false,
            pinned: true,
            snap: false,
            flexibleSpace: new FlexibleSpaceBar(
              background: Image.network(
                  _teaClasss.length == 0
                      ? 'http://www.artepie.cn/image/video_cover.png'
                      : _teaClasss['selectbackimg'],
                  fit: BoxFit.cover),
            ),
          ),
          SliverToBoxAdapter(
            child: _headWidget(context),
          ),
          SliverToBoxAdapter(child: _contentWidget(context)),
          SliverToBoxAdapter(
            child: new Container(
              padding: EdgeInsets.only(
                  left: Adapt.px(44),
                  right: Adapt.px(44),
                  bottom: Adapt.px(12)),
              color: Colors.white,
              child: new Text(
                  _teaClasss.length == 0 ? '' : _teaClasss['selectdesc']),
            ),
          ),
          SliverToBoxAdapter(
            child: new Container(
              padding: EdgeInsets.only(
                  left: Adapt.px(32), right: Adapt.px(32), bottom: Adapt.px(6)),
              color: Colors.white,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    '讲师简介',
                    style: new TextStyle(
                        color: MyColors.fontColor,
                        fontSize: Adapt.px(32),
                        fontWeight: FontWeight.bold),
                  ),
                  new Container(
                    padding: EdgeInsets.all(Adapt.px(12)),
                    child: new Text(_teaClasss.length == 0
                        ? ''
                        : _teaClasss['selectauthordes']),
                  )
                ],
              ),
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
                      _loadMoreClassDetailData();
                    },
                  );
                } else {
                  return _classDetailItem(context, index);
                }
              },
              childCount: _itemCount + 1,
            ),
          )
        ],
      ),
      onRefresh: _loadClassDetailData,
    );
  }

  Widget _headWidget(BuildContext context) {
    return Container(
      height: Adapt.px(210),
      color: Colors.white,
      padding: EdgeInsets.all(Adapt.px(26)),
      margin: EdgeInsets.only(bottom: Adapt.px(26)),
      child: new Row(
        children: <Widget>[
          Expanded(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(
                  _teaClasss.length == 0 ? '' : _teaClasss['selectlisttitle'],
                  maxLines: 1,
                  style: new TextStyle(
                    color: MyColors.colorPrimary,
                    fontSize: Adapt.px(44),
                  ),
                ),
                new Text(
                  _teaClasss.length == 0
                      ? ''
                      : '讲师：${_teaClasss['selectauthor']}',
                  style: new TextStyle(
                      color: MyColors.fontColor, fontSize: Adapt.px(36)),
                ),
                new Text(
                  _teaClasss.length == 0
                      ? ''
                      : '课程总时长：${CommonUtils.msTomin(double.parse(_teaClasss['selecttime']))}分钟',
                  style: new TextStyle(
                      color: MyColors.fontColor, fontSize: Adapt.px(24)),
                ),
              ],
            ),
            flex: 2,
          ),
          Expanded(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                new Text(
                  _teaClasss.length == 0
                      ? ''
                      : (_teaClasss['selectscore'] == '暂无评分'
                          ? _teaClasss['selectscore']
                          : '${_teaClasss['selectscore']}分'),
                  style: new TextStyle(
                      color: MyColors.fontColor,
                      fontSize: Adapt.px(36),
                      fontWeight: FontWeight.bold),
                ),
                new Text(
                  _teaClasss.length == 0
                      ? ''
                      : (_teaClasss['isbuy']
                          ? '已购买'
                          : (_teaClasss['selectprice'] == '0.00'
                              ? '免费'
                              : '￥${_teaClasss['selectprice']}')),
                  style: new TextStyle(
                      color: MyColors.colorPrimary,
                      fontSize: Adapt.px(30),
                      fontStyle: FontStyle.italic),
                ),
              ],
            ),
            flex: 1,
          ),
        ],
      ),
    );
  }

  Widget _contentWidget(BuildContext context) {
    return new Container(
      color: Colors.white,
      padding: EdgeInsets.only(
          left: Adapt.px(32),
          right: Adapt.px(32),
          top: Adapt.px(22),
          bottom: Adapt.px(12)),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Text(
            '课程简介',
            style: new TextStyle(
                color: MyColors.fontColor,
                fontSize: Adapt.px(32),
                fontWeight: FontWeight.bold),
          ),
          new Row(
            children: <Widget>[
              new Offstage(
                child: new Container(
                  margin: EdgeInsets.only(right: Adapt.px(18)),
                  height: Adapt.px(34),
                  width: Adapt.px(94),
                  decoration: BoxDecoration(
                      color: MyColors.colorPrimary,
                      borderRadius: BorderRadius.circular(Adapt.px(18))),
                  child: new Text('官方课程',
                      textAlign: TextAlign.center,
                      style: new TextStyle(
                          color: Colors.white, fontSize: Adapt.px(20))),
                ),
                offstage:
                    _teaClasss.length == 0 ? false : !_teaClasss['authorize'],
              ),
              new Container(
                height: Adapt.px(34),
                width: Adapt.px(88),
                decoration: BoxDecoration(
                    color: _teaClasss.length == 0
                        ? Colors.white
                        : (_teaClasss['serialize']
                            ? MyColors.colorPrimary
                            : Colors.green),
                    borderRadius: BorderRadius.circular(Adapt.px(18))),
                child: new Text(
                    _teaClasss.length == 0
                        ? ''
                        : (_teaClasss['serialize'] ? '连载中' : '已完结'),
                    textAlign: TextAlign.center,
                    style: new TextStyle(
                        color: Colors.white, fontSize: Adapt.px(20))),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _classDetailItem(BuildContext context, int position) {
    return InkWell(
      child: Container(
        height: Adapt.px(120),
        margin: EdgeInsets.only(
            top: Adapt.px(14), left: Adapt.px(14), right: Adapt.px(14)),
        //foregroundDecoration: BoxDecoration(color: MyColors.alphaWhite),
        //margin: EdgeInsets.fromLTRB(Adapt.px(24), 0, Adapt.px(24), 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Adapt.px(20)),
          image: DecorationImage(
            image: NetworkImage(_classItemList[position]['classd_video_cover']),
            fit: BoxFit.cover,
          ),
        ),
        child: new Container(
          height: Adapt.px(120),
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [MyColors.lowfontColor, MyColors.blackalpha],
                begin: FractionalOffset(0, 1),
                end: FractionalOffset(1, 0)),
            borderRadius: BorderRadius.circular(Adapt.px(20)),
          ),
          child: new Row(
            children: <Widget>[
              Expanded(
                child: new Text(
                  '第${position + 1}课',
                  textAlign: TextAlign.center,
                  style: new TextStyle(color: Colors.white),
                ),
                flex: 1,
              ),
              Expanded(
                child: new Text(
                    _classItemList.length == 0
                        ? ''
                        : _classItemList[position]['classd_title'],
                    textAlign: TextAlign.start,
                    style: new TextStyle(color: Colors.white)),
                flex: 5,
              ),
              Expanded(
                child: _teaClasss['selectprice'] == '0.00' ||
                        _teaClasss['isbuy'] ||
                        position == 0
                    ? Icon(Icons.play_circle_outline, color: Colors.white)
                    : Icon(Icons.lock, color: Colors.white),
                flex: 1,
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        if (_teaClasss['selectprice'] == '0.00' || _teaClasss['isbuy']) {
          //TODO 跳转

        } else if (position == 0) {
          //TODO 跳转

        } else {
          showDialog<Null>(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('提醒'),
                  content: Text('本课程是付费课程，是否购买整套课程'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('去订阅'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        //TODO 跳转购买课程
                      },
                    ),
                    FlatButton(
                      child: Text('放弃'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              });
        }
      },
    );
  }

  Future _loadClassDetailData() {
    return DataUtils.getClassDetail({
      'token': Application.spUtil.get('token'),
      'classid': widget._classId
    }).then((result) {
      var data = result['data'];
      if (data.length == 0) {
        setState(() {
          _layoutState = LoadState.State_Empty;
        });
      } else {
        setState(() {
          _layoutState = LoadState.State_Success;
          _teaClasss = data['teaClasss'];
          _classItemList = data['classDetailLists'];
          _itemCount = _classItemList.length;
        });
      }
    }).catchError((onError) {
      setState(() {
        LogUtil.e(onError);
        _layoutState = LoadState.State_Error;
      });
    });
  }

  void _loadMoreClassDetailData() {
    _loadState = BottomState.bottom_Loading;
    DataUtils.getMoreClassDetail({
      'token': Application.spUtil.get('token'),
      'classid': widget._classId,
      'currentpage': _itemCount.toString(),
    }).then((result) {
      var data = result['data'];
      if (data.length == 0) {
        setState(() {
          _loadState = BottomState.bottom_Empty;
        });
      } else {
        setState(() {
          _classItemList.addAll(data);
          _itemCount = _classItemList.length;
        });
      }
    }).catchError((onError) {
      setState(() {
        _loadState = BottomState.bottom_Error;
      });
    });
  }
}
