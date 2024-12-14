import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/controller/db_services.dart';
import 'package:ecommerce_app/modals/cart_model.dart';
import 'package:ecommerce_app/modals/products_model.dart';
import 'package:flutter/material.dart';

class CartProvider with ChangeNotifier {
  StreamSubscription<QuerySnapshot>? _cartSubscription;
  StreamSubscription<DocumentSnapshot>? _productSubscription;

  bool isLoading = false;
  List<CartModel> carts = [];
  List<String> cartUids = [];
  List<ProductsModel> products = [];
  int totalCost = 0;
  int totalQuantity = 0;

  CartProvider() {
    readCartData();
  }

  void addToCart(CartModel cartModel) {
    DbServices().addToCart(cartData: cartModel);
    notifyListeners();
  }

  // STREAM AND READ THE CARD DATA
  void readCartData() {
    isLoading = true;
    _cartSubscription?.cancel();
    _cartSubscription = DbServices().readUSerCart().listen((snapshot) {
      List<CartModel> cartsData =
          CartModel.fromJsonList(snapshot.docs) as List<CartModel>;
      carts = cartsData;
      for (int i = 0; i < carts.length; i++) {
        cartUids.add(carts[i].productId);
        debugPrint(" cart Uids : ${cartUids[i]}");
      }
      if (carts.length > 0) {
        readCartProducts(cartUids);
      }
      isLoading = false;
      notifyListeners();
    });
  }

  // READ CART  PRODUCTS
  void readCartProducts(List<String> uids) {
    _productSubscription?.cancel();
    _productSubscription = DbServices().searchProducts(uids).listen((snapshot) {
      List<ProductsModel> productData =
          ProductsModel.fromJsonList(snapshot.docs) as List<ProductsModel>;
      products = productData;
      isLoading = false;
      addCost(products, carts);
      calculateTotalQuantity();
      notifyListeners();
    }) as StreamSubscription<DocumentSnapshot<Object?>>?;
  }

  // ADD COST OF ALL PRODUCTS
  void addCost(List<ProductsModel> products, List<CartModel> carts) {
    totalCost = 0;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (int i = 0; i < carts.length; i++) {
        totalCost += carts[i].quantity * products[i].new_price;
      }
      notifyListeners();
    });
  }

  void calculateTotalQuantity() {
    totalQuantity = 0;
    for (CartModel cart in carts) {
      totalQuantity += cart.quantity;
    }
    debugPrint("total quantity $totalQuantity");
    notifyListeners();
  }

  // DELETE PRODUCT FROM  THE CART
  void deleteItemCart(String productId) {
    DbServices().deleteItemFromCart(productId: productId);

    readCartData();
    notifyListeners();
  }

  // DECREASE THE COUNT OF PRODUCT
  void decreaseCount(String productId) {
    readCartData();
    notifyListeners();
  }
}
