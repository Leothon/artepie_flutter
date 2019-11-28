import 'package:artepie/parseHtml/flutter_html_textview.dart';
import 'package:artepie/resource/MyColors.dart';
import 'package:artepie/routers/Application.dart';
import 'package:artepie/utils/Adapt.dart';
import 'package:artepie/utils/data_utils.dart';
import 'package:artepie/views/LoadStateLayout.dart';
import 'package:artepie/views/listview_item_bottom.dart';
import 'package:artepie/views/userIconWidget/UserIconWidget.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';

class articleDetailPage extends StatefulWidget {
  final String _articleId;

  articleDetailPage(this._articleId);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _articleDetailState();
  }
}

class _articleDetailState extends State<articleDetailPage> {
  LoadState _layoutState = LoadState.State_Loading;
  ScrollController _scrollController = new ScrollController();

  bool isTop = false;
  var data = {};
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadArticleDetailData();

    _scrollController.addListener(() {

      if (_scrollController.offset < Adapt.px(200)) {
        setState(() {
          isTop = false;
        });
      } else {
        setState(() {
          isTop = true;
        });
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: new LoadStateLayout(
        successWidget: _articlePageWidget(context),
        errorRetry: () {
          setState(() {
            _layoutState = LoadState.State_Loading;
          });
          _loadArticleDetailData();
        },
        state: _layoutState,
      ),


      bottomNavigationBar: new Card(
        elevation: Adapt.px(4),
        child: new Container(
          height: Adapt.px(90),
          padding: EdgeInsets.only(left: Adapt.px(40), right: Adapt.px(20)),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Row(
                children: <Widget>[
                  new RaisedButton(
                    onPressed: () {
                      setState(() {
                        data['like']
                            ? data['likeCount'] =
                                (double.parse(data['likeCount']) - 1)
                                    .toStringAsFixed(0)
                            : data['likeCount'] =
                                (double.parse(data['likeCount']) + 1)
                                    .toStringAsFixed(0);
                        data['like'] = !data['like'];
                      });
                    },
                    textColor: data.isEmpty
                        ? MyColors.colorPrimary
                        : (data['like']
                            ? MyColors.white
                            : MyColors.colorPrimary),
                    child: new Text(
                        data.isEmpty ? '推荐' : (data['like'] ? '已推荐' : '推荐')),
                    color: data.isEmpty
                        ? MyColors.lowColorPrimary
                        : (data['like']
                            ? MyColors.colorPrimary
                            : MyColors.lowColorPrimary),
                    elevation: 0,
                  ),
                  new Padding(
                    padding: EdgeInsets.only(left: Adapt.px(16)),
                    child: new Text(
                        '${data.isEmpty ? '0' : data['likeCount']}人已推荐'),
                  )
                ],
              ),
              RaisedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.message,size: Adapt.px(46),color: MyColors.lowfontColor,),
                  color: Colors.white,
                  elevation: 0,
                  label: new Text('留言',style: new TextStyle(color: MyColors.lowfontColor),)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _articlePageWidget(BuildContext context) {
    return new RefreshIndicator(
        displacement: Adapt.px(200),
        child: new CustomScrollView(
          controller: _scrollController,
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: Adapt.px(280),
              brightness: Brightness.light,
              title: new Text(
                data.isEmpty ? '' : data['articleTitle'],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: new TextStyle(
                    color: isTop ? MyColors.fontColor : Colors.transparent),
              ),
              leading: InkWell(
                child: Icon(
                  Icons.arrow_back,
                  color: isTop ? MyColors.fontColor : Colors.white,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),

              actions: <Widget>[
                IconButton(icon: Icon(Icons.share,color: isTop ? MyColors.fontColor : Colors.white,), onPressed: (){}),
                IconButton(icon: Icon(Icons.more_horiz,color: isTop ? MyColors.fontColor : Colors.white,), onPressed: (){})
              ],
              backgroundColor: Colors.white,
              floating: false,
              pinned: true,
              snap: false,
              flexibleSpace: new FlexibleSpaceBar(
                background: Image.network(
                    data.isEmpty
                        ? 'http://www.artepie.cn/image/video_cover.png'
                        : data['articleImg'],
                    fit: BoxFit.cover),
              ),
            ),
            SliverToBoxAdapter(
              child: new Container(
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          left: Adapt.px(20),
                          right: Adapt.px(20),
                          top: Adapt.px(14),
                          bottom: Adapt.px(14)),
                      child: new Text(data.isEmpty ? '' : data['articleTitle'],

                          style: new TextStyle(
                              fontSize: Adapt.px(45),
                              color: MyColors.fontColor)),
                    ),
                    Card(
                      elevation: Adapt.px(4),
                      child: new Container(
                        height: Adapt.px(100),
                        padding: EdgeInsets.only(
                            left: Adapt.px(40), right: Adapt.px(40)),
                        child: new Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            UserIconWidget(
                              url:
                                  data.isEmpty ? '' : data['articleAuthorIcon'],
                              size: Adapt.px(70),
                              authority: true,
                              isAuthor: true,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: Adapt.px(22)),
                              child: new Text(
                                data.isEmpty ? '' : data['articleAuthorName'],
                                style: new TextStyle(fontSize: Adapt.px(32)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: HtmlTextView(data:data.isEmpty ? '' : data['articleContent'],),
            ),
            SliverToBoxAdapter(
              child: new Column(
                children: <Widget>[
                  new Container(
                    padding: EdgeInsets.only(right: Adapt.px(20)),
                    alignment: Alignment.centerRight,
                    child: new Text(
                        '本文著作权归作者@${data.isEmpty ? '' : data['articleAuthorName']}所有，转载请联系作者'),
                  ),
                  new Container(
                    padding:
                        EdgeInsets.only(right: Adapt.px(20), top: Adapt.px(10)),
                    alignment: Alignment.centerRight,
                    child: new Text(
                        '发布于${data.isEmpty ? '' : data['articleTime']}'),
                  )
                ],
              ),
            )
          ],
        ),
        onRefresh: _loadArticleDetailData);
  }

  Future _loadArticleDetailData() {
    return DataUtils.getArticleDetail({
      'token': Application.spUtil.get('token'),
      'articleid': widget._articleId
    }).then((result) {
      var datare = result['data'];
      if (datare.length == 0) {
        setState(() {
          _layoutState = LoadState.State_Empty;
        });
      } else {
        setState(() {
          data = datare;
          _layoutState = LoadState.State_Success;
        });
      }
    }).catchError((onError) {
      setState(() {
        LogUtil.e(onError);
        _layoutState = LoadState.State_Error;
      });
    });
  }
}
