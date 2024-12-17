import 'package:ecommerce_app/container/additional_conferm.dart';
import 'package:ecommerce_app/container/cart_container.dart';
import 'package:ecommerce_app/container/flexible_button.dart';
import 'package:ecommerce_app/controller/db_services.dart';
import 'package:ecommerce_app/modals/orders_model.dart';
import 'package:ecommerce_app/utils/ext/ext.dart';
import 'package:ecommerce_app/utils/utils.dart';
import 'package:flutter/material.dart';

class ViewOrderScreen extends StatefulWidget {
  const ViewOrderScreen({super.key});

  @override
  State<ViewOrderScreen> createState() => _ViewOrderScreenState();
}

class _ViewOrderScreenState extends State<ViewOrderScreen> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as OrdersModel;
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Summery"),
        scrolledUnderElevation: 0,
        // forceMaterialTransparency: true,
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              "Delevery Details",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Order Id - ${args.id}"),
                Text(
                    "Order On - ${DateTime.fromMicrosecondsSinceEpoch(args.created_at).toString()}"),
                Text("Name - ${args.name}"),
                Text("Email - ${args.email}"),
                Text("Phone - ${args.phone}"),
                Text("Address - ${args.address}"),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: args.products
                .map((e) => Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 50,
                                width: 50,
                                child: Image.network(e.image),
                              ),
                              10.widthBox,
                              Expanded(
                                child: Text(e.name),
                              ),
                            ],
                          ),
                          Text(
                            "₹${e.single_price} x ${e.quantity} quantity",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          Text(
                            "₹${e.total_price}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          )
                        ],
                      ),
                    ))
                .toList(),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Discount : ₹${args.discount}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  "Total : ₹${args.total}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                args.status == "CANCELLED"
                    ? Text(
                        "Status : ${args.status}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                          fontSize: 18,
                        ),
                      )
                    : Text(
                        "Status : ${args.status}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
              ],
            ),
          ),
          10.heightBox,
          args.status == "PAID" || args.status == "ON_THE_WAY"
              ? Center(
                  child: FlexibleButton(
                      height: 45,
                      width: 200,
                      title: "Modify Order",
                      onPress: () {
                        showDialog(
                            context: context,
                            builder: (context) => ModifyOrder(
                                  order: args,
                                ));
                      }),
                )
              : SizedBox(),
        ]),
      )),
    );
  }
}

class ModifyOrder extends StatefulWidget {
  final OrdersModel order;
  const ModifyOrder({super.key, required this.order});

  @override
  State<ModifyOrder> createState() => _ModifyOrderState();
}

class _ModifyOrderState extends State<ModifyOrder> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Modify this order"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Chosse want you want to do"),
          TextButton(
              onPressed: () {
                Navigator.pop(context);
                showDialog(
                    context: context,
                    builder: (context) => AdditionalConferm(
                        contentText:
                            "After canceling this cannot be changed you need to order again.",
                        onYes: () async {
                          await DbServices().updateOrderStatus(
                              docId: widget.order.id,
                              data: {"status": "CANCELLED"});
                          Utils.toastSuccessMessage(
                              "Order updated and cancelled");
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        onNo: () {
                          Navigator.pop(context);
                        }));
              },
              child: Center(
                  child: Container(
                      height: 35,
                      width: 140,
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10)),
                      child: const Center(
                          child: Text(
                        "Cancel Order",
                        style: TextStyle(color: Colors.white),
                      )))))
        ],
      ),
    );
  }
}
