import 'package:ecommerce_app/provider/cart_provider.dart';
import 'package:ecommerce_app/views/cart/cart_screen.dart';
import 'package:ecommerce_app/views/home/home_screen.dart';
import 'package:ecommerce_app/views/orders/orders_screen.dart';
import 'package:ecommerce_app/views/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeNav extends StatefulWidget {
  const HomeNav({super.key});

  @override
  State<HomeNav> createState() => _HomeNavState();
}

class _HomeNavState extends State<HomeNav> {
  int selectedIndex = 0;
  List pages = [HomeScreen(), OrdersScreen(), CartScreen(), ProfileScreen()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.amber,
          unselectedItemColor: Colors.grey,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          currentIndex: selectedIndex,
          onTap: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.local_shipping_outlined), label: "Order"),
            BottomNavigationBarItem(
                icon: Consumer<CartProvider>(builder: (context, value, _) {
                  if (value.carts.length > 0) {
                    return Badge(
                      backgroundColor: Colors.green,
                      label: Text(value.carts.length.toString()),
                      child: Icon(Icons.shopping_cart_rounded),
                    );
                  }
                  return Icon(Icons.shopping_cart_rounded);
                }),
                label: "Cart"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          ]),
    );
  }
}
