import 'package:artepie/resource/MyColors.dart';
import 'package:flutter/material.dart';

class UserIconWidget extends StatefulWidget {
  final String url;
  final double size;
  final bool authority;
  final bool isAuthor;

  const UserIconWidget({Key key, this.url, this.authority, this.isAuthor,this.size})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _MyUserIcon();
  }
}

class _MyUserIcon extends State<UserIconWidget> {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Stack(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(widget.size / 2),
          child: FadeInImage.assetNetwork(
            height: widget.size,
            width: widget.size,
            placeholder: 'lib/resource/assets/img/defaulticon.jpeg',
            image: widget.url,
            fit: BoxFit.cover,
          ),
        ),
        new Offstage(
          offstage: !widget.authority,

          child: new Container(
            width: widget.size,
            height: widget.size,
            alignment: Alignment(1, 1),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(widget.size / 3),
              child: Container(
                  width: widget.size / 3,
                  height: widget.size / 3,
                  color: widget.isAuthor ? Colors.blue : Colors.orange,
                  child: new Center(
                    child: new Text(
                      'V',
                      style: new TextStyle(
                          fontSize: widget.size / 4,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          color: Colors.white),
                    ),
                  )),
            ),
          ),
        )
      ],
    );
  }
}
