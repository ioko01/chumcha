import 'package:chumcha/interfaces/interface_menu.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<String> confirmMenu(List<IMenu> tempMenu) async {
  try {
    String url = "http://127.0.0.1:8000/confirm/menu";
    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode(tempMenu),
      headers: {'Content-Type': 'application/json'},
    );
    return response.body;
  } catch (e) {
    return e.toString();
  }
}
