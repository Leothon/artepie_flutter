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
  @override
  void initState() {
    super.initState();
    //TODO 加载数据
  }

  bool isListInTop = true;

  ScrollController _scrollController;

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
              child: new Listener(
                onPointerMove: (event) {
                  var position = event.position.distance;
                  LogUtil.e(position);
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
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.yellowAccent
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
                      itemExtent: 50.0,
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return Container(
                            alignment: Alignment.center,
                            color: Colors.lightBlue[100 * (index % 9)],
                            child: Text('SliverFixedExtentList item $index'),
                          );
                        },
                        childCount: 20,
                      ),
                    )
                  ],
                ),
              ),
              onRefresh: () {}),
          isListInTop
              ? _searchWidgetFloating(context)
              : _searchWidgetNormal(context),
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
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(teaIcons[index]),
                            radius: 25,
                          ),
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

  Widget _searchWidgetFloating(BuildContext context) {
    return new Container(
      height: 86,
      child: new Stack(
        children: <Widget>[
          new AppBar(
            elevation: 0,
            brightness: Brightness.light,
            backgroundColor: Colors.transparent,
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
                      color: Colors.white),
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

  Widget _searchWidgetNormal(BuildContext context) {
    return new Container(
      height: 86,
      child: new Stack(
        children: <Widget>[
          new AppBar(
            elevation: 3,
            brightness: Brightness.light,
            backgroundColor: Colors.white,
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
                      color: MyColors.dividerColor),
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
