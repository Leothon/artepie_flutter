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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:video_player/video_player.dart';

class VideoDetailPage extends StatefulWidget {
  final String _videoId;
  VideoDetailPage(this._videoId);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _videoDetailPageState();
  }
}

class _videoDetailPageState extends State<VideoDetailPage> {
  LoadState _layoutState = LoadState.State_Loading;
  BottomState _loadState = BottomState.bottom_Success;
  ScrollController _scrollController = new ScrollController();
  var _itemCount = 0;
  List _commentItemList = [];
  var videoInfo = {};
  //bool isTop = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _loadVideoDetailData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          _loadState = BottomState.bottom_Loading;
        });
        _loadMoreCommentData();
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
        successWidget: _videoDetailPageWidget(context),
        errorRetry: () {
          setState(() {
            _layoutState = LoadState.State_Loading;
          });
          _loadVideoDetailData();
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
              child: new Text(
                '评论，请文明发言',
                style: new TextStyle(
                    fontSize: Adapt.px(28), color: MyColors.fontColor),
              ),
            ),
            Container(
              height: Adapt.px(2),
              color: MyColors.dividerColor,
            )
          ],
        ),
        onTap: () {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _videoDetailPageWidget(BuildContext context) {
    return RefreshIndicator(
      displacement: Adapt.px(200),
      child: new CustomScrollView(
        controller: _scrollController,
        physics: AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        slivers: <Widget>[
          SliverAppBar(
            brightness: Brightness.light,
            leading: InkWell(
              child: Icon(
                Icons.arrow_back,
                color: MyColors.fontColor,
              ),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
            backgroundColor: Colors.white,
            elevation: Adapt.px(8),
            pinned: true,
          ),
          SliverToBoxAdapter(child: _videoContent(context)),
          SliverToBoxAdapter(
            child: new Row(
              children: <Widget>[
                new Container(
                  width: Adapt.px(100),
                  height: Adapt.px(60),
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(left: Adapt.px(10)),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(Adapt.px(14)),
                          topRight: Radius.circular(Adapt.px(14))),
                      color: Colors.black12),
                  child: new Text('点赞'),
                ),
                new Container(
                  width: Adapt.px(100),
                  height: Adapt.px(60),
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(left: Adapt.px(10)),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(Adapt.px(14)),
                          topRight: Radius.circular(Adapt.px(14))),
                      color: Colors.white),
                  child: new Text('评论'),
                )
              ],
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                if (_commentItemList.length == 0) {
                  return _emptyView;
                } else {
                  if (index == _itemCount) {
                    return new ListBottomView(
                      isHighBottom: true,
                      bottomState: _loadState,
                      errorRetry: () {
                        setState(() {
                          _loadState = BottomState.bottom_Loading;
                        });
                        _loadMoreCommentData();
                      },
                    );
                  } else {
                    return _commentItem(context, index);
                  }
                }
              },
              childCount: _itemCount + 1,
            ),
          )
        ],
      ),
      onRefresh: _loadVideoDetailData,
    );
  }

  Widget _commentItem(BuildContext context, int position) {
    return new Container(
      color: Colors.white,
      padding: EdgeInsets.only(
          bottom: Adapt.px(8), left: Adapt.px(14), right: Adapt.px(14)),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _commentReplyItem(context, true, 11, position),
          Offstage(
            offstage: (_commentItemList[position]['replies']).length == 0,
            child: _commentReplyItem(context, false, 0, position),
          ),
          Offstage(
            offstage: !((_commentItemList[position]['replies']).length >= 2),
            child: !((_commentItemList[position]['replies']).length >= 2)
                ? new Container(
                    width: 0,
                    height: 0,
                  )
                : _commentReplyItem(context, false, 1, position),
          ),
          Offstage(
              offstage: !((_commentItemList[position]['replies']).length >= 3),
              child: new InkWell(
                child: Stack(
                  children: <Widget>[
                    new Container(
                      padding: EdgeInsets.only(
                          left: Adapt.px(68),
                          top: Adapt.px(18),
                          bottom: Adapt.px(18)),
                      child: new Text(
                        '查看全部${(_commentItemList[position]['replies']).length}条评论',
                        style: new TextStyle(
                            fontSize: Adapt.px(26),
                            color: MyColors.colorPrimary,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    new Container(
                      margin: EdgeInsets.only(left: Adapt.px(68)),
                      color: MyColors.dividerColor,
                      height: Adapt.px(2),
                    ),
                  ],
                ),
                onTap: () {
                  Application.router.navigateTo(context,
                      '${Routes.commentDetailPage}?commentid=${Uri.encodeComponent(_commentItemList[position]['comment_q_id'])}',
                      transition: TransitionType.fadeIn);
                },
              )),
        ],
      ),
    );
  }

  Widget _commentReplyItem(
      BuildContext context, bool comment, int index, int position) {
    return new Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(Adapt.px(18)),
          margin: EdgeInsets.only(left: comment ? 0 : Adapt.px(68)),
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
                        url: comment
                            ? _commentItemList[position]['user_icon']
                            : (_commentItemList[position]['replies'].length == 0
                                ? ''
                                : _commentItemList[position]['replies'][index]
                                    ['user_icon']),
                        isAuthor: false,
                        authority: false,
                        size: Adapt.px(46),
                      ),
                      new Text(
                        '  ${comment ? _commentItemList[position]['user_name'] : (_commentItemList[position]['replies'].length == 0 ? '' : _commentItemList[position]['replies'][index]['user_name'])}',
                        style: new TextStyle(
                            fontSize: Adapt.px(28),
                            fontWeight: FontWeight.bold),
                      ),
                      comment
                          ? new Text('')
                          : Icon(
                              Icons.arrow_right,
                              color: MyColors.lowfontColor,
                            ),
                      new Text(
                          comment
                              ? ''
                              : '${(_commentItemList[position]['replies'].length == 0 ? '' : _commentItemList[position]['replies'][index]['to_user_name'])} ',
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
                child: new Text(
                    comment
                        ? _commentItemList[position]['comment_q_content']
                        : (_commentItemList[position]['replies'].length == 0
                            ? ''
                            : _commentItemList[position]['replies'][index]
                                ['reply_comment']),
                    style: new TextStyle(fontSize: Adapt.px(26))),
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Text(
                      comment
                          ? TimelineUtil.formatByDateTime(DateTime.parse(
                              _commentItemList[position]['comment_q_time']))
                          : (_commentItemList[position]['replies'].length == 0
                              ? ''
                              : TimelineUtil.formatByDateTime(DateTime.parse(
                                  _commentItemList[position]['replies'][index]
                                      ['reply_time']))),
                      style: new TextStyle(
                          fontSize: Adapt.px(22),
                          color: MyColors.lowfontColor)),
                  new Row(
                    children: <Widget>[
                      new Row(
                        children: <Widget>[
                          new Text(
                              comment
                                  ? _commentItemList[position]['comment_q_like']
                                  : (_commentItemList[position]['replies']
                                              .length ==
                                          0
                                      ? ''
                                      : _commentItemList[position]['replies']
                                          [index]['reply_like']),
                              style: new TextStyle(
                                  fontSize: Adapt.px(22),
                                  color: MyColors.lowfontColor)),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: Adapt.px(12), right: Adapt.px(22)),
                              child: comment
                                  ? (_commentItemList[position]['comment_liked']
                                      ? Icon(Icons.sentiment_satisfied,
                                          size: Adapt.px(36),
                                          color: MyColors.colorPrimary)
                                      : Icon(Icons.sentiment_neutral,
                                          size: Adapt.px(36),
                                          color: MyColors.lowfontColor))
                                  : ((_commentItemList[position]['replies']
                                                  .length ==
                                              0
                                          ? true
                                          : _commentItemList[position]
                                              ['replies'][index]['reply_liked'])
                                      ? Icon(Icons.sentiment_satisfied,
                                          size: Adapt.px(36),
                                          color: MyColors.colorPrimary)
                                      : Icon(Icons.sentiment_neutral,
                                          size: Adapt.px(36),
                                          color: MyColors.lowfontColor)))
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
            margin: EdgeInsets.only(left: comment ? 0 : Adapt.px(68)),
            color: MyColors.dividerColor,
            height: Adapt.px(2),
          ),
        )
      ],
    );
  }

  Widget _videoContent(BuildContext context) {
    return new InkWell(
      onTap: () {
        print('整体跳转');
      },
      child: Container(
        color: MyColors.white,
        margin: EdgeInsets.fromLTRB(0, Adapt.px(18), 0, Adapt.px(18)),
        padding: EdgeInsets.all(Adapt.px(26)),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _headWidget(context),
            _contentWidget(context),
            _footWidget(context),
          ],
        ),
      ),
    );
  }

  Widget _headWidget(BuildContext context) {
    return new Container(
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child: new InkWell(
              onTap: () {
                Application.router.navigateTo(context,
                    '${Routes.personalPage}?info=false&userid=${videoInfo['qa_user_id']}',
                    transition: TransitionType.fadeIn);
              },
              child: UserIconWidget(
                url: videoInfo.isEmpty ? '' : videoInfo['user_icon'],
                size: Adapt.px(66),
                authority: videoInfo.isEmpty
                    ? false
                    : (videoInfo['user_role'].substring(0, 1) == '0' ||
                            videoInfo['user_role'].substring(0, 1) == '1'
                        ? true
                        : false),
                isAuthor: videoInfo.isEmpty
                    ? false
                    : (videoInfo['user_role'].substring(0, 1) == '0'
                        ? false
                        : true),
              ),
            ),
            flex: 1,
          ),
          Expanded(
            child: new InkWell(
              onTap: () {
                Application.router.navigateTo(context,
                    '${Routes.personalPage}?info=false&userid=${videoInfo['qa_user_id']}',
                    transition: TransitionType.fadeIn);
              },
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Text(
                    videoInfo.isEmpty ? '' : videoInfo['user_name'],
                    style: new TextStyle(
                        fontSize: Adapt.px(26),
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  new Text(
                    videoInfo.isEmpty
                        ? ''
                        : (videoInfo['user_role'].substring(0, 1) == '0' ||
                                videoInfo['user_role'].substring(0, 1) == '1'
                            ? '认证：${videoInfo['user_role'].substring(1)}'
                            : '${videoInfo['user_signal']}'),
                    style: new TextStyle(
                      fontSize: Adapt.px(20),
                      color: MyColors.fontColor,
                    ),
                  ),
                ],
              ),
            ),
            flex: 6,
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                print('点击更多');
              },
              child: Icon(
                Icons.more_horiz,
              ),
            ),
            flex: 1,
          )
        ],
      ),
    );
  }

  Widget _footWidget(BuildContext context) {
    return new Container(
      margin: EdgeInsets.fromLTRB(Adapt.px(22), 0, Adapt.px(22), 0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new InkWell(
            onTap: () {
              videoInfo['liked'] ? _removeLikeVideoData() : _addLikeVideoData();
            },
            child: Row(
              children: <Widget>[
                Icon(
                  videoInfo.isEmpty
                      ? Icons.favorite_border
                      : (videoInfo['liked']
                          ? Icons.favorite
                          : Icons.favorite_border),
                  size: Adapt.px(34),
                  color: videoInfo.isEmpty
                      ? MyColors.fontColor
                      : (videoInfo['liked']
                          ? MyColors.colorAccent
                          : MyColors.fontColor),
                ),
                new Text(
                  videoInfo.isEmpty ? '' : videoInfo['qa_like'],
                  style: new TextStyle(
                      fontSize: Adapt.px(22),
                      color: videoInfo.isEmpty
                          ? MyColors.fontColor
                          : (videoInfo['liked']
                              ? MyColors.colorAccent
                              : MyColors.fontColor)),
                )
              ],
            ),
          ),
          new InkWell(
            onTap: () {
              print('点击评论');
            },
            child: new Row(
              children: <Widget>[
                Icon(
                  Icons.comment,
                  size: Adapt.px(34),
                ),
                new Text(
                  videoInfo.isEmpty ? '' : videoInfo['qa_comment'],
                  style: new TextStyle(fontSize: Adapt.px(22)),
                )
              ],
            ),
          ),
          new InkWell(
            onTap: () {
              print('点击转发');
            },
            child: Icon(
              Icons.repeat,
              size: Adapt.px(34),
            ),
          ),
          new InkWell(
            onTap: () {
              print('点击分享');
            },
            child: Icon(
              Icons.share,
              size: Adapt.px(34),
            ),
          ),
        ],
      ),
    );
  }

  Widget _contentWidget(BuildContext context) {
    return new Container(
      padding: EdgeInsets.all(Adapt.px(18)),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          new Text(
            videoInfo.isEmpty ? '' : videoInfo['qa_content'],
            style: new TextStyle(
              fontSize: Adapt.px(26),
            ),
          ),
          new Text(
            '阅读：${videoInfo.isEmpty ? '' : videoInfo['qa_view']}',
            style: new TextStyle(
                fontSize: Adapt.px(22), color: MyColors.lowfontColor),
          ),
          new Offstage(
            offstage: videoInfo.isEmpty ? true : videoInfo['qa_video'] == null,
            child: new Chewie(
              new VideoPlayerController.network(videoInfo.isEmpty
                  ? ''
                  : (videoInfo['qa_video'] == null
                      ? ''
                      : videoInfo['qa_video'])),
              aspectRatio: 16 / 9,
              autoPlay: false,
              looping: true,
              showControls: true,
              placeholder: Container(
                  width: double.infinity,
                  child: Image.network(
                    videoInfo.isEmpty
                        ? ''
                        : (videoInfo['qa_video'] == null
                            ? ''
                            : videoInfo['qa_video_cover']),
                    fit: BoxFit.cover,
                  )),
              autoInitialize: false,
              materialProgressColors: new ChewieProgressColors(
                  playedColor: MyColors.white,
                  handleColor: MyColors.colorPrimary,
                  backgroundColor: Colors.grey,
                  bufferedColor: MyColors.pressColorPrimary),
            ),
          ),
          new Offstage(
              offstage:
                  videoInfo.isEmpty ? true : (videoInfo['qaData'] == null),
              child: InkWell(
                onTap: () {
                  Application.spUtil.get('login')
                      ? Application.router.navigateTo(context,
                          '${Routes.videoDetailPage}?videoid=${Uri.encodeComponent(videoInfo.isEmpty ? '' : videoInfo['qaData']['qa_id'])}',
                          transition: TransitionType.fadeIn)
                      : CommonUtils.toLogin(context);
                },
                child: Container(
                  alignment: Alignment.centerLeft,
                  margin:
                      EdgeInsets.only(top: Adapt.px(14), bottom: Adapt.px(14)),
                  padding: EdgeInsets.all(
                    Adapt.px(14),
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Adapt.px(14)),
                      color: MyColors.dividerColor),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                                text: videoInfo.isEmpty
                                    ? ''
                                    : '@${videoInfo['qaData'] == null ? '' : videoInfo['qaData']['user_name']}  ',
                                style: TextStyle(
                                    fontSize: Adapt.px(28),
                                    color: MyColors.blue)),
                            TextSpan(
                                text: videoInfo.isEmpty
                                    ? ''
                                    : (videoInfo['qaData'] == null
                                        ? ''
                                        : videoInfo['qaData']['qa_content']),
                                style: TextStyle(
                                    fontSize: Adapt.px(28),
                                    color: MyColors.fontColor)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(Adapt.px(10)),
                        child: new Text(
                          '喜欢：${videoInfo.isEmpty ? '' : (videoInfo['qaData'] == null ? '' : videoInfo['qaData']['qa_like'])}  评论：${videoInfo.isEmpty ? '' : (videoInfo['qaData'] == null ? '' : videoInfo['qaData']['qa_comment'])}',
                          style: new TextStyle(fontSize: Adapt.px(22)),
                        ),
                      ),
                      new Offstage(
                        offstage: videoInfo.isEmpty
                            ? true
                            : (videoInfo['qaData'] == null
                                ? true
                                : videoInfo['qaData']['qa_video'] == null),
                        child: new Chewie(
                          new VideoPlayerController.network(videoInfo.isEmpty
                              ? ''
                              : (videoInfo['qaData'] == null
                                  ? ''
                                  : (videoInfo['qaData']['qa_video'] == null
                                      ? ''
                                      : videoInfo['qaData']['qa_video']))),
                          aspectRatio: 16 / 9,
                          autoPlay: false,
                          looping: true,
                          showControls: true,
                          placeholder: Container(
                              width: double.infinity,
                              child: Image.network(
                                videoInfo.isEmpty
                                    ? ''
                                    : (videoInfo['qaData'] == null
                                        ? ''
                                        : (videoInfo['qaData']
                                                    ['qa_video_cover'] ==
                                                null
                                            ? ''
                                            : videoInfo['qaData']
                                                ['qa_video_cover'])),
                                fit: BoxFit.cover,
                              )),
                          autoInitialize: false,
                          materialProgressColors: new ChewieProgressColors(
                              playedColor: MyColors.white,
                              handleColor: MyColors.colorPrimary,
                              backgroundColor: Colors.grey,
                              bufferedColor: MyColors.pressColorPrimary),
                        ),
                      ),
                    ],
                  ),
                ),
              ))
        ],
      ),
    );
  }

  Future _loadVideoDetailData() {
    return DataUtils.getVideoDetail(
            {'token': Application.spUtil.get('token'), 'qaid': widget._videoId})
        .then((result) {
      var data = result['data'];
      if (data.length == 0) {
        setState(() {
          _layoutState = LoadState.State_Empty;
        });
      } else {
        setState(() {
          _layoutState = LoadState.State_Success;
          _commentItemList = data['comments'];
          videoInfo = data['qaData'];
          _itemCount = _commentItemList.length;
        });
      }
    }).catchError((onError) {
      setState(() {
        LogUtil.e(onError);
        _layoutState = LoadState.State_Error;
      });
    });
  }

  void _loadMoreCommentData() {
    _loadState = BottomState.bottom_Loading;
    DataUtils.getVideoMoreComment({
      'token': Application.spUtil.get('token'),
      'qaid': widget._videoId,
      'currentpage': _itemCount.toString(),
    }).then((result) {
      var data = result['data'];
      if (data.length == 0) {
        setState(() {
          _loadState = BottomState.bottom_Empty;
        });
      } else {
        setState(() {
          _commentItemList.addAll(data);
          _itemCount = _commentItemList.length;
        });
      }
    }).catchError((onError) {
      setState(() {
        _loadState = BottomState.bottom_Error;
      });
    });
  }

  Widget get _emptyView {
    return Container(
      color: Colors.white,
      width: double.infinity,
      height: Adapt.px(300),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'lib/resource/assets/img/emptyimg.png',
            height: Adapt.px(200),
            width: Adapt.px(200),
          ),
          Padding(
            padding: EdgeInsets.only(top: Adapt.px(10)),
            child: Text('暂无评论'),
          )
        ],
      ),
    );
  }

  Future _addLikeVideoData() {
    return DataUtils.addLikeVideo({
      'token': Application.spUtil.get('token'),
      'qaid': videoInfo['qa_id']
    }).then((result) {
      setState(() {
        videoInfo['qa_like'] =
            (double.parse(videoInfo['qa_like']) + 1).toStringAsFixed(0);
        videoInfo['liked'] = !videoInfo['liked'];
      });
      Toast.show('已点赞', context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
    }).catchError((onError) {
      Toast.show('点赞发生错误，请重试', context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
    });
  }

  Future _removeLikeVideoData() {
    return DataUtils.removeLikeVideo({
      'token': Application.spUtil.get('token'),
      'qaid': videoInfo['qa_id']
    }).then((result) {
      setState(() {
        videoInfo['qa_like'] =
            (double.parse(videoInfo['qa_like']) - 1).toStringAsFixed(0);
        videoInfo['liked'] = !videoInfo['liked'];
      });
      Toast.show('已取消赞', context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
    }).catchError((onError) {
      Toast.show('取消赞发生错误，请重试', context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
    });
  }
}
