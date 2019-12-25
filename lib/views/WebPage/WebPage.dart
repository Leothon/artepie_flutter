import 'package:artepie/resource/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebPage extends StatefulWidget {
  final String url;
  WebPage(this.url);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _webPage();
  }
}

class _webPage extends State<WebPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        title: new Text(''),
        backgroundColor: Colors.white,
        leading: new InkWell(
          child: Icon(
            Icons.arrow_back,
            color: MyColors.fontColor,
          ),
          onTap: (){Navigator.of(context).pop();},
        ),
      ),
      body: WebView(
        initialUrl: widget.url,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController web) {
          web.canGoBack().then((res) {
            print(res); // 是否能返回上一级
          });
          web.currentUrl().then((url) {
            print(url); // 返回当前url
          });
          web.canGoForward().then((res) {
            print(res); //是否能前进
          });
        },
        onPageFinished: (String value) {
          // webview 页面加载调用
        },
      ),
    );
  }
}
