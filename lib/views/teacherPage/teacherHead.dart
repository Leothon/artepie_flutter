import 'package:artepie/resource/MyColors.dart';
import 'package:artepie/utils/Adapt.dart';
import 'package:artepie/views/userIconWidget/UserIconWidget.dart';
import 'package:flutter/material.dart';

class CurvePage extends StatefulWidget {
  final String iconUrl;
  final String name;
  final String description;
  final String backUrl;

  const CurvePage({Key key, this.iconUrl, this.name, this.description,this.backUrl})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _curvePageState();
  }
}

class _curvePageState extends State<CurvePage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Container(
      margin: EdgeInsets.only(bottom: Adapt.px(22)),
      color: MyColors.dividerColor,
      child: new SingleChildScrollView(
        child: new ListBody(
          children: <Widget>[
            new Stack(
              children: <Widget>[
                new Container(
                  child: Image.network(
                    widget.backUrl,
                    fit: BoxFit.cover,
                  ),
                  width: double.infinity,
                  height: Adapt.px(319.5),
                ),
                ClipPath(
                  //路径裁切组件
                  clipper: BottomClipper(), //路径
                  child: Container(
                    height: Adapt.px(320),
                    color: Colors.white,
                  ),
                ),
                new Container(
                    height: Adapt.px(320),
                    padding: EdgeInsets.only(top: Adapt.px(130)),
                    alignment: Alignment.center,
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        UserIconWidget(
                          url: widget.iconUrl,
                          authority: true,
                          isAuthor: true,
                          size: Adapt.px(110),
                        ),
                        Padding(padding: EdgeInsets.only(top: Adapt.px(10)),child:  new Text(
                          widget.name,
                          style: new TextStyle(
                              fontSize: Adapt.px(30),
                              fontWeight: FontWeight.bold),
                        ),)

                      ],
                    ))
              ],
            ),
            new Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(Adapt.px(22)),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(Adapt.px(26)),bottomRight: Radius.circular(Adapt.px(26))),
                  color: Colors.white),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    '人物介绍',
                    style: new TextStyle(
                        fontSize: Adapt.px(28),
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: EdgeInsets.all(Adapt.px(12)),
                    child: new Text(
                      widget.description,
                      style: new TextStyle(
                          fontSize: Adapt.px(22), color: MyColors.fontColor),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      //margin: EdgeInsets.only(top: Adapt.px(100)),
    );
  }
}

class BottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, Adapt.px(320)); //第1个点

    var firstControlPoint = Offset(size.width / 2, Adapt.px(80));
    var firstEdnPoint = Offset(size.width, Adapt.px(320));
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEdnPoint.dx, firstEdnPoint.dy);
    path.lineTo(size.width, Adapt.px(320)); //第2个点

    path.lineTo(size.width, size.height); //第3个点
    path.lineTo(0, size.height); //第4个点

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
