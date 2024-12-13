import 'package:ecommerce_app/controller/auth_services.dart';
import 'package:flutter/material.dart';

class CheckUserLogInOrNot extends StatefulWidget {
  const CheckUserLogInOrNot({super.key});

  @override
  State<CheckUserLogInOrNot> createState() => _CheckUserLogInOrNotState();
}

class _CheckUserLogInOrNotState extends State<CheckUserLogInOrNot> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AuthServices().isLoggedIn().then((onValue) => {
          if (onValue)
            {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/home_nav', (route) => false)
            }
          else
            {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/login', (route) => false)
            }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
