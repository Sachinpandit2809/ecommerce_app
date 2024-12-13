// import 'package:ecommerce_app/controller/auth_services.dart';
import 'package:ecommerce_app/container/category_container.dart';
import 'package:ecommerce_app/container/discount_container.dart';
import 'package:ecommerce_app/container/promo_container.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Customer app"),
        ),
        body: Column(children: [
          PromoContainer(),
          DiscountContainer(),
          CategoryContainer()
        ]));
  }
}
