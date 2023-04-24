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
    return AlertDialog(
      title: Text(
        widget.title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      content: RichText(
        text: TextSpan(text: "asd"),
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
                    backgroundColor: getColor(textLight, textLight, textLight),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "asd",
                    style: const TextStyle(fontSize: 17),
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

void showModalListviewDialog(BuildContext context, title, content, data, state,
    int index, List<Color>? color) {
  showGeneralDialog(
    context: context,
    pageBuilder: (context, animation, secondaryAnimation) {
      return Container();
    },
    barrierDismissible: false,
    transitionBuilder: (ctx, animation, secondaryAnimation, child) {
      return Transform.translate(
        offset: Offset(0, -10 * animation.value),
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
