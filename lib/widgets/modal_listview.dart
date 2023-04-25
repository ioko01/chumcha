import 'package:chumcha/interfaces/interface_menu.dart';
import 'package:chumcha/main.dart';
import 'package:chumcha/redux/menu_reducers.dart';
import 'package:chumcha/widgets/modal_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';

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
    return AlertDialog(
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: data.length,
          itemBuilder: (context, index) {
            return SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Image.asset(
                        data[index].image,
                        fit: BoxFit.cover,
                        width: 60,
                      ),
                      Text(
                        data[index].name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 14),
                      ),
                      Text(
                        "ราคา: ${NumberFormat("#,###").format(data[index].price)} บาท",
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                        iconSize: const MaterialStatePropertyAll(20),
                        backgroundColor:
                            const MaterialStatePropertyAll(Colors.transparent),
                        foregroundColor: getColor(Colors.red.shade300,
                            Colors.red.shade500, Colors.red.shade600),
                        shadowColor:
                            const MaterialStatePropertyAll(Colors.transparent),
                        overlayColor:
                            const MaterialStatePropertyAll(Colors.transparent)),
                    onPressed: () {
                      ShowGrowDialog(
                          context: context,
                          title: "ยืนยันรายการ",
                          content: ["ต้องการลบ ", "ลบเมนู"],
                          data: data[index],
                          action: MenuActions.decrement,
                          index: index,
                          color: [textLight, Colors.red]).showModalGrowDialog();
                    },
                    child: const Icon(Icons.delete),
                  )
                ],
              ),
            );
          },
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