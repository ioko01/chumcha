import 'package:chumcha/interfaces/interface_menu.dart';
import 'package:chumcha/utils/device.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<String> confirmMenu(List<IMenu> tempMenu) async {
  try {
    bool mobile = IsDevice().isMobile();
    String port = "http://127.0.0.1:8000";
    String url = (mobile) ? port = "http://10.0.2.2:8000" : port;
    dynamic response = await http.post(
      Uri.parse("$url/confirm/menu"),
      body: jsonEncode(tempMenu),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load data');
    }
  } catch (e) {
    print(e);
    return e.toString();
  }
}
