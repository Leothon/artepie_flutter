import 'package:artepie/resource/MyColors.dart';
import 'package:artepie/utils/Adapt.dart';
import 'package:flutter/material.dart';

///四种视图状态
enum LoadState { State_Success, State_Error, State_Loading, State_Empty }

///根据不同状态来展示不同的视图
class LoadStateLayout extends StatefulWidget {

  final LoadState state; //页面状态
  final Widget successWidget;//成功视图
  final VoidCallback errorRetry; //错误事件处理

  LoadStateLayout(
      {Key key,
        this.state = LoadState.State_Loading,//默认为加载状态
        this.successWidget,
        this.errorRetry})
      : super(key: key);

  @override
  _LoadStateLayoutState createState() => _LoadStateLayoutState();
}

class _LoadStateLayoutState extends State<LoadStateLayout> {
  @override
  Widget build(BuildContext context) {
    return Container(
      //宽高都充满屏幕剩余空间
      width: double.infinity,
      height: double.infinity,
      child: _buildWidget,
    );
  }

  ///根据不同状态来显示不同的视图
  Widget get _buildWidget {
    switch (widget.state) {
      case LoadState.State_Success:
        return widget.successWidget;
        break;
      case LoadState.State_Error:
        return _errorView;
        break;
      case LoadState.State_Loading:
        return _loadingView;
        break;
      case LoadState.State_Empty:
        return _emptyView;
        break;
      default:
        return null;
    }
  }

  ///加载中视图
  Widget get _loadingView {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(color: Colors.transparent),
      alignment: Alignment.center,
      child: Container(
        height: Adapt.px(240),
        width: Adapt.px(300),
        padding: EdgeInsets.all(Adapt.px(18)),
        decoration: BoxDecoration(
            color: Color(0x88000000), borderRadius: BorderRadius.circular(6)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[CircularProgressIndicator(valueColor : new AlwaysStoppedAnimation<Color>(Colors.white), backgroundColor: Colors.transparent,), Text('正在加载',style: new TextStyle(color: Colors.white),)],
        ),
      ),
    );
  }

  ///错误视图
  Widget get _errorView {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.perm_scan_wifi,size: Adapt.px(150),),
          Text("加载失败，请检查网络"),
          RaisedButton(
            color: MyColors.colorPrimary,
            onPressed: widget.errorRetry,
            child: Text(
              '重新加载',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }

  ///数据为空的视图
  Widget get _emptyView {
    return Container(
      width: double.infinity,
      height: double.infinity,
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
            padding: EdgeInsets.only(top: Adapt.px(18)),
            child: Text('暂无数据'),
          )
        ],
      ),
    );
  }
}