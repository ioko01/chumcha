class IMenu {
  String name;
  String? description;
  double price;
  String? detail;
  String category;
  String? image;

  IMenu(
      {required this.name,
      this.description,
      required this.price,
      this.detail,
      required this.category,
      this.image});
}
