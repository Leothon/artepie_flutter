import 'package:artepie/parseHtml/html_parser.dart';
import 'package:artepie/utils/Adapt.dart';
import 'package:flutter/material.dart';

class HtmlTextView extends StatelessWidget {
  final String data;

  HtmlTextView({
    this.data
  });

  @override
  Widget build(BuildContext context) {
    HtmlParser htmlParser = new HtmlParser();

    List<Widget> nodes = htmlParser.HParse(this.data);

    return new Container(
        padding: EdgeInsets.all(Adapt.px(10.0)),
        child:  new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: nodes,
        )

    );
  }
}



