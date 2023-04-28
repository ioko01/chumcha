/* 
// Example Usage
Map<String, dynamic> map = jsonDecode(<myJSONString>);
var myRootNode = ErrorMessage.fromJson(map);
*/
class ErrorMessage {
  String? errorMessage;

  ErrorMessage({this.errorMessage});

  ErrorMessage.fromJson(Map<String, dynamic> json) {
    errorMessage = json['errorMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['errorMessage'] = errorMessage;
    return data;
  }
}
