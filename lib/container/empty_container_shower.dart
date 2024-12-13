import 'package:ecommerce_app/utils/ext/ext.dart';
import 'package:flutter/material.dart';

class EmptyContainerShower extends StatelessWidget {
  const EmptyContainerShower({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          150.heightBox,
          Image.asset(
            "assets/images/empty_box.png",
            height: 150,
          ),
          Text("No data is Found"),
        ],
      ),
    );
    ;
  }
}
