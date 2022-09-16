/**
 * 
 * authors @musabisimwa @diri0060
 * 
 * splash screen 
 * contains the clients logo and slogan
 * for more information follow the link below
 * link: https://runtime-terror4001.atlassian.net/wiki/spaces/SA/blog/2022/03/16/753665/UI+UX+Design
 * 
 * 
 */

import 'package:flutter/material.dart';
import 'package:safe_app/screens/client/wrapper.dart';
import 'package:safe_app/screens/common/themedFrame.dart';
import 'package:safe_app/screens/common/themedHooks.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void initState() {
    super.initState();
    _navigateToHome();
  }

//allows the splash screen to run for milliseconds before moving to login page
  _navigateToHome() async {
    await Future.delayed(Duration(milliseconds: 2500), () {});
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Wrapper()));
  }

  @override
  Widget build(BuildContext context) {
    return ThemedFrame(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: ExactAssetImage('assets/Aegis.png'),
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
