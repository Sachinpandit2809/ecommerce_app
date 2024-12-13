import 'package:ecommerce_app/container/shimmer_effect.dart';
import 'package:ecommerce_app/controller/db_services.dart';
import 'package:ecommerce_app/modals/categories_model.dart';
import 'package:ecommerce_app/utils/ext/ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class CategoryContainer extends StatefulWidget {
  const CategoryContainer({super.key});

  @override
  State<CategoryContainer> createState() => _CategoryContainerState();
}

class _CategoryContainerState extends State<CategoryContainer> {
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
              return SizedBox();
            } else {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: categories
                      .map((cat) => CategoryButton(
                            image: cat.image,
                            name: cat.name,
                          ))
                      .toList(),
                ),
              );
            }
          } else {
            return ShimmerEffect(
              height: 90,
            );
          }
        });
  }
}

class CategoryButton extends StatelessWidget {
  String image;
  String name;
  CategoryButton({super.key, required this.image, required this.name});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "/specific_products", arguments: {
          "name": name,
        });
      },
      child: Container(
          margin: EdgeInsets.all(4),
          padding: EdgeInsets.all(4),
          height: 95,
          width: 95,
          decoration: BoxDecoration(
            color: Colors.amber.shade100,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.network(
                image,
                // fit: BoxFit.cover,
                height: 50,
              ),
              8.heightBox,
              Text("${name.substring(0, 1).toUpperCase()}${name.substring(1)}")
            ],
          )),
    );
  }
}
