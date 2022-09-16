// ignore_for_file: prefer_const_constructors

/**
 * main dart
 * 
 * has only 1 function
 * 
 * 
 * 
 * author @musabisimwa @diri0060
 * 
 */

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:provider/provider.dart' as provider;
import 'package:safe_app/screens/client/splashScreen.dart';

import 'package:safe_app/services/authentication/auth.dart';
import 'package:safe_app/services/models/auth_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp()
      .whenComplete(() => runApp(ProviderScope(child: const MyApp())));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return provider.StreamProvider<AppUser?>.value(
      value: AuthService().user,
      initialData: null,
      child: const MaterialApp(
        home: SplashScreen(),
      ),
    );
  }
}
