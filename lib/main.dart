import 'package:chumcha/interfaces/interface_menu.dart';
import 'package:chumcha/redux/menu_reducers.dart';
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
String fontFamily = "FC Minimal";

// Define your State
class AppState {
  List<IMenu> menu;
  bool tempMenu;
  List<String> filterMenu;

  AppState(this.menu, this.tempMenu, this.filterMenu);
}

AppState appReducer(AppState state, action) => AppState(
    menuReducer(state.menu, action),
    tempMenuReducer(state.tempMenu, action),
    filterMenuReducer(state.filterMenu, action));

void main(List<String> args) {
  final store =
      Store<AppState>(appReducer, initialState: AppState([], false, []));
  runApp(MyApp(title: "ฉ่ำชา @กุดป่อง", store: store));
}

class MyApp extends StatelessWidget {
  final String title;
  final Store<AppState> store;
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
