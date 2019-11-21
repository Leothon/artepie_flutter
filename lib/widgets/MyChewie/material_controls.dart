import 'dart:async';


import 'package:artepie/widgets/MyChewie/chewie_progress_colors.dart';
import 'package:artepie/widgets/MyChewie/material_progress_bar.dart';
import 'package:artepie/widgets/MyChewie/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class MaterialControls extends StatefulWidget {
  final VideoPlayerController controller;
  final bool fullScreen;
  final Future<dynamic> Function() onExpandCollapse;
  final ChewieProgressColors progressColors;
  final bool autoPlay;
  final String title;
  MaterialControls({
    @required this.controller,
    @required this.fullScreen,
    @required this.onExpandCollapse,
    @required this.progressColors,
    @required this.autoPlay,
    @required this.title,
  });

  @override
  State<StatefulWidget> createState() {
    return new _MaterialControlsState();
  }
}

class _MaterialControlsState extends State<MaterialControls> {
  VideoPlayerValue _latestValue;
  double _latestVolume;
  bool _hideStuff = true;
  Timer _hideTimer;
  Timer _showTimer;
  Timer _showAfterExpandCollapseTimer;
  bool _dragging = false;

  final barHeight = 40.0;
  final marginSize = 5.0;



  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        widget.fullScreen ? _buildHeader(context, widget.title) : new Container(),

        _buildHitArea(),
        _buildBottomBar(context, widget.controller),
      ],
    );
  }


  AnimatedOpacity _buildHeader(BuildContext context, String title) {
    return new AnimatedOpacity(
      opacity: _hideStuff ? 0.0 : 1.0,
      duration: new Duration(milliseconds: 300),
      child: new Container(
        color: Color(0x33000000),
        height: barHeight,
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new IconButton(
              onPressed: _onExpandCollapse,
              color: Colors.white,
              icon: new Icon(Icons.chevron_left),
            ),
            new Text(
              '$title',
              style: new TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
            ),
          ],
        ),
      ),
    );
  }


  @override
  void dispose() {
    _dispose();
    super.dispose();
  }

  void _dispose() {
    widget.controller.removeListener(_updateState);
    _hideTimer?.cancel();
    _showTimer?.cancel();
    _showAfterExpandCollapseTimer?.cancel();
  }

  @override
  void initState() {
    _initialize();

    super.initState();
  }

  @override
  void didUpdateWidget(MaterialControls oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller.dataSource != oldWidget.controller.dataSource) {
      _dispose();
      _initialize();
    }
  }

  AnimatedOpacity _buildBottomBar(
    BuildContext context,
    VideoPlayerController controller,
  ) {
    final iconColor = Theme.of(context).textTheme.button.color;

    return new AnimatedOpacity(
      //opacity: _hideStuff ? 0.0 : 1.0,
      opacity:
          _latestValue.duration == null  || _hideStuff ? 0.0 : 1.0,
      duration: new Duration(milliseconds: 300),
      child: new Container(
        height: barHeight,
        color:  Color(0x33000000),
        child: new Row(
          children: <Widget>[
//            _buildPlayPause(controller),
            _buildPosition(iconColor),
            _buildProgressBar(),
            _buildMuteButton(controller),
            _buildExpandButton(),
          ],
        ),
      ),
    );
  }

  GestureDetector _buildExpandButton() {
    return new GestureDetector(
      onTap: _onExpandCollapse,
      child: new AnimatedOpacity(
        opacity: _hideStuff ? 0.0 : 1.0,
        duration: new Duration(milliseconds: 300),
        child: new Container(
          height: barHeight,
          margin: new EdgeInsets.only(right: 10.0),
          padding: new EdgeInsets.only(
            left: 8.0,
            right: 8.0,
          ),
          child: new Center(
            child: new Icon(
              widget.fullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Expanded _buildHitArea() {
    return new Expanded(
      child: new GestureDetector(
        onTap: _latestValue != null && _latestValue.isPlaying
            ? _cancelAndRestartTimer
            : () {
                _playPause();

                setState(() {
                  _hideStuff = true;
                });
              },
        child: new Container(
          color: Colors.transparent,
          child: new Center(
            child: new AnimatedOpacity(
              opacity: _hideStuff ? 0.0 : 1.0,
//                  _latestValue != null && !_latestValue.isPlaying && !_dragging
//                      ? 1.0
//                      : 0.0,
              duration: new Duration(milliseconds: 300),
              child: new GestureDetector(
                child: new Container(
                  margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                  decoration: new BoxDecoration(
                    color: Colors.black38,
                    borderRadius: new BorderRadius.circular(48.0),
                  ),
                  child: new Padding(
                    padding: new EdgeInsets.all(12.0),
                    child: _latestValue.isPlaying ? Icon(Icons.pause,size: 32.0,color: Colors.white,) : Icon(Icons.play_arrow,size: 32.0,color: Colors.white,),
                  ),
                ),
                onTap: _playPause,
              ),
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector _buildMuteButton(
    VideoPlayerController controller,
  ) {
    return new GestureDetector(
      onTap: () {
        _cancelAndRestartTimer();

        if (_latestValue.volume == 0) {
          controller.setVolume(_latestVolume ?? 0.5);
        } else {
          _latestVolume = controller.value.volume;
          controller.setVolume(0.0);
        }
      },
      child: new AnimatedOpacity(
        opacity: _hideStuff ? 0.0 : 1.0,
        duration: new Duration(milliseconds: 300),
        child: new ClipRect(
          child: new Container(
            child: new Container(
              height: barHeight,
              padding: new EdgeInsets.only(
                left: 8.0,
                right: 8.0,
              ),
              child: new Icon(

                (_latestValue != null && _latestValue.volume > 0)
                    ? Icons.volume_up
                    : Icons.volume_off,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

//  GestureDetector _buildPlayPause(VideoPlayerController controller) {
//    return new GestureDetector(
//      onTap: _playPause,
//      child: new Container(
//        height: barHeight,
//        color: Colors.transparent,
//        margin: new EdgeInsets.only(left: 8.0, right: 4.0),
//        padding: new EdgeInsets.only(
//          left: 12.0,
//          right: 12.0,
//        ),
//        child: new Icon(
//          controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
//          color: Colors.white,
//        ),
//      ),
//    );
//  }

  Widget _buildPosition(Color iconColor) {
    final position = _latestValue != null && _latestValue.position != null
        ? _latestValue.position
        : Duration.zero;
    final duration = _latestValue != null && _latestValue.duration != null
        ? _latestValue.duration
        : Duration.zero;

    return new Padding(
      padding: new EdgeInsets.fromLTRB(20,0,10,0),
      child: new Text(
        '${formatDuration(position)} / ${formatDuration(duration)}',
        style: new TextStyle(
          fontSize: 14.0,
          color: Colors.white
        ),
      ),
    );
  }

  void _cancelAndRestartTimer() {
    _hideTimer?.cancel();
    _startHideTimer();

    setState(() {
      _hideStuff = false;
    });
  }

  Future<Null> _initialize() async {
    widget.controller.addListener(_updateState);

    _updateState();

    if ((widget.controller.value != null &&
            widget.controller.value.isPlaying) ||
        widget.autoPlay) {
      _startHideTimer();
    }

    _showTimer = new Timer(new Duration(milliseconds: 200), () {
      setState(() {
        _hideStuff = false;
      });
    });
  }

  void _onExpandCollapse() {
    setState(() {
      _hideStuff = true;

      widget.onExpandCollapse().then((dynamic _) {
        _showAfterExpandCollapseTimer =
            new Timer(new Duration(milliseconds: 300), () {
          setState(() {
            _cancelAndRestartTimer();
          });
        });
      });
    });
  }

  void _playPause() {
    setState(() {
      if (widget.controller.value.isPlaying) {
        _hideStuff = false;
        _hideTimer?.cancel();
        widget.controller.pause();
      } else {
        _cancelAndRestartTimer();

        if (!widget.controller.value.initialized) {
          widget.controller.initialize().then((_) {
            widget.controller.play();
          });
        } else {
          widget.controller.play();
        }
      }
    });
  }

  void _startHideTimer() {
    _hideTimer = new Timer(const Duration(seconds: 3), () {
      setState(() {
        _hideStuff = true;
      });
    });
  }

  void _updateState() {
    setState(() {
      _latestValue = widget.controller.value;
    });
  }

  Widget _buildProgressBar() {
    return new Expanded(
      child: new Padding(
        padding: new EdgeInsets.only(right: 10.0),
        child: new MaterialVideoProgressBar(
          widget.controller,
          onDragStart: () {
            setState(() {
              _dragging = true;
            });

            _hideTimer?.cancel();
          },
          onDragEnd: () {
            setState(() {
              _dragging = false;
            });

            _startHideTimer();
          },
          colors: widget.progressColors ??
              new ChewieProgressColors(
                  playedColor: Colors.white,
                  handleColor: Colors.white,
                  bufferedColor: Colors.white30,
                  backgroundColor: Colors.grey,
        ),
      ),
    )
    );
  }
}
