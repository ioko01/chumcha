import 'package:chumcha/interfaces/interface_menu.dart';
import 'package:chumcha/main.dart';
import 'package:chumcha/redux/menu_reducers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

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
      content: RichText(
        text: content[0].isNotEmpty
            ? TextSpan(
                text: content[0],
                style: const TextStyle(
                    color: Colors.black, fontFamily: "FC Minimal"),
                children: [
                    TextSpan(
                      text: '"${data!.name}"',
                      style: TextStyle(color: colorAction),
                    ),
                    const TextSpan(text: " หรือไม่?")
                  ])
            : const TextSpan(text: ""),
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
                    switch (action) {
                      case MenuActions.increment:
                        StoreProvider.of<AppState>(context).dispatch(
                            StateActionMenu(data, MenuActions.increment));

                        StoreProvider.of<AppState>(context).dispatch(
                            StateActionMenu(false, TempMenuActions.close));
                        break;

                      case MenuActions.decrement:
                        if (length == 1) {
                          StoreProvider.of<AppState>(context).dispatch(
                              StateActionMenu(false, TempMenuActions.close));

                          StoreProvider.of<AppState>(context).dispatch(
                              StateActionMenu(index, MenuActions.decrement));
                          Navigator.of(context).pop();
                        } else {
                          StoreProvider.of<AppState>(context).dispatch(
                              StateActionMenu(true, TempMenuActions.open));

                          StoreProvider.of<AppState>(context).dispatch(
                              StateActionMenu(index, MenuActions.decrement));
                        }
                        break;

                      default:
                        StoreProvider.of<AppState>(context).dispatch(
                            StateActionMenu(data, MenuActions.decrement));
                    }
                    Navigator.of(context).pop();
                  },
                  child: content[1].isNotEmpty
                      ? Text(
                          content[1],
                          style: const TextStyle(fontSize: 17),
                        )
                      : const Text(""),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: ElevatedButton(
                  onPressed: () {
                    if (action == MenuActions.increment) {
                      StateActionMenu action =
                          StateActionMenu(false, TempMenuActions.close);
                      StoreProvider.of<AppState>(context).dispatch(action);
                    }
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

class ShowGrowDialog {
  final BuildContext context;
  final String title;
  final dynamic content, data, action;
  final int? index;
  final int? length;
  final List<Color>? color;
  const ShowGrowDialog({
    required this.context,
    required this.title,
    this.content,
    this.data,
    this.action,
    this.index = 0,
    this.length = 0,
    this.color,
  });

  showModalGrowDialog() {
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
