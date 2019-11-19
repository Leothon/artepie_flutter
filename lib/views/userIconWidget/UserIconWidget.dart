import 'package:flutter/cupertino.dart';

class UserIconWidget extends StatefulWidget{
  final String url;
  final double size;
  final int authority;

  const UserIconWidget(
      {Key key,
        this.url,
        this.authority,
        this.size
        })
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
            placeholder: 'lib/resource/assets/img/default.jpeg',
            image: widget.url,
            fit: BoxFit.cover,
          ),
        ),
        
      ],
    );
  }

}