/* 
// Example Usage
Map<String, dynamic> map = jsonDecode(<myJSONString>);
var myRootNode = Root.fromJson(map);
*/
import 'package:chumcha/interfaces/interface_date.dart';
import 'package:chumcha/redux/menu_reducers.dart';
import 'package:intl/intl.dart';

class IMenu extends IsDate {
  String? name;
  List<String>? topping;
  int? price;
  String? detail;
  String? category;
  String? image;

  IMenu(
      {this.name,
      this.topping,
      this.price,
      this.detail,
      this.category,
      this.image});

  IMenu.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    topping = json['topping'];
    price = json['price'];
    detail = json['detail'];
    category = json['category'];
    image = json['image'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['name'] = name;
    data['topping'] = topping;
    data['price'] = price;
    data['detail'] = detail;
    data['category'] = category;
    data['image'] = image;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
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
