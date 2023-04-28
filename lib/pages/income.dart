import 'dart:convert';

import 'package:chumcha/api/menu.dart';
import 'package:chumcha/interfaces/interface_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';

class Income extends StatelessWidget {
  const Income({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          child: FutureBuilder<String>(
            future: getConfirmMenu(),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                String data = snapshot.data.toString();
                final List<IMenu>? menu;
                if (data.contains("errorMessage")) {
                  menu = [];
                } else {
                  menu = List.from(json.decode(data))
                      .map((json) => IMenu.fromJson(json))
                      .toList();
                }

                return Wrap(
                  alignment: WrapAlignment.spaceAround,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.all(10),
                      width: 150,
                      color: Colors.amber,
                      child: Column(
                        children: [
                          const Text("บิลที่ขายได้"),
                          Text(NumberFormat("#,###").format(menu.length))
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.all(10),
                      width: 150,
                      color: Colors.amber,
                      child: Column(
                        children: [
                          const Text("รายได้วันนี้"),
                          Text(NumberFormat("#,###").format(menu.length))
                        ],
                      ),
                    ),
                  ],
                );
              }
              return const LinearProgressIndicator();
            },
          ),
        ),
      ],
    );
  }
}
