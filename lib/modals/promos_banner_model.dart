import 'package:cloud_firestore/cloud_firestore.dart';

class PromosBannerModel {
  String title;
  String image;
  String category;
  String id;

  PromosBannerModel({
    required this.title,
    required this.image,
    required this.category,
    required this.id,
  });
  // CONVERT TO JSON TO OBJECT MODEL
  factory PromosBannerModel.fromJson(Map<String, dynamic> json, String id) {
    return PromosBannerModel(
      title: json['title']?? "",
      image: json['image']?? "",
      category: json['category']?? "",
      id: id?? "",
    );
  }

  // CONVERT List<QueryDocumnetSnapshot> to List<ProductModel> 
  static List<PromosBannerModel> fromJsonList(
    List<QueryDocumentSnapshot> list) {
      return list.map((e) => PromosBannerModel.fromJson(e.data() as Map<String, dynamic>, e.id)).toList();
    }

}
