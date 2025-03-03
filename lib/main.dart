import 'package:afya/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/providers/token_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ApiCalls()),
    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Works',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff1684A7)),
        // primarySwatch: Colors.blue,
        // useMaterial3: true,
      ),
      home: SplashPage(token: token),
    ),
  ));
}


///colors
///blue 1684A7
///green 09A599
///yellow F6EC72
///white F6F6F6
///pupple 7743DB
///black 314165

//new colors
/// blue 0071e7
/// red fe0002
/// normal black 262626
/// pure black 000000
/// white FFFFFF