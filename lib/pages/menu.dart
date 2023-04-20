import 'dart:convert';

import 'package:chumcha/main.dart';
import 'package:flutter/material.dart';
import 'package:chumcha/interfaces/interface_menu.dart';
import 'package:chumcha/json_parse/json_parse_menu.dart';
import 'package:intl/intl.dart';

double widthScreen = 200;

class Menu extends StatefulWidget {
  final List<JsonMenu?>? menu;
  const Menu({super.key, this.menu});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  List<JsonMenu?> tempMenu = [];
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.menu!.length,
      itemBuilder: (context, index) {
        return SizedBox(
            width: double.infinity,
            child: ListTile(
              minLeadingWidth: 100,
              trailing: const Icon(Icons.add),
              title: Text(widget.menu![index]!.name!),
              leading: Image.asset(
                widget.menu![index]!.image!,
                fit: BoxFit.contain,
                alignment: Alignment.center,
              ),
              subtitle: Text(
                  "ราคา: ${NumberFormat("#,###").format(widget.menu![index]!.price!)} บาท"),
              onTap: () => updateMenu(widget.menu![index]!),
            ));
      },
    );
  }

  updateMenu(JsonMenu menu) {
    setState(() {
      tempMenu.add(menu);
    });
  }
}

class InitMenu extends StatelessWidget {
  const InitMenu({super.key});

  @override
  Widget build(BuildContext context) {
    JsonIMenu? dataFromAPI;

    Future<JsonIMenu?> getAPI() async {
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
                            "price":50,
                            "category":"นมเหนียว",
                            "image":"assets/images/2.jpg"
                          }
                      ]
                    }
                ''';

      Map<String, dynamic> map = jsonDecode(data);
      dataFromAPI = JsonIMenu.fromJson(map);
      return dataFromAPI;
    }

    return Row(
      children: [
        Expanded(
            child: FutureBuilder(
          future: getAPI(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              JsonIMenu result = snapshot.data;
              return Menu(
                menu: result.menu,
              );
            }
            return const LinearProgressIndicator();
          },
        )),
        ListMenu(
          order: tempMenu,
        )
      ],
    );
  }
}

class ListMenu extends StatelessWidget {
  final List<JsonMenu?> order;
  const ListMenu({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
      child: Container(
        width: widthScreen,
        decoration: BoxDecoration(color: Colors.grey.shade50, boxShadow: [
          BoxShadow(
              blurRadius: 5,
              spreadRadius: 5,
              color: Colors.grey.withOpacity(0.2))
        ]),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                "รายการ",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              height: 50,
              color: lightGreen,
              width: double.infinity,
            )
          ],
        ),
      ),
    );
  }
}
