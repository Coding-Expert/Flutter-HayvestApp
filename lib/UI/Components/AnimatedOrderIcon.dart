import 'package:flutter/material.dart';
import 'package:flutter_classifiedappclone/UI/Pages/Registration/BuyerRegistration/Custom_Icons.dart';

// Its the burger icon that appears in the order tracking system 
class AnimatedOrderIcon extends AnimatedWidget {
  AnimatedOrderIcon({Key key, Animation<double> animation})
      : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    Animation<double> animation = super.listenable;
    return Icon(
      CustomIcons.menu,
      color: Colors.red,
      size: animation.value,
    );
  }
}
