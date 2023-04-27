import 'package:chumcha/interfaces/interface_menu.dart';
import 'package:chumcha/main.dart';
import 'package:chumcha/redux/menu_reducers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class ModalData extends StatelessWidget {
  final BuildContext context;
  final dynamic title, content, data, state;
  final int index;
  final List<Color>? color;
  const ModalData({
    super.key,
    required this.context,
    required this.title,
    this.content,
    this.data,
    this.state,
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
          state: state,
          index: index,
          color: color,
        );
      },
    );
  }
}

class ShowDialogData extends StatefulWidget {
  final BuildContext context;
  final dynamic title, content, data, state;
  final int? index;
  final List<Color>? color;
  const ShowDialogData({
    super.key,
    required this.context,
    required this.title,
    this.content,
    this.data,
    this.state,
    this.index = 0,
    this.color,
  });

  @override
  State<ShowDialogData> createState() => _ShowDialogDataState();
}

class _ShowDialogDataState extends State<ShowDialogData> {
  @override
  Widget build(BuildContext context) {
    var colorAction = Colors.white;
    if (widget.state == MenuActions.increment) {
      colorAction = lightGreen;
    } else if (widget.state == MenuActions.decrement) {
      colorAction = Colors.red;
    }
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
                    style:
                        TextStyle(color: Colors.black, fontFamily: fontFamily),
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
                        foregroundColor: widget.state == MenuActions.increment
                            ? getColor(colorAction, textLight, textLight)
                            : getColor(textLight, textLight, textLight),
                        backgroundColor: widget.state == MenuActions.increment
                            ? getColor(textLight, colorAction, colorAction)
                            : getColor(colorAction, colorAction, colorAction),
                      ),
                      onPressed: () {
                        switch (widget.state) {
                          case MenuActions.increment:
                            StateActionMenu action =
                                StateActionMenu(data, MenuActions.increment);
                            StoreProvider.of<AppState>(context)
                                .dispatch(action);
                            break;

                          case MenuActions.decrement:
                            if (widget.index == 1) {
                              StateActionMenu action =
                                  StateActionMenu(false, TempMenuActions.close);

                              StoreProvider.of<AppState>(context)
                                  .dispatch(action);

                              action = StateActionMenu(
                                  widget.index, MenuActions.decrement);

                              StoreProvider.of<AppState>(context)
                                  .dispatch(action);
                            } else {
                              StateActionMenu action = StateActionMenu(
                                  widget.index, MenuActions.decrement);

                              StoreProvider.of<AppState>(context)
                                  .dispatch(action);
                            }
                            break;

                          default:
                            StateActionMenu action =
                                StateActionMenu(data, MenuActions.decrement);
                            StoreProvider.of<AppState>(context)
                                .dispatch(action);
                        }
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
                          backgroundColor: getColor(textLight,
                              Colors.grey.shade50, Colors.grey.shade50)),
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

void showModalBottomDialog(BuildContext context, title, content, data, state,
    int index, List<Color>? color) {
  showGeneralDialog(
    context: context,
    pageBuilder: (context, animation, secondaryAnimation) {
      return Container();
    },
    barrierDismissible: false,
    transitionBuilder: (ctx, animation, secondaryAnimation, child) {
      return Transform.translate(
        offset: Offset(0, -animation.value * 20),
        child: ModalData(
          context: ctx,
          title: title,
          content: content,
          data: data,
          state: state,
          index: index,
          color: color,
        ),
      );
    },
  );
}
