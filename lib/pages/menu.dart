import 'dart:convert';

import 'package:chumcha/main.dart';
import 'package:chumcha/redux/menu_reducers.dart';
import 'package:flutter/material.dart';
import 'package:chumcha/interfaces/interface_menu.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:chumcha/widgets/modal_center_dialog.dart';
import 'package:chumcha/widgets/modal_listview.dart';

double widthScreen = 150;

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
          builder: (context, IMenu? menu) {
            return SizedBox(
              width: double.infinity,
              child: ListTile(
                minLeadingWidth: 100,
                title: Text(listMenu[index]!.name!),
                leading: Image.asset(
                  listMenu[index]!.image!,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  width: 100,
                ),
                subtitle: Text(
                    "ราคา: ${NumberFormat("#,###").format(listMenu[index]!.price!)} บาท"),
                onTap: () {
                  showModalCenterDialog(
                      context,
                      "ยืนยันรายการ",
                      ["ต้องการเพิ่มเมนู ", "เพิ่มเมนู"],
                      listMenu[index],
                      MenuActions.increment,
                      index,
                      [textLight, lightGreen]);
                },
              ),
            );
          },
        );
      },
    );
  }
}

class TempMenuButton extends StatelessWidget {
  final List<IMenu> tempMenu;
  final bool isOpenTempMenu;
  const TempMenuButton(
      {super.key, required this.tempMenu, required this.isOpenTempMenu});

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      bottom: tempMenu.isNotEmpty && !isOpenTempMenu ? 20 : -100,
      curve: Curves.easeIn,
      duration: const Duration(milliseconds: 300),
      width: MediaQuery.of(context).size.width,
      child: FloatingActionButton(
        backgroundColor: lightGreen,
        foregroundColor: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.local_grocery_store_outlined),
            Text(
              "ตะกร้า",
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            )
          ],
        ),
        onPressed: () {
          // showModalListviewDialog(context, "รายการที่เลือก", [], tempMenu,
          //     TempMenuActions.open, 0, null);

          StateActionMenu action = StateActionMenu(true, TempMenuActions.open);

          StoreProvider.of<AppState>(context).dispatch(action);
        },
      ),
    );
  }
}

class TempMenuList extends StatelessWidget {
  final List<IMenu> tempMenu;
  final bool isOpenTempMenu;
  const TempMenuList(
      {super.key, required this.tempMenu, required this.isOpenTempMenu});

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
      width: MediaQuery.of(context).size.width,
      bottom: tempMenu.isNotEmpty && isOpenTempMenu
          ? 0
          : -MediaQuery.of(context).size.height,
      child: Column(
        children: [
          Container(
            color: lightGreen,
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            child: const Text(
              "รายการที่เลือกไว้",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          SizedBox(
            height: 200,
            child: ListView.builder(
              itemCount: tempMenu.length,
              itemBuilder: (context, index) {
                return ListTile(
                    minLeadingWidth: 100,
                    title: Text(tempMenu[index].name!),
                    subtitle: Text(
                        "ราคา: ${NumberFormat("#,###").format(tempMenu[index].price!)} บาท"),
                    leading: Image.asset(
                      tempMenu[index].image!,
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                      width: 100,
                    ),
                    onTap: () {
                      showModalCenterDialog(
                          context,
                          "ยืนยันรายการ",
                          ["ต้องการลบ ", "ลบเมนู"],
                          tempMenu[index],
                          MenuActions.decrement,
                          index,
                          [textLight, Colors.red]);
                    });
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TempMenu extends StatelessWidget {
  const TempMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, List<IMenu>>(
      converter: (store) {
        return store.state.menu;
      },
      builder: (context, List<IMenu> tempMenu) {
        return StoreConnector<AppState, bool>(
          converter: (store) => store.state.tempMenu,
          builder: (context, isOpenTempMenu) {
            return Stack(
              children: [
                TempMenuList(
                  tempMenu: tempMenu,
                  isOpenTempMenu: isOpenTempMenu,
                ),
                TempMenuButton(
                    tempMenu: tempMenu, isOpenTempMenu: isOpenTempMenu)
              ],
            );
          },
        );
      },
    );
  }
}
