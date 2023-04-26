import 'package:chumcha/interfaces/interface_menu.dart';
import 'package:chumcha/main.dart';
import 'package:chumcha/redux/menu_reducers.dart';
import 'package:chumcha/widgets/modal_dialog.dart';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

class ModalData extends StatelessWidget {
  final BuildContext context;
  final String title;
  final dynamic content, data, action;
  final int index;
  final List<Color>? color;
  const ModalData({
    super.key,
    required this.context,
    required this.title,
    this.content,
    this.data,
    this.action,
    this.index = 0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, dynamic>(
      converter: (store) {
        return data;
      },
      builder: (context, dynamic data) {
        return ShowDialogData(
          context: context,
          title: title,
          content: content,
          data: data,
          action: action,
          index: index,
          color: color,
        );
      },
    );
  }
}

class MenuAmount extends IMenu {
  int? amount;
}

class ShowDialogData extends StatelessWidget {
  final BuildContext context;
  final String title;
  final dynamic content, data, action;
  final int? index;
  final List<Color>? color;
  const ShowDialogData({
    super.key,
    required this.context,
    required this.title,
    this.content,
    this.data,
    this.action,
    this.index = 0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    Map<String, Map<String, int>> countMap =
        HashMap<String, Map<String, int>>();

    for (int i = 0; i < data.length; i++) {
      countMap.addAll({
        data[i].name!: {
          "price": data[i].price!,
          "amount": (countMap[data[i].name]?.values.elementAt(1) ?? 0) + 1,
          "index": i
        }
      });
    }

    return AlertDialog(
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: countMap.length,
              itemBuilder: (context, index) {
                return SizedBox(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                countMap.keys.elementAt(index),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "ราคา: ${countMap.values.elementAt(index).values.elementAt(0)} บาท",
                                textAlign: TextAlign.start,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                style: const ButtonStyle(
                                  shape: MaterialStatePropertyAll(CircleBorder(
                                      side: BorderSide(color: Colors.black))),
                                  padding: MaterialStatePropertyAll(
                                      EdgeInsets.all(10)),
                                  iconSize: MaterialStatePropertyAll(25),
                                  backgroundColor: MaterialStatePropertyAll(
                                      Colors.transparent),
                                  foregroundColor:
                                      MaterialStatePropertyAll(Colors.black),
                                  shadowColor: MaterialStatePropertyAll(
                                      Colors.transparent),
                                ),
                                onPressed: () {
                                  if (countMap.values
                                          .elementAt(index)
                                          .values
                                          .elementAt(1) ==
                                      1) {
                                    ShowGrowDialog(
                                        context: context,
                                        title: "ยืนยันรายการ",
                                        content: ["ต้องการลบเมนู ", "ลบเมนู"],
                                        data: data[countMap.values
                                            .elementAt(index)
                                            .values
                                            .elementAt(2)],
                                        action: MenuActions.decrement,
                                        index: countMap.values
                                            .elementAt(index)
                                            .values
                                            .elementAt(2),
                                        length: data.length,
                                        color: [
                                          Colors.red,
                                          textLight
                                        ]).showModalGrowDialog();
                                  } else {
                                    StoreProvider.of<AppState>(context)
                                        .dispatch(StateActionMenu(
                                            countMap.values
                                                .elementAt(index)
                                                .values
                                                .elementAt(2),
                                            MenuActions.decrement));
                                  }
                                },
                                child: const Icon(Icons.remove),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 16, 0, 16),
                                child: Text(
                                  "${countMap.values.elementAt(index).values.elementAt(1)}",
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              ElevatedButton(
                                style: const ButtonStyle(
                                  shape: MaterialStatePropertyAll(CircleBorder(
                                      side: BorderSide(color: Colors.black))),
                                  padding: MaterialStatePropertyAll(
                                      EdgeInsets.all(10)),
                                  iconSize: MaterialStatePropertyAll(25),
                                  backgroundColor: MaterialStatePropertyAll(
                                      Colors.transparent),
                                  foregroundColor:
                                      MaterialStatePropertyAll(Colors.black),
                                  shadowColor: MaterialStatePropertyAll(
                                      Colors.transparent),
                                ),
                                onPressed: () {
                                  ShowGrowDialog(
                                          context: context,
                                          title: "ยืนยันรายการ",
                                          content: [
                                            "ต้องการเพิ่มเมนู ",
                                            "เพิ่มเมนู"
                                          ],
                                          data: data[countMap.values
                                              .elementAt(index)
                                              .values
                                              .elementAt(2)],
                                          action: MenuActions.increment,
                                          index: countMap.values
                                              .elementAt(index)
                                              .values
                                              .elementAt(2),
                                          color: [textLight, lightGreen])
                                      .showModalGrowDialog();
                                },
                                child: const Icon(Icons.add),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: Colors.black.withOpacity(0.1)))),
                      )
                    ],
                  ),
                );
              },
            ),
            Text(
              "รวม",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            )
          ],
        ),
      ),
      actions: <Widget>[
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: ElevatedButton(
                  style: ButtonStyle(
                    foregroundColor: getColor(textLight, textLight, textLight),
                    backgroundColor:
                        getColor(lightGreen, lightGreen, lightGreen),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("บันทึกรายการ"),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: ElevatedButton(
                  onPressed: () {
                    StateActionMenu action =
                        StateActionMenu(false, TempMenuActions.close);

                    StoreProvider.of<AppState>(context).dispatch(action);
                    Navigator.of(context).pop();
                  },
                  style: ButtonStyle(
                      foregroundColor:
                          getColor(Colors.red, textLight, textLight),
                      backgroundColor: getColor(
                          textLight, Colors.grey.shade50, Colors.grey.shade50)),
                  child: const Text(
                    "ปิด",
                    style: TextStyle(fontSize: 17),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  MaterialStateProperty<Color> getColor(
      Color color, Color colorHovered, Color colorPressed) {
    Color getColor(Set<MaterialState> state) {
      if (state.contains(MaterialState.pressed)) {
        return colorPressed;
      } else if (state.contains(MaterialState.hovered)) {
        return colorHovered;
      } else {
        return color;
      }
    }

    return MaterialStateProperty.resolveWith(getColor);
  }

  MaterialStateProperty<TextStyle> getText(
      TextStyle text, TextStyle textHovered, TextStyle textPressed) {
    TextStyle getText(Set<MaterialState> state) {
      if (state.contains(MaterialState.pressed)) {
        return textPressed;
      } else if (state.contains(MaterialState.hovered)) {
        return textHovered;
      } else {
        return text;
      }
    }

    return MaterialStateProperty.resolveWith(getText);
  }
}

class ShowGrowDialogListView {
  final BuildContext context;
  final String title;
  final dynamic content, data, action;
  final int? index;
  final List<Color>? color;
  const ShowGrowDialogListView({
    required this.context,
    required this.title,
    this.content,
    this.data,
    this.action,
    this.index = 0,
    this.color,
  });

  showModalGrowDialogListView() {
    showGeneralDialog(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) {
        return Container();
      },
      barrierDismissible: false,
      transitionBuilder: (ctx, animation, secondaryAnimation, child) {
        return Transform.scale(
          scale: animation.value,
          child: ModalData(
            context: ctx,
            title: title,
            content: content,
            data: data,
            action: action,
            index: index!,
            color: color,
          ),
        );
      },
    );
  }
}
