import 'dart:convert';

import 'package:chumcha/api/menu.dart';
import 'package:chumcha/interfaces/interface_menu.dart';
import 'package:chumcha/utils/timestamp.dart';
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
                List<IMenu>? menu;
                if (data.contains("errorMessage")) {
                  menu = [];
                } else {
                  menu = List.from(json.decode(data))
                      .map((json) => IMenu.fromJson(json))
                      .toList();
                }

                List<IMenu>? thisIsBill;
                List<int> thisIsPrice = [];
                List<int> thisIsPriceAll = [];
                for (int i = 0; i < menu.length; i++) {
                  thisIsBill = List.from(json.decode(data)[i]['data'])
                      .map((json) => IMenu.fromJson(json))
                      .toList();

                  String now = DateFormat('yyyy-MM-dd').format(DateTime.now());
                  for (int j = 0; j < thisIsBill.length; j++) {
                    int seconds = json.decode(
                        json.encode(thisIsBill[j].createdAt))['_seconds'];
                    int nanoseconds = json.decode(
                        json.encode(thisIsBill[j].createdAt))['_nanoseconds'];

                    DateTime dateTime =
                        TimeStamp().getTimeStamp(seconds, nanoseconds);
                    String thisDate = DateFormat('yyyy-MM-dd').format(dateTime);

                    if (now.contains(thisDate)) {
                      thisIsPrice.add(thisIsBill[j].price!);
                    }
                    thisIsPriceAll.add(thisIsBill[j].price!);
                  }
                }

                return Wrap(
                  alignment: WrapAlignment.spaceAround,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.all(10),
                      width: double.infinity,
                      color: Colors.amber,
                      child: Column(
                        children: [
                          const Text("รายได้วันนี้"),
                          Text(NumberFormat("#,###").format(
                              thisIsPrice.fold(0, (prev, cur) => prev + cur)))
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.all(10),
                      width: double.infinity,
                      color: Colors.amber,
                      child: Column(
                        children: [
                          const Text("บิลที่ขายได้ทั้งหมด"),
                          Text(NumberFormat("#,###").format(menu.length))
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.all(10),
                      width: double.infinity,
                      color: Colors.amber,
                      child: Column(
                        children: [
                          const Text("รายได้ทั้งหมด"),
                          Text(NumberFormat("#,###").format(thisIsPriceAll.fold(
                              0, (prev, cur) => prev + cur)))
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
