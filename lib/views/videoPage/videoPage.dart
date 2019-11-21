import 'package:artepie/model/user_info.dart';
import 'package:artepie/resource/MyColors.dart';
import 'package:artepie/views/userIconWidget/UserIconWidget.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
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
  var _noticeInfo = '我这倒是难得跑i就得跑i手机打破旧的是';
  var _authInfo = '优秀民歌爱好者';
  var _content = '视频播放器视频播放器视频播放器视频播放器视频播放器视频播放器视频播放器视频播放器视频播放器视频播放器';
  var _readCount = '125';
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        backgroundColor: MyColors.dividerColor,
        body: new RefreshIndicator(
          displacement: 150,
          child: new Listener(
            child: new CustomScrollView(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              slivers: <Widget>[
                SliverAppBar(
                  title: new Text(
                    '秀吧视频',
                    style: new TextStyle(fontSize: 22, color: Colors.black),
                  ),
                  pinned: true,
                  backgroundColor: Colors.white,
                  brightness: Brightness.light,
                  elevation: 3,
                  forceElevated: true,
                ),
                SliverToBoxAdapter(
                  child: new Padding(
                    padding: EdgeInsets.all(8),
                    child: new Row(
                      children: <Widget>[
                        Icon(
                          Icons.info_outline,
                          size: 18,
                        ),
                        new Padding(
                          padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                          child: Text(
                            '官方消息：$_noticeInfo',
                            style: new TextStyle(fontSize: 12),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return _videoItem(context, index);
                    },
                    childCount: 20,
                  ),
                )
              ],
            ),
          ),
          onRefresh: () {},
        ));
  }

  Widget _videoItem(BuildContext context, int position) {
    return new Container(
      color: MyColors.white,
      margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
      padding: EdgeInsets.all(15),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _headWidget(context, position),
          _contentWidget(context, position),
          _footWidget(context, position),
        ],
      ),
    );
  }

  Widget _headWidget(BuildContext context, int position) {
    return new Container(
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child: UserIconWidget(
              url: 'http://www.artepie.cn/image/bannertest2.jpg',
              size: 34,
              authority: true,
              isAuthor: true,
            ),
            flex: 1,
          ),
          Expanded(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text(
                  '名字',
                  style: new TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                new Text(
                  '认证：$_authInfo',
                  style: new TextStyle(
                    fontSize: 10,
                    color: MyColors.fontColor,
                  ),
                ),
              ],
            ),
            flex: 6,
          ),
          Expanded(
            child: Icon(
              Icons.more_horiz,
            ),
            flex: 1,
          )
        ],
      ),
    );
  }

  Widget _footWidget(BuildContext context, int position) {
    return new Container(
      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Row(
            children: <Widget>[
              Icon(
                Icons.favorite_border,
                size: 18,
              ),
              new Text(
                '12',
                style: new TextStyle(fontSize: 12),
              )
            ],
          ),
          new Row(
            children: <Widget>[
              Icon(
                Icons.comment,
                size: 18,
              ),
              new Text(
                '5',
                style: new TextStyle(fontSize: 12),
              )
            ],
          ),
          Icon(
            Icons.repeat,
            size: 18,
          ),
          Icon(
            Icons.share,
            size: 18,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
  }

  var testVideoUrl =
      'https://v-cdn.zjol.com.cn/280443.mp4';
  Widget _contentWidget(BuildContext context, int position) {
    return new Container(
      padding: EdgeInsets.all(10),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          new Text(
            '$_content',
            style: new TextStyle(
              fontSize: 15,
            ),
          ),
          new Text(
            '阅读：$_readCount',
            style: new TextStyle(
              fontSize: 12,
            ),
          ),
          new Chewie(
            new VideoPlayerController.network(testVideoUrl),
            aspectRatio: 16 / 9,
            autoPlay: false,
            looping: true,
            showControls: true,
            placeholder: Container(width:double.infinity,child: Image.network('http://www.artepie.cn/image/bannertest2.jpg',fit: BoxFit.cover,)),
            autoInitialize: false,
            materialProgressColors: new ChewieProgressColors(
                playedColor: MyColors.white,
                handleColor: MyColors.colorPrimary,
                backgroundColor: Colors.grey,
                bufferedColor: MyColors.pressColorPrimary),
          )
        ],
      ),
    );
  }
}
