import 'package:flutter/material.dart';

extension Ext on num {
  SizedBox get heightBox => SizedBox(height: toDouble());
  SizedBox get widthBox => SizedBox(width: toDouble());
}

extension medExt on BuildContext {
  double get mediaHeight => MediaQuery.of(this).size.height;
  double get mediaWidth => MediaQuery.of(this).size.width;
}
