/* 
// Example Usage
Map<String, dynamic> map = jsonDecode(<myJSONString>);
var myRootNode = Root.fromJson(map);
*/
class JsonMenu {
  String? name;
  String? description;
  int? price;
  String? detail;
  String? category;
  String? image;

  JsonMenu(
      {this.name,
      this.description,
      this.price,
      this.detail,
      this.category,
      this.image});

  JsonMenu.fromJson(Map<String, dynamic> json) {
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

class JsonIMenu {
  List<JsonMenu?>? menu;

  JsonIMenu({this.menu});

  JsonIMenu.fromJson(Map<String, dynamic> json) {
    if (json['menu'] != null) {
      menu = <JsonMenu>[];
      json['menu'].forEach((v) {
        menu!.add(JsonMenu.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['menu'] = menu != null ? menu!.map((v) => v?.toJson()).toList() : null;
    return data;
  }
}
