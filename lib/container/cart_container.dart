import 'package:ecommerce_app/container/category_container.dart';
import 'package:ecommerce_app/modals/cart_model.dart';
import 'package:ecommerce_app/provider/cart_provider.dart';
import 'package:ecommerce_app/utils/discount_calculater.dart';
import 'package:ecommerce_app/utils/ext/ext.dart';
import 'package:ecommerce_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartContainer extends StatefulWidget {
  final String image, name, productId;
  int new_price, old_price, maxQuantity, selectedQuantity;

  CartContainer(
      {super.key,
      required this.image,
      required this.name,
      required this.productId,
      required this.new_price,
      required this.old_price,
      required this.maxQuantity,
      required this.selectedQuantity});

  @override
  State<CartContainer> createState() => _CartContainerState();
}

class _CartContainerState extends State<CartContainer> {
  int count = 1;
  increaseCount(int max) async {
    if (count >= max) {
      Utils.toastErrorMessage("Maximum quantity reached");
      return;
    } else {
      Provider.of<CartProvider>(context, listen: false)
          .addToCart(CartModel(productId: widget.productId, quantity: count));
      setState(() {
        count++;
      });
    }
  }

  decreaseCount() async {
    if (count > 1) {
      Provider.of<CartProvider>(context, listen: false)
          .decreaseCount(widget.productId);
      setState(() {
        count--;
      });
    }
  }

  @override
  void initState() {
    count = widget.selectedQuantity;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    height: 80, width: 80, child: Image.network(widget.image)),
                10.widthBox,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)),
                      5.heightBox,
                      Row(
                        children: [
                          2.widthBox,
                          Text(
                            "${widget.old_price}",
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                decoration: TextDecoration.lineThrough),
                          ),
                          8.widthBox,
                          Text(
                            "₹${widget.new_price}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          8.widthBox,
                          const Icon(
                            Icons.arrow_downward_sharp,
                            color: Colors.green,
                            size: 20,
                          ),
                          Text(
                            "₹${discountPercent(widget.old_price, widget.new_price)}%",
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.green),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                InkWell(
                    onTap: () {
                      Provider.of<CartProvider>(context, listen: false)
                          .deleteItemCart(widget.productId);
                    },
                    child: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ))
              ],
            ),
            10.heightBox,
            Row(
              children: [
                const Text(
                  "Quantity:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                8.widthBox,
                // increment button
                GestureDetector(
                  onTap: () {
                    debugPrint(
                        "maximum product -> " + widget.maxQuantity.toString());
                    debugPrint("count of cart product " + count.toString());
                    increaseCount(widget.maxQuantity);
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.amber.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.add),
                  ),
                ),
                8.widthBox,
                // quantity text
                Text("${widget.selectedQuantity}"),
                8.widthBox,
                // decrement button
                GestureDetector(
                  onTap: () {
                    decreaseCount();
                    setState(() {});
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.amber.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.remove),
                  ),
                ),
                Spacer(),
                Text("Total"),
                8.widthBox,
                Text(
                  "₹${widget.new_price * count}",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
