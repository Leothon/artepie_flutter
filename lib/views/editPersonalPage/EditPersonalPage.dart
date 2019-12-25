import 'dart:convert';

import 'package:artepie/resource/MyColors.dart';
import 'package:artepie/routers/Application.dart';
import 'package:artepie/utils/Adapt.dart';
import 'package:artepie/utils/OssApiService.dart';
import 'package:artepie/utils/OssUtils.dart';
import 'package:artepie/utils/data_utils.dart';
import 'package:artepie/views/LoadStateLayout.dart';
import 'package:artepie/views/userIconWidget/UserIconWidget.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';
import 'dart:convert' as JSON;

class EditPersonalPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _editPersonalPageState();
  }
}

class _editPersonalPageState extends State<EditPersonalPage> {
  LoadState _layoutState = LoadState.State_Loading;
  TextEditingController nameController = TextEditingController();
  var userInfo = {
    'user_name': '',
    'user_icon': '',
    'user_birth': '',
    'user_sex': 0,
    'user_signal': '',
    'user_address': '',
    'user_phone': '',
  };
  int groupValue = 1;

  bool isEdit = false;

  var _imgPath;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    hideLoadingDialog();
    _loadEditInfo();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        backgroundColor: Colors.white,
        body: new WillPopScope(
          child: Stack(
            children: <Widget>[
              LoadStateLayout(
                successWidget: _editPersonalPageWidget(context),
                errorRetry: () {
                  setState(() {
                    _layoutState = LoadState.State_Loading;
                  });
                  _loadEditInfo();
                },
                state: _layoutState,
              ),
              loadingDialog,
            ],
          ),
          onWillPop: () {
            if (isEdit) {
              showDialog<Null>(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return new AlertDialog(
                      title: new Text('提示'),
                      content: new SingleChildScrollView(
                        child: new ListBody(
                          children: <Widget>[
                            new Text('资料已被修改，保存请点击完成，退出即放弃修改'),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        new FlatButton(
                          child: new Text('退出'),
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
                        ),
                        new FlatButton(
                          child: new Text('继续编辑'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  });
            } else {
              Navigator.of(context).pop();
            }
          },
        ));
  }

  Widget _editPersonalPageWidget(BuildContext context) {
    return new RefreshIndicator(
        displacement: Adapt.px(200),
        child: new CustomScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          slivers: <Widget>[
            SliverAppBar(
              title: new Text(
                '编辑个人信息',
                style:
                    new TextStyle(fontSize: Adapt.px(34), color: Colors.black),
              ),
              leading: new InkWell(
                child: Icon(
                  Icons.arrow_back,
                  color: MyColors.fontColor,
                ),
                onTap: () {
                  if (isEdit) {
                    showDialog<Null>(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return new AlertDialog(
                            title: new Text('提示'),
                            content: new SingleChildScrollView(
                              child: new ListBody(
                                children: <Widget>[
                                  new Text('资料已被修改，保存请点击完成，退出即放弃修改'),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              new FlatButton(
                                child: new Text('退出'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                },
                              ),
                              new FlatButton(
                                child: new Text('继续编辑'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        });
                  } else {
                    Navigator.of(context).pop();
                  }
                },
              ),
              pinned: true,
              backgroundColor: Colors.white,
              brightness: Brightness.light,
              elevation: 3,
              forceElevated: true,
            ),
            SliverToBoxAdapter(
              child: new Container(
                height: Adapt.px(20),
                color: MyColors.dividerColor,
              ),
            ),
            SliverToBoxAdapter(
                child: new InkWell(
              child: Container(
                height: Adapt.px(110),
                padding:
                    EdgeInsets.only(left: Adapt.px(28), right: Adapt.px(28)),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Text(
                      '头像',
                      style: new TextStyle(
                          fontSize: Adapt.px(28), color: MyColors.lowfontColor),
                    ),
                    new Row(
                      children: <Widget>[
                        UserIconWidget(
                          url: userInfo['user_icon'],
                          isAuthor: false,
                          authority: false,
                          size: Adapt.px(56),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: Adapt.px(18)),
                          child: Icon(Icons.keyboard_arrow_right,
                              color: MyColors.lowfontColor),
                        )
                      ],
                    )
                  ],
                ),
              ),
              onTap: () {
                showDialog<Null>(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return new AlertDialog(
                        title: new Text('更换头像'),
                        content: new SingleChildScrollView(
                          child: new ListBody(
                            children: <Widget>[
                              new InkWell(
                                child: new Container(
                                  padding: EdgeInsets.fromLTRB(
                                    Adapt.px(14),
                                    Adapt.px(16),
                                    Adapt.px(14),
                                    Adapt.px(12),
                                  ),
                                  child: new Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.camera_alt,
                                        color: MyColors.lowfontColor,
                                      ),
                                      new Text('   拍摄照片')
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  _takePhoto();
                                  Navigator.of(context).pop();
                                },
                              ),
                              new Container(
                                height: Adapt.px(2),
                                color: MyColors.dividerColor,
                              ),
                              new InkWell(
                                child: new Container(
                                  padding: EdgeInsets.fromLTRB(
                                    Adapt.px(14),
                                    Adapt.px(16),
                                    Adapt.px(14),
                                    Adapt.px(12),
                                  ),
                                  child: new Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.photo_album,
                                        color: MyColors.lowfontColor,
                                      ),
                                      new Text('  从相册选取')
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  _openGallery();
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          new FlatButton(
                            child: new Text('取消'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    });
              },
            )),
            SliverToBoxAdapter(
              child: new Container(
                height: Adapt.px(2),
                color: MyColors.dividerColor,
              ),
            ),
            SliverToBoxAdapter(
                child: new InkWell(
              child: Container(
                height: Adapt.px(110),
                padding:
                    EdgeInsets.only(left: Adapt.px(28), right: Adapt.px(28)),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Text(
                      '昵称',
                      style: new TextStyle(
                          fontSize: Adapt.px(28), color: MyColors.lowfontColor),
                    ),
                    new Row(
                      children: <Widget>[
                        new Text(
                          userInfo['user_name'],
                          style: new TextStyle(
                              fontSize: Adapt.px(22),
                              color: MyColors.lowfontColor),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: Adapt.px(18)),
                          child: Icon(Icons.keyboard_arrow_right,
                              color: MyColors.lowfontColor),
                        )
                      ],
                    )
                  ],
                ),
              ),
              onTap: () {
                //TODO 跳转到昵称
                showDialog<Null>(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return new AlertDialog(
                        title: new Text('修改昵称'),
                        content: new SingleChildScrollView(
                          child: new ListBody(
                            children: <Widget>[
                              TextField(
                                controller: nameController,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.account_box),
                                  labelText: '输入昵称',
                                  labelStyle:
                                      new TextStyle(fontSize: Adapt.px(32)),
                                  hintText: '输入昵称',
                                  hintStyle:
                                      new TextStyle(fontSize: Adapt.px(22)),
                                ),
                                //autofocus: true,
                              ),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          new FlatButton(
                            child: new Text('取消'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          new FlatButton(
                            child: new Text('确定'),
                            onPressed: () {
                              Navigator.of(context).pop();
                              setState(() {
                                isEdit = true;
                                userInfo['user_name'] =
                                    nameController.text.toString();
                              });
                            },
                          ),
                        ],
                      );
                    });
              },
            )),
            SliverToBoxAdapter(
              child: new Container(
                height: Adapt.px(18),
                color: MyColors.dividerColor,
              ),
            ),
            SliverToBoxAdapter(
                child: new InkWell(
              child: Container(
                height: Adapt.px(110),
                padding:
                    EdgeInsets.only(left: Adapt.px(28), right: Adapt.px(28)),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Text(
                      '性别',
                      style: new TextStyle(
                          fontSize: Adapt.px(28), color: MyColors.lowfontColor),
                    ),
                    new Row(
                      children: <Widget>[
                        new Text(
                          userInfo['user_sex'] == 0
                              ? '未知'
                              : (userInfo['user_sex'] == 1 ? '男' : '女'),
                          style: new TextStyle(
                              fontSize: Adapt.px(22),
                              color: MyColors.lowfontColor),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: Adapt.px(18)),
                          child: Icon(Icons.keyboard_arrow_right,
                              color: MyColors.lowfontColor),
                        )
                      ],
                    )
                  ],
                ),
              ),
              onTap: () {
                //TODO 跳转到性别
                showDialog<Null>(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return new StatefulBuilder(
                          builder: (context, setStateDialog) {
                        return AlertDialog(
                          title: new Text('修改昵称'),
                          content: new SingleChildScrollView(
                            child: new ListBody(
                              children: <Widget>[
                                new RadioListTile(
                                    value: 0,
                                    groupValue: groupValue,
                                    title: new Text('未知'),
                                    onChanged: (T) {
                                      setStateDialog(() {
                                        groupValue = T;
                                      });
                                    }),
                                new RadioListTile(
                                    value: 1,
                                    groupValue: groupValue,
                                    title: new Text('男'),
                                    onChanged: (T) {
                                      setStateDialog(() {
                                        groupValue = T;
                                      });
                                    }),
                                new RadioListTile(
                                    value: 2,
                                    groupValue: groupValue,
                                    title: new Text('女'),
                                    onChanged: (T) {
                                      setStateDialog(() {
                                        groupValue = T;
                                      });
                                    }),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            new FlatButton(
                              child: new Text('取消'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            new FlatButton(
                              child: new Text('确定'),
                              onPressed: () {
                                Navigator.of(context).pop();
                                setState(() {
                                  isEdit = true;
                                  setState(() {
                                    isEdit = true;
                                    userInfo['user_sex'] = groupValue;
                                  });
                                });
                              },
                            ),
                          ],
                        );
                      });
                    });
              },
            )),
            SliverToBoxAdapter(
              child: new Container(
                height: Adapt.px(2),
                color: MyColors.dividerColor,
              ),
            ),
            SliverToBoxAdapter(
                child: new InkWell(
                    child: Container(
                      height: Adapt.px(110),
                      padding: EdgeInsets.only(
                          left: Adapt.px(28), right: Adapt.px(28)),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new Text(
                            '生日',
                            style: new TextStyle(
                                fontSize: Adapt.px(28),
                                color: MyColors.lowfontColor),
                          ),
                          new Row(
                            children: <Widget>[
                              new Text(
                                userInfo['user_birth'],
                                style: new TextStyle(
                                    fontSize: Adapt.px(22),
                                    color: MyColors.lowfontColor),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: Adapt.px(18)),
                                child: Icon(Icons.keyboard_arrow_right,
                                    color: MyColors.lowfontColor),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    onTap: () {
                      //TODO 跳转生日

                      showDialog<Null>(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return new AlertDialog(
                              title: new Text('修改生日'),
                              content: new SingleChildScrollView(
                                child: new ListBody(
                                  children: <Widget>[
                                    DatePickerWidget(
                                      initialDateTime: userInfo['user_birth'] == null ? DateTime.now() : DateUtil.getDateTime(userInfo['user_birth']),
                                      locale: DateTimePickerLocale.zh_cn,
                                      pickerTheme: new DateTimePickerTheme(
                                        cancel: new Container(height: 0,width: 0,),
                                        confirm: new Container(height: 0,width: 0,)
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                new FlatButton(
                                  child: new Text('取消'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                new FlatButton(
                                  child: new Text('确定'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    setState(() {
                                      isEdit = true;
                                      userInfo['user_birth'] = '';
                                    });
                                  },
                                ),
                              ],
                            );
                          });
                    })),
            SliverToBoxAdapter(
              child: new Container(
                height: Adapt.px(2),
                color: MyColors.dividerColor,
              ),
            ),
            SliverToBoxAdapter(
                child: new InkWell(
              child: Container(
                height: Adapt.px(110),
                padding:
                    EdgeInsets.only(left: Adapt.px(28), right: Adapt.px(28)),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Text(
                      '修改绑定号码',
                      style: new TextStyle(
                          fontSize: Adapt.px(28), color: MyColors.lowfontColor),
                    ),
                    new Row(
                      children: <Widget>[
                        new Text(
                          userInfo['user_phone'],
                          style: new TextStyle(
                              fontSize: Adapt.px(22),
                              color: MyColors.lowfontColor),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: Adapt.px(18)),
                          child: Icon(Icons.keyboard_arrow_right,
                              color: MyColors.lowfontColor),
                        )
                      ],
                    )
                  ],
                ),
              ),
              onTap: () {
                //TODO 跳转修改手机号码
              },
            )),
            SliverToBoxAdapter(
              child: new Container(
                height: Adapt.px(2),
                color: MyColors.dividerColor,
              ),
            ),
            SliverToBoxAdapter(
                child: new InkWell(
              child: Container(
                height: Adapt.px(110),
                padding:
                    EdgeInsets.only(left: Adapt.px(28), right: Adapt.px(28)),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Text(
                      '修改签名',
                      style: new TextStyle(
                          fontSize: Adapt.px(28), color: MyColors.lowfontColor),
                    ),
                    new Row(
                      children: <Widget>[
                        new Text(
                          userInfo['user_signal'],
                          style: new TextStyle(
                              fontSize: Adapt.px(22),
                              color: MyColors.lowfontColor),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: Adapt.px(18)),
                          child: Icon(Icons.keyboard_arrow_right,
                              color: MyColors.lowfontColor),
                        )
                      ],
                    )
                  ],
                ),
              ),
              onTap: () {
                //TODO 修改签名
              },
            )),
            SliverToBoxAdapter(
              child: new Container(
                height: Adapt.px(20),
                color: MyColors.dividerColor,
              ),
            ),
            SliverToBoxAdapter(
                child: new InkWell(
              child: Container(
                height: Adapt.px(110),
                padding:
                    EdgeInsets.only(left: Adapt.px(28), right: Adapt.px(28)),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Text(
                      '修改地址',
                      style: new TextStyle(
                          fontSize: Adapt.px(28), color: MyColors.lowfontColor),
                    ),
                    new Row(
                      children: <Widget>[
                        new Text(
                          userInfo['user_address'],
                          style: new TextStyle(
                              fontSize: Adapt.px(22),
                              color: MyColors.lowfontColor),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: Adapt.px(18)),
                          child: Icon(Icons.keyboard_arrow_right,
                              color: MyColors.lowfontColor),
                        )
                      ],
                    )
                  ],
                ),
              ),
              onTap: () {
                //TODO 修改地址
              },
            )),
            SliverToBoxAdapter(
              child: new Container(
                height: Adapt.px(2),
                color: MyColors.dividerColor,
              ),
            ),
            SliverToBoxAdapter(
                child: new InkWell(
              child: Container(
                height: Adapt.px(110),
                padding:
                    EdgeInsets.only(left: Adapt.px(28), right: Adapt.px(28)),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Text(
                      '修改密码',
                      style: new TextStyle(
                          fontSize: Adapt.px(28), color: MyColors.lowfontColor),
                    ),
                    new Row(
                      children: <Widget>[
                        new Text(
                          '',
                          style: new TextStyle(
                              fontSize: Adapt.px(22),
                              color: MyColors.lowfontColor),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: Adapt.px(18)),
                          child: Icon(Icons.keyboard_arrow_right,
                              color: MyColors.lowfontColor),
                        )
                      ],
                    )
                  ],
                ),
              ),
              onTap: () {},
            )),
            SliverToBoxAdapter(
              child: new Container(
                height: Adapt.px(2),
                color: MyColors.dividerColor,
              ),
            ),
            SliverToBoxAdapter(
              child: new Container(
                padding: EdgeInsets.fromLTRB(
                    Adapt.px(60), Adapt.px(60), Adapt.px(60), Adapt.px(60)),
                child: RaisedButton(
                  onPressed: () {
                    //TODO 完成
                  },
                  child: new Text('完成'),
                  textColor: MyColors.white,
                  color: MyColors.colorPrimary,
                ),
              ),
            )
          ],
        ),
        onRefresh: _loadEditInfo);
  }

  Future _loadEditInfo() {
    return DataUtils.getUserInfo({'token': Application.spUtil.get('token')})
        .then((result) {
      var data = result['data'];
      setState(() {
        _layoutState = LoadState.State_Success;
        userInfo = data;
        groupValue = data['user_sex'];
      });
    }).catchError((onError) {
      setState(() {
        _layoutState = LoadState.State_Error;
      });
    });
  }

  _takePhoto() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _imgPath = image.path;
      _getOssToken();
    });
  }

  _openGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _imgPath = image.path;
      _getOssToken();
    });
  }

  Container loadingDialog;

  showLoadingDialog() {
    setState(() {
      loadingDialog = new Container(
          constraints: BoxConstraints.expand(),
          color: Color(0x80000000),
          child: new Center(
            child: new CircularProgressIndicator(),
          ));
    });
  }

  hideLoadingDialog() {
    setState(() {
      loadingDialog = new Container();
    });
  }

  /*
  * 获取OssToken
  */
  void _getOssToken() async {
    showLoadingDialog();
    await ApiService.getOssToken(context).then((result) {
      var data = JSON.jsonDecode(result);
      if (data != null) {
        OssUtil.accesskeyId = data['AccessKeyId'];
        OssUtil.accessKeySecret = data['AccessKeySecret'];
        OssUtil.stsToken = data['SecurityToken'];
      } else {
        Toast.show('获取失败', context);
      }
    }).then((data) {
      _uploadImage();
    });
  }

  void _uploadImage() async {
    String uploadName = OssUtil.instance.getImageUploadName("photo", _imgPath);
    LogUtil.e(uploadName);
    await ApiService.uploadImage(context, uploadName, _imgPath).then((data) {
      hideLoadingDialog();
      if (data == null) {
        Toast.show('上传成功', context);
      }
      setState(() {
        userInfo['user_icon'] = 'http://www.artepie.cn/$uploadName';
        isEdit = true;
      });
    }).then((data) {
      //更新数据库中数据
      LogUtil.e(data);
    });
  }

  void _showBackInfo() {}
}
