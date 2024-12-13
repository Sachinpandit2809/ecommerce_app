import 'package:ecommerce_app/controller/db_services.dart';
import 'package:ecommerce_app/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthServices {
  // creating new account using eamil  password method

  Future<String> createAccountWithEmail(String name , String email, String password) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword( email: email, password: password);
      await DbServices().saveUserData(name: name, email: email);
      return "Account Created";
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    }
  }

  // login with email    password  method
  Future<String> loginWithEmail(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return "Login Succesful";
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    }
  }

  // LOG OUT user
  Future<void> logOut() async {
    await FirebaseAuth.instance.signOut();
  }

  // reset password
  Future<String> resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return "Mail Sent";
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message.toString());
      Utils.toastErrorMessage(e.message.toString());
      return e.message.toString();
    }
  }

  // check whether the user is sign in or not
  Future<bool> isLoggedIn() async {
    var currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      return true;
    } else {
      return false;
    }
  }
}
