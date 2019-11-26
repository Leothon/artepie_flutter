import 'package:artepie/resource/MyColors.dart';
import 'package:artepie/routers/Application.dart';
import 'package:artepie/routers/routers.dart';
import 'package:artepie/utils/Adapt.dart';
import 'package:artepie/utils/data_utils.dart';
import 'package:artepie/views/LoadStateLayout.dart';
import 'package:artepie/views/listview_item_bottom.dart';
import 'package:common_utils/common_utils.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TypePage extends StatefulWidget {
  final String _type;
  TypePage(this._type);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _typePageState();
  }
}

class _typePageState extends State<TypePage> {
  LoadState _layoutState = LoadState.State_Loading;
  BottomState _loadState = BottomState.bottom_Success;
  ScrollController _scrollController = new ScrollController();
  var _itemCount = 1;
  List _classItemList = [];
  var _classCount = '';


  Map<String,String> typeDescription  = {
  '民族':'所谓中国民族音乐就是祖祖辈辈生活、繁衍在中国这片土地上的各民族，从古到今在悠久历史文化传统上创造的具有民族特色，能体现民族文化和民族精神的音乐。而广义上，民族音乐是泛指中国音乐家所创作的的音乐和具有中国五声色彩的音乐。',
  '美声':'美声不仅是一种发声方法，还代表着一种演唱风格，一种声乐学派，因之通常又可译作美声唱法、美声学派。 美声歌唱不同于其他歌唱方法的特点之一，是它采用了比其他唱法的喉头位置较低的发声方法，因而产生了一种明亮、丰满、松弛、圆润，而又具有一种金属色彩的、富于共鸣的音质；其次是它注重句法连贯，声音灵活，刚柔兼备，以柔为主的演唱风格。',
  '古典':'古典是指那些从西方中世纪开始至今的、在欧洲主流文化背景下创作的西方古典音乐，主要因其复杂多样的创作技术和所能承载的厚重内涵而有别于通俗音乐和民间音乐。狭义指古典主义时期，1750年（J·S·巴赫去世）至1827年（贝多芬去世)，这一时期为古典主义音乐时期，它包含了两大时间段：“前古典时期”和“维也纳古典时期”。“最为著名的维也纳乐派也是在“维也纳古典时期”兴起，其代表作曲家有海顿、莫扎特和贝多芬，被后世称为“维也纳三杰”。',
  '戏曲':'中国戏曲主要是由民间歌舞、说唱和滑稽戏三种不同艺术形式综合而成。它起源于原始歌舞，是一种历史悠久的综合舞台艺术样式。经过汉、唐到宋、金才形成比较完整的戏曲艺术，它由文学、音乐、舞蹈、美术、武术、杂技以及表演艺术综合而成，约有三百六十多个种类。它的特点是将众多艺术形式以一种标准聚合在一起，在共同具有的性质中体现其各自的个性。 [1]  中国的戏曲与希腊悲剧和喜剧、印度梵剧并称为世界三大古老的戏剧文化，经过长期的发展演变，逐步形成了以“京剧、越剧、黄梅戏、评剧、豫剧”五大戏曲剧种为核心的中华戏曲百花苑',
  '原生态': '原生态指没有被特殊雕琢，存在于民间原始的、散发着乡土气息的表演形态，它包含着原生态唱法、原生态舞蹈、原生态歌手、原生态大写意山水画等。',
  '民谣':'民间流行的、赋予民族色彩的歌曲，称为民谣或民歌。民谣的历史悠远，故其作者多不知名。民谣的内容丰富，有宗教的、爱情的、战争的、工作的，也有饮酒、舞蹈作乐、祭典等等。民谣表现一个民族的感情与习尚，因此各有其独特的音阶与情调风格。如法国民谣的蓬勃、意大利民谣的热情、英国民谣的淳朴、日本民谣的悲愤、西班牙民谣的狂放不羁、中国民谣的缠绵悱恻，都表现了强烈的民族气质与色彩。',
  '通俗':'通俗唱法（原也称流行唱法）始于中国二十世纪30年代得到广泛的流传。其特点是声音自然，近似说话，中声区使用真声，高声区一般使用假声。很少使用共鸣，故音量较小。演唱时必须借助电声扩音器，演出形式以独唱为主，常配以舞蹈动作、追求声音自然甜美，感情细腻真实。',
  '其他':'其他相关的艺术形式'};

  bool isTop = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _loadTypeData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          _loadState = BottomState.bottom_Loading;
        });
        _loadMoreTypeData();
      }

      if (_scrollController.offset < Adapt.px(280)) {
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

    return new Scaffold(
        backgroundColor: MyColors.dividerColor,
        body: new LoadStateLayout(
          successWidget: _typePageWidget(context),
          errorRetry: () {
            setState(() {
              _layoutState = LoadState.State_Loading;
            });
            _loadTypeData();
          },
          state: _layoutState,
        ));
  }

  Widget _typePageWidget(BuildContext context) {
    return RefreshIndicator(
      displacement: Adapt.px(200),
      child: new CustomScrollView(
        controller: _scrollController,
        physics: AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: Adapt.px(280),
            brightness: Brightness.light,
            title: new Text(
              widget._type,
              style: new TextStyle(color: isTop ? MyColors.fontColor : Colors.white),
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
            backgroundColor: Colors.white,
            floating: false,
            pinned: true,
            snap: false,
            flexibleSpace: new FlexibleSpaceBar(
              background: Image.network(
                  _classItemList.length == 0 ? 'http://www.artepie.cn/image/video_cover.png' : _classItemList[0]['selectbackimg'],
                  fit: BoxFit.cover),
            ),
          ),
          SliverToBoxAdapter(
            child: new Container(
                padding: EdgeInsets.all(Adapt.px(20)),
                color: Colors.white,
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text('总课程数:$_classCount',style: new TextStyle(
                      color: Colors.black,
                      fontSize: Adapt.px(32)
                    ),),
                    new Padding(padding: EdgeInsets.only(top: Adapt.px(20),left: Adapt.px(10),right: Adapt.px(10)),child: new Text(
                        typeDescription[widget._type],style: new TextStyle(
                      color: MyColors.fontColor,
                      fontSize: Adapt.px(24)
                    ),),
                        )
                    ],
                )),
          ),
          SliverToBoxAdapter(
            child: ClipPath(
              //路径裁切组件
              clipper: BottomClipper(), //路径
              child: new Container(
                height: Adapt.px(100),
                color: Colors.white,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                if (index == _itemCount) {
                  return new ListBottomView(
                    isHighBottom: true,
                    bottomState: _loadState,
                    errorRetry: () {
                      setState(() {
                        _loadState = BottomState.bottom_Loading;
                      });
                      _loadMoreTypeData();
                    },
                  );
                } else {
                  return _classItem(context, index);
                }
              },
              childCount: _itemCount + 1,
            ),
          )
        ],
      ),
      onRefresh: _loadTypeData,
    );
  }

  Widget _classItem(BuildContext context, int position) {
    return InkWell(
      child: new Stack(
        children: <Widget>[
          Container(
            height: Adapt.px(332),
            margin: EdgeInsets.fromLTRB(Adapt.px(24), 0, Adapt.px(24), 0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: position == 0
                        ? Radius.circular(Adapt.px(28))
                        : Radius.circular(Adapt.px(0)),
                    topRight: position == 0
                        ? Radius.circular(Adapt.px(28))
                        : Radius.circular(Adapt.px(0)),
                    bottomRight: position == _itemCount - 1
                        ? Radius.circular(Adapt.px(28))
                        : Radius.circular(Adapt.px(0)),
                    bottomLeft: position == _itemCount - 1
                        ? Radius.circular(Adapt.px(28))
                        : Radius.circular(Adapt.px(0)))),
            child: new Row(
              children: <Widget>[
                Expanded(
                  child: new Stack(
                    children: <Widget>[
                      Container(
                        height: Adapt.px(332),
                        //width: Adapt.px(300),
                        padding: EdgeInsets.only(
                            left: Adapt.px(18),
                            bottom: Adapt.px(18),
                            top: Adapt.px(18)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(Adapt.px(28)),
                          child: FadeInImage.assetNetwork(
                            placeholder: 'lib/resource/assets/img/loading.png',
                            image: _classItemList[position]['selectbackimg'],
                            fit: BoxFit.cover,
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
                        new Text(_classItemList[position]['selectlisttitle'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: new TextStyle(
                              fontSize: Adapt.px(34),
                              fontWeight: FontWeight.bold,
                            )),
//                  new Text(_classItemList[position]['selectauthor'],
//                      maxLines: 1,
//                      overflow: TextOverflow.ellipsis,
//                      style: new TextStyle(
//                          fontSize: Adapt.px(28), color: MyColors.fontColor)),
                        new Text(_classItemList[position]['selectdesc'],
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: new TextStyle(
                              fontSize: Adapt.px(24),
                            )),
                        new Container(
                          height: Adapt.px(34),
                          width: Adapt.px(88),
                          decoration: BoxDecoration(
                              color: _classItemList[position]['serialize']
                                  ? MyColors.colorPrimary
                                  : Colors.green,
                              borderRadius: BorderRadius.circular(Adapt.px(18))),
                          child: new Text(
                              _classItemList[position]['serialize']
                                  ? '连载中'
                                  : '已完结',
                              textAlign: TextAlign.center,
                              style: new TextStyle(
                                  color: Colors.white, fontSize: Adapt.px(20))),
                        ),
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            new Text(
                              '${_classItemList[position]['selectstucount']}人次已学习',
                              style: new TextStyle(
                                fontSize: Adapt.px(22),
                              ),
                            ),
                            new Text(
                              _classItemList[position]['isbuy']
                                  ? '已购买'
                                  : (_classItemList[position]['selectprice'] == '0.00'
                                  ? '免费'
                                  : '￥${_classItemList[position]['selectprice']}'),
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
          ),
          new Offstage(
            offstage: position == 0 ? true : false,
            child: Container(
              color: MyColors.dividerColor,
              margin: EdgeInsets.only(left: Adapt.px(60), right: Adapt.px(60)),
              height: Adapt.px(2),
            ),
          )
        ],
      ),
      onTap: () {
        if (_classItemList[position]['selectprice'] == '0.00' ||
            _classItemList[position]['isbuy']) {
          Application.router.navigateTo(context,
              '${Routes.classDetailPage}?classid=${Uri.encodeComponent(
                  _classItemList[position]['selectId'])}',
              transition: TransitionType.fadeIn);
        } else if (position == 0) {
          Application.router.navigateTo(context,
              '${Routes.classDetailPage}?classid=${Uri.encodeComponent(
                  _classItemList[position]['selectId'])}',
              transition: TransitionType.fadeIn);
        } else {
          showDialog<Null>(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('提醒'),
                  content: Text('本课程是付费课程，您尚未订阅'),
                  actions: <Widget>[

                    FlatButton(
                      child: Text('直接订阅'),
                      onPressed: () {
                        Navigator.of(context).pop();

                        //TODO 跳转购买课程
                      },
                    ),

                    FlatButton(
                      child: Text('试看一下'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        Application.router.navigateTo(context,
                            '${Routes.classDetailPage}?classid=${Uri
                                .encodeComponent(
                                _classItemList[position]['selectId'])}',
                            transition: TransitionType.fadeIn);
                      },
                    ),
                  ],
                );
              });
        }
      },


    );
  }

  Future _loadTypeData() {
    return DataUtils.getTypeData(
            {'token': Application.spUtil.get('token'), 'type': widget._type})
        .then((result) {
      var data = result['data'];
      if (data.length == 0) {
        setState(() {
          _layoutState = LoadState.State_Empty;
        });
      } else {
        setState(() {
          _layoutState = LoadState.State_Success;
          _classCount = data['typeClassCount'];
          _classItemList = data['typeClass'];
          _itemCount = _classItemList.length;
        });
      }
    }).catchError((onError) {
      setState(() {
        LogUtil.e(onError);
        _layoutState = LoadState.State_Error;
      });
    });
  }

  void _loadMoreTypeData() {
    _loadState = BottomState.bottom_Loading;
    DataUtils.getTypeMoreData({
      'token': Application.spUtil.get('token'),
      'type': widget._type,
      'currentpage': _itemCount.toString(),
    }).then((result) {
      var data = result['data'];
      if (data.length == 0) {
        setState(() {
          _loadState = BottomState.bottom_Empty;
        });
      } else {
        setState(() {
          _classItemList.addAll(data);
          _itemCount = _classItemList.length;
        });
      }
    }).catchError((onError) {
      setState(() {
        _loadState = BottomState.bottom_Error;
      });
    });
  }
}

class BottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, 0);
    path.lineTo(0, size.height - 50.0);
    var firstControlPoint = Offset(size.width / 2, size.height);
    var firstEdnPoint = Offset(size.width, size.height - 50.0);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEdnPoint.dx, firstEdnPoint.dy);
    path.lineTo(size.width, size.height - 50.0);
    path.lineTo(size.width, 0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
