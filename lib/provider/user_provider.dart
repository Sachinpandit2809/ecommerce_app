import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/controller/db_services.dart';
import 'package:ecommerce_app/modals/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  StreamSubscription<DocumentSnapshot>? _userSubscription;

  String name = "User";
  String email = "";
  String address = "";
  String phone = "";

UserProvider() {
  loadUserProfile();
}
// load user profile data
  Future<void> loadUserProfile() async {
    _userSubscription?.cancel();
    _userSubscription = DbServices().readUserData().listen((snapshot) {
      debugPrint(snapshot.data().toString());

      final UserModel data =
          UserModel.fromJson(snapshot.data() as Map<String, dynamic>);
      name = data.name;
      email = data.email;
      address = data.address;
      phone = data.phone;
      notifyListeners();
    });
  }
}
