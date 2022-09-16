// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

/**
 * themed frame
 * 
 * custom widget with the default background colors
 * takes in a Column
 * 
 * 
 * 
 * author @musabisimwa @diri0060
 * 
 */

@immutable
class ThemedFrame extends StatelessWidget {
  Widget child;
  ThemedFrame({
    Key? key,
    required Widget this.child,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: const [
            Color.fromRGBO(0, 18, 25, 1),
            Color.fromRGBO(0, 95, 115, 1)
          ])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(child: child),
      ),
    );
  }
}
