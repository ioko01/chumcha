/* 
// Example Usage
Map<String, dynamic> map = jsonDecode(<myJSONString>);
var myDateNode = Date.fromJson(map);
*/
class IsDate {
  String? createdAt;
  String? updatedAt;

  IsDate({this.createdAt, this.updatedAt});

  IsDate.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
