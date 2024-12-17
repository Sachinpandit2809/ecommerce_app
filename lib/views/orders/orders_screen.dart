import 'package:ecommerce_app/container/empty_container_shower.dart';
import 'package:ecommerce_app/controller/db_services.dart';
import 'package:ecommerce_app/modals/orders_model.dart';
import 'package:flutter/material.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  totalQuantityCalculator(List<OrderProductModel> products) {
    int qty = 0;
    products.map((e) => qty += e.quantity).toList();
    return qty;
  }

  Widget statusIcon(String status) {
    if (status == "PAID") {
      return statusContainer(
          text: "PAID", bgColor: Colors.lightGreen, textColor: Colors.white);
    }
    if (status == "ON_THE_WAY") {
      return statusContainer(
          text: "ON_THE_WAY", bgColor: Colors.yellow, textColor: Colors.black);
    }
    if (status == "DELIVERED") {
      return statusContainer(
          text: "DELEVERED", bgColor: Colors.green, textColor: Colors.white);
    } else {
      return statusContainer(
          text: "CANCELLED", bgColor: Colors.red, textColor: Colors.white);
    }
  }

  Widget statusContainer({
    required String text,
    required Color bgColor,
    required Color textColor,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      child: Text(
        text,
        style: TextStyle(
            color: textColor, fontWeight: FontWeight.bold, fontSize: 12),
      ),
      color: bgColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Orders"),
        // backgroundColor: Colors.amber,
        scrolledUnderElevation: 0,
        // forceMaterialTransparency: true,
      ),
      body: StreamBuilder(
          stream: DbServices().readOrders(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<OrdersModel> orders =
                  OrdersModel.fromJsonList(snapshot.data!.docs)
                      as List<OrdersModel>;
              if (orders.isEmpty) {
                return EmptyContainerShower(
                  title: "No Orders Found",
                );
              } else {
                return ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Container(
                          height: 50,
                          width: 50,
                          child:
                              Image.network(orders[index].products[0].image)),
                      onTap: () {
                        Navigator.pushNamed(context, "/view_order",
                            arguments: orders[index]);
                      },
                      title: Text(
                          "${totalQuantityCalculator(orders[index].products)} Items Worth ₹${orders[index].total}"),
                      subtitle: Text(
                          "Ordered on ${DateTime.fromMicrosecondsSinceEpoch(orders[index].created_at)}"),
                      trailing: statusIcon(orders[index].status),
                    );
                  },
                );
              }
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
