
import 'dart:ui';

import 'package:flutter/material.dart';

class Adapt{
  static MediaQueryData mediaQueryData = MediaQueryData.fromWindow(window);
  static double _width = mediaQueryData.size.width;
  static double _height = mediaQueryData.size.height;
  static double _topbarH = mediaQueryData.padding.top;
  static double _botbarH = mediaQueryData.padding.bottom;
  static double _pixelRatio = mediaQueryData.devicePixelRatio;
  static var _ratio;

  static init(int number){
    int uiWidth = number is int ? number : 750;
    _ratio = _width / uiWidth;
  }

  static px(number){
    if(!(_ratio is double || _ratio is int)){
      Adapt.init(750);
    }
    return number * _ratio;
  }

  static onepx(){
    return 1 / _pixelRatio;
  }

  static screenW(){
    return _width;
  }

  static screenH(){
    return _height;
  }

  static padTopH(){
    return _topbarH;
  }

  static padBotH(){
    return _botbarH;
  }
}