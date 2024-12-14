import 'package:ecommerce_app/container/banner_container.dart';
import 'package:ecommerce_app/container/category_container.dart';
import 'package:ecommerce_app/container/shimmer_effect.dart';
import 'package:ecommerce_app/container/zone_container.dart';
import 'package:ecommerce_app/controller/db_services.dart';
import 'package:ecommerce_app/modals/categories_model.dart';
import 'package:ecommerce_app/modals/promos_banner_model.dart';
import 'package:flutter/material.dart';

class HomePageMakerContainer extends StatefulWidget {
  const HomePageMakerContainer({super.key});

  @override
  State<HomePageMakerContainer> createState() => _HomePageMakerContainerState();
}

class _HomePageMakerContainerState extends State<HomePageMakerContainer> {
  int min = 0;
  minCalculator(int a, int b) {
    return min = a > b ? b : a;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: DbServices().readCategory(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<CategoriesModel> categories =
                CategoriesModel.fromJsonList(snapshot.data!.docs)
                    as List<CategoriesModel>;
            if (categories.isEmpty) {
              return const SizedBox();
            } else {
              return StreamBuilder(
                  stream: DbServices().readBanners(),
                  builder: (context, bannerSnapshot) {
                    if (bannerSnapshot.hasData) {
                      List<PromosBannerModel> banner =
                          PromosBannerModel.fromJsonList(snapshot.data!.docs)
                              as List<PromosBannerModel>;
                      if (banner.isEmpty) {
                        return SizedBox();
                      } else {
                        return Column(children: [
                          for (int i = 0;
                              i <
                                  minCalculator(
                                    snapshot.data!.docs.length,
                                    bannerSnapshot.data!.docs.length,
                                  );
                              i++)
                            Column(
                              children: [
                                ZoneContainer(
                                    category: snapshot.data!.docs[i]["name"]),
                                BannerContainer(
                                    imageUrl: bannerSnapshot.data!.docs[i]
                                        ["image"],
                                    category: bannerSnapshot.data!.docs[i]
                                        ['category']),
                              ],
                            )
                        ]);
                      }
                    } else {
                      return ShimmerEffect(
                        //TODO  self added this height
                        height: 50,
                      );
                    }
                  });
            }
          } else {
            return ShimmerEffect(
              height: 90,
            );
          }
        });
  }
}
