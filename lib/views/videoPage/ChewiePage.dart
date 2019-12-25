import 'package:artepie/widgets/MyChewie/chewie_player.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ChewiePage extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final bool looping;
  final Widget placeholder;

  ChewiePage({
    @required this.videoPlayerController,
    this.looping,
    this.placeholder,
    Key key,
  }) : super(key: key);

  @override
  _ChewiePageState createState() => _ChewiePageState();
}

class _ChewiePageState extends State<ChewiePage> {
  ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    //创建Chewie 的控制器
    _chewieController = ChewieController(
      videoPlayerController: widget.videoPlayerController,
      aspectRatio: 16 / 9,
      autoInitialize: true,
      looping: widget.looping,
      placeholder: widget.placeholder,
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(
            errorMessage,
            style: TextStyle(color: Colors.white),
          ),
        );
      },
    );

  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Chewie(
        controller: _chewieController,
      ),
    );
  }

  @override
  void dispose() {
    //为了满足全屏时候 控制器不被直接销毁 判断只有不是全屏的时候 才允许控制器被销毁
    if (_chewieController != null && !_chewieController.isFullScreen) {
      widget.videoPlayerController.dispose();
      _chewieController.dispose();
      print('控制器销毁');
    }
    super.dispose();
  }
}
