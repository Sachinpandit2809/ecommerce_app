import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DbServices {
  User? user = FirebaseAuth.instance.currentUser;

  // USER DATA
  // add the user to firestore

  Future saveUserData({required String name, required String email}) async {
    try {
      Map<String, dynamic> data = {
        "name": name,
        "email": email,
      };
      debugPrint("save $data");
      await FirebaseFirestore.instance
          .collection("shop-users")
          .doc(user!.uid)
          .set(data);
    } catch (e) {
      debugPrint("error on save user data" + e.toString());
    }
  }

  // UPDATE OTHER DATA IN DATABASE
  Future updateUserData({required Map<String, dynamic> extraData}) async {
    await FirebaseFirestore.instance
        .collection("shop-users")
        .doc(user!.uid)
        .update(extraData);
  }

  //READ USER CURRENT USER DATA
  Stream<DocumentSnapshot> readUserData() {
    return FirebaseFirestore.instance
        .collection("shop-users")
        .doc(user!.uid)
        .snapshots();
  }

  // READING PROMOS AND BANNERS
  Stream<QuerySnapshot> readPromos() {
    return FirebaseFirestore.instance.collection("shop_promos").snapshots();
  }

  Stream<QuerySnapshot> readBanners() {
    return FirebaseFirestore.instance.collection("shop_banners").snapshots();
  }

  // // // DISCOUNTS
  // READING DISCOUNT COUPONS
  Stream<QuerySnapshot> readDiscountCoupons() {
    return FirebaseFirestore.instance
        .collection("shop_coupons")
        .orderBy("discount", descending: true)
        .snapshots();
  }

  // // // CATEGORIES
  // READING CATEGORIES
  Stream<QuerySnapshot> readCategory() {
    return FirebaseFirestore.instance
        .collection("shop_categories")
        .orderBy("priority", descending: true)
        .snapshots();
  }

  // // // PRODUCTS
  // READING PRODUCTS
  Stream<QuerySnapshot> readProducts(String category ) {
    return FirebaseFirestore.instance
        .collection("shop_products")
        .where("category", isEqualTo: category.toLowerCase())
        .snapshots();
  }
}
