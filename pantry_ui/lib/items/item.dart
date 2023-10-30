class Item {
  late int? id;
  late String name;
  late String? image;
  List<String> tags = List.empty();

  Item({this.id, required this.name, this.image});

  Item.withTags({this.id, required this.name, this.image, required this.tags});
}
