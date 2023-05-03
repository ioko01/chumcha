import 'package:chumcha/interfaces/interface_menu.dart';
import 'package:chumcha/main.dart';
import 'package:chumcha/redux/menu_reducers.dart';
import 'package:chumcha/widgets/modal_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

List<String>? selectTopping = [];

class ModalData extends StatelessWidget {
  final BuildContext context;
  final String title;
  final dynamic content, data, action;
  final int index;
  final int? length;
  final List<Color>? color;
  const ModalData({
    super.key,
    required this.context,
    required this.title,
    this.content,
    this.data,
    this.action,
    this.index = 0,
    this.length = 0,
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
          length: length,
          color: color,
        );
      },
    );
  }
}

class CheckBoxMenu extends StatefulWidget {
  final String topping;
  const CheckBoxMenu({super.key, required this.topping});

  @override
  State<CheckBoxMenu> createState() => _CheckBoxMenuState();
}

class _CheckBoxMenuState extends State<CheckBoxMenu> {
  bool isChecked = false;
  @override
  void initState() {
    super.initState();
    setState(() {
      selectTopping!.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CheckboxMenuButton(
      value: isChecked,
      onChanged: (value) {
        setState(() {
          if (selectTopping!.contains(widget.topping)) {
            int index = selectTopping!.indexOf(widget.topping);
            selectTopping?.removeAt(index);
          } else {
            selectTopping?.add(widget.topping);
          }
          isChecked = value!;
        });
      },
      child: Row(
        children: [Text(widget.topping), const Text("5 บาท")],
      ),
    );
  }
}

class ShowDialogData extends StatelessWidget {
  final BuildContext context;
  final String title;
  final dynamic content, data, action;
  final int? index;
  final int? length;
  final List<Color>? color;
  const ShowDialogData({
    super.key,
    required this.context,
    required this.title,
    this.content,
    this.data,
    this.action,
    this.index = 0,
    this.length = 0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> topping = [];
    List<String>? listTopping = [];

    for (var val in content) {
      topping.add(CheckBoxMenu(topping: val));
    }

    var colorAction = Colors.white;
    if (action == MenuActions.increment) {
      colorAction = lightGreen;
    } else if (action == MenuActions.decrement) {
      colorAction = Colors.red;
    }
    return AlertDialog(
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Column(
        children: topping,
      ),
      actions: <Widget>[
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: ElevatedButton(
                  style: ButtonStyle(
                    foregroundColor: action == MenuActions.increment
                        ? getColor(colorAction, textLight, textLight)
                        : getColor(textLight, textLight, textLight),
                    backgroundColor: action == MenuActions.increment
                        ? getColor(textLight, colorAction, colorAction)
                        : getColor(colorAction, colorAction, colorAction),
                  ),
                  onPressed: () {
                    data.topping = listTopping;
                    print(data);
                    Navigator.of(context).pop();
                    ShowGrowDialog(
                        context: context,
                        title: "ยืนยันรายการ",
                        content: ["ต้องการเพิ่ม ", "ยืนยัน"],
                        data: data,
                        action: MenuActions.increment,
                        index: index,
                        color: [textLight, lightGreen]).showModalGrowDialog();
                  },
                  child: const Text(
                    "ยืนยัน",
                    style: TextStyle(fontSize: 17),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ButtonStyle(
                      foregroundColor:
                          getColor(Colors.red, textLight, textLight),
                      backgroundColor: getColor(
                          textLight, Colors.grey.shade50, Colors.grey.shade50)),
                  child: const Text(
                    "ยกเลิก",
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
}

class ShowToppingDialog {
  final BuildContext context;
  final String title;
  final dynamic content, data, action;
  final int? index;
  final int? length;
  final List<Color>? color;
  const ShowToppingDialog({
    required this.context,
    required this.title,
    this.content,
    this.data,
    this.action,
    this.index = 0,
    this.length = 0,
    this.color,
  });

  showModalToppingDialog() {
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
            length: length,
            color: color,
          ),
        );
      },
    );
  }
}
