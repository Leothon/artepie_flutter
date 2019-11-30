import 'package:artepie/resource/MyColors.dart';
import 'package:artepie/routers/Application.dart';
import 'package:artepie/routers/routers.dart';
import 'package:artepie/utils/Adapt.dart';
import 'package:artepie/utils/data_utils.dart';
import 'package:artepie/views/LoadStateLayout.dart';
import 'package:artepie/views/listview_item_bottom.dart';

import 'package:common_utils/common_utils.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class OrderPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _orderPageState();
  }
}

class _orderPageState extends State<OrderPage> {
  LoadState _layoutState = LoadState.State_Loading;
  BottomState _loadState = BottomState.bottom_Success;
  ScrollController _scrollController = new ScrollController();

  var _itemCount = 0;
  List _orderItemList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadOrderData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          _loadState = BottomState.bottom_Loading;
        });
        _loadMoreOrderData();
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
      backgroundColor: MyColors.dividerColor,
      body: new LoadStateLayout(
        successWidget: _commentPageWidget(context),
        errorRetry: () {
          setState(() {
            _layoutState = LoadState.State_Loading;
          });
          _loadOrderData();
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
              '我的订单',
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
                      _loadMoreOrderData();
                    },
                  );
                } else {
                  return _orderItem(context, index);
                }
              },
              childCount: _itemCount + 1,
            ),
          )
        ],
      ),
      onRefresh: _loadOrderData,
    );
  }

  Widget _orderItem(BuildContext context, int position) {
    return Container(
      margin: EdgeInsets.fromLTRB(
          Adapt.px(24), Adapt.px(8), Adapt.px(24), Adapt.px(8)),
      padding: EdgeInsets.all(Adapt.px(18)),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Adapt.px(24)),
          color: Colors.white),
      child: new Column(
        children: <Widget>[
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Text(
                '讲师： ${_orderItemList[position]['authorName']}',
                style: new TextStyle(
                    fontSize: Adapt.px(28), color: MyColors.fontColor),
              ),
              new Text(
                _orderItemList[position]['orderStatus'],
                style: new TextStyle(
                    fontSize: Adapt.px(28),
                    color: _orderItemList[position]['orderStatus'] == '待支付'
                        ? MyColors.colorAccent
                        : Colors.green),
              ),
            ],
          ),
          new Padding(padding: EdgeInsets.only(top: Adapt.px(20),bottom: Adapt.px(20)),child: new Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  height: Adapt.px(200),
                  //width: Adapt.px(300),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(Adapt.px(14)),
                    child: FadeInImage.assetNetwork(
                      placeholder: 'lib/resource/assets/img/loading.png',
                      image: _orderItemList[position]['orderImg'],
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
                        _orderItemList[position]['orderTitle'],
                        style: new TextStyle(
                            fontSize: Adapt.px(28), fontWeight: FontWeight.bold,color: MyColors.fontColor),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      new Text(
                        _orderItemList[position]['orderDes'],
                        style: new TextStyle(
                            fontSize: Adapt.px(28), color: MyColors.fontColor),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                flex: 4,
              ),
            ],
          ),),

          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Text(_orderItemList[position]['orderTime'],style: new TextStyle(
                  fontSize: Adapt.px(24),color: MyColors.fontColor),),
              new Text('合计 ：￥${_orderItemList[position]['orderCount']}',style: new TextStyle(
                  fontSize: Adapt.px(24),color: MyColors.fontColor),),
            ],
          )
        ],
      ),
    );
  }

  Future _loadOrderData() {
    return DataUtils.getOrder({
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
          _orderItemList = data;
          _itemCount = _orderItemList.length;
        });
      }
    }).catchError((onError) {
      setState(() {
        LogUtil.e(onError);
        _layoutState = LoadState.State_Error;
      });
    });
  }

  void _loadMoreOrderData() {
    _loadState = BottomState.bottom_Loading;
    DataUtils.getOrder({
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
          _orderItemList.addAll(data);
          _itemCount = _orderItemList.length;
        });
      }
    }).catchError((onError) {
      setState(() {
        _loadState = BottomState.bottom_Error;
      });
    });
  }
}
