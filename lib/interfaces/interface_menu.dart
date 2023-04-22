/* 
// Example Usage
Map<String, dynamic> map = jsonDecode(<myJSONString>);
var myRootNode = Root.fromJson(map);
*/
import 'package:chumcha/redux/menu_reducers.dart';

class IMenu {
  String? name;
  String? description;
  int? price;
  String? detail;
  String? category;
  String? image;

  IMenu(
      {this.name,
      this.description,
      this.price,
      this.detail,
      this.category,
      this.image});

  IMenu.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    price = json['price'];
    detail = json['detail'];
    category = json['category'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['name'] = name;
    data['description'] = description;
    data['price'] = price;
    data['detail'] = detail;
    data['category'] = category;
    data['image'] = image;
    return data;
  }
}

class ListIMenu {
  List<IMenu?>? menu;

  ListIMenu({this.menu});

  ListIMenu.fromJson(Map<String, dynamic> json) {
    if (json['menu'] != null) {
      menu = <IMenu>[];
      json['menu'].forEach((v) {
        menu!.add(IMenu.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['menu'] = menu != null ? menu!.map((v) => v?.toJson()).toList() : null;
    return data;
  }
}

class StateActionMenu extends IMenu {
  dynamic state;
  dynamic action;

  StateActionMenu(this.state, this.action);
}
