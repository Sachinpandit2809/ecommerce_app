import 'package:flutter/material.dart';

// ignore: must_be_immutable
class FlexibleButton extends StatefulWidget {
  String title;
  VoidCallback onPress;
  bool loading;
  double height, width;
  Color textColor;
  Color btnColor;

  FlexibleButton(
      {super.key,
      this.height = 50,
      this.width = 180,
      this.textColor = Colors.white,
      this.btnColor = Colors.amber,
      required this.title,
      this.loading = false,
      required this.onPress});

  @override
  State<FlexibleButton> createState() => _FlexibleButtonState();
}

class _FlexibleButtonState extends State<FlexibleButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPress,
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          // border: Border.all(color: AppColors.white, width: 2),
          borderRadius: BorderRadius.circular(16),
          color: widget.btnColor,
        ),
        child: Center(
            child: widget.loading
                ? const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                    strokeCap: StrokeCap.square,
                  )
                : Text(
                    widget.title,
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  )),
      ),
    );
  }
}
