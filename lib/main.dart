import 'package:chumcha/json_parse/json_parse_menu.dart';
import 'package:chumcha/pages/menu.dart';
import 'package:flutter/material.dart';
import 'package:chumcha/configs/theme.dart';
import 'package:chumcha/layout.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

var lightGreen = const Color.fromRGBO(139, 195, 74, 1);
var backgroundThemePrimaryLight = lightGreen;
var backgroundThemePrimaryLightMaterial = Colors.lightGreen;
var textSelectedThemePrimary = lightGreen;
var textUnSelectedThemePrimary = Colors.grey;
var textLight = Colors.white;

void main(List<String> args) {
  final store = Store<List<IMenu>>(addMenu, initialState: []);
  runApp(MyApp(title: "ฉ่ำชา @กุดป่อง", store: store));
}

class MyApp extends StatelessWidget {
  final String title;
  final Store<List<IMenu>> store;
  const MyApp({super.key, required this.title, required this.store});

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: MaterialApp(
        title: title,
        debugShowCheckedModeBanner: false,
        theme: themePrimaryData,
        home: const HomeScreen(),
      ),
    );
  }
}
