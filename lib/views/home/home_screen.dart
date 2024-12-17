// import 'package:ecommerce_app/controller/auth_services.dart';
import 'package:ecommerce_app/container/cart_container.dart';
import 'package:ecommerce_app/container/category_container.dart';
import 'package:ecommerce_app/container/discount_container.dart';
import 'package:ecommerce_app/container/home_page_maker_container.dart';
import 'package:ecommerce_app/container/promo_container.dart';
import 'package:ecommerce_app/utils/ext/ext.dart';
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
          title: Text("Shop Now"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            10.heightBox,
            PromoContainer(),
            5.heightBox,
            DiscountContainer(),
            CategoryContainer(),
            HomePageMakerContainer()
          ]),
        ));
  }
}
