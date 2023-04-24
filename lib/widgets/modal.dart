import 'package:chumcha/interfaces/interface_menu.dart';
import 'package:chumcha/main.dart';
import 'package:chumcha/redux/menu_reducers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class ModalData extends StatelessWidget {
  final BuildContext context;
  final dynamic title, content, data;
  const ModalData(
      {super.key,
      required this.context,
      required this.title,
      this.content,
      this.data});

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
        );
      },
    );
  }
}

class ShowDialogData extends StatefulWidget {
  final BuildContext context;
  final dynamic title, content, data;
  const ShowDialogData(
      {super.key,
      required this.context,
      required this.title,
      this.content,
      this.data});

  @override
  State<ShowDialogData> createState() => _ShowDialogDataState();
}

class _ShowDialogDataState extends State<ShowDialogData> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, dynamic>(
      converter: (store) {
        return widget.data;
      },
      builder: (context, dynamic data) {
        return AlertDialog(
          title: Text(
            widget.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: RichText(
            text: widget.content[0].isNotEmpty
                ? TextSpan(
                    text: widget.content[0],
                    style: const TextStyle(
                        color: Colors.black, fontFamily: "FC Minimal"),
                    children: [
                        TextSpan(
                          text: '"${data!.name}"',
                          style: TextStyle(color: lightGreen),
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
                        foregroundColor:
                            getColor(lightGreen, textLight, textLight),
                        backgroundColor:
                            getColor(textLight, lightGreen, lightGreen),
                      ),
                      onPressed: () {
                        StateActionMenu action =
                            StateActionMenu(data, MenuActions.increment);
                        StoreProvider.of<AppState>(context).dispatch(action);
                        Navigator.of(context).pop();
                      },
                      child: widget.content[1].isNotEmpty
                          ? Text(
                              widget.content[1],
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
                        Navigator.of(context).pop();
                      },
                      style: ButtonStyle(
                          foregroundColor:
                              getColor(Colors.red, textLight, textLight),
                          backgroundColor:
                              getColor(textLight, Colors.red, Colors.red)),
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
      },
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

void showModalCenterDialog(context, title, content, data) {
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
        ),
      );
    },
  );
}
