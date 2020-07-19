import 'dart:async';


import 'package:flutter/material.dart';
import 'package:flutter_classifiedappclone/UI/models/OrderState.dart';

import 'AnimatedDot.dart';
import 'AnimatedOrderIcon.dart';
import 'OrderStateCard.dart';

// Responsible for the whole graph that appears in the order tracking system
class CartDetailsGraph extends StatefulWidget {

  // Contains all your order states
  List<OrderState> orderStates;
  final double height;

  // IntrinsicHeight so that our view will fill as much space as it can and we will be able to render it in ScrollView
  CartDetailsGraph({this.orderStates, this.height});

  @override
  _CartDetailsGraphState createState() => _CartDetailsGraphState();
}

class _CartDetailsGraphState extends State<CartDetailsGraph>
    with TickerProviderStateMixin {

  final double _initialOrderPaddingBottom = 50.0;
  final double _minOrderPaddingTop = 50.0;

  // Contains all your order states
  List<OrderState> _orderStates = [];

  // Contains a key for each state
  final List<GlobalKey<OrderStateCardState>> _stateKeys = [];

  AnimationController _orderSizeAnimationController;
  AnimationController _orderStateController;
  AnimationController _dotsAnimationController;
  AnimationController _fabAnimationController;
  Animation _orderSizeAnimation;
  Animation _orderStateAnimation;
  Animation _fabAnimation;

  List<Animation<double>> _dotPositions = [];

  //_orderTopPadding getter so that it is dependent on _orderSizeAnimationController
  double get _orderTopPadding =>
      _minOrderPaddingTop +
      (1 - _orderStateAnimation.value) * _maxOrderTopPadding;

  double get _maxOrderTopPadding =>
      widget.height -
      _minOrderPaddingTop -
      _initialOrderPaddingBottom -
      _orderSize;

  double get _orderSize => _orderSizeAnimation.value;

  @override
  void initState() {
    super.initState();

    // Getting all order states
    _orderStates = widget.orderStates;
    
    // For burger icon size animation.
    _initSizeAnimations();

    // Responsible for animating (moving up) the burger icon
    _initOrderStateAnimations();
    
    // Responsible for controlling all dots' animations
    _initDotAnimationController();
    _initDotAnimations();

    // Responsible for controlling the animation of the payment button
    _initFabAnimationController();
    
    // Adding the global key for each state
    _orderStates.forEach(
        (state) => _stateKeys.add(new GlobalKey<OrderStateCardState>()));

    // Start the animation
    _orderSizeAnimationController.forward();
  }


  // The main build method which is responsible for rendering the view
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[_buildOrder()]
          ..addAll(_orderStates.map(_buildStateCard))
          ..addAll(_orderStates.map(_mapOrderStateToDot))
          ..add(_buildFab()),
      ),
    );
  }

  // Responsible for building the order state cards
  Widget _buildStateCard(OrderState state) {
    int index = _orderStates.indexOf(state);
    double topMargin = _dotPositions[index].value -
        0.5 * (OrderStateCard.height - AnimatedDot.size);
    bool isLeft = index.isOdd;
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.only(top: topMargin),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            isLeft ? Container() : Expanded(child: Container()),
            Expanded(
              child: OrderStateCard(
                key: _stateKeys[index],
                orderState: state,
                isLeft: isLeft,
              ),
            ),
            !isLeft ? Container() : Expanded(child: Container()),
          ],
        ),
      ),
    );
  }

  // Determining the color of dots depending on the state of each phase
  Widget _mapOrderStateToDot(OrderState state) {
    int index = _orderStates.indexOf(state);
    bool isDoneOrNot = (state.state.toLowerCase() == "Ok".toLowerCase());
    Color color = isDoneOrNot ? Colors.green : Colors.red;

    return AnimatedDot(
      animation: _dotPositions[index],
      color: color,
    );
  }

  Widget _buildOrder() {

    // We have added an AnimatedBuilder which will rebuild the burger icon according to Animation’s value
    return AnimatedBuilder(
      animation: _orderStateAnimation,
      child: Column(
        children: <Widget>[

          // Showing the burger icon
          AnimatedOrderIcon(animation: _orderSizeAnimation),

          // Showing the long line below the burger icon
          Container(
            width: 2.0,
            height: _orderStates.length * OrderStateCard.height * 0.8,
            color: Color.fromARGB(255, 200, 200, 200),
          ),
        ],
      ),
      builder: (context, child) => Positioned(
            top: _orderTopPadding,
            child: child,
          ),
    );
  }

  // We added a FloatingActionButton so that whole view will be completed
  // This fab’s animation will start just after last card animation’s start
  Widget _buildFab() {
    return Positioned(
      bottom: 30.0,
      child: ScaleTransition(
        scale: _fabAnimation,
        child: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () => Navigator.of(context).pop(),
          child: Icon(
            Icons.check,
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }

  // For burger size animation. First by adding AnimationController and Animation objects 
  // related to the size of the burger icon
  _initSizeAnimations() {
    _orderSizeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 340),
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Future.delayed(Duration(milliseconds: 500), () {
            _orderStateController.forward();
          });
          Future.delayed(Duration(milliseconds: 700), () {
            _dotsAnimationController.forward();
          });
        }
      });

    // This animation will scale from 60 to 36 which is the actual size we would like to achieve
    // We pass it to the AnimatedOrderIcon widget which will be rebuilt on every animation change
    _orderSizeAnimation =
        Tween<double>(begin: 60.0, end: 36.0).animate(CurvedAnimation(
      parent: _orderSizeAnimationController,
      curve: Curves.easeOut,
    ));
  }

  // Responsible for animating (moving up) the burger icon
  _initOrderStateAnimations() {
    _orderStateController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _orderStateAnimation = CurvedAnimation(
      parent: _orderStateController,
      curve: Curves.fastOutSlowIn,
    );
  }

  void _initDotAnimations() {

    // What part of whole animation takes one dot state
    final double slideDurationInterval = 0.4;

    // What are delays between dot animations
    final double slideDelayInterval = 0.2;

    // At the bottom of the screen
    double startingMarginTop = widget.height + 30.0;
    
    // Minimal margin from the top (where first dot will be placed)
    double minMarginTop =
        _minOrderPaddingTop + _orderSize + 0.5 * (0.8 * OrderStateCard.height);

    for (int i = 0; i < _orderStates.length; i++) {
      final start = slideDelayInterval * i;
      final end = start + slideDurationInterval;

      double finalMarginTop = minMarginTop + i * (0.8 * OrderStateCard.height);
      Animation<double> animation = new Tween(
        begin: startingMarginTop,
        end: finalMarginTop,
      ).animate(
        new CurvedAnimation(
          parent: _dotsAnimationController,
          curve: new Interval(start, end, curve: Curves.easeOut),
        ),
      );
      _dotPositions.add(animation);
    }
  }

  // Responsible for starting the animation of each card, then the animation of the payment button
  void _initDotAnimationController() {
    _dotsAnimationController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 500))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _animateOrderStateCards().then((_) => _animateFab());
        }
      });
  }

  // Responsible for starting the animation of each card
  Future _animateOrderStateCards() async {
    return Future.forEach(_stateKeys,
        (GlobalKey<OrderStateCardState> stateKey) {
      return new Future.delayed(Duration(milliseconds: 250), () {
        stateKey.currentState.runAnimation();
      });
    });
  }

  // Responsible for controlling the animation of the payment button
  void _initFabAnimationController() {
    _fabAnimationController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 300));
    _fabAnimation = new CurvedAnimation(
        parent: _fabAnimationController, curve: Curves.easeOut);
  }

  _animateFab() {
    _fabAnimationController.forward();
  }

  @override
  void dispose() {
    _orderSizeAnimationController.dispose();
    _orderStateController.dispose();
    _dotsAnimationController.dispose();
    _fabAnimationController.dispose();
    super.dispose();
  }
}
