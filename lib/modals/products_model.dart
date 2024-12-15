import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductsModel {
  String name;
  String description;
  String image;
  int old_price;
  int new_price;
  String category;
  String id;
  int maxQuantity;

  ProductsModel({
    required this.name,
    required this.description,
    required this.image,
    required this.old_price,
    required this.new_price,
    required this.category,
    required this.id,
    required this.maxQuantity,
  });

  // to convert the json to the object model
  factory ProductsModel.toJson(Map<String, dynamic> json, String id) {
    return ProductsModel(
      name: json['name'] ?? "",
      description: json['description'] ?? "no description",
      image: json['image'] ?? "",
      old_price: json['old_price'] ?? 0,
      new_price: json['new_price'] ?? 0,
      category: json['category'] ?? "",
      id: id ?? "",
      maxQuantity: json['maxQuantity'] ?? 0,
    );
  }

  static List<ProductsModel> fromJsonList(List<QueryDocumentSnapshot> list) {
    return list
        .map(
            (e) => ProductsModel.toJson(e.data() as Map<String, dynamic>, e.id))
        .toList();
  }

// this is the chatGpt Code for below lines

  factory ProductsModel.fromJson(Map<String, dynamic> json, String id) {
    return ProductsModel(
      name: json["name"] ?? "",
      description: json["desc"] ?? "no description",
      image: json["image"] ?? "",
      new_price: json["new_price"] ?? 0,
      old_price: json["old_price"] ?? 0,
      category: json["category"] ?? "",
      maxQuantity: json["maxQuantity"] ?? 0,
      id: id ?? "",
    );
  }
  static List<ProductsModel> fromJsonListChatGpt(
      List<QueryDocumentSnapshot> list) {
    return list
        .map((e) =>
            ProductsModel.fromJson(e.data() as Map<String, dynamic>, e.id))
        .toList();
  }
}
