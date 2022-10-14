import 'package:flutter/cupertino.dart';

class Books {
  int? id;
  late String name;
  late String author;
  late String image;

  Books({
    this.id,
    required this.name,
    required this.author,
    required this.image,
  });

  Books.fromMap(Map<String, dynamic> map) {
    if (map['id'] != null) {
      id = map['id'];
    }
    name = map['name'];
    author = map['author'];
    image = map['image'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    if (id != null) {
      map['id'] = id;
    }
    map['name'] = name;
    map['author'] = author;
    map['image'] = image;
    return map;
  }
}
