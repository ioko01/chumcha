import 'dart:convert';

import 'package:chumcha/api/menu.dart';
import 'package:chumcha/interfaces/interface_menu.dart';
import 'package:chumcha/main.dart';
import 'package:chumcha/redux/menu_reducers.dart';
import 'package:chumcha/widgets/modal_dialog.dart';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:chumcha/interfaces/interface_error.dart';

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

class ShowDialogData extends StatefulWidget {
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
  State<ShowDialogData> createState() => _ShowDialogDataState();
}

class _ShowDialogDataState extends State<ShowDialogData> {
  bool isSaveBill = false;
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    Map<String, Map<String, int>> countMap =
        HashMap<String, Map<String, int>>();

    for (int i = 0; i < widget.data.length; i++) {
      countMap.addAll({
        widget.data[i].name!: {
          "price": widget.data[i].price!,
          "amount":
              (countMap[widget.data[i].name]?.values.elementAt(1) ?? 0) + 1,
          "index": i
        }
      });
    }

    return AlertDialog(
      title: Text(
        widget.title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
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
                              shape: MaterialStatePropertyAll(
                                CircleBorder(
                                  side: BorderSide(color: Colors.black),
                                ),
                              ),
                              iconSize: MaterialStatePropertyAll(20),
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.white),
                              foregroundColor:
                                  MaterialStatePropertyAll(Colors.black),
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
                                        data: widget.data[countMap.values
                                            .elementAt(index)
                                            .values
                                            .elementAt(2)],
                                        action: MenuActions.decrement,
                                        index: countMap.values
                                            .elementAt(index)
                                            .values
                                            .elementAt(2),
                                        length: widget.data.length,
                                        color: [Colors.red, textLight])
                                    .showModalGrowDialog();
                              } else {
                                StoreProvider.of<AppState>(context).dispatch(
                                  StateActionMenu(
                                      countMap.values
                                          .elementAt(index)
                                          .values
                                          .elementAt(2),
                                      MenuActions.decrement),
                                );
                              }
                            },
                            child: const Icon(Icons.remove),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                            child: Text(
                              "${countMap.values.elementAt(index).values.elementAt(1)}",
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          ElevatedButton(
                            style: const ButtonStyle(
                              shape: MaterialStatePropertyAll(
                                CircleBorder(
                                  side: BorderSide(color: Colors.black),
                                ),
                              ),
                              iconSize: MaterialStatePropertyAll(20),
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.white),
                              foregroundColor:
                                  MaterialStatePropertyAll(Colors.black),
                            ),
                            onPressed: () {
                              ShowGrowDialog(
                                  context: context,
                                  title: "ยืนยันรายการ",
                                  content: ["ต้องการเพิ่มเมนู ", "เพิ่มเมนู"],
                                  data: widget.data[countMap.values
                                      .elementAt(index)
                                      .values
                                      .elementAt(2)],
                                  action: MenuActions.increment,
                                  index: countMap.values
                                      .elementAt(index)
                                      .values
                                      .elementAt(2),
                                  color: [
                                    textLight,
                                    lightGreen
                                  ]).showModalGrowDialog();
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
                          color: Colors.black.withOpacity(0.1),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
      actions: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
              child: StoreConnector<AppState, List<IMenu>>(
                converter: (store) => store.state.menu,
                builder: (context, tempMenu) {
                  List<int> price = [];
                  for (int i = 0; i < tempMenu.length; i++) {
                    price.add(tempMenu[i].price!);
                  }

                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      "รวม ${NumberFormat("#,###").format(price.fold(0, (prev, cur) => prev + cur))} บาท",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  );
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: StoreConnector<AppState, List<IMenu>>(
                    converter: (store) => store.state.menu,
                    builder: (context, tempMenu) {
                      return Padding(
                        padding: const EdgeInsets.all(4),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            foregroundColor:
                                getColor(textLight, textLight, textLight),
                            backgroundColor: !isSaveBill
                                ? MaterialStatePropertyAll(lightGreen)
                                : MaterialStatePropertyAll(
                                    Colors.grey.withOpacity(0.5),
                                  ),
                            shadowColor: const MaterialStatePropertyAll(
                                Colors.transparent),
                          ),
                          onPressed: () {
                            errorMessage = "";
                            setState(
                              () {
                                isSaveBill = true;
                              },
                            );
                            if (isSaveBill) {
                              confirmMenu(tempMenu).then(
                                (value) {
                                  if (value.contains("errorMessage")) {
                                    Map<String, dynamic> map =
                                        jsonDecode(value);
                                    var myErrorMessageNode =
                                        ErrorMessage.fromJson(map);
                                    if (myErrorMessageNode.errorMessage != "") {
                                      setState(() {
                                        errorMessage =
                                            myErrorMessageNode.errorMessage;
                                      });
                                    }
                                  } else {
                                    StateActionMenu action =
                                        StateActionMenu([], MenuActions.reset);
                                    StoreProvider.of<AppState>(context)
                                        .dispatch(action);
                                    Navigator.of(context).pop();
                                  }

                                  setState(() {
                                    isSaveBill = false;
                                  });
                                },
                              );
                            }
                          },
                          child: !isSaveBill
                              ? const Text("บันทึกรายการ")
                              : SizedBox(
                                  width: 10,
                                  height: 10,
                                  child: CircularProgressIndicator(
                                    color: textLight,
                                    strokeWidth: 2,
                                  ),
                                ),
                        ),
                      );
                    },
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
                        backgroundColor: getColor(textLight,
                            Colors.grey.shade50, Colors.grey.shade50),
                      ),
                      child: const Text(
                        "ปิด",
                        style: TextStyle(fontSize: 17),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Text(
              errorMessage ?? "",
              style: const TextStyle(color: Colors.red),
            )
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
