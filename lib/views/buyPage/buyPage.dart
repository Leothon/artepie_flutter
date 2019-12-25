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

class BuyPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _buyPageState();
  }
}

class _buyPageState extends State<BuyPage> {
  LoadState _layoutState = LoadState.State_Loading;
  BottomState _loadState = BottomState.bottom_Success;
  ScrollController _scrollController = new ScrollController();

  var _itemCount = 0;
  List _buyItemList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadBuyData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          _loadState = BottomState.bottom_Loading;
        });
        _loadMoreBuyData();
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
          _loadBuyData();
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
              '我订阅的课程',
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
                      _loadMoreBuyData();
                    },
                  );
                } else {
                  return _buyItem(context, index);
                }
              },
              childCount: _itemCount + 1,
            ),
          )
        ],
      ),
      onRefresh: _loadBuyData,
    );
  }

  Widget _buyItem(BuildContext context, int position) {
    return new Stack(
      children: <Widget>[
        InkWell(
          onTap: () {
            Application.router.navigateTo(context,
                '${Routes.classDetailPage}?classid=${Uri.encodeComponent(
                    _buyItemList[position]['selectId'])}',
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
                        image: _buyItemList[position]['selectbackimg'],
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
                          _buyItemList[position]['selectlisttitle'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        new Text(
                          _buyItemList[position]['selectdesc'],
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  flex: 4,
                ),

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


  Future _loadBuyData() {
    return DataUtils.getBuyClass({
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
          _buyItemList = data;
          _itemCount = _buyItemList.length;
        });
      }
    }).catchError((onError) {
      setState(() {
        LogUtil.e(onError);
        _layoutState = LoadState.State_Error;
      });
    });
  }

  void _loadMoreBuyData() {
    _loadState = BottomState.bottom_Loading;
    DataUtils.getBuyClass({
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
          _buyItemList.addAll(data);
          _itemCount = _buyItemList.length;
        });
      }
    }).catchError((onError) {
      setState(() {
        _loadState = BottomState.bottom_Error;
      });
    });
  }


}
