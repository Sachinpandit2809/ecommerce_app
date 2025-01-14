import 'package:cloud_firestore/cloud_firestore.dart';

class CartModel {
  final String productId;
  int quantity;

  CartModel({required this.productId, required this.quantity});

  // CONVERT JSON TO OBJECT MODEL
  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      productId: json["product_id"] ?? "",
      quantity: json["quantity"] ?? 0,
    );
  }

  // CONVERT List<QueryDocumnetSnapshot> to List<CartModel>
  static List<CartModel> fromJsonList(List<QueryDocumentSnapshot> list) {
    return list
        .map((e) => CartModel.fromJson(e.data() as Map<String, dynamic>))
        .toList();
  }
}
