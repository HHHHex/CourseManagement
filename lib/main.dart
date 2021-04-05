import 'package:boxing_lessons/Scene/ContentPager.dart';
import 'package:boxing_lessons/Service/DataBaseManager.dart';
import 'package:flutter/material.dart';
import 'Scene/AppTabbar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    DataBaseManager.shared();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: AppTabbar(),
    );
  }
}