import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerEffect extends StatefulWidget {
  double height;
  ShimmerEffect({super.key, this.height = 300});

  @override
  State<ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<ShimmerEffect> {
  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: Container(
        height: widget.height,
        width: double.infinity,
      ),
      gradient: LinearGradient(colors: [Colors.grey.shade400, Colors.white]),
    );
  }
}
