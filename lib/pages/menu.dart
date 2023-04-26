import 'dart:convert';

import 'package:chumcha/main.dart';
import 'package:chumcha/redux/menu_reducers.dart';
import 'package:flutter/material.dart';
import 'package:chumcha/interfaces/interface_menu.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:chumcha/widgets/modal_dialog.dart';
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
                            "price":100,
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
                  ShowGrowDialog(
                      context: context,
                      title: "ยืนยันรายการ",
                      content: ["ต้องการเพิ่มเมนู ", "เพิ่มเมนู"],
                      data: listMenu[index],
                      action: MenuActions.increment,
                      index: index,
                      color: [textLight, lightGreen]).showModalGrowDialog();
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
  const TempMenuButton({super.key, required this.tempMenu});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, bool>(
      converter: (store) {
        return store.state.tempMenu;
      },
      builder: (context, isOpenTempMenu) {
        return AnimatedPositioned(
          bottom: tempMenu.isNotEmpty && !isOpenTempMenu ? 20 : -100,
          curve: Curves.easeIn,
          right: 20,
          duration: const Duration(milliseconds: 300),
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
              StoreProvider.of<AppState>(context)
                  .dispatch(StateActionMenu(true, TempMenuActions.open));

              ShowGrowDialogListView(
                context: context,
                title: "รายการที่เลือกไว้",
                content: [],
                data: tempMenu,
                action: TempMenuActions.open,
              ).showModalGrowDialogListView();
            },
          ),
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
        return store.state.menu;
      },
      builder: (context, List<IMenu> tempMenu) {
        return TempMenuButton(tempMenu: tempMenu);
      },
    );
  }
}
