import 'package:ecommerce_app/container/cart_container.dart';
import 'package:ecommerce_app/container/empty_container_shower.dart';
import 'package:ecommerce_app/container/flexible_button.dart';
import 'package:ecommerce_app/provider/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        forceMaterialTransparency: true,
        title: const Text(
          "Your Cart",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 26),
        ),
      ),
      body: Consumer<CartProvider>(
        builder: (context, value, child) {
          if (value.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (value.carts.isEmpty) {
              // return EmptyContainerShower(
              //   title: "NO Items in Cart",
              // );
              return const Center(
                child: Text("No Items in Cart"),
              );
            } else {
              if (value.products.isNotEmpty) {
                return ListView.builder(
                    itemCount: value.carts.length,
                    itemBuilder: (context, index) {
                      return CartContainer(
                          image: value.products[index].image,
                          name: value.products[index].name,
                          productId: value.products[index].id,
                          new_price: value.products[index].new_price,
                          old_price: value.products[index].old_price,
                          maxQuantity: value.products[index].maxQuantity,
                          selectedQuantity: value.carts[index].quantity);
                    });
              } else {
                return Center(
                  child: Text("No Items in Cart"),
                );
              }
            }
          }
        },
      ),
      bottomNavigationBar:
          Consumer<CartProvider>(builder: (context, value, child) {
        if (value.carts.length == 0) {
          return SizedBox();
        } else {
          return Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total : ₹${value.totalCost}",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                FlexibleButton(
                    title: "Proced to Checkout",
                    height: 40,
                    width: 200,
                    onPress: () {})
              ],
            ),
          );
        }
      }),
    );
  }
}
