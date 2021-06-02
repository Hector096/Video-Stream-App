import 'package:flutter/material.dart';
import 'package:videostremapp/screen/home.dart';
import 'package:videostremapp/util/sizeConfig.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(builder: (context, orientation) {
        SizeConfig().init(constraints, orientation);
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Video Streaming live',
            theme: ThemeData(
              colorScheme: ColorScheme.dark(),
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: HomeScreen());
      });
    });
  }
}
