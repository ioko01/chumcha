import 'package:chumcha/interfaces/interface_menu.dart';
import 'package:chumcha/pages/menu.dart';
import 'package:chumcha/utils/device.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<String> getMenu() async {
  try {
    bool mobile = IsDevice().isMobile();
    String port = "https://chumcha.netlify.app";
    String url = (mobile) ? port = "https://chumcha.netlify.app" : port;
    http.Response response = await http.get(Uri.parse("$url/get/menu"));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      String err = '''"errorMessage": "Failed to load data"''';
      return jsonEncode(err);
    }
  } catch (e) {
    String err = '''"errorMessage": "$e"''';
    return jsonEncode(err);
  }
}

Future<String> confirmMenu(List<IMenu> tempMenu) async {
  try {
    bool mobile = IsDevice().isMobile();
    String port = "https://chumcha.netlify.app";
    String url = (mobile) ? port = "https://chumcha.netlify.app" : port;
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
    Object err = {"errorMessage": "$e"};
    return jsonEncode(err);
  }
}

Future<String> getConfirmMenu() async {
  try {
    bool mobile = IsDevice().isMobile();
    String port = "https://chumcha.netlify.app";
    String url = (mobile) ? port = "https://chumcha.netlify.app" : port;
    dynamic response = await http.get(Uri.parse("$url/get/confirm/menu"));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load data');
    }
  } catch (e) {
    Object err = {"errorMessage": "$e"};
    return jsonEncode(err);
  }
}
