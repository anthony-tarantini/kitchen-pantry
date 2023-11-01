class Item {
  late int? id;
  late String name;
  late String? image;
  List<String> categories = List.empty();

  Item({this.id, required this.name, this.image});

  Item.withCategories({this.id, required this.name, this.image, required this.categories});

  Item.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    categories = json['categories'];
  }

  String toJson(){
    return '{"name": "$name", "image": "$image", "categories": [${categories.map((e) => '"$e"').join(", ")}]}';
  }
}
