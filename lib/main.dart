import 'package:flutter/material.dart';
import 'package:chumcha/configs/theme.dart';
import 'package:chumcha/layout.dart';

var lightGreen = const Color.fromRGBO(139, 195, 74, 1);
var backgroundThemePrimaryLight = lightGreen;
var backgroundThemePrimaryLightMaterial = Colors.lightGreen;
var textSelectedThemePrimary = lightGreen;
var textUnSelectedThemePrimary = Colors.grey;
var textLight = Colors.white;

void main(List<String> args) {
  const app = MyApp();
  runApp(app);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "ฉ่ำชา @กุดป่อง",
        debugShowCheckedModeBanner: false,
        theme: themePrimaryData,
        home: const HomeScreen());
  }
}
