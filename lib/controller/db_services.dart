import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/modals/cart_model.dart';
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
          .collection("shop_users")
          .doc(user!.uid)
          .set(data);
    } catch (e) {
      debugPrint("error on save user data" + e.toString());
    }
  }

  // UPDATE OTHER DATA IN DATABASE
  Future updateUserData({required Map<String, dynamic> extraData}) async {
    await FirebaseFirestore.instance
        .collection("shop_users")
        .doc(user!.uid)
        .update(extraData);
  }

  //READ USER CURRENT USER DATA
  Stream<DocumentSnapshot> readUserData() {
    return FirebaseFirestore.instance
        .collection("shop_users")
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

  // // // VERYFY THE COUPONS
  Future<QuerySnapshot> verifyDiscount({required String code}) {
    debugPrint(" ................... \n  Searchin For code $code");
    return FirebaseFirestore.instance
        .collection("shop_coupons")
        .where("code", isEqualTo: code)
        .get();
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
  Stream<QuerySnapshot> readProducts(String category) {
    return FirebaseFirestore.instance
        .collection("shop_products")
        .where("category", isEqualTo: category.toLowerCase())
        .snapshots();
  }

  //// SEARCH PRODUCT BY DOC IDS
  Stream<QuerySnapshot> searchProducts(List<String> docIds) {
    return FirebaseFirestore.instance
        .collection("shop_products")
        .where(FieldPath.documentId, whereIn: docIds)
        .snapshots();
  }

  // // // CART
  // DISPLAY THE USER CART
  Stream<QuerySnapshot> readUSerCart() {
    return FirebaseFirestore.instance
        .collection("shop_users")
        .doc(user!.uid)
        .collection("cart")
        .snapshots();
  }

  //ADDING PRODUCT  TO THE CART
  Future addToCart({required CartModel cartData}) async {
    // update the cart data
    try {
      await FirebaseFirestore.instance
          .collection("shop_users")
          .doc(user!.uid)
          .collection("cart")
          .doc(cartData.productId)
          .update({
        "product_id": cartData.productId,
        "quantity": FieldValue.increment(1),
      });
    } on FirebaseException catch (e) {
      debugPrint("...................................");

      debugPrint(e.code.toString());
      if (e.code == "not-found") {
        // set the data
        // insert
        await FirebaseFirestore.instance
            .collection("shop_users")
            .doc(user!.uid)
            .collection("cart")
            .doc(cartData.productId)
            .set({
          "product_id": cartData.productId,
          "quantity": 1,
        });
      }
    }
  }

  // DELETE SPECIFIC PRODUCT FROM CART
  Future deleteItemFromCart({required String productId}) async {
    await FirebaseFirestore.instance
        .collection("shop_users")
        .doc(user!.uid)
        .collection("cart")
        .doc(productId)
        .delete();
  }

  // EMPTY THE CART
  Future emptyCart() async {
    await FirebaseFirestore.instance
        .collection("shop_users")
        .doc(user!.uid)
        .collection("cart")
        .get()
        .then((value) {
      for (DocumentSnapshot doc in value.docs) {
        doc.reference.delete();
      }
    });
  }

  // DECREASING COUNT OF ITEMS
  Future decreaseCount({
    required String productId,
  }) async {
    await FirebaseFirestore.instance
        .collection("shop_users")
        .doc(user!.uid)
        .collection("cart")
        .doc(productId)
        .update({
      "quantity": FieldValue.increment(-1),
    });
  }

////////////////////////////////////////////////////////////////////////////////////////////////
  // ORDERS
  // create a new order
  Future createOrder({required Map<String, dynamic> data}) async {
    await FirebaseFirestore.instance.collection("shop_orders").add(data);
  }

  // update the status of order
  Future updateOrderStatus(
      {required String docId, required Map<String, dynamic> data}) async {
    await FirebaseFirestore.instance
        .collection("shop_orders")
        .doc(docId)
        .update(data);
  }

  // read the order data of specific user
  Stream<QuerySnapshot> readOrders() {
    return FirebaseFirestore.instance
        .collection("shop_orders")
        .where("user_id", isEqualTo: user!.uid)
        .orderBy("created_at", descending: true)
        .snapshots();
  }
}
