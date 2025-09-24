import 'package:flutter/material.dart';



enum ButtonSize {
  large, medium, small ;

  double getScaleNum(){
    if(this==ButtonSize.small){
      return 0.85;
    }else if(this==ButtonSize.large){
      return 1.2;
    }
    return 1;
  }
  double getIconSize(){
    if(this==ButtonSize.small){
      return 20;
    }else if(this==ButtonSize.large){
      return 30;
    }
    return 24;
  }
}

enum ButtonShape {
  ///圆形
  circle,
  ///椭圆形
  stadium,
  ///长方形
  rectangle;
  OutlinedBorder getShape(){
    if(this==circle){
      return const CircleBorder();
    }else if(this==stadium){
      return  RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      );
    }
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(2),
    );
  }
}
///按钮类型
enum ButtonType { dashed, link, normal, primary, text;}