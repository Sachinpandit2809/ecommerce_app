import 'package:ecommerce_app/controller/db_services.dart';
import 'package:ecommerce_app/modals/coupon_model.dart';
import 'package:flutter/material.dart';

class DiscountScreen extends StatefulWidget {
  const DiscountScreen({super.key});

  @override
  State<DiscountScreen> createState() => _DiscountScreenState();
}

class _DiscountScreenState extends State<DiscountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Discount"),
      ),
      body: StreamBuilder(
        stream: DbServices().readDiscountCoupons(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<CouponModel> coupons =
                CouponModel.fromJsonList(snapshot.data!.docs)
                    as List<CouponModel>;
            if (coupons.isEmpty) {
              return SizedBox();
            } else {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                    itemCount: coupons.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        tileColor: Colors.amber.withOpacity(0.1),
                        leading:
                            CircleAvatar(child: Icon(Icons.discount_outlined)),
                        title: Text(coupons[index].code),
                        subtitle: Text(coupons[index].desc),
                      );
                    }),
              );
            }
          } else {
            return SizedBox();
          }
        },
      ),
    );
  }
}
