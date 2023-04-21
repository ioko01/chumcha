import 'dart:convert';

import 'package:chumcha/main.dart';
import 'package:flutter/material.dart';
import 'package:chumcha/json_parse/json_parse_menu.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';

double widthScreen = 150;

List<IMenu> menuReducer(List<IMenu> state, dynamic action) {
  if (action is IMenu?) {
    state.add(action!);
  }
  if (action is int) {
    state.removeAt(action);
  }
  return state;
}

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    ListIMenu? dataFromAPI;

    Future<ListIMenu?> getAPI() async {
      String data = '''
                    {
                      "menu":[
                          {
                            "name":"โกโก้นมเหนียว",
                            "price":50,
                            "category":"นมเหนียว",
                            "image":"assets/images/1.jpg"
                          },
                          {
                            "name":"ชาไทยนมเหนียว",
                            "price":50,
                            "category":"นมเหนียว",
                            "image":"assets/images/2.jpg"
                          }
                      ]
                    }
                ''';

      Map<String, dynamic> map = jsonDecode(data);
      dataFromAPI = ListIMenu.fromJson(map);
      return dataFromAPI;
    }

    return Stack(
      children: [
        FutureBuilder(
          future: getAPI(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              ListIMenu result = snapshot.data;
              return ListMenu(
                menu: result,
              );
            }
            return const LinearProgressIndicator();
          },
        ),
        const TempMenu()
      ],
    );
  }
}

class ListMenu extends StatelessWidget {
  final ListIMenu menu;
  const ListMenu({super.key, required this.menu});

  @override
  Widget build(BuildContext context) {
    List<IMenu?>? listMenu = menu.menu;
    return ListView.builder(
      itemCount: listMenu!.length,
      itemBuilder: (context, index) {
        return StoreConnector<AppState, IMenu?>(
          converter: (store) {
            return listMenu[index];
          },
          builder: (context, IMenu? stateMenu) {
            return SizedBox(
              width: double.infinity,
              child: ListTile(
                minLeadingWidth: 100,
                trailing: const Icon(Icons.add),
                title: Text(listMenu[index]!.name!),
                leading: Image.asset(
                  listMenu[index]!.image!,
                  fit: BoxFit.contain,
                  alignment: Alignment.center,
                ),
                subtitle: Text(
                    "ราคา: ${NumberFormat("#,###").format(listMenu[index]!.price!)} บาท"),
                onTap: () =>
                    StoreProvider.of<AppState>(context).dispatch(stateMenu),
              ),
            );
          },
        );
      },
    );
  }
}

class TempMenu extends StatelessWidget {
  const TempMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, List<IMenu>>(
      converter: (store) {
        return store.state.addMenu;
      },
      builder: (context, List<IMenu> tempMenu) {
        return AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
          width: MediaQuery.of(context).size.width,
          top: tempMenu.isNotEmpty
              ? MediaQuery.of(context).size.height - 350
              : MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Container(
                color: lightGreen,
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                child: const Text(
                  "รายการ",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              Container(
                color: Colors.white,
                height: 200,
                child: ListView.builder(
                  itemCount: tempMenu.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      minLeadingWidth: 100,
                      title: Text(tempMenu[index].name!),
                      subtitle: Text(
                          "ราคา: ${NumberFormat("#,###").format(tempMenu[index].price!)} บาท"),
                      onTap: () =>
                          StoreProvider.of<AppState>(context).dispatch(index),
                    );
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
