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

class CommentDetailPage extends StatefulWidget {
  final String _commentId;

  CommentDetailPage(this._commentId);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _commentDetailPageState();
  }
}

class _commentDetailPageState extends State<CommentDetailPage> {
  LoadState _layoutState = LoadState.State_Loading;
  BottomState _loadState = BottomState.bottom_Success;
  ScrollController _scrollController = new ScrollController();

  var _itemCount = 0;
  var _commentInfo = {};
  List _replyItemList = [];
//  bool isNeedUp = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadCommentData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          _loadState = BottomState.bottom_Loading;
        });
        _loadMoreReplyData();
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
          _loadCommentData();
        },
        state: _layoutState,
      ),
      floatingActionButton: InkWell(
        child: new Stack(
          children: <Widget>[
            Container(
              height: Adapt.px(90),
              width: double.infinity,
              color: Colors.white,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: Adapt.px(24)),
              child: new Text('评论，请文明发言',style: new TextStyle(fontSize: Adapt.px(28),color: MyColors.fontColor),),
            ),
            Container(
              height: Adapt.px(2),
              color: MyColors.dividerColor,
            )
          ],
        ),
        onTap: (){},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _commentPageWidget(BuildContext context) {
    return new RefreshIndicator(
      displacement: Adapt.px(200),
      child: new CustomScrollView(
        controller: _scrollController,
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        slivers: <Widget>[
          SliverAppBar(
            title: new Text(
              '评论详情',
              style: new TextStyle(fontSize: Adapt.px(34), color: MyColors.fontColor),
            ),
            pinned: true,
            backgroundColor: Colors.white,
            brightness: Brightness.light,
            elevation: 3,
            forceElevated: true,
            leading: new InkWell(
              child: Icon(Icons.arrow_back,color: MyColors.fontColor,),
              onTap: (){
                Navigator.of(context).pop();
              },
            ),
          ),
          SliverToBoxAdapter(
              child: new InkWell(
                  child: new Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(Adapt.px(10)),
                    child: Container(
                      padding: EdgeInsets.all(Adapt.px(18)),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              new Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  UserIconWidget(
                                    url: _commentInfo.isEmpty
                                        ? ''
                                        : _commentInfo['user_icon'],
                                    isAuthor: false,
                                    authority: false,
                                    size: Adapt.px(46),
                                  ),
                                  new Text(
                                    '  ${_commentInfo.isEmpty ? '' : _commentInfo['user_name']}',
                                    style: new TextStyle(
                                        fontSize: Adapt.px(28),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Icon(Icons.more_horiz)
                            ],
                          ),
                          new Padding(
                            padding: EdgeInsets.all(Adapt.px(20)),
                            child: new Text(
                                _commentInfo.isEmpty
                                    ? ''
                                    : _commentInfo['comment_q_content'],
                                style: new TextStyle(fontSize: Adapt.px(26))),
                          ),
                          new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              new Text(
                                  TimelineUtil.formatByDateTime(DateTime.parse(
                                      _commentInfo.isEmpty
                                          ? '2019-06-05 18:38:45'
                                          : _commentInfo['comment_q_time'])),
                                  style: new TextStyle(
                                      fontSize: Adapt.px(22),
                                      color: MyColors.lowfontColor)),
                              new Row(
                                children: <Widget>[
                                  new Row(
                                    children: <Widget>[
                                      new Text(
                                          _commentInfo.isEmpty
                                              ? ''
                                              : _commentInfo['comment_q_like'],
                                          style: new TextStyle(
                                              fontSize: Adapt.px(22),
                                              color: MyColors.lowfontColor)),
                                      Padding(
                                          padding: EdgeInsets.only(
                                              left: Adapt.px(12),
                                              right: Adapt.px(22)),
                                          child: _commentInfo.isEmpty
                                              ? Icon(Icons.sentiment_satisfied,
                                                  size: Adapt.px(36),
                                                  color: MyColors.colorPrimary)
                                              : _commentInfo['comment_liked']
                                                  ? Icon(
                                                      Icons.sentiment_satisfied,
                                                      size: Adapt.px(36),
                                                      color:
                                                          MyColors.colorPrimary)
                                                  : Icon(
                                                      Icons.sentiment_neutral,
                                                      size: Adapt.px(36),
                                                      color: MyColors
                                                          .lowfontColor))
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: Adapt.px(22),
                                        right: Adapt.px(22)),
                                    child: Icon(Icons.message,
                                        size: Adapt.px(36),
                                        color: MyColors.lowfontColor),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    //TODO 回复该评论
                  })),
          SliverToBoxAdapter(
            child: new Container(
              color: Colors.white,
              padding: EdgeInsets.all(Adapt.px(22)),
              margin: EdgeInsets.only(top: Adapt.px(18)),
              child: new Text(
                '${_replyItemList.length}条回复',
                style: new TextStyle(fontSize: Adapt.px(30)),
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
                      _loadMoreReplyData();
                    },
                  );
                } else {
                  return _replyItem(context, index);
                }
              },
              childCount: _itemCount + 1,
            ),
          )
        ],
      ),
      onRefresh: _loadCommentData,
    );
  }

  Widget _replyItem(BuildContext context, int position) {
    return new InkWell(
      onTap: () {
        //TODO 回复 回复
      },
      child: new Container(
        color: Colors.white,
        padding: EdgeInsets.all(Adapt.px(10)),
        child: _commentReplyItem(context, position),
      ),
    );
  }

  Widget _commentReplyItem(BuildContext context, int position) {
    return new Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(Adapt.px(18)),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      UserIconWidget(
                        url: _replyItemList[position]['user_icon'],
                        isAuthor: false,
                        authority: false,
                        size: Adapt.px(46),
                      ),
                      new Text(
                        '  ${_replyItemList[position]['user_name']}',
                        style: new TextStyle(
                            fontSize: Adapt.px(28),
                            fontWeight: FontWeight.bold),
                      ),
                      Icon(
                        Icons.arrow_right,
                        color: MyColors.lowfontColor,
                      ),
                      new Text(_replyItemList[position]['to_user_name'],
                          style: new TextStyle(
                              fontSize: Adapt.px(28),
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Icon(Icons.more_horiz)
                ],
              ),
              new Padding(
                padding: EdgeInsets.all(Adapt.px(20)),
                child: new Text(_replyItemList[position]['reply_comment'],
                    style: new TextStyle(fontSize: Adapt.px(26))),
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Text(
                      TimelineUtil.formatByDateTime(DateTime.parse(
                          _replyItemList[position]['reply_time'])),
                      style: new TextStyle(
                          fontSize: Adapt.px(22),
                          color: MyColors.lowfontColor)),
                  new Row(
                    children: <Widget>[
                      new Row(
                        children: <Widget>[
                          new Text(_replyItemList[position]['reply_like'],
                              style: new TextStyle(
                                  fontSize: Adapt.px(22),
                                  color: MyColors.lowfontColor)),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: Adapt.px(12), right: Adapt.px(22)),
                              child: _replyItemList[position]['reply_liked']
                                  ? Icon(Icons.sentiment_satisfied,
                                      size: Adapt.px(36),
                                      color: MyColors.colorPrimary)
                                  : Icon(Icons.sentiment_neutral,
                                      size: Adapt.px(36),
                                      color: MyColors.lowfontColor))
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: Adapt.px(22), right: Adapt.px(22)),
                        child: Icon(Icons.message,
                            size: Adapt.px(36), color: MyColors.lowfontColor),
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        Offstage(
          offstage: position == 0,
          child: new Container(
            color: MyColors.dividerColor,
            height: Adapt.px(2),
          ),
        )
      ],
    );
  }

  Future _loadCommentData() {
    return DataUtils.getCommentInfo({
      'commentid': widget._commentId,
      'token': Application.spUtil.get('token')
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
          _commentInfo = data['comment'];
          _replyItemList = data['replies'];
          _itemCount = _replyItemList.length;
        });
      }
    }).catchError((onError) {
      setState(() {
        LogUtil.e(onError);
        _layoutState = LoadState.State_Error;
      });
    });
  }

  void _loadMoreReplyData() {
    _loadState = BottomState.bottom_Loading;
    DataUtils.getCommentReplyInfo({
      'commentid': widget._commentId,
      'token': Application.spUtil.get('token'),
      'currentpage': _itemCount.toString()
    }).then((result) {
      var data = result['data'];
      if (data.length == 0) {
        setState(() {
          _loadState = BottomState.bottom_Empty;
        });
      } else {
        setState(() {
          _replyItemList.addAll(data);
          _itemCount = _replyItemList.length;
        });
      }
    }).catchError((onError) {
      setState(() {
        _loadState = BottomState.bottom_Error;
      });
    });
  }
}
