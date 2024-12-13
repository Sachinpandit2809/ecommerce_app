import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecommerce_app/controller/db_services.dart';
import 'package:ecommerce_app/modals/promos_banner_model.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PromoContainer extends StatefulWidget {
  const PromoContainer({super.key});

  @override
  State<PromoContainer> createState() => _PromoContainerState();
}

class _PromoContainerState extends State<PromoContainer> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: DbServices().readPromos(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<PromosBannerModel> promos =
                PromosBannerModel.fromJsonList(snapshot.data!.docs);
            if (promos.isEmpty) {
              return SizedBox();
            } else {
              return CarouselSlider(
                items: promos
                    .map((promo) => Image.network(
                                              promo.image,
                                              fit: BoxFit.cover,
                                            ))
                    .toList(),
                options: CarouselOptions(
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 3),
                    aspectRatio: 16 / 8,
                    enlargeCenterPage: true,
                    scrollDirection: Axis.horizontal),
              );
            }
          } else {
            return Shimmer(
              child: Container(
                height: 300,
                width: double.infinity,
              ),
              gradient:
                  LinearGradient(colors: [Colors.grey.shade400, Colors.white]),
            );
          }
        });
  }
}
