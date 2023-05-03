/* 
// Example Usage
Map<String, dynamic> map = jsonDecode(<myJSONString>);
var myRootNode = Root.fromJson(map);
*/
import 'package:chumcha/interfaces/interface_date.dart';
import 'package:chumcha/redux/menu_reducers.dart';
import 'package:intl/intl.dart';

class ITopping extends IsDate {
  String? name;
  int? price;
  String? image;

  ITopping({this.name, this.price, this.image});

  ITopping.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    price = json['price'];
    image = json['image'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['name'] = name;
    data['price'] = price;
    data['image'] = image;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class ListITopping {
  List<ITopping?>? topping;

  ListITopping({this.topping});

  ListITopping.fromJson(Map<String, dynamic> json) {
    if (json['menu'] != null) {
      topping = <ITopping>[];
      json['menu'].forEach((v) {
        topping!.add(ITopping.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['menu'] =
        topping != null ? topping!.map((v) => v?.toJson()).toList() : null;
    return data;
  }
}

class StateActionTopping extends ITopping {
  dynamic state;
  dynamic action;

  StateActionTopping(this.state, this.action);
}
