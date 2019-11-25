import 'package:artepie/resource/MyColors.dart';
import 'package:artepie/routers/Application.dart';
import 'package:artepie/utils/Adapt.dart';
import 'package:artepie/utils/data_utils.dart';
import 'package:artepie/views/LoadStateLayout.dart';
import 'package:artepie/views/listview_item_bottom.dart';
import 'package:artepie/views/teacherPage/teacherHead.dart';
import 'package:artepie/views/userIconWidget/UserIconWidget.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';

class TeacherPage extends StatefulWidget {
  final String _teacherId;
  TeacherPage(this._teacherId);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _TeacherPageState();
  }
}

class _TeacherPageState extends State<TeacherPage> {
  LoadState _layoutState = LoadState.State_Loading;
  BottomState _loadState = BottomState.bottom_Success;
  ScrollController _scrollController = new ScrollController();
  bool isListInTop = true;
  var _itemCount = 1;
  List _classItemList = [];
  var _description = '';
  var _name = '';
  var _iconUrl = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _loadTeacherData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          _loadState = BottomState.bottom_Loading;
        });
        _loadMoreTeacherData();
      }

      if (_scrollController.offset < Adapt.px(320)) {
        setState(() {
          isListInTop = true;
        });
      } else {
        setState(() {
          isListInTop = false;
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
          successWidget: _teacherPageWidget(context),
          errorRetry: () {
            setState(() {
              _layoutState = LoadState.State_Loading;
            });
            _loadTeacherData();
          },
          state: _layoutState,
        ));
  }

  Widget _teacherPageWidget(BuildContext context) {
    return new Stack(
      children: <Widget>[
        RefreshIndicator(
          displacement: Adapt.px(200),
          child: new CustomScrollView(
            controller: _scrollController,
            physics: AlwaysScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: CurvePage(
                  description: _description,
                  name: _name,
                  iconUrl: _iconUrl,
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
                          _loadMoreTeacherData();
                        },
                      );
                    } else {
                      return _classItem(context, index);
                    }
                  },
                  childCount: _itemCount + 1,
                ),
              )
            ],
          ),
          onRefresh: _loadTeacherData,
        ),
        _toolBarWidget(context),
      ],
    );
  }

  Widget _classItem(BuildContext context, int position) {
    return new Stack(
      children: <Widget>[
        Container(
          height: Adapt.px(332),
          margin: EdgeInsets.fromLTRB(Adapt.px(24), 0, Adapt.px(24), 0),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: position == 0
                      ? Radius.circular(Adapt.px(28))
                      : Radius.circular(Adapt.px(0)),
                  topRight: position == 0
                      ? Radius.circular(Adapt.px(28))
                      : Radius.circular(Adapt.px(0)),
                  bottomRight: position == _itemCount - 1
                      ? Radius.circular(Adapt.px(28))
                      : Radius.circular(Adapt.px(0)),
                  bottomLeft: position == _itemCount - 1
                      ? Radius.circular(Adapt.px(28))
                      : Radius.circular(Adapt.px(0)))),
          child: new Row(
            children: <Widget>[
              Expanded(
                child: new Stack(
                  children: <Widget>[
                    Container(
                      height: Adapt.px(332),
                      //width: Adapt.px(300),
                      padding: EdgeInsets.only(
                          left: Adapt.px(18),
                          bottom: Adapt.px(18),
                          top: Adapt.px(18)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(Adapt.px(28)),
                        child: FadeInImage.assetNetwork(
                          placeholder: 'lib/resource/assets/img/loading.png',
                          image: _classItemList[position]['selectbackimg'],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
                flex: 2,
              ),
              Expanded(
                child: new Container(
                  //width: 180,
                  margin: EdgeInsets.fromLTRB(Adapt.px(18), 0, Adapt.px(18), 0),
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text(_classItemList[position]['selectlisttitle'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: new TextStyle(
                            fontSize: Adapt.px(34),
                            fontWeight: FontWeight.bold,
                          )),
//                  new Text(_classItemList[position]['selectauthor'],
//                      maxLines: 1,
//                      overflow: TextOverflow.ellipsis,
//                      style: new TextStyle(
//                          fontSize: Adapt.px(28), color: MyColors.fontColor)),
                      new Text(_classItemList[position]['selectdesc'],
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: new TextStyle(
                            fontSize: Adapt.px(24),
                          )),
                      new Container(
                        height: Adapt.px(34),
                        width: Adapt.px(88),
                        decoration: BoxDecoration(
                            color: _classItemList[position]['serialize']
                                ? MyColors.colorPrimary
                                : Colors.green,
                            borderRadius: BorderRadius.circular(Adapt.px(18))),
                        child: new Text(
                            _classItemList[position]['serialize']
                                ? '连载中'
                                : '已完结',
                            textAlign: TextAlign.center,
                            style: new TextStyle(
                                color: Colors.white, fontSize: Adapt.px(20))),
                      ),
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          new Text(
                            '${_classItemList[position]['selectstucount']}人次已学习',
                            style: new TextStyle(
                              fontSize: Adapt.px(22),
                            ),
                          ),
                          new Text(
                            _classItemList[position]['selectprice'] == '0.00'
                                ? '免费'
                                : '￥${_classItemList[position]['selectprice']}',
                            style: new TextStyle(
                                fontSize: Adapt.px(30),
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                                color: MyColors.colorPrimary),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                flex: 3,
              )
            ],
          ),
        ),
        new Offstage(
          offstage: position == 0 ? true : false,
          child: Container(
            color: MyColors.dividerColor,
            margin: EdgeInsets.only(left: Adapt.px(60), right: Adapt.px(60)),
            height: Adapt.px(2),
          ),
        )
      ],
    );
  }

  Future _loadTeacherData() {
    return DataUtils.getTeacherData({
      'token': Application.spUtil.get('token'),
      'teaid': widget._teacherId
    }).then((result) {
      var data = result['data'];
      if (data.length == 0) {
        setState(() {
          _layoutState = LoadState.State_Empty;
        });
      } else {
        setState(() {
          LogUtil.e('执行');

          _layoutState = LoadState.State_Success;
          _description = data['teacher']['user_signal'];
          _iconUrl = data['teacher']['user_icon'];
          _name = data['teacher']['user_name'];
          _classItemList = data['teaClassses'];
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

  void _loadMoreTeacherData() {
    _loadState = BottomState.bottom_Loading;
    DataUtils.getTeacherMoreData({
      'token': Application.spUtil.get('token'),
      'teaid': widget._teacherId,
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

  Widget _toolBarWidget(BuildContext context) {
    return new Container(
      height: Adapt.px(160),
      child: new Stack(
        children: <Widget>[
          new AppBar(
            leading: new Text(''),
            elevation: isListInTop ? 0 : 3,
            brightness: Brightness.light,
            backgroundColor: isListInTop ? Colors.transparent : Colors.white,
          ),
          new SafeArea(
              top: true,
              child: new Container(
                height: Adapt.px(100),
                padding:
                    EdgeInsets.only(left: Adapt.px(30), right: Adapt.px(30)),
                child: new Container(
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      InkWell(
                        child: Icon(
                          Icons.arrow_back,
                          color: isListInTop ? Colors.white : Colors.black,
                        ),
                        onTap: (){Navigator.of(context).pop();},
                      ),

                      new Offstage(
                        child: UserIconWidget(
                          url: _iconUrl,
                          size: Adapt.px(68),
                          isAuthor: true,
                          authority: true,
                        ),
                        offstage: isListInTop ? true : false,
                      ),
                      new Offstage(
                        child: new Text(
                          _name,
                          style: new TextStyle(fontSize: Adapt.px(30)),
                        ),
                        offstage: isListInTop ? true : false,
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
