import 'package:artepie/model/user_info.dart';
import 'package:artepie/resource/MyColors.dart';
import 'package:artepie/routers/Application.dart';
import 'package:artepie/utils/Adapt.dart';
import 'package:artepie/utils/data_utils.dart';
import 'package:artepie/views/LoadStateLayout.dart';
import 'package:artepie/views/commonAppBar/CommonAppBar.dart';
import 'package:artepie/views/listview_item_bottom.dart';
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



  //SwiperController _swiperController = new SwiperController();

  var _itemCount = 1;
  List _articleList = [];
  List _articleBanners = [];
  LoadState _layoutState = LoadState.State_Loading;
  BottomState _loadState = BottomState.bottom_Success;
  ScrollController _scrollController = new ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadArticleData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          _loadState = BottomState.bottom_Loading;
        });
        _loadArticleMoreData();
      }
    });

//   _swiperController.addListener((){
//     LogUtil.e(_swiperController.index.toString());
//   });
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
        backgroundColor: MyColors.dividerColor,
        body: new LoadStateLayout(
          successWidget: _articlePageWidget(context),
          errorRetry: () {
            setState(() {
              _layoutState = LoadState.State_Loading;
            });
            _loadArticleData();
          },
          state: _layoutState,
        ));
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
              title: new Text(
                '艺条',
                style:
                    new TextStyle(fontSize: Adapt.px(34), color: Colors.black),
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
                margin: EdgeInsets.fromLTRB(
                    Adapt.px(38), Adapt.px(8), Adapt.px(38), Adapt.px(8)),
                child: new Row(
                  children: <Widget>[
                    new Text(
                      '文章列表',
                      style: new TextStyle(
                          fontSize: Adapt.px(34), color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                  Adapt.px(28), Adapt.px(8), Adapt.px(28), Adapt.px(8)),
              sliver: new SliverGrid(
                //Grid
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, //Grid按两列显示
                  mainAxisSpacing: Adapt.px(28),
                  crossAxisSpacing: Adapt.px(28),
                  childAspectRatio: 0.75,
                ),
                delegate: new SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    //创建子widget
                    if (index == _itemCount) {
                      return new ListBottomView(
                        isHighBottom: true,
                        bottomState: _loadState,
                        errorRetry: () {
                          setState(() {
                            _loadState = BottomState.bottom_Loading;
                          });
                          _loadArticleMoreData();
                        },
                      );
                    } else {
                      return _articleItemWidget(context, index);
                    }
                  },
                  childCount: _itemCount + 1,
                ),
              ),
            ),
          ],
        ),
        onRefresh: _loadArticleData);
  }

  Widget _articleBannerWidget(BuildContext context) {
    return new Container(
      height: Adapt.px(380),
      padding: EdgeInsets.fromLTRB(0, Adapt.px(2), 0, Adapt.px(8)),
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return new Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.all(Radius.circular(Adapt.px(18)))),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(Adapt.px(18)),
                child: new Stack(
                  children: <Widget>[
                    Container(

                      child: FadeInImage.assetNetwork(
                        placeholder: 'lib/resource/assets/img/loading.png',
                        image: _articleBanners[index]['banner_img'] == null ? 'http://www.artepie.cn/image/default_cover.png' :  _articleBanners[index]['banner_img'],
                        fit: BoxFit.cover,
                      ),
                      height: Adapt.px(380),
                      width: double.infinity,
                    ),

                    new Container(
                      height: Adapt.px(50),
                      width: double.infinity,
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(top: Adapt.px(305)),
                      padding: EdgeInsets.fromLTRB(Adapt.px(18),0,Adapt.px(110),0),
                      decoration: BoxDecoration(

                        gradient:  LinearGradient(colors: [ Colors.black, Colors.transparent, Colors.black], begin: FractionalOffset(0, -1), end: FractionalOffset(0, 1))

                      ),
                      child: Text(_articleBanners[index]['banner_url'],maxLines: 1,overflow: TextOverflow.ellipsis,style: new TextStyle(color: Colors.white),),
                    )
                  ],
                )
              ));
        },
        viewportFraction: 0.8,
        scale: 0.9,
        itemCount: _articleBanners.length,
        pagination: new SwiperPagination(
          alignment: Alignment.bottomRight,
            margin: EdgeInsets.fromLTRB(0,0,Adapt.px(100),Adapt.px(18)),
            builder: DotSwiperPaginationBuilder(
                color: Colors.white,
                activeColor: MyColors.colorPrimary,
                size: Adapt.px(8),
                activeSize: Adapt.px(10))),
        autoplayDisableOnInteraction: true,
        //controller: _swiperController,
        scrollDirection: Axis.horizontal,
        autoplay: true,
        onTap: (index) {

        },
      ),
    );
  }

  Widget _articleItemWidget(BuildContext context, int position) {
    return new Container(
      padding: EdgeInsets.all(Adapt.px(14)),
      decoration: BoxDecoration(
          color: MyColors.white,
          borderRadius: BorderRadius.circular(Adapt.px(14))),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Adapt.px(14)),
              child: FadeInImage.assetNetwork(
                placeholder: 'lib/resource/assets/img/loading.png',
                image: _articleList[position]['articleImg'] == null ? 'http://www.artepie.cn/image/default_cover.png' : _articleList[position]['articleImg'],
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
                  _articleList[position]['articleTitle'],
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: new TextStyle(
                      fontSize: Adapt.px(26), color: Colors.black),
                ),
                new Padding(
                  padding: EdgeInsets.fromLTRB(0, Adapt.px(6), 0, Adapt.px(6)),
                  child: new Text(
                    '推荐${_articleList[position]['likeCount']}   阅读${_articleList[position]['articleVisionCount']}',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: new TextStyle(
                        fontSize: Adapt.px(22), color: MyColors.fontColor),
                  ),
                ),
                new Row(
                  children: <Widget>[
                    UserIconWidget(
                      url: _articleList[position]['articleAuthorIcon'],
                      size: Adapt.px(34),
                      authority: _articleList[position]['authorRole'].substring(0,1) == 0 || _articleList[position]['authorRole'].substring(0,1) == 1 ? true : false,
                      isAuthor: _articleList[position]['authorRole'].substring(0,1) == 0 ? false : true,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.fromLTRB(Adapt.px(16), 0, Adapt.px(16), 0),
                      child: new Text(
                        _articleList[position]['articleAuthorName'],
                        maxLines: 1,
                        style: new TextStyle(
                            fontSize: Adapt.px(24), color: MyColors.fontColor),
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

  Future _loadArticleData() {
    return DataUtils.getArticleData({'token': Application.spUtil.get('token')})
        .then((result) {
      var data = result['data'];

      var articles = data['articles'];
      var banners = data['banners'];
      if (data.length == 0) {
        setState(() {
          _layoutState = LoadState.State_Empty;
        });
      } else {
        setState(() {
          _loadState = BottomState.bottom_Loading;
          _layoutState = LoadState.State_Success;
          _articleList = articles;
          _articleBanners = banners;
          _itemCount = _articleList.length;
        });
      }
    }).catchError((onError) {
      setState(() {
        LogUtil.e(onError);
        _layoutState = LoadState.State_Error;
      });
    });
  }

  void _loadArticleMoreData() {
    DataUtils.getArticleMoreData(
            {'token': Application.spUtil.get('token'), 'currentpage': _itemCount.toString()})
        .then((result) {
      var data = result['data'];
      if (data.length == 0) {
        setState(() {
          _loadState = BottomState.bottom_Empty;
        });
      } else {
        setState(() {
          _articleList.addAll(data);
          _itemCount = _articleList.length;
        });
      }
    }).catchError((onError) {
      setState(() {
        _loadState = BottomState.bottom_Error;
      });
    });
  }
}
