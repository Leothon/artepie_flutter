import 'package:artepie/resource/MyColors.dart';
import 'package:artepie/routers/Application.dart';
import 'package:artepie/utils/Adapt.dart';
import 'package:artepie/utils/data_utils.dart';
import 'package:artepie/views/LoadStateLayout.dart';
import 'package:artepie/views/listview_item_bottom.dart';
import 'package:artepie/views/teacherPage/teacherHead.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';

class TeacherPage extends StatefulWidget{


  final String _teacherId;
  TeacherPage(this._teacherId);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _TeacherPageState();
  }

}

class _TeacherPageState extends State<TeacherPage>{

  LoadState _layoutState = LoadState.State_Loading;
  BottomState _loadState = BottomState.bottom_Success;
  ScrollController _scrollController = new ScrollController();

  var _itemCount = 1;
  List _classItemList = [];
  var _teacherData;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    LogUtil.e('执行');
    _loadTeacherData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          _loadState = BottomState.bottom_Loading;
        });
        _loadMoreTeacherData();
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


  Widget _teacherPageWidget(BuildContext context){
    new RefreshIndicator(
      displacement: Adapt.px(200),
      child: new CustomScrollView(
        controller: _scrollController,
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        slivers: <Widget>[
//          SliverAppBar(
//            title: new Text(
//              '秀吧视频',
//              style: new TextStyle(fontSize: Adapt.px(34), color: Colors.black),
//            ),
//            pinned: true,
//            backgroundColor: Colors.white,
//            brightness: Brightness.light,
//            elevation: 3,
//            forceElevated: true,
//          ),
          SliverToBoxAdapter(
              child: CurvePage(
                description: _teacherData['user_signal'],
                name: _teacherData['user_name'],
                iconUrl: _teacherData['user_icon'],
              ),),
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
    );
  }


  Widget _classItem(BuildContext context,int position){

    return Container(
      height: Adapt.px(332),
      margin: EdgeInsets.fromLTRB(Adapt.px(24), 0, Adapt.px(24), 0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: position == 0 ? Radius.circular(Adapt.px(28)) : 0,topRight: position == 0 ? Radius.circular(Adapt.px(28)) : 0,bottomRight: position == _itemCount ? Radius.circular(Adapt.px(28)) : 0,bottomLeft:position == _itemCount ? Radius.circular(Adapt.px(28)) : 0)),
      child: new Row(
        children: <Widget>[
          Expanded(
            child: new Stack(
              children: <Widget>[
                Container(
                  height: Adapt.px(332),
                  //width: Adapt.px(300),
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
                        _classItemList[position]['serialize'] ? '连载中' : '已完结',
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
    );
  }



  Future _loadTeacherData() {

    return DataUtils.getTeacherData({'token': Application.spUtil.get('token'),'teaid' : widget._teacherId})
        .then((result) {
      var data = result['data'];
      LogUtil.e(result);
      if (data.length == 0) {
        setState(() {
          _layoutState = LoadState.State_Empty;
        });
      } else {
        setState(() {
          _loadState = BottomState.bottom_Loading;
          _layoutState = LoadState.State_Success;
          _teacherData = data['teacher'];
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
    DataUtils.getTeacherMoreData({

      'token': Application.spUtil.get('token'),

      'teaid' : widget._teacherId,
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