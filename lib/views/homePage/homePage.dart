import 'package:artepie/resource/MyColors.dart';
import 'package:common_utils/common_utils.dart';
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

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset < 200) {
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
    //为了避免内存泄露，需要调用_controller.dispose
    _scrollController.dispose();
    super.dispose();
  }


  bool isListInTop = true;
  bool isOfficialClass = true;
  bool isSerial = false;

  var _classViewCount = '265610';
  var _classPrice = '15';

  List<String> bannerImgs = [
    'http://www.artepie.cn/image/bannertest.jpg',
    'http://www.artepie.cn/image/bannertest1.jpg',
    'http://www.artepie.cn/image/bannertest2.jpg',
    'http://www.artepie.cn/image/bannertest3.jpg'
  ];

  List<String> teaIcons = [
    'https://www.artepie.com/image/jintielin.png',
    'https://www.artepie.com/image/wenkezheng.png',
    'https://www.artepie.com/image/lishuangjiang.png',
    'https://www.artepie.com/image/liushiming.png',
    'https://www.artepie.com/image/zhouxiaoyan.png',
    'https://www.artepie.com/image/shenxiang.png',
    'https://www.artepie.com/image/wangbaozhang.png',
    'https://www.artepie.com/image/wangsufen.png',
    'https://www.artepie.com/image/chengzhi.png',
    'https://www.artepie.com/image/maqiuhua.png',
    'https://www.artepie.com/image/zouwenqin.png',
    'https://www.artepie.com/image/langlang.png',
    'https://www.artepie.com/image/dengmei.png',
    'https://www.artepie.com/image/fangqiong.jpg',
    'http://www.artepie.cn/image/logo.png',
  ];

  List<String> teaNames = [
    '金铁霖',
    '温可铮',
    '李双江',
    '柳石明',
    '周小燕',
    '沈湘',
    '王宝璋',
    '王苏芬',
    '程志',
    '马秋华',
    '邹文琴',
    '朗朗',
    '邓梅',
    '方琼',
    '音乐家',
  ];

  List<String> typeNames = ['民族', '美声', '古典', '戏曲', '原生态', '民谣', '通俗', '其他'];
  List<Icon> typeIcons = [
    Icon(Icons.movie),
    Icon(Icons.fiber_pin),
    Icon(Icons.music_video),
    Icon(Icons.face),
    Icon(Icons.nature),
    Icon(Icons.gif),
    Icon(Icons.star_border),
    Icon(Icons.music_note)
  ];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      color: MyColors.dividerColor,
      child: Stack(
        children: <Widget>[
          new RefreshIndicator(
              displacement: 50,
              child: new Listener(
                onPointerMove: (event) {
                  var position = event.position.distance;
//                  LogUtil.e(position);
                },
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
                        height: 40,
                        margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: MyColors.card_tap,
                        ),
                        child: new Padding(
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
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
                                    fontSize: 14,
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
                        padding: EdgeInsets.all(10),
                        child: new Text(
                          '热门课程',
                          style: new TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SliverFixedExtentList(
                      itemExtent: 180.0,
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return _classItem(context, index);
                        },
                        childCount: 20,
                      ),
                    )
                  ],
                ),
              ),
              onRefresh: () {}),
          _searchWidget(context)
        ],
      ),
    );
  }

  Widget _bannerWidget(BuildContext context) {
    return new Container(
      height: 220.0,
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return (Image.network(
            bannerImgs[index],
            fit: BoxFit.cover,
          ));
        },
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

  Widget _teacherItemWidget(BuildContext context) {
    return new Container(
      height: 160,
      child: new Column(
        children: <Widget>[
          new Container(
            width: double.infinity,
            padding: EdgeInsets.all(10),
            child: new Text(
              '名师专栏',
              style: new TextStyle(
                  fontSize: 20,
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
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    child: new Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.all(8),


                          child: ClipRRect(

                            borderRadius: BorderRadius.circular(30),
                            child: FadeInImage.assetNetwork(
                              height: 50,
                              width: 50,
                              placeholder: 'lib/resource/assets/img/defaulticon.jpeg',
                              image: teaIcons[index],
                              fit: BoxFit.cover,
                            ),
                          ),
//                          child: Align(
//                            child: CircleAvatar(
//                              child: Image.network(teaIcons[index]),
//                              backgroundImage: AssetImage(
//                                  'lib/resource/assets/img/defaulticon.jpeg'),
//                              radius: 25,
//                            ),
//                          )
                        ),
                        new Text(
                          teaNames[index],
                          style: new TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                onTap: () {
                  //TODO 跳转教师
                },
              );
            },
            itemCount: teaIcons.length,
          ))
        ],
      ),
    );
  }

  Widget _typeWidget(BuildContext context) {
    return new Container(
        margin: EdgeInsets.fromLTRB(10, 5, 10, 0),
        child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            child: new Container(
              margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
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
        margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: new Column(
          children: <Widget>[
            typeIcons[position],
            new Text(
              typeNames[position],
              style: new TextStyle(
                fontSize: 12,
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
      height: 180,
      margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: new Row(
        children: <Widget>[
          new Stack(
            children: <Widget>[
              Container(
                height: 180,
                width: 160,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: FadeInImage.assetNetwork(
                    placeholder: 'lib/resource/assets/img/loading.png',
                    image: 'http://www.artepie.cn/image/bannertest2.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              new Offstage(
                offstage: !isOfficialClass,
                child: Container(
                  height: 32,
                  width: 62,
                  decoration: BoxDecoration(
                    color: MyColors.colorPrimary,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(0),
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(15)),
                  ),
                  child: new Center(
                    child: new Text(
                      '官方课程',
                      style: new TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
          new Container(
            width: 180,
            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text('标题',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: new TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    )),
                new Text('作者',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: new TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                new Text(
                    '简介dsdsdsdsdsdsdsdsdsdsfwegregsdgdgsddgsgsewrwfewfwefwfwfewfewfwefwefwefewfwef',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: new TextStyle(
                      fontSize: 16,
                    )),
                new Container(
                  height: 20,
                  width: 50,
                  decoration: BoxDecoration(
                      color: MyColors.colorPrimary,
                      borderRadius: BorderRadius.circular(10)),
                  child: new Text(isSerial ? '连载中' : '已完结',
                      textAlign: TextAlign.center,
                      style: new TextStyle(color: Colors.white, fontSize: 12)),
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    new Text(
                      '$_classViewCount人次已学习',
                      style: new TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    new Text(
                      '￥$_classPrice',
                      style: new TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          color: MyColors.colorPrimary),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchWidget(BuildContext context) {
    return new Container(
      height: 86,
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
                height: 56.0,
                child: new Container(
                  margin: EdgeInsets.fromLTRB(25, 10, 25, 10),
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color:
                          isListInTop ? Colors.white : MyColors.dividerColor),
                  child: new Row(
                    children: <Widget>[
                      Icon(Icons.search),
                      new Padding(
                        padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                        child: new Text('搜索艺派相关内容'),
                      )
                    ],
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
