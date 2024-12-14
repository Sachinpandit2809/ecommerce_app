import 'package:flutter/material.dart';

class BannerContainer extends StatefulWidget {
  final String imageUrl;
  final String category;
  const BannerContainer(
      {super.key, required this.imageUrl, required this.category});

  @override
  State<BannerContainer> createState() => _BannerContainerState();
}

class _BannerContainerState extends State<BannerContainer> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "/specific_products",
            arguments: {"name": widget.category});
      },
      child: Container(
        margin: EdgeInsets.all(3),
        height: 200,
        child: Image.network(widget.imageUrl, fit: BoxFit.cover),
      ),
    );
  }
}
