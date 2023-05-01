import 'dart:convert';

import 'package:chumcha/api/menu.dart';
import 'package:chumcha/main.dart';
import 'package:chumcha/redux/menu_reducers.dart';
import 'package:flutter/material.dart';
import 'package:chumcha/interfaces/interface_menu.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:chumcha/widgets/modal_dialog.dart';
import 'package:chumcha/widgets/modal_listview.dart';
import 'package:chumcha/utils/resize.dart';
import 'package:chumcha/utils/image_data.dart';
import 'dart:typed_data';

double widthScreen = 150;

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FutureBuilder<String>(
          future: getMenu(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              String data = snapshot.data.toString();
              final List<IMenu>? menu;
              if (data.contains("errorMessage")) {
                menu = [];
              } else {
                menu = List.from(json.decode(data))
                    .map((json) => IMenu.fromJson(json))
                    .toList();
              }

              return ListMenu(
                menu: menu,
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

class CheckBoxMenu extends StatefulWidget {
  final List<String>? categories;
  final List<String> filterCategories = [];

  CheckBoxMenu({super.key, this.categories});

  @override
  State<CheckBoxMenu> createState() => _CheckBoxMenuState();
}

class _CheckBoxMenuState extends State<CheckBoxMenu> {
  @override
  Widget build(BuildContext context) {
    int categoryLength = widget.categories?.length ?? 0;
    List<String> listCategories = [];
    List<Widget> listCheckbox = [];

    for (int i = 0; i < categoryLength; i++) {
      if (!listCategories.contains(widget.categories![i])) {
        listCategories.add(widget.categories![i]);
      }
    }
    listCheckbox.add(
      Container(
        padding: const EdgeInsets.all(8),
        width: double.infinity,
        child: const Text(
          "ตัวกรอง",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
    for (int i = 0; i < listCategories.length; i++) {
      listCheckbox.add(
        StoreConnector<AppState, List<String>>(
          converter: (store) => store.state.filterMenu,
          builder: (context, categories) {
            return SizedBox(
              width: 130,
              child: CheckboxMenuButton(
                value: categories.contains(listCategories[i]) ? true : false,
                onChanged: (value) {
                  if (categories.contains(listCategories[i])) {
                    StoreProvider.of<AppState>(context).dispatch(
                        StateActionMenu(categories.indexOf(listCategories[i]),
                            FilterMenuActions.decrement));
                  } else {
                    StoreProvider.of<AppState>(context).dispatch(
                        StateActionMenu(
                            listCategories[i], FilterMenuActions.increment));
                  }
                },
                child: Text(listCategories[i]),
              ),
            );
          },
        ),
      );
    }

    return Wrap(
      alignment: WrapAlignment.center,
      direction: Axis.horizontal,
      children: listCheckbox,
    );
  }
}

class ListMenu extends StatelessWidget {
  final List<IMenu> menu;
  const ListMenu({super.key, required this.menu});

  @override
  Widget build(BuildContext context) {
    if (menu.isEmpty) {
      return Container(
        padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
        width: double.maxFinite,
        child: const Text(
          "ไม่มีข้อมูลหรืออาจมีบางอย่างผิดพลาด กรุณาลองใหม่อีกครั้ง",
          style: TextStyle(color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      );
    } else {
      List<String>? catgories = [];
      for (var val in menu) {
        catgories.add(val.category!);
      }

      List<Widget> iMenuList = [];
      iMenuList.add(CheckBoxMenu(categories: catgories));

      for (var index = 0; index < menu.length; index++) {
        final btnColor = index % 2 == 0 ? Colors.grey.shade100 : Colors.white;
        ResizeImage resizeImage =
            ResizeImage(AssetImage(menu[index].image!), width: 70, height: 70);

        iMenuList.add(
          StoreConnector<AppState, List<String>>(
            converter: (store) => store.state.filterMenu,
            builder: (context, categories) {
              return Visibility(
                visible: categories.isNotEmpty
                    ? categories.contains(menu[index].category)
                        ? true
                        : false
                    : true,
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      ShowGrowDialog(
                          context: context,
                          title: "ยืนยันรายการ",
                          content: ["ต้องการเพิ่มเมนู ", "เพิ่มเมนู"],
                          data: menu[index],
                          action: MenuActions.increment,
                          index: index,
                          color: [textLight, lightGreen]).showModalGrowDialog();
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(btnColor),
                      shape: const MaterialStatePropertyAll(
                        BeveledRectangleBorder(borderRadius: BorderRadius.zero),
                      ),
                      shadowColor:
                          const MaterialStatePropertyAll(Colors.transparent),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image(image: resizeImage),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  menu[index].name!,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                Text(
                                    "ราคา: ${NumberFormat("#,###").format(menu[index].price)} บาท")
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }

      return SingleChildScrollView(
        child: Column(children: iMenuList),
      );
    }
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
