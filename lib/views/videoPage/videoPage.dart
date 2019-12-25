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

class VideoPage extends StatefulWidget {
  final bool hasLogined;

  VideoPage(this.hasLogined);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _MyVideoPageState();
  }
}

class _MyVideoPageState extends State<VideoPage> {
  var _noticeInfo = '';

  LoadState _layoutState = LoadState.State_Loading;
  BottomState _loadState = BottomState.bottom_Success;
  ScrollController _scrollController = new ScrollController();

  var _itemCount = 1;
  List _videoItemList = [];
  bool isNeedUp = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadVideoData();
    _loadInform();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          _loadState = BottomState.bottom_Loading;
        });
        _loadMoreVideoData();
      }

      if (_scrollController.offset < Adapt.px(1000)) {
        setState(() {
          isNeedUp = false;
        });
      } else {
        setState(() {
          isNeedUp = true;
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
    return Scaffold(
      backgroundColor: MyColors.dividerColor,
      body: new LoadStateLayout(
        successWidget: _videoPageWidget(context),
        errorRetry: () {
          setState(() {
            _layoutState = LoadState.State_Loading;
          });
          _loadVideoData();
        },
        state: _layoutState,
      ),
      floatingActionButton: Offstage(
        child: Container(
          height: Adapt.px(80),
          width: Adapt.px(80),
          child: FloatingActionButton(
            backgroundColor: MyColors.white,
            heroTag: 'video',
            child: Icon(
              Icons.arrow_upward,
              color: MyColors.fontColor,
            ),
            elevation: 3,
            onPressed: () {
              _scrollController.animateTo(
                0,
                duration: new Duration(milliseconds: 300), // 300ms
                curve: Curves.bounceIn, // 动画方式
              );
            },
          ),
        ),
        offstage: !isNeedUp,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _videoPageWidget(BuildContext context) {
    return new RefreshIndicator(
      displacement: Adapt.px(200),
      child: new CustomScrollView(
        controller: _scrollController,
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        slivers: <Widget>[
          SliverAppBar(
            title: new Text(
              '秀吧视频',
              style: new TextStyle(fontSize: Adapt.px(34), color: Colors.black),
            ),
            pinned: true,
            backgroundColor: Colors.white,
            brightness: Brightness.light,
            elevation: 3,
            forceElevated: true,
          ),
          SliverToBoxAdapter(
              child: new InkWell(
                  child: new Padding(
                    padding: EdgeInsets.all(Adapt.px(12)),
                    child: new Flex(
                      direction: Axis.horizontal,
                      children: <Widget>[
                        Icon(
                          Icons.info_outline,
                          size: Adapt.px(34),
                        ),
                        Expanded(
                            child: new Padding(
                          padding: EdgeInsets.fromLTRB(
                              Adapt.px(8), 0, Adapt.px(8), 0),
                          child: Text(
                            _noticeInfo,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: new TextStyle(fontSize: Adapt.px(22)),
                          ),
                        ))
                      ],
                    ),
                  ),
                  onTap: () {
                    showDialog<Null>(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return new AlertDialog(
                            title: new Text('公告'),
                            content: new SingleChildScrollView(
                              child: new ListBody(
                                children: <Widget>[
                                  new Text(_noticeInfo),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              new FlatButton(
                                child: new Text('确定'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        });
                  })),
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
                      _loadMoreVideoData();
                    },
                  );
                } else {
                  return _videoItem(context, index);
                }
              },
              childCount: _itemCount + 1,
            ),
          )
        ],
      ),
      onRefresh: _loadVideoData,
    );
  }

  Widget _videoItem(BuildContext context, int position) {
    return new InkWell(
      onTap: () {
        Application.spUtil.get('login') ? Application.router.navigateTo(context,
            '${Routes.videoDetailPage}?videoid=${Uri
                .encodeComponent(
                _videoItemList[position]['qa_id'])}',
            transition: TransitionType.fadeIn) : CommonUtils.toLogin(context);
      },
      child: Container(
        color: MyColors.white,
        margin: EdgeInsets.fromLTRB(0, 0, 0, Adapt.px(18)),
        padding: EdgeInsets.all(Adapt.px(26)),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _headWidget(context, position),
            _contentWidget(context, position),
            _footWidget(context, position),
          ],
        ),
      ),
    );
  }

  Widget _headWidget(BuildContext context, int position) {
    return new Container(
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child: new InkWell(
              onTap: () {
                Application.spUtil.get('login') ?  Application.router.navigateTo(context,
                    '${Routes.personalPage}?info=false&userid=${_videoItemList[position]['qa_user_id']}',
                    transition: TransitionType.fadeIn) : CommonUtils.toLogin(context);
              },
              child: UserIconWidget(
                url: _videoItemList[position]['user_icon'],
                size: Adapt.px(66),
                authority: _videoItemList[position]['user_role']
                                .substring(0, 1) ==
                            '0' ||
                        _videoItemList[position]['user_role'].substring(0, 1) ==
                            '1'
                    ? true
                    : false,
                isAuthor:
                    _videoItemList[position]['user_role'].substring(0, 1) == '0'
                        ? false
                        : true,
              ),
            ),
            flex: 1,
          ),
          Expanded(
            child: new InkWell(
              onTap: () {
                Application.spUtil.get('login') ?  Application.router.navigateTo(context,
                    '${Routes.personalPage}?info=false&userid=${_videoItemList[position]['qa_user_id']}',
                    transition: TransitionType.fadeIn) : CommonUtils.toLogin(context);
              },
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Text(
                    _videoItemList[position]['user_name'],
                    style: new TextStyle(
                        fontSize: Adapt.px(26),
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  new Text(
                    _videoItemList[position]['user_role'].substring(0, 1) ==
                                '0' ||
                            _videoItemList[position]['user_role']
                                    .substring(0, 1) ==
                                '1'
                        ? '认证：${_videoItemList[position]['user_role'].substring(1)}'
                        : '${_videoItemList[position]['user_signal']}',
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
                Application.spUtil.get('login') ? print('点击更多') : CommonUtils.toLogin(context);
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

  Widget _footWidget(BuildContext context, int position) {
    return new Container(
      margin: EdgeInsets.fromLTRB(Adapt.px(22), 0, Adapt.px(22), 0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new InkWell(
            onTap: () {Application.spUtil.get('login') ? _videoItemList[position]['liked'] ? _removeLikeVideoData(position) : _addLikeVideoData(position) : CommonUtils.toLogin(context);},
            child: Row(
              children: <Widget>[
                Icon(
                  _videoItemList[position]['liked'] ? Icons.favorite : Icons.favorite_border,
                  size: Adapt.px(34),
                  color: _videoItemList[position]['liked'] ? MyColors.colorAccent : MyColors.fontColor,
                ),
                new Text(
                  _videoItemList[position]['qa_like'],
                  style: new TextStyle(fontSize: Adapt.px(22),color: _videoItemList[position]['liked'] ? MyColors.colorAccent : MyColors.fontColor),
                )
              ],
            ),
          ),
          new InkWell(
            onTap: () {Application.spUtil.get('login') ? print('点击评论') : CommonUtils.toLogin(context);},
            child: new Row(
              children: <Widget>[
                Icon(
                  Icons.comment,
                  size: Adapt.px(34),
                ),
                new Text(
                  _videoItemList[position]['qa_comment'],
                  style: new TextStyle(fontSize: Adapt.px(22)),
                )
              ],
            ),
          ),
          new InkWell(
            onTap: () {Application.spUtil.get('login') ? print('点击转发') : CommonUtils.toLogin(context);},
            child: Icon(
              Icons.repeat,
              size: Adapt.px(34),
            ),
          ),
          new InkWell(
            onTap: () {Application.spUtil.get('login') ? print('点击分享') : CommonUtils.toLogin(context);},
            child: Icon(
              Icons.share,
              size: Adapt.px(34),
            ),
          ),
        ],
      ),
    );
  }

  Widget _contentWidget(BuildContext context, int position) {
    return new Container(
      padding: EdgeInsets.all(Adapt.px(18)),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          new Text(
            _videoItemList[position]['qa_content'],
            style: new TextStyle(
              fontSize: Adapt.px(26),
            ),
          ),
          new Text(
            '阅读：${_videoItemList[position]['qa_view']}',
            style: new TextStyle(
                fontSize: Adapt.px(22), color: MyColors.lowfontColor),
          ),
          new Offstage(
            offstage: _videoItemList[position]['qa_video'] == null,
            child: new Chewie(
              new VideoPlayerController.network(
                  _videoItemList[position]['qa_video'] == null
                      ? ''
                      : _videoItemList[position]['qa_video']),
              aspectRatio: 16 / 9,
              autoPlay: false,
              looping: true,
              showControls: true,
              placeholder: Container(
                  width: double.infinity,
                  child: Image.network(
                    _videoItemList[position]['qa_video'] == null
                        ? ''
                        : _videoItemList[position]['qa_video_cover'],
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
              offstage: _videoItemList[position]['qaData'] == null,
              child: InkWell(
                onTap: () {
                  Application.spUtil.get('login') ? Application.router.navigateTo(context,
                      '${Routes.videoDetailPage}?videoid=${Uri
                          .encodeComponent(
                          _videoItemList[position]['qaData']['qa_id'])}',
                      transition: TransitionType.fadeIn) : CommonUtils.toLogin(context);
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
                                text: _videoItemList[position]['qaData'] == null
                                    ? ''
                                    : '@${_videoItemList[position]['qaData']['user_name']}  ',
                                style: TextStyle(
                                    fontSize: Adapt.px(28),
                                    color: MyColors.blue)),
                            TextSpan(
                                text: _videoItemList[position]['qaData'] == null
                                    ? ''
                                    : _videoItemList[position]['qaData']
                                        ['qa_content'],
                                style: TextStyle(
                                    fontSize: Adapt.px(28),
                                    color: MyColors.fontColor)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(Adapt.px(10)),
                        child: new Text(
                          '喜欢：${_videoItemList[position]['qaData'] == null ? '' : _videoItemList[position]['qaData']['qa_like']}  评论：${_videoItemList[position]['qaData'] == null ? '' : _videoItemList[position]['qaData']['qa_comment']}',
                          style: new TextStyle(fontSize: Adapt.px(22)),
                        ),
                      ),
                      new Offstage(
                        offstage: _videoItemList[position]['qaData'] == null
                            ? true
                            : _videoItemList[position]['qaData']['qa_video'] ==
                                null,
                        child: new Chewie(
                          new VideoPlayerController.network(
                              _videoItemList[position]['qaData'] == null
                                  ? ''
                                  : (_videoItemList[position]['qaData']
                                              ['qa_video'] ==
                                          null
                                      ? ''
                                      : _videoItemList[position]['qaData']
                                          ['qa_video'])),
                          aspectRatio: 16 / 9,
                          autoPlay: false,
                          looping: true,
                          showControls: true,
                          placeholder: Container(
                              width: double.infinity,
                              child: Image.network(
                                _videoItemList[position]['qaData'] == null
                                    ? ''
                                    : (_videoItemList[position]['qaData']
                                                ['qa_video_cover'] ==
                                            null
                                        ? ''
                                        : _videoItemList[position]['qaData']
                                            ['qa_video_cover']),
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

  Future _addLikeVideoData(int position) {
    return DataUtils.addLikeVideo({'token': Application.spUtil.get('token'),'qaid' : _videoItemList[position]['qa_id']})
        .then((result) {

      setState(() {
        _videoItemList[position]['qa_like'] = (double.parse(_videoItemList[position]['qa_like']) + 1).toStringAsFixed(0);
        _videoItemList[position]['liked'] = !_videoItemList[position]['liked'];
      });
      Toast.show('已点赞', context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
    }).catchError((onError) {
      Toast.show('点赞发生错误，请重试', context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
    });
  }

  Future _removeLikeVideoData(int position) {


    return DataUtils.removeLikeVideo({'token': Application.spUtil.get('token'),'qaid' : _videoItemList[position]['qa_id']})
        .then((result) {
      setState(() {
        _videoItemList[position]['qa_like'] = (double.parse(_videoItemList[position]['qa_like']) - 1).toStringAsFixed(0);
        _videoItemList[position]['liked'] = !_videoItemList[position]['liked'];
      });
      Toast.show('已取消赞', context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
    }).catchError((onError) {
      Toast.show('取消赞发生错误，请重试', context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
    });
  }

  Future _loadVideoData() {
    return DataUtils.getVideoData({'token': Application.spUtil.get('token')})
        .then((result) {
      var data = result['data'];

      if (data.length == 0) {
        setState(() {
          _layoutState = LoadState.State_Empty;
        });
      } else {
        setState(() {
          _loadState = BottomState.bottom_Loading;
          _layoutState = LoadState.State_Success;
          _videoItemList = data;
          _itemCount = data.length;
        });
      }
    }).catchError((onError) {
      setState(() {
        LogUtil.e(onError);
        _layoutState = LoadState.State_Error;
      });
    });
  }

  void _loadMoreVideoData() {
    DataUtils.getVideoMoreData({
      'currentpage': _itemCount.toString(),
      'token': Application.spUtil.get('token')
    }).then((result) {
      var data = result['data'];
      if (data.length == 0) {
        setState(() {
          _loadState = BottomState.bottom_Empty;
        });
      } else {
        setState(() {
          _videoItemList.addAll(data);
          _itemCount = _videoItemList.length;
        });
      }
    }).catchError((onError) {
      setState(() {
        _loadState = BottomState.bottom_Error;
      });
    });
  }

  void _loadInform() {
    DataUtils.getInform({'token': Application.spUtil.get('token')})
        .then((result) {
      var data = result['data'];
      setState(() {
        _noticeInfo = data['informText'];
      });
    }).catchError((onError) {
      setState(() {
        setState(() {
          _noticeInfo = '加载错误，刷新重试';
        });
      });
    });
  }
}
