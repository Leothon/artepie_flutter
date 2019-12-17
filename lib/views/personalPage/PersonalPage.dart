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
import 'package:video_player/video_player.dart';

class PersonalPage extends StatefulWidget {

  final bool isMyPage;
  final String userId;

  PersonalPage(this.isMyPage,this.userId);
  @override
  State<StatefulWidget> createState() {
    return new _personalPageState();
  }
}

class _personalPageState extends State<PersonalPage> {
  LoadState _layoutState = LoadState.State_Loading;
  BottomState _loadStateVideo = BottomState.bottom_Success;
  BottomState _loadStateArticle = BottomState.bottom_Success;
  ScrollController _scrollController = new ScrollController();
  var _itemCountVideo = 0;
  var _itemCountArticle = 0;
  List _videoItemList = [];
  List _articleItemList = [];
  var userInfo = {};
  bool isTop = false;

  bool isVideoPage = true;

  bool videoEmpty = true;
  bool articleEmpty = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    widget.isMyPage ? _loadUserInfoData() : _loadUserInfoDataById();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          isVideoPage
              ? _loadStateVideo = BottomState.bottom_Loading
              : _loadStateArticle = BottomState.bottom_Loading;
        });
        isVideoPage ? _loadMoreVideoData() : _loadMoreArticleData();
      }

      if (_scrollController.offset < Adapt.px(320)) {
        setState(() {
          isTop = true;
        });
      } else {
        setState(() {
          isTop = false;
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
          successWidget: _personalPageWidget(context),
          errorRetry: () {
            setState(() {
              _layoutState = LoadState.State_Loading;
            });
            widget.isMyPage ? _loadUserInfoData() : _loadUserInfoDataById();
            //_loadVideoData();
          },
          state: _layoutState,
        ));
  }

  Widget _personalPageWidget(BuildContext context) {
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
            actions: <Widget>[
              new InkWell(
                child: Container(
                  child: new Text(widget.isMyPage ? '编辑个人资料' : '',
                      textAlign: TextAlign.center,
                      style: new TextStyle(color: MyColors.fontColor)),
                  alignment: Alignment.center,
                  padding:
                      EdgeInsets.only(right: Adapt.px(24), left: Adapt.px(24)),
                ),
                onTap: () {
                  if(widget.isMyPage){
                    Application.router.navigateTo(context,
                        '${Routes.editPersonalPage}',
                        transition: TransitionType.fadeIn);
                  }

                },
              )
            ],
          ),
          SliverToBoxAdapter(
            child: new Container(
              color: Colors.white,
//              padding: EdgeInsets.all(Adapt.px(12)),
              margin: EdgeInsets.only(bottom: Adapt.px(24)),
              child: new Stack(
                children: <Widget>[
                  new Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Container(
                        width: double.infinity,
                        height: Adapt.px(340),
                        child: new Image.network(
                          'http://www.artepie.cn/image/aboutbackground.jpg',
                          fit: BoxFit.cover,
                        ),
                        foregroundDecoration: BoxDecoration(
                          color: MyColors.blackalpha,
                        ),
                      ),
                      new Container(
                        padding: EdgeInsets.all(Adapt.px(18)),
                        child: new Row(
                          children: <Widget>[
                            new Text(
                              userInfo.isEmpty ? '' : userInfo['user_name'],
                              style: new TextStyle(
                                  fontSize: Adapt.px(34),
                                  fontWeight: FontWeight.bold,
                                  color: MyColors.fontColor),
                            ),
                            new Text(
                              '    ${CommonUtils.getAgeByBirthday(userInfo.isEmpty ? '' : userInfo['user_birth'])}岁   ',
                              style: new TextStyle(
                                  fontSize: Adapt.px(24),
                                  color: MyColors.lowfontColor),
                            ),
                            new SizedBox(
                              height: Adapt.px(32),
                              width: Adapt.px(32),
                              child: Image.asset(userInfo.isEmpty
                                  ? 'lib/resource/assets/img/defaultsex.png'
                                  : (userInfo['user_sex'] == 0
                                      ? 'lib/resource/assets/img/defaultsex.png'
                                      : (userInfo['user_sex'] == 1
                                          ? 'lib/resource/assets/img/male.png'
                                          : 'lib/resource/assets/img/female.png'))),
                            )
                          ],
                        ),
                      ),
                      new Padding(
                          padding: EdgeInsets.all(Adapt.px(12)),
                        child: new Text(
                          userInfo.isEmpty ? '' : userInfo['user_signal'],
                          style: new TextStyle(
                              fontSize: Adapt.px(24),
                              color: MyColors.lowfontColor),
                        ),
                      ),
                      new Padding(
                        padding: EdgeInsets.all(Adapt.px(12)),
                        child: new Row(
                          children: <Widget>[
                            Icon(Icons.location_on),
                            new Text(
                              userInfo.isEmpty ? '' : userInfo['user_address'],
                              style: new TextStyle(
                                  fontSize: Adapt.px(24),
                                  color: MyColors.lowfontColor),
                            )
                          ],
                        ),
                      ),
                      new Row(
                        children: <Widget>[
                          new Padding(
                            padding: EdgeInsets.all(Adapt.px(12)),
                            child: new Text(userInfo.isEmpty ? '' : (
                            (userInfo['user_role'].substring(0, 1) == '0' ||
                                      userInfo['user_role'].substring(0, 1) ==
                                          '1')
                                  ? '认证: ${userInfo.isEmpty ? '' : userInfo['user_role'].substring(1)}'
                                  : ''),
                              style: new TextStyle(
                                  fontSize: Adapt.px(24),
                                  color: MyColors.colorPrimary),
                            ),
                          ),
                          new Offstage(
                            offstage: !widget.isMyPage,
                            child: new InkWell(
                              child: Container(
                                width: Adapt.px(140),
                                height: Adapt.px(60),
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(left: Adapt.px(10),bottom: Adapt.px(10)),
                                decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.circular(Adapt.px(14)),
                                    color: MyColors.colorPrimary),
                                child: new Text(
                                  '认证自己',
                                  style: new TextStyle(color: Colors.white),
                                ),
                              ),
                              onTap: () {},
                            ),
                          ),
                          Offstage(
                            offstage: !widget.isMyPage,
                            child: new InkWell(
                              child: Container(
                                width: Adapt.px(140),
                                height: Adapt.px(60),
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(left: Adapt.px(10),bottom: Adapt.px(10)),
                                decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.circular(Adapt.px(14)),
                                    color: MyColors.colorPrimary),
                                child: new Text(
                                  '制作课程',
                                  style: new TextStyle(color: Colors.white),
                                ),
                              ),
                              onTap: () {},
                            ),
                          ),

                        ],
                      )
                    ],
                  ),
                  new Container(
                    height: Adapt.px(340),
                    alignment: Alignment.center,
                    child: UserIconWidget(
                      url: userInfo.isEmpty ? '' : userInfo['user_icon'],
                      isAuthor: userInfo.isEmpty ? true : (userInfo['user_role'].substring(0, 1) == '1'),
                      authority:userInfo.isEmpty ? true :
                      (userInfo['user_role'].substring(0, 1) == '0' ||
                              userInfo['user_role'].substring(0, 1) == '1'),
                      size: Adapt.px(120),
                    ),
                  )
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: new Row(
              children: <Widget>[
                new InkWell(
                  child: Container(
                    width: Adapt.px(140),
                    height: Adapt.px(60),
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(left: Adapt.px(10)),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(Adapt.px(14)),
                            topRight: Radius.circular(Adapt.px(14))),
                        color: isVideoPage ? Colors.white : Colors.black12),
                    child: new Text('我的视频'),
                  ),
                  onTap: () {
                    setState(() {
                      //isVideoPage ? null : isVideoPage = true;
                      isVideoPage = true;
                    });
                  },
                ),
                new InkWell(
                  child: new Container(
                    width: Adapt.px(140),
                    height: Adapt.px(60),
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(left: Adapt.px(10)),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(Adapt.px(14)),
                            topRight: Radius.circular(Adapt.px(14))),
                        color: isVideoPage ? Colors.black12 : Colors.white),
                    child: new Text('我的文章'),
                  ),
                  onTap: () {
                    if (isVideoPage && _itemCountArticle == 0) {
                      _loadArticleData();
                    }
                    setState(() {
                      isVideoPage = false;
                    });
                  },
                ),
              ],
            ),
          ),
          isVideoPage
              ? SliverList(
                  delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    if (videoEmpty) {
                      return _emptyView;
                    } else {
                      if (index == _itemCountVideo) {
                        return new ListBottomView(
                            isHighBottom: true,
                            bottomState: _loadStateVideo,
                            errorRetry: () {
                              setState(() {
                                _loadStateVideo = BottomState.bottom_Loading;
                              });
                              _loadMoreVideoData();
                            });
                      } else {
                        return _videoItemWidget(context, index);

                      }
                    }
                  },
                  childCount: _itemCountVideo + 1,
                ))
              : SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                      Adapt.px(28), 0, Adapt.px(28), Adapt.px(8)),
                  sliver: new SliverGrid(
                    //Grid
                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, //Grid按两列显示
                      mainAxisSpacing: Adapt.px(28),
                      crossAxisSpacing: Adapt.px(28),
                      childAspectRatio: 0.75,
                    ),
                    delegate: new SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        //创建子widget

                        if (articleEmpty) {
                          return _emptyView;
                        } else {
                          if (index == _itemCountArticle) {
                            return new ListBottomView(
                                isHighBottom: true,
                                bottomState: _loadStateArticle,
                                errorRetry: () {
                                  setState(() {
                                    _loadStateArticle =
                                        BottomState.bottom_Loading;
                                  });
                                  _loadMoreArticleData();
                                });
                          } else {
                            return _articleItemWidget(context, index);
                          }
                        }
                      },
                      childCount: _itemCountArticle + 1,
                    ),
                  ),
                ),
        ],
      ),
      onRefresh: widget.isMyPage ? _loadUserInfoData : _loadUserInfoDataById,
    );
  }


  Future _loadUserInfoData() {
    return DataUtils.getUserInfo({'token': Application.spUtil.get('token')})
        .then((result) {
      var data = result['data'];
      if (data.length == 0) {
        setState(() {
          _layoutState = LoadState.State_Empty;
        });
      } else {
        setState(() {
          userInfo = data;
        });
        _loadVideoData();
//        setState(() {
//          _layoutState = LoadState.State_Success;
//        });
      }
    }).catchError((onError) {
      setState(() {
        LogUtil.e(onError);
        _layoutState = LoadState.State_Error;
      });
    });
  }

  Future _loadUserInfoDataById() {
    return DataUtils.getUserInfoById({'userid': widget.userId})
        .then((result) {
      var data = result['data'];
      if (data.length == 0) {
        setState(() {
          _layoutState = LoadState.State_Empty;
        });
      } else {
        setState(() {
          userInfo = data;
        });
        _loadVideoData();
//        setState(() {
//          _layoutState = LoadState.State_Success;
//        });
      }
    }).catchError((onError) {
      setState(() {
        LogUtil.e(onError);
        _layoutState = LoadState.State_Error;
      });
    });
  }

  Future _loadVideoData() {
    return DataUtils.getPersonalVideo(
            {'currentpage': '0', 'userid': widget.isMyPage ? Application.spUtil.get('userid') : widget.userId})
        .then((result) {
      var data = result['data'];
      if (data.length == 0) {
        setState(() {
          //_layoutState = LoadState.State_Empty;
          videoEmpty = true;
          _layoutState = LoadState.State_Success;
        });
      } else {
        setState(() {
          videoEmpty = false;
          _layoutState = LoadState.State_Success;
          _videoItemList = data;
          _itemCountVideo = _videoItemList.length;
        });
      }
    }).catchError((onError) {
      setState(() {
        LogUtil.e(onError);
        _layoutState = LoadState.State_Error;
      });
    });
  }

  Future _loadArticleData() {
    return DataUtils.getPersonalArticle({
      'userid': widget.isMyPage ? Application.spUtil.get('userid') : widget.userId,
      'currentpage': '0',
    }).then((result) {
      var data = result['data'];
      if (data.length == 0) {
        setState(() {
          //_layoutState = LoadState.State_Empty;
          articleEmpty = true;
          _layoutState = LoadState.State_Success;
        });
      } else {
        setState(() {
          articleEmpty = false;
          _layoutState = LoadState.State_Success;
          _articleItemList = data;
          _itemCountArticle = _articleItemList.length;
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
    _loadStateVideo = BottomState.bottom_Loading;
    DataUtils.getPersonalVideo({
      'currentpage': _itemCountVideo.toString(),
      'userid': widget.isMyPage ? Application.spUtil.get('userid') : widget.userId
    }).then((result) {
      var data = result['data'];
      if (data.length == 0) {
        setState(() {
          _loadStateVideo = BottomState.bottom_Empty;
        });
      } else {
        setState(() {
          _videoItemList.addAll(data);
          _itemCountVideo = _videoItemList.length;
        });
      }
    }).catchError((onError) {
      LogUtil.e(onError);
      setState(() {
        _loadStateVideo = BottomState.bottom_Error;
      });
    });
  }

  void _loadMoreArticleData() {
    _loadStateArticle = BottomState.bottom_Loading;
    DataUtils.getPersonalArticle({
      'userid': widget.isMyPage ? Application.spUtil.get('userid') : widget.userId,
      'currentpage': _itemCountArticle.toString(),
    }).then((result) {
      var data = result['data'];
      if (data.length == 0) {
        setState(() {
          _loadStateArticle = BottomState.bottom_Empty;
        });
      } else {
        setState(() {
          _articleItemList.addAll(data);
          _itemCountArticle = _articleItemList.length;
        });
      }
    }).catchError((onError) {
      LogUtil.e(onError);
      setState(() {
        _loadStateArticle = BottomState.bottom_Error;
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
            child: Text('暂无内容'),
          )
        ],
      ),
    );
  }

  Widget _videoItemWidget(BuildContext context, int position) {
    return new InkWell(
      onTap: () {
        Application.router.navigateTo(context,
            '${Routes.videoDetailPage}?videoid=${Uri.encodeComponent(_videoItemList[position]['qa_id'])}',
            transition: TransitionType.fadeIn);
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
                print('点击头像');
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
                print('点击名字');
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

  Widget _footWidget(BuildContext context, int position) {
    return new Container(
      margin: EdgeInsets.fromLTRB(Adapt.px(22), 0, Adapt.px(22), 0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new InkWell(
            onTap: () {
              print('点击喜欢');
            },
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.favorite_border,
                  size: Adapt.px(34),
                ),
                new Text(
                  _videoItemList[position]['qa_like'],
                  style: new TextStyle(fontSize: Adapt.px(22)),
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
                  _videoItemList[position]['qa_comment'],
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
                  print('点击转发');
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

  Widget _articleItemWidget(BuildContext context, int position) {
    return new InkWell(
      child: Container(
        padding: EdgeInsets.all(Adapt.px(14)),
        decoration: BoxDecoration(
            color: MyColors.white,
            borderRadius: BorderRadius.circular(Adapt.px(14))),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(Adapt.px(14)),
                child: FadeInImage.assetNetwork(
                  placeholder: 'lib/resource/assets/img/loading.png',
                  image: _articleItemList[position]['articleImg'] == null
                      ? 'http://www.artepie.cn/image/default_cover.png'
                      : _articleItemList[position]['articleImg'],
                  fit: BoxFit.cover,
                ),
              ),
              flex: 3,
            ),
            Expanded(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new Text(
                    _articleItemList[position]['articleTitle'],
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: new TextStyle(
                        fontSize: Adapt.px(26), color: Colors.black),
                  ),
                  new Padding(
                    padding:
                        EdgeInsets.fromLTRB(0, Adapt.px(6), 0, Adapt.px(6)),
                    child: new Text(
                      '推荐${_articleItemList[position]['likeCount']}   阅读${_articleItemList[position]['articleVisionCount']}',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: new TextStyle(
                          fontSize: Adapt.px(22), color: MyColors.fontColor),
                    ),
                  ),
                  new Row(
                    children: <Widget>[
                      UserIconWidget(
                        url: _articleItemList[position]['articleAuthorIcon'],
                        size: Adapt.px(34),
                        authority: _articleItemList[position]['authorRole']
                                        .substring(0, 1) ==
                                    0 ||
                                _articleItemList[position]['authorRole']
                                        .substring(0, 1) ==
                                    1
                            ? true
                            : false,
                        isAuthor: _articleItemList[position]['authorRole']
                                    .substring(0, 1) ==
                                0
                            ? false
                            : true,
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            Adapt.px(16), 0, Adapt.px(16), 0),
                        child: new Text(
                          _articleItemList[position]['articleAuthorName'],
                          maxLines: 1,
                          style: new TextStyle(
                              fontSize: Adapt.px(24),
                              color: MyColors.fontColor),
                        ),
                      )
                    ],
                  )
                ],
              ),
              flex: 2,
            )
          ],
        ),
      ),
      onTap: () {
        Application.router.navigateTo(context,
            '${Routes.articleDetailPage}?articleid=${Uri.encodeComponent(_articleItemList[position]['articleId'])}',
            transition: TransitionType.fadeIn);
      },
    );
  }
}
