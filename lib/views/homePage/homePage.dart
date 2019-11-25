import 'package:artepie/resource/MyColors.dart';
import 'package:artepie/routers/Application.dart';
import 'package:artepie/routers/routers.dart';
import 'package:artepie/utils/Adapt.dart';
import 'package:artepie/utils/data_utils.dart';
import 'package:artepie/views/LoadStateLayout.dart';
import 'package:artepie/views/listview_item_bottom.dart';
import 'package:common_utils/common_utils.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class HomePage extends StatefulWidget {
  final bool hasLogined;

  HomePage(this.hasLogined);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _MyHomePageState();
  }
}

class _MyHomePageState extends State<HomePage> {
  ScrollController _scrollController = new ScrollController();
  LoadState _layoutState = LoadState.State_Loading;
  BottomState _loadState = BottomState.bottom_Success;
  var itemCount = 1;
  @override
  void initState() {
    super.initState();
    _loadHomeData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          _loadState = BottomState.bottom_Loading;
        });
        _getMoreData();
      }

      if (_scrollController.offset < Adapt.px(400)) {
        setState(() {
          isListInTop = true;
        });
      } else {
        setState(() {
          isListInTop = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  bool isListInTop = true;

  List<String> typeNames = ['民族', '美声', '古典', '戏曲', '原生态', '民谣', '通俗', '其他'];
  List<String> typeIcons = [
    'lib/resource/assets/img/minzu.png',
    'lib/resource/assets/img/meisheng.png',
    'lib/resource/assets/img/gudian.png',
    'lib/resource/assets/img/xiqu.png',
    'lib/resource/assets/img/yuanshengtai.png',
    'lib/resource/assets/img/minyao.png',
    'lib/resource/assets/img/tongsu.png',
    'lib/resource/assets/img/qita.png'
  ];

  List itemInfo = [];
  List bannersInfo = [];
  List teachersInfo = [];
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      color: MyColors.dividerColor,
      child: Stack(
        children: <Widget>[
          new RefreshIndicator(
              displacement: Adapt.px(200),
              child: new CustomScrollView(
                controller: _scrollController,
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: _bannerWidget(context),
                  ),
                  SliverToBoxAdapter(
                    child: _teacherItemWidget(context),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      height: Adapt.px(70),
                      margin:
                          EdgeInsets.fromLTRB(Adapt.px(20), 0, Adapt.px(20), 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Adapt.px(20)),
                        color: MyColors.card_tap,
                        image: new DecorationImage(
                          image: new AssetImage(
                            'lib/resource/assets/img/tap_back_icon.png',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: new Padding(
                        padding: EdgeInsets.fromLTRB(
                            Adapt.px(20), 0, Adapt.px(20), 0),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Expanded(
                              child: Icon(
                                Icons.music_note,
                                color: MyColors.card_tap_to,
                              ),
                              flex: 1,
                            ),
                            Expanded(
                              child: new Text(
                                'AIS商业音乐定制',
                                style: new TextStyle(
                                  fontSize: Adapt.px(26),
                                  color: MyColors.card_text,
                                ),
                              ),
                              flex: 10,
                            ),
                            Expanded(
                              child: Icon(
                                Icons.touch_app,
                                color: MyColors.card_tap_to,
                              ),
                              flex: 1,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: _typeWidget(context),
                  ),
                  SliverToBoxAdapter(
                    child: new Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(Adapt.px(18)),
                      child: new Text(
                        '热门课程',
                        style: new TextStyle(
                            fontSize: Adapt.px(38),
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SliverList(
                    //itemExtent: Adapt.px(350),
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        if (index == itemCount) {
                          return new ListBottomView(
                            isHighBottom: true,
                            bottomState: _loadState,
                            errorRetry: () {
                              setState(() {
                                _loadState = BottomState.bottom_Loading;
                              });
                              _getMoreData();
                            },
                          );
                        } else {
                          return _buildWidget(context, index);
                        }
                      },
                      childCount: itemCount + 1,
                    ),
                  ),
//                  SliverToBoxAdapter(
//                    child: _loadMoreWidgetInfo(context),
//                  )
                ],
              ),
              onRefresh: _loadHomeData),
          _searchWidget(context)
        ],
      ),
    );
  }

  Widget _bannerWidget(BuildContext context) {
    return new Container(
      height: Adapt.px(420),
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return (Image.network(
            bannersInfo[index]['banner_img'],
            fit: BoxFit.cover,
          ));
        },
        itemCount: bannersInfo.length,
        pagination: new SwiperPagination(
            builder: DotSwiperPaginationBuilder(
                color: Colors.white,
                activeColor: MyColors.colorPrimary,
                size: Adapt.px(8),
                activeSize: Adapt.px(14))),
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

  Widget _teacherItemWidget(BuildContext context) {
    return new Container(
      height: Adapt.px(300),
      child: new Column(
        children: <Widget>[
          new Container(
            width: double.infinity,
            padding: EdgeInsets.all(Adapt.px(18)),
            child: new Text(
              '名师专栏',
              style: new TextStyle(
                  fontSize: Adapt.px(38),
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Flexible(
              child: new ListView.builder(
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              return new GestureDetector(
                child: Container(
                  margin: EdgeInsets.only(bottom: Adapt.px(18)),
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.all(Radius.circular(Adapt.px(18))),
                    ),
                    child: new Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.all(Adapt.px(14)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(Adapt.px(56)),
                            child: FadeInImage.assetNetwork(
                              height: Adapt.px(90),
                              width: Adapt.px(90),
                              placeholder:
                                  'lib/resource/assets/img/defaulticon.jpeg',
                              image: teachersInfo[index]['user_icon'],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        new Text(
                          teachersInfo[index]['user_name'],
                          style: new TextStyle(
                            fontSize: Adapt.px(22),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                onTap: () {
                  Application.router.navigateTo(context, '${Routes.teacherPage}?teacherId=${Uri.encodeComponent(teachersInfo[index]['user_id'])}',transition: TransitionType.fadeIn);

                },
              );
            },
            itemCount: teachersInfo.length,
          ))
        ],
      ),
    );
  }

  Widget _typeWidget(BuildContext context) {
    return new Container(
        margin: EdgeInsets.fromLTRB(Adapt.px(18), Adapt.px(8), Adapt.px(18), 0),
        child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(Adapt.px(18))),
            ),
            child: new Container(
              margin: EdgeInsets.fromLTRB(0, Adapt.px(18), 0, Adapt.px(18)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child: _typeItem(context, 0),
                        flex: 1,
                      ),
                      Expanded(
                        child: _typeItem(context, 1),
                        flex: 1,
                      ),
                      Expanded(
                        child: _typeItem(context, 2),
                        flex: 1,
                      ),
                      Expanded(
                        child: _typeItem(context, 3),
                        flex: 1,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child: _typeItem(context, 4),
                        flex: 1,
                      ),
                      Expanded(
                        child: _typeItem(context, 5),
                        flex: 1,
                      ),
                      Expanded(
                        child: _typeItem(context, 6),
                        flex: 1,
                      ),
                      Expanded(
                        child: _typeItem(context, 7),
                        flex: 1,
                      ),
                    ],
                  )
                ],
              ),
            )));
  }

  Widget _typeItem(BuildContext context, int position) {
    return new GestureDetector(
      child: Container(
        margin: EdgeInsets.fromLTRB(0, Adapt.px(18), 0, Adapt.px(18)),
        child: new Column(
          children: <Widget>[
//            typeIcons[position],

            Image.asset(
              typeIcons[position],
              width: Adapt.px(80),
              height: Adapt.px(80),
            ),
            new Text(
              typeNames[position],
              style: new TextStyle(
                fontSize: Adapt.px(22),
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        //TODO 跳转类型
      },
    );
  }

  Widget _classItem(BuildContext context, int position) {
    return Container(
      height: Adapt.px(332),
      margin: EdgeInsets.fromLTRB(Adapt.px(24), 0, Adapt.px(24), Adapt.px(18)),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(Adapt.px(28))),
      child: new Row(
        children: <Widget>[
          Expanded(
            child: new Stack(
              children: <Widget>[
                Container(
                  height: Adapt.px(332),
                  //width: Adapt.px(300),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(Adapt.px(28)),
                    child: FadeInImage.assetNetwork(
                      placeholder: 'lib/resource/assets/img/loading.png',
                      image: itemInfo[position]['selectbackimg'],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                new Offstage(
                  offstage: !itemInfo[position]['authorize'],
                  child: Container(
                    height: Adapt.px(54),
                    width: Adapt.px(120),
                    decoration: BoxDecoration(
                      color: MyColors.colorPrimary,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(Adapt.px(28)),
                          topRight: Radius.circular(0),
                          bottomLeft: Radius.circular(0),
                          bottomRight: Radius.circular(Adapt.px(28))),
                    ),
                    child: new Center(
                      child: new Text(
                        '官方课程',
                        style: new TextStyle(
                            fontSize: Adapt.px(22), color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            flex: 2,
          ),
          Expanded(
            child: new Container(
              //width: 180,
              margin: EdgeInsets.fromLTRB(Adapt.px(18), 0, Adapt.px(18), 0),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(itemInfo[position]['selectlisttitle'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: new TextStyle(
                        fontSize: Adapt.px(34),
                        fontWeight: FontWeight.bold,
                      )),
                  new Text(itemInfo[position]['selectauthor'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: new TextStyle(
                          fontSize: Adapt.px(28), color: MyColors.fontColor)),
                  new Text(itemInfo[position]['selectdesc'],
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: new TextStyle(
                        fontSize: Adapt.px(24),
                      )),
                  new Container(
                    height: Adapt.px(34),
                    width: Adapt.px(88),
                    decoration: BoxDecoration(
                        color: itemInfo[position]['serialize']
                            ? MyColors.colorPrimary
                            : Colors.green,
                        borderRadius: BorderRadius.circular(Adapt.px(18))),
                    child: new Text(
                        itemInfo[position]['serialize'] ? '连载中' : '已完结',
                        textAlign: TextAlign.center,
                        style: new TextStyle(
                            color: Colors.white, fontSize: Adapt.px(20))),
                  ),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      new Text(
                        '${itemInfo[position]['selectstucount']}人次已学习',
                        style: new TextStyle(
                          fontSize: Adapt.px(22),
                        ),
                      ),
                      new Text(
                        itemInfo[position]['selectprice'] == '0.00'
                            ? '免费'
                            : '￥${itemInfo[position]['selectprice']}',
                        style: new TextStyle(
                            fontSize: Adapt.px(30),
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            color: MyColors.colorPrimary),
                      ),
                    ],
                  )
                ],
              ),
            ),
            flex: 3,
          )
        ],
      ),
    );
  }

  Widget _searchWidget(BuildContext context) {
    return new Container(
      height: Adapt.px(180),
      child: new Stack(
        children: <Widget>[
          new AppBar(
            elevation: isListInTop ? 0 : 3,
            brightness: Brightness.light,
            backgroundColor: isListInTop ? Colors.transparent : Colors.white,
          ),
          new SafeArea(
              top: true,
              child: new Container(
                height: Adapt.px(80),
                child: new Container(
                  margin: EdgeInsets.fromLTRB(
                      Adapt.px(40), Adapt.px(20), Adapt.px(40), 0),
                  padding:
                      EdgeInsets.fromLTRB(Adapt.px(18), 0, Adapt.px(18), 0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Adapt.px(80)),
                      color:
                          isListInTop ? Colors.white : MyColors.dividerColor),
                  child: new Row(
                    children: <Widget>[
                      Icon(Icons.search),
                      new Padding(
                        padding: EdgeInsets.fromLTRB(
                            Adapt.px(14), 0, Adapt.px(14), 0),
                        child: new Text(
                          '搜索艺派相关内容',
                          style: new TextStyle(fontSize: Adapt.px(24)),
                        ),
                      )
                    ],
                  ),
                ),
              ))
        ],
      ),
    );
  }

  ///加载中视图
  Widget get _loadingView {
    return Container(
      width: double.infinity,
      height: Adapt.px(100),
      decoration: BoxDecoration(color: Colors.transparent),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            child: CircularProgressIndicator(
              valueColor:
                  new AlwaysStoppedAnimation<Color>(MyColors.colorPrimary),
              backgroundColor: Colors.transparent,
            ),
            width: Adapt.px(50),
            height: Adapt.px(50),
          ),
          Padding(
            padding: EdgeInsets.only(left: Adapt.px(40)),
            child: Text(
              '正在加载',
              style: new TextStyle(color: MyColors.fontColor),
            ),
          )
        ],
      ),
    );
  }

  ///错误视图
  Widget get _errorView {
    return Container(
        width: double.infinity,
        height: Adapt.px(100),
        alignment: Alignment.center,
        child: InkWell(
          onTap: _loadHomeData,
          child: Text(
            '加载失败，点击重试',
            style: TextStyle(color: MyColors.colorPrimary),
          ),
        ));
  }

  Future _loadHomeData() {
    setState(() {
      _layoutState = LoadState.State_Loading;
    });
    return DataUtils.getHomeData({'token': Application.spUtil.get('token')})
        .then((result) {
      var data = result['data']['teaClasses'];
      var banners = result['data']['banners'];
      var teachers = result['data']['teachers'];
      if (data.length == 0) {
        setState(() {
          _layoutState = LoadState.State_Empty;
        });
      } else {
        setState(() {
          _loadState = BottomState.bottom_Loading;
          _layoutState = LoadState.State_Success;
          itemInfo = data;
          bannersInfo = banners;
          teachersInfo = teachers;
          itemCount = itemInfo.length;
        });
      }
    }).catchError((onError) {
      setState(() {
        LogUtil.e(onError);
        _layoutState = LoadState.State_Error;
      });
    });
  }

  void _getMoreData() {
    DataUtils.getHomeMoreData({
      'currentpage': itemInfo.length.toString(),
      'token': Application.spUtil.get('token')
    }).then((result) {
      var data = result['data'];
      if (data.length == 0) {
        setState(() {
          _loadState = BottomState.bottom_Empty;
        });
      } else {
        setState(() {
          itemInfo.addAll(result['data']);
          itemCount = itemInfo.length;
//          _loadInfo = 3;
        });
      }
    }).catchError((onError) {
      setState(() {
        _loadState = BottomState.bottom_Error;
      });
    });
  }

  ///数据为空的视图
  Widget get _emptyView {
    return Container(
      width: double.infinity,
      height: Adapt.px(100),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'lib/resource/assets/img/emptyimg.png',
            height: Adapt.px(100),
            width: Adapt.px(100),
          ),
          Padding(
            padding: EdgeInsets.only(left: Adapt.px(10)),
            child: Text(
              '暂无数据,刷新试试',
              style: new TextStyle(fontSize: Adapt.px(26)),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildWidget(BuildContext context, int position) {
    switch (_layoutState) {
      case LoadState.State_Success:
        return _classItem(context, position);
        break;
      case LoadState.State_Error:
        return _errorView;
        break;
      case LoadState.State_Loading:
        return _loadingView;
        break;
      case LoadState.State_Empty:
        return _emptyView;
        break;
      default:
        return null;
    }
  }
}
