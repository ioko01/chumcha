import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:chumcha/interfaces/interface_menu.dart';
import 'package:chumcha/json_parse/json_parse_menu.dart';
import 'package:intl/intl.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  JsonIMenu? _dataFromAPI;

  @override
  void initState() {
    super.initState();
    getMenu();
  }

  Future<JsonIMenu?> getMenu() async {
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
    _dataFromAPI = JsonIMenu.fromJson(map);
    return _dataFromAPI;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FutureBuilder(
            future: getMenu(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                JsonIMenu result = snapshot.data;
                return ListView.builder(
                  itemCount: result.menu!.length,
                  itemBuilder: (context, index) {
                    return SizedBox(
                      width: double.infinity,
                      child: ListTile(
                        minLeadingWidth: 100,
                        trailing: const Icon(Icons.add),
                        title: Text(result.menu![index]!.name!),
                        leading: Image.asset(
                          result.menu![index]!.image!,
                          fit: BoxFit.contain,
                          alignment: Alignment.center,
                        ),
                        subtitle: Text(
                            "ราคา: ${NumberFormat("#,###").format(result.menu![index]!.price!)} บาท"),
                        onTap: () {},
                      ),
                    );
                  },
                );
              }
              return const LinearProgressIndicator();
            },
          ),
        ),
        Expanded(
            child: Container(
          width: 10,
          color: Colors.red,
        ))
      ],
    );
  }
}
