import 'package:artepie/model/user_info.dart';
import 'package:artepie/resource/MyColors.dart';
import 'package:artepie/views/commonAppBar/CommonAppBar.dart';
import 'package:artepie/views/userIconWidget/UserIconWidget.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class ArticlePage extends StatefulWidget {
  final bool hasLogined;

  ArticlePage(this.hasLogined);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _MyArticlePage();
  }
}

class _MyArticlePage extends State<ArticlePage> {
  List<String> bannerImgs = [
    'http://www.artepie.cn/image/bannertest.jpg',
    'http://www.artepie.cn/image/bannertest1.jpg',
    'http://www.artepie.cn/image/bannertest2.jpg',
    'http://www.artepie.cn/image/bannertest3.jpg'
  ];

  var _likeCount = '10';
  var _readCount = '4566';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        backgroundColor: MyColors.dividerColor,
        body: new RefreshIndicator(
          displacement: 150,
          child: new Listener(
            child: new CustomScrollView(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              slivers: <Widget>[
                SliverAppBar(
                  title: new Text(
                    '艺条',
                    style: new TextStyle(fontSize: 22, color: Colors.black),
                  ),
                  pinned: true,
                  backgroundColor: Colors.white,
                  brightness: Brightness.light,
                  elevation: 3,
                  forceElevated: true,
                ),
                SliverToBoxAdapter(
                  child: _articleBannerWidget(context),
                ),
                SliverToBoxAdapter(
                  child: new Container(
                    margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
                    child: new Row(
                      children: <Widget>[
                        new Text(
                          '文章列表',
                          style:
                              new TextStyle(fontSize: 20, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                  sliver: new SliverGrid(
                    //Grid
                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, //Grid按两列显示
                      mainAxisSpacing: 15.0,
                      crossAxisSpacing: 15.0,
                      childAspectRatio: 0.9,
                    ),
                    delegate: new SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        //创建子widget
                        return _articleItemWidget(context, index);
                      },
                      childCount: 40,
                    ),
                  ),
                ),
              ],
            ),
          ),
          onRefresh: () {},
        ));
  }

  Widget _articleBannerWidget(BuildContext context) {
    return new Container(
      height: 200.0,
      padding: EdgeInsets.fromLTRB(0, 2, 0, 5),
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return new Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: FadeInImage.assetNetwork(
                  placeholder: 'lib/resource/assets/img/loading.png',
                  image: bannerImgs[index],
                  fit: BoxFit.cover,
                ),
              ));
        },
        viewportFraction: 0.8,
        scale: 0.9,
        itemCount: bannerImgs.length,
        pagination: new SwiperPagination(
            builder: DotSwiperPaginationBuilder(
                color: Colors.white,
                activeColor: MyColors.colorPrimary,
                size: 5.0,
                activeSize: 8.0)),
        autoplayDisableOnInteraction: true,
        controller: new SwiperController(),
        scrollDirection: Axis.horizontal,
        autoplay: true,
        onTap: (index) {
          LogUtil.e('点击了第$index个');
        },
      ),
    );
  }

  Widget _articleItemWidget(BuildContext context, int position) {
    return new Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: MyColors.white, borderRadius: BorderRadius.circular(8)),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: FadeInImage.assetNetwork(
                placeholder: 'lib/resource/assets/img/loading.png',
                image: 'http://www.artepie.cn/image/bannertest2.jpg',
                fit: BoxFit.cover,
              ),
            ),
            flex: 3,
          ),
          Expanded(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new Text(
                  '标题wozhegejiushi biaodidaw',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: new TextStyle(fontSize: 18, color: Colors.black),
                ),
                new Padding(
                  padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
                  child: new Text(
                    '推荐$_likeCount 阅读$_readCount',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style:
                        new TextStyle(fontSize: 12, color: MyColors.fontColor),
                  ),
                ),
                new Row(
                  children: <Widget>[
                    UserIconWidget(
                      url: 'http://www.artepie.cn/image/bannertest2.jpg',
                      size: 18,
                      authority: true,
                      isAuthor: true,
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: new Text(
                        '名字',
                        maxLines: 1,
                        style: new TextStyle(
                            fontSize: 14, color: MyColors.fontColor),
                      ),
                    )
                  ],
                )
              ],
            ),
            flex: 2,
          )
        ],
      ),
    );
  }
}
