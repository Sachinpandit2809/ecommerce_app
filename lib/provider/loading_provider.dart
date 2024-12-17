import 'package:flutter/material.dart';

class LoadingProvider with ChangeNotifier {
 bool _loginLoading = false;
  bool get loginLoading => _loginLoading;
  void setLoginLoading(bool load) {
    _loginLoading = load;
    notifyListeners();
  }
  bool _signInLoading = false;
  bool get signInLoading => _signInLoading;
  void setSignInLoading(bool load) {
    _signInLoading = load;
    notifyListeners();
  }
}
