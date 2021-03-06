import 'package:artepie/utils/Adapt.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CommonAppBar extends StatefulWidget {
  final String title;
  final String subTitle;
  final Color subTitleColor;
  final GestureTapCallback onPressSubTitle;
  final bool isBackLastPage;

  const CommonAppBar(
      {Key key,
      this.title,
      this.subTitle,
      this.subTitleColor,
      this.onPressSubTitle,
      this.isBackLastPage})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _MyCommonAppBar();
  }
}

class _MyCommonAppBar extends State<CommonAppBar> {
  @override
  Widget build(BuildContext context) {
    return new Container(
      height: Adapt.px(180),
      child: Stack(
        children: <Widget>[
          new AppBar(
            elevation: 3,
            brightness: Brightness.light,
            backgroundColor: Colors.white,
          ),
          new SafeArea(
              top: true,
              child: new Container(
                height: kToolbarHeight,
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: new GestureDetector(
                        child: widget.isBackLastPage
                            ? Icon(
                          Icons.arrow_back,
                          size: Adapt.px(56),
                        )
                            : Icon(
                          Icons.clear,
                          size: Adapt.px(56),
                        ),
                        onTap: () {
                          if (widget.isBackLastPage) {
                            Navigator.pop(context);
                          } else {
                            SystemNavigator.pop();
                          }
                        },
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: new Text(
                        widget.title,
                        style: new TextStyle(
                          fontSize: Adapt.px(36),
                          color: Colors.black,
                        ),
                      ),
                      flex: 4,
                    ),
                    Expanded(
                      child: new Center(
                        child: new GestureDetector(
                            child: new Text(
                              widget.subTitle,
                              style: new TextStyle(
                                  fontSize: Adapt.px(30), color: widget.subTitleColor),
                            ),
                            onTap: this.widget.onPressSubTitle),
                      ),
                      flex: 2,
                    ),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
