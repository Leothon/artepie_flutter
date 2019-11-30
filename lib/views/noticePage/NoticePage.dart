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
import 'package:video_player/video_player.dart';

class NoticePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _noticePageState();
  }
}

class _noticePageState extends State<NoticePage> {
  LoadState _layoutState = LoadState.State_Loading;
  BottomState _loadState = BottomState.bottom_Success;
  ScrollController _scrollController = new ScrollController();

  var _itemCount = 0;
  List _noticeItemList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadNoticeData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          _loadState = BottomState.bottom_Loading;
        });
        _loadMoreNoticeData();
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
          _loadNoticeData();
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
              '消息通知',
              style: new TextStyle(
                  fontSize: Adapt.px(34), color: MyColors.fontColor),
            ),
            pinned: true,
            backgroundColor: Colors.white,
            brightness: Brightness.light,
            elevation: 3,
            forceElevated: true,
            actions: <Widget>[
              new InkWell(
                child: new Container(
                  child: Text('全部已阅',style: new TextStyle(fontSize: Adapt.px(28),color: MyColors.fontColor),),
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(right: Adapt.px(24)),
                ),
              ),
            ],
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
          SliverToBoxAdapter(
              child: new Container(
                margin: EdgeInsets.all(Adapt.px(18)),
            child: RaisedButton(
              child: Container(
                padding: EdgeInsets.all(
                    Adapt.px(14)),
                child: new Row(
                  children: <Widget>[
                    Icon(
                      Icons.notifications,
                      color: MyColors.colorPrimary,
                    ),
                    new Text(
                      '  私信',
                      style: new TextStyle(
                          fontSize: Adapt.px(36), color: MyColors.fontColor),
                    )
                  ],
                ),
              ),
              onPressed: () {},
              elevation: Adapt.px(4),
              color: MyColors.white,
            ),
          )),
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
                      _loadMoreNoticeData();
                    },
                  );
                } else {
                  return _noticeItem(context, index);
                }
              },
              childCount: _itemCount + 1,
            ),
          )
        ],
      ),
      onRefresh: _loadNoticeData,
    );
  }

  Widget _noticeItem(BuildContext context, int position) {
    return new Stack(
      children: <Widget>[
        InkWell(
          onTap: () {
            switch (_noticeItemList[position]['noticeType']){
              case "qalike":

                _toCommentPage(_noticeItemList[position]['noticeTargetId']);
                break;
              case "commentlike":

                _toReplyPage(_noticeItemList[position]['noticeTargetId']);
                break;
              case "replylike":

                _toReplyPage(_noticeItemList[position]['noticeTargetId']);
                break;
              case "qacomment":

                _toCommentPage(_noticeItemList[position]['noticeTargetId']);
                break;
              case "replycomment":

                _toReplyPage(_noticeItemList[position]['noticeTargetId']);
                break;
              default:
                break;
            }
          },
          child: new Container(
            color: _noticeItemList[position]['noticeStatus'] == 1 ? Colors.white : null,
            padding: EdgeInsets.all(Adapt.px(10)),
            child: new Row(
              children: <Widget>[
                UserIconWidget(
                  url: _noticeItemList[position]['userIcon'],
                  isAuthor: false,
                  authority: false,
                  size: Adapt.px(64),
                ),
                new Padding(
                  padding: EdgeInsets.fromLTRB(
                      Adapt.px(24), Adapt.px(10), Adapt.px(24), Adapt.px(10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Row(
                        children: <Widget>[
                          new Text(
                            '${_noticeItemList[position]['userName']}  ',
                            style: new TextStyle(
                                fontSize: Adapt.px(26), color: MyColors.black),
                          ),
                          new Text(
                            _noticeItemList[position]['noticeType'] == 'qalike'
                                ? '点赞了您的视频'
                                : (_noticeItemList[position]['noticeType'] ==
                                        'commentlike'
                                    ? '点赞了您的评论'
                                    : (_noticeItemList[position]
                                                ['noticeType'] ==
                                            'replylike'
                                        ? '点赞了您的回复'
                                        : (_noticeItemList[position]
                                                    ['noticeType'] ==
                                                'qacomment'
                                            ? '评论了您的视频'
                                            : (_noticeItemList[position]
                                                        ['noticeType'] ==
                                                    'replycomment'
                                                ? '回复了您的评论'
                                                : '')))),
                            style: new TextStyle(
                                fontSize: Adapt.px(26),
                                color: MyColors.lowfontColor),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(Adapt.px(10)),
                        child: new Text(
                          _noticeItemList[position]['noticeContent'] == ''
                              ? '点击查看详情'
                              : _noticeItemList[position]['noticeContent'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: new TextStyle(fontSize: Adapt.px(24),color: _noticeItemList[position]['noticeContent'] == '' ? MyColors.colorPrimary : MyColors.lowfontColor),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        new Container(
          height: Adapt.px(2),
          color: MyColors.dividerColor,
          margin: EdgeInsets.only(left: Adapt.px(70)),
        )
      ],
    );
  }


  void _toCommentPage(String _id){
    Application.router.navigateTo(context,
        '${Routes.videoDetailPage}?videoid=${Uri
            .encodeComponent(_id)}',
        transition: TransitionType.fadeIn);
  }

  void _toReplyPage(String _id){
    Application.router.navigateTo(context,
        '${Routes.commentDetailPage}?commentid=${Uri
            .encodeComponent(
            _id)}',
        transition: TransitionType.fadeIn);
  }

  Future _loadNoticeData() {
    return DataUtils.getNotice(
            {'current': '0', 'token': Application.spUtil.get('token')})
        .then((result) {
      var data = result['data'];

      if (data.length == 0) {
        setState(() {
          _layoutState = LoadState.State_Empty;
        });
      } else {
        setState(() {
//          _loadState = BottomState.bottom_Loading;
          _layoutState = LoadState.State_Success;
          _noticeItemList = data;
          _itemCount = _noticeItemList.length;
        });
      }
    }).catchError((onError) {
      setState(() {
        LogUtil.e(onError);
        _layoutState = LoadState.State_Error;
      });
    });
  }

  void _loadMoreNoticeData() {
    _loadState = BottomState.bottom_Loading;
    DataUtils.getNotice({
      'current': _itemCount.toString(),
      'token': Application.spUtil.get('token')
    }).then((result) {
      var data = result['data'];
      if (data.length == 0) {
        setState(() {
          _loadState = BottomState.bottom_Empty;
        });
      } else {
        setState(() {
          _noticeItemList.addAll(data);
          _itemCount = _noticeItemList.length;
        });
      }
    }).catchError((onError) {
      setState(() {
        _loadState = BottomState.bottom_Error;
      });
    });
  }
}
