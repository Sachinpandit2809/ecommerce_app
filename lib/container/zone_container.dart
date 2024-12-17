import 'dart:math';

import 'package:ecommerce_app/container/category_container.dart';
import 'package:ecommerce_app/container/empty_container_shower.dart';
import 'package:ecommerce_app/container/shimmer_effect.dart';
import 'package:ecommerce_app/controller/db_services.dart';
import 'package:ecommerce_app/modals/products_model.dart';
import 'package:ecommerce_app/utils/discount_calculater.dart';
import 'package:ecommerce_app/utils/ext/ext.dart';
import 'package:ecommerce_app/views/products/specific_products.dart';
import 'package:ecommerce_app/views/products/view_product_screen.dart';
import 'package:flutter/material.dart';

class ZoneContainer extends StatefulWidget {
  String category;
  ZoneContainer({super.key, required this.category});

  @override
  State<ZoneContainer> createState() => _ZoneContainerState();
}

class _ZoneContainerState extends State<ZoneContainer> {
  Widget specialQuote({required int price, required int dis}) {
    int random = Random().nextInt(2);

    List<String> quotes = ["Starting at ₹$price", "Get upto $dis% off"];

    return Text(
      quotes[random],
      style: TextStyle(color: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: DbServices().readProducts(widget.category),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<ProductsModel> products =
                ProductsModel.fromJsonList(snapshot.data!.docs)
                    as List<ProductsModel>;
            if (products.isEmpty) {
              // return EmptyContainerShower(
              //   title: "No Products Found",
              // );
              return const SizedBox();
            } else {
              return Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                              "${widget.category.substring(0, 1).toUpperCase() + widget.category.substring(1)} "),
                          Spacer(),
                          IconButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, '/specific_products',
                                    arguments: {'name': widget.category});
                              },
                              icon: const Icon(
                                Icons.chevron_right,
                                size: 30,
                                color: Colors.green,
                              ))
                        ],
                      ),
                      // show maximum 4 products
                      Wrap(
                        spacing: 4,
                        children: [
                          for (int i = 0;
                              i < (products.length > 4 ? 4 : products.length);
                              i++)
                            GestureDetector(
                              onTap: () {
                                // Navigator.pushNamed(context, "/view_products",
                                //     arguments: products[i]);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ViewProductScreen(
                                              product: products[i],
                                            )));
                              },
                              child: Container(
                                height: 170,
                                width: MediaQuery.sizeOf(context).width * .41,
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(14)),
                                margin: const EdgeInsets.all(5),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Center(
                                          child: Image.network(
                                        products[i].image,
                                        height: 80,
                                      )),
                                      8.heightBox,
                                      Text(
                                        products[i].name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      specialQuote(
                                          price: products[i].new_price,
                                          dis: int.parse(discountPercent(
                                              products[i].old_price,
                                              products[i].new_price))),
                                    ]),
                              ),
                            )
                        ],
                      ),
                    ],
                  ));
            }
          } else {
            return ShimmerEffect();
          }
        });
  }
}

// import 'dart:math';

// import 'package:ecommerce_app/controller/db_services.dart';
// import 'package:ecommerce_app/modals/products_model.dart';
// import 'package:ecommerce_app/utils/discount_calculater.dart';
// import 'package:flutter/material.dart';
// import 'package:shimmer/shimmer.dart';

// class ZoneContainer extends StatefulWidget {
//   final String category;
//   const ZoneContainer({super.key, required this.category});

//   @override
//   State<ZoneContainer> createState() => _ZoneContainerState();
// }

// class _ZoneContainerState extends State<ZoneContainer> {
//   Widget specialQuote({required int price, required int dis}) {
//     int random = Random().nextInt(2);

//     List<String> quotes = ["Starting at ₹$price", "Get upto $dis% off"];

//     return Text(
//       quotes[random],
//       style: TextStyle(color: Colors.green),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//         stream: DbServices().readProducts(widget.category),
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             List<ProductsModel> products =
//                 ProductsModel.fromJsonList(snapshot.data!.docs)
//                     as List<ProductsModel>;
//             if (products.isEmpty) {
//               return Center(
//                 child: Text("No Products Found"),
//               );
//             } else {
//               return Container(
//                 margin: EdgeInsets.all(4),
//                 padding: EdgeInsets.symmetric(horizontal: 10),
//                 color: Colors.green.shade50,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 8, vertical: 4),
//                       child: Row(
//                         children: [
//                           Text(
//                             "${widget.category.substring(0, 1).toUpperCase() + widget.category.substring(1)}",
//                             style: TextStyle(
//                                 fontSize: 20, fontWeight: FontWeight.w500),
//                           ),
//                           Spacer(),
//                           IconButton(
//                               onPressed: () {
//                                 Navigator.pushNamed(context, "/specific",
//                                     arguments: {
//                                       "name": widget.category,
//                                     });
//                               },
//                               icon: Icon(Icons.chevron_right))
//                         ],
//                       ),
//                     ),
//                     // show max 4 products
//                     Wrap(
//                       spacing: 4,
//                       children: [
//                         for (int i = 0;
//                             i < (products.length > 4 ? 4 : products.length);
//                             i++)
//                           GestureDetector(
//                             onTap: () {
//                               Navigator.pushNamed(context, "/view_product",
//                                   arguments: products[i]);
//                             },
//                             child: Container(
//                               width: MediaQuery.sizeOf(context).width * .43,
//                               padding: EdgeInsets.all(8),
//                               color: Colors.white,
//                               height: 180,
//                               margin: const EdgeInsets.all(5),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Center(
//                                       child: Image.network(
//                                     products[i].image,
//                                     height: 120,
//                                   )),
//                                   Text(
//                                     products[i].name,
//                                     maxLines: 1,
//                                     overflow: TextOverflow.ellipsis,
//                                     style: TextStyle(
//                                         fontSize: 15,
//                                         fontWeight: FontWeight.w500),
//                                   ),
//                                   specialQuote(
//                                       price: products[i].new_price,
//                                       dis: int.parse(discountPercent(
//                                           products[i].old_price,
//                                           products[i].new_price)))
//                                 ],
//                               ),
//                             ),
//                           )
//                       ],
//                     )
//                   ],
//                 ),
//               );
//             }
//           } else {
//             return Shimmer(
//               child: Container(
//                 height: 400,
//                 width: double.infinity,
//                 color: Colors.white,
//               ),
//               gradient:
//                   LinearGradient(colors: [Colors.grey.shade200, Colors.white]),
//             );
//           }
//         });
//   }
// }
