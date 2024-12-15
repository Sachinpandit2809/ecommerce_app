import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/container/cart_container.dart';
import 'package:ecommerce_app/controller/db_services.dart';
import 'package:ecommerce_app/provider/cart_provider.dart';
import 'package:ecommerce_app/utils/ext/ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    );
  }
}
