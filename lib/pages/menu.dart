import 'dart:convert';

import 'package:chumcha/main.dart';
import 'package:flutter/material.dart';
import 'package:chumcha/json_parse/json_parse_menu.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';

double widthScreen = 200;

List<IMenu> addMenu(List<IMenu> state, dynamic action) {
  state.add(action);
  return state;
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
        return StoreConnector<List<IMenu>, IMenu?>(
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
                onTap: () {
                  StoreProvider.of<List<IMenu>>(context).dispatch(stateMenu);
                },
              ),
            );
          },
        );
      },
    );
  }
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

    return Row(
      children: [
        Expanded(
          child: FutureBuilder(
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
        ),
        const TempMenu()
      ],
    );
  }
}

class TempMenu extends StatelessWidget {
  const TempMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<List<IMenu>, List<IMenu>>(
      converter: (store) {
        return store.state;
      },
      builder: (context, List<IMenu> tempMenu) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
          child: Container(
            width: tempMenu.isNotEmpty ? widthScreen : 0,
            decoration: BoxDecoration(color: Colors.grey.shade50, boxShadow: [
              BoxShadow(
                  blurRadius: 5,
                  spreadRadius: 5,
                  color: Colors.grey.withOpacity(0.2))
            ]),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    "รายการ",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                    child: ListView.builder(
                  itemCount: tempMenu.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(tempMenu[index].name!),
                      subtitle: Text(
                          "ราคา: ${NumberFormat("#,###").format(tempMenu[index].price!)} บาท"),
                    );
                  },
                )),
                Container(
                  height: 50,
                  color: lightGreen,
                  width: double.infinity,
                  child: Text(""),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
