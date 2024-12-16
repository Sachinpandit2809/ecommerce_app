import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/constants/payment.dart';
import 'package:ecommerce_app/container/cart_container.dart';
import 'package:ecommerce_app/container/flexible_button.dart';
import 'package:ecommerce_app/controller/db_services.dart';
import 'package:ecommerce_app/provider/cart_provider.dart';
import 'package:ecommerce_app/utils/ext/ext.dart';
import 'package:ecommerce_app/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';

import '../../provider/user_provider.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({super.key});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  TextEditingController _couponController = TextEditingController();
  int discount = 0;
  int toPay = 0;
  String discountText = "";

  discountCalculater(int discountPercent, int totalCost) {
    // discount = 0;
    discount = (discountPercent * totalCost) ~/ 100;
    setState(() {});
  }

  Future<void> initPaymentSheet(int cost) async {
    try {
      final user = Provider.of<UserProvider>(context, listen: false);
      // 1. create payment intent on the server
      final data = await createPaymentIntent(
          name: user.name,
          address: user.address,
          amount: (cost * 100).toString());

      // 2. initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          // Set to true for custom flow
          customFlow: false,
          // Main params
          merchantDisplayName: 'Flutter Stripe Store Demo',
          paymentIntentClientSecret: data['client_secret'],
          // Customer keys
          customerEphemeralKeySecret: data['ephemeralKey'],
          customerId: data['id'],
          // Extra options

          style: ThemeMode.dark,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Checkout"),
        scrolledUnderElevation: 0,
        forceMaterialTransparency: true,
      ),
      body: Consumer<UserProvider>(
          builder: (context, userData, child) => Consumer<CartProvider>(
                builder: (context, cartData, child) {
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Delevery Details",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.65,
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Name - " + userData.name,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Text("Email - " + userData.email),
                                          Text("Phone - " + userData.phone),
                                          Text("Address - " + userData.address),
                                        ]),
                                  ),
                                  Spacer(),
                                  InkWell(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, "/update_profile");
                                      },
                                      child:
                                          CircleAvatar(child: Icon(Icons.edit)))
                                ],
                              )),
                          20.heightBox,
                          Text("Have a coupon? "),
                          Row(
                            children: [
                              SizedBox(
                                width: 200,
                                // child: TextFormField(
                                //   textCapitalization:
                                //       TextCapitalization.characters,
                                //   controller: _couponController,
                                //   decoration: InputDecoration(
                                //     labelText: "Coupon Code",
                                //     hintText: "Enter Coupon Code",
                                //     // border: OutlineInputBorder(
                                //     //   borderRadius: BorderRadius.circular(10),
                                //     // ),
                                //     border: InputBorder.none,
                                //     filled: true,
                                //     fillColor: Colors.grey.shade200,
                                //   ),
                                // ),
                                child: TextFormField(
                                  textCapitalization:
                                      TextCapitalization.characters,
                                  controller: _couponController,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(RegExp(
                                        r'[a-zA-Z0-9]')), // Allow alphanumeric characters
                                    TextInputFormatter.withFunction(
                                      (oldValue, newValue) => TextEditingValue(
                                        text: newValue.text.toUpperCase(),
                                        selection: newValue.selection,
                                      ),
                                    ),
                                  ],
                                  decoration: InputDecoration(
                                    labelText: "Coupon Code",
                                    hintText: "Enter Coupon Code",
                                    border: InputBorder.none,
                                    filled: true,
                                    fillColor: Colors.grey.shade200,
                                  ),
                                ),
                              ),
                              TextButton(
                                  onPressed: () async {
                                    QuerySnapshot querySnapshot =
                                        await DbServices().verifyDiscount(
                                            code: _couponController.text
                                                .toUpperCase());
                                    if (querySnapshot.docs.isNotEmpty) {
                                      QueryDocumentSnapshot doc =
                                          querySnapshot.docs.first;
                                      String code = doc.get('code');
                                      int percent = doc.get('discount');
                                      debugPrint(
                                          "Discount code : ${code},Discount percent : ${percent} ");
                                      discountText =
                                          "A discount of $percent% has been applied.";

                                      discountCalculater(
                                          percent, cartData.totalCost);
                                    } else {
                                      debugPrint("No discount code found");
                                      discountText = "No discount code found";
                                    }
                                    setState(() {});
                                  },
                                  child: Text("Apply"))
                            ],
                          ),
                          8.heightBox,
                          discountText == "" ? SizedBox() : Text(discountText),
                          10.heightBox,
                          Divider(),
                          10.heightBox,
                          Text(
                            "Total Quantity of Products : ${cartData.totalQuantity}",
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            " Sub total : ₹${cartData.totalCost}",
                            style: TextStyle(fontSize: 14),
                          ),
                          Divider(),
                          Text(
                            style: TextStyle(fontSize: 14),
                            "Extra Discount: - ₹$discount",
                          ),
                          Divider(),
                          Text(
                            "Total Payable amount : ₹${cartData.totalCost - discount}",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  );
                },
              )),
      bottomNavigationBar: Container(
        height: 60,
        padding: const EdgeInsets.all(8),
        child: FlexibleButton(
            title: "Procced to Pay",
            onPress: () async {
              final user = Provider.of<UserProvider>(context, listen: false);
              if (user.address == "" ||
                  user.phone == "" ||
                  user.name == "" ||
                  user.email == "") {
                Utils.toastErrorMessage("Please fill your delivery details");
                return;
              }
              await initPaymentSheet(
                  Provider.of<CartProvider>(context, listen: false).totalCost -
                      discount);
              try {
                await Stripe.instance.presentPaymentSheet();
                final cart = Provider.of<CartProvider>(context, listen: false);
                User? currentUser = FirebaseAuth.instance.currentUser;
                List products = [];
                for (int i = 0; i < cart.products.length; i++) {
                  products.add({
                    "id": cart.products[i].id,
                    "name": cart.products[i].name,
                    "image": cart.products[i].image,
                    "single_price": cart.products[i].new_price,
                    "total_price":
                        cart.products[i].new_price * cart.carts[i].quantity,
                    "quantity": cart.carts[i].quantity,
                  });
                }
                // ORDER STATUS
                // PAID - paid money by users
                // SHIPPED - item shipped
                // CANCELLED - item canacelled
                // COMPLETED - order delevered
                Map<String, dynamic> orderData = {
                  "user_id": currentUser!.uid,
                  "name": user.name,
                  "email": user.email,
                  "phone": user.phone,
                  "discount": discount,
                  "address": user.address,
                  "total": cart.totalCost - discount,
                  "products": products,
                  "status": "PAID",
                  "created_at": DateTime.now().millisecondsSinceEpoch
                };

                // creating new Order
                await DbServices().createOrder(data: orderData);
                // reduce the quantity of product on firebaseFirestore
                for (int i = 0; i < cart.products.length; i++) {
                   DbServices().reduceQuantity(
                      productId: cart.products[i].id,
                      quantity: cart.carts[i].quantity);
                }
                //clear  the cart  for the user
                await DbServices().emptyCart();
                

                //  close the check-out screen
                Navigator.pop(context);
                Utils.toastSuccessMessage("Payment Done");
              } catch (e) {
                debugPrint(" --- ---- ---- ---- ----- Payment sheet error " +
                    e.toString());
                debugPrint("  PAYMENT SHEET FAILED");
                Utils.toastErrorMessage("Payment Failed");
              }
            }),
      ),
    );
  }
}
