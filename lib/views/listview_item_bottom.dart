import 'package:artepie/resource/MyColors.dart';
import 'package:artepie/utils/Adapt.dart';
import 'package:flutter/material.dart';


enum BottomState { bottom_Success, bottom_Error, bottom_Loading, bottom_Empty }

class ListBottomView extends StatefulWidget{


  final bool isHighBottom;//空出底部距离
  final BottomState bottomState;
  final VoidCallback errorRetry;


  const ListBottomView({Key key, this.isHighBottom, this.bottomState,this.errorRetry})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _listBottomView();
  }

}


class _listBottomView extends State<ListBottomView>{


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return _loadMoreWidgetInfo(context);
  }


  Widget _loadMoreWidgetInfo(BuildContext context) {
    switch (widget.bottomState) {
      case BottomState.bottom_Loading:
        return new Container(
          padding: EdgeInsets.fromLTRB(0, Adapt.px(20), 0, widget.isHighBottom ? Adapt.px(60) : Adapt.px(20)),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                child: CircularProgressIndicator(
                  valueColor:
                  new AlwaysStoppedAnimation<Color>(MyColors.colorPrimary),
                  backgroundColor: Colors.transparent,
                ),
                width: Adapt.px(40),
                height: Adapt.px(40),
              ),
              new Padding(
                padding: EdgeInsets.only(left: Adapt.px(18)),
                child: Text(
                  "加载中",
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        );
        break;
      case BottomState.bottom_Error:
        return new Container(
            width: double.infinity,
            height: Adapt.px(100),
            alignment: Alignment.center,
            child: InkWell(
              onTap: () {
                widget.errorRetry;
              },
              child: Text(
                '加载失败，点击重试',
                style: TextStyle(color: MyColors.colorPrimary),
              ),
            ));
        break;
      case BottomState.bottom_Empty:
        return new Container(
          padding: EdgeInsets.fromLTRB(0, Adapt.px(20), 0, widget.isHighBottom ? Adapt.px(60) : Adapt.px(20)),
          child: Text(
            "已经滑到底了",
            textAlign: TextAlign.center,
          ),
        );
        break;
      case BottomState.bottom_Success:
        return new Container(
          height: 0,
          width: 0,
        );
      default:
        return null;
    }
  }
}