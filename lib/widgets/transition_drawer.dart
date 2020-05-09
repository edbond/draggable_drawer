import 'dart:async';

import 'package:flutter/material.dart';

class TransitionDrawer extends StatefulWidget {
  final Widget app;
  final Widget menu;
  final StreamController<void> toggleStream;

  TransitionDrawer({
    @required this.app,
    @required this.menu,
    @required this.toggleStream,
  });

  @override
  _TransitionDrawerState createState() => _TransitionDrawerState();
}

enum DrawerState { Opened, Closed }
enum OnRelease { toLeft, toRight }

class _TransitionDrawerState extends State<TransitionDrawer>
    with TickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;
  OnRelease onRelease = OnRelease.toLeft;
  bool trackHorizontalDrag = false;
  DrawerState _drawerState = DrawerState.Closed;
  double dragOffset;
  StreamSubscription<void> toggleSubscription;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      lowerBound: 0,
      upperBound: 1,
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    animation = Tween<double>(begin: 0, end: 100).animate(controller)
      ..addStatusListener((status) {
        // print("status ${status}");
        if (status == AnimationStatus.completed) {
          _drawerState = DrawerState.Opened;
          onRelease = OnRelease.toRight;
        }
        if (status == AnimationStatus.dismissed) {
          _drawerState = DrawerState.Closed;
          onRelease = OnRelease.toLeft;
        }
      });

    toggleSubscription = widget.toggleStream.stream.listen((event) {
      // print("animating? ${controller.isAnimating}, drawer state=$_drawerState");
      if (controller.isAnimating) {
        return;
      }

      if (_drawerState == DrawerState.Closed) {
        controller.forward();
      } else {
        controller.reverse();
      }
    });
  }

  @override
  void dispose() async {
    super.dispose();
    controller.dispose();
    await toggleSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        widget.menu,
        GestureDetector(
          onHorizontalDragStart: (details) {
            var progress = animation.value;
            var leftX = (width * 0.85) * (progress / 100.0);
            var x = details.globalPosition.dx;
            dragOffset = x - leftX;

            if (_drawerState == DrawerState.Opened) {
              trackHorizontalDrag = true;
              return;
            }

            if (details.globalPosition.dx < width * 0.15) {
              trackHorizontalDrag = true;
            } else {
              trackHorizontalDrag = false;
            }
          },
          onHorizontalDragUpdate: (details) {
            if (!trackHorizontalDrag) return;
            var x = details.globalPosition.dx;

            controller.value = (x - dragOffset) / (width * 0.85);
            if (x < width / 2) {
              onRelease = OnRelease.toLeft;
            } else {
              onRelease = OnRelease.toRight;
            }
          },
          onHorizontalDragEnd: (details) {
            if (onRelease == OnRelease.toLeft) {
              controller.reverse();
            } else {
              controller.forward();
            }
            trackHorizontalDrag = false;
          },
          child: AnimatedBuilder(
            animation: animation,
            child: widget.app,
            builder: (context, child) {
              var scale = (0.85 - 1) / 100 * animation.value + 1;
              var translateX = (animation.value / 100 * width * 0.85);

              return Transform(
                alignment: Alignment.centerLeft,
                transform: Matrix4.identity()
                  ..translate(translateX, 0)
                  ..scale(scale),
                child: child,
              );
            },
          ),
        ),
        // Positioned(
        //   left: (width * 0.15),
        //   top: 0,
        //   width: 0.5,
        //   bottom: 0,
        //   child: Container(
        //     color: Colors.red,
        //   ),
        // )
      ],
    );
  }
}
