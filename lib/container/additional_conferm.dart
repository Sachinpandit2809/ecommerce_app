import 'package:flutter/material.dart';

class AdditionalConferm extends StatefulWidget {
  final String contentText;
  final VoidCallback onYes;
  final VoidCallback onNo;
  const AdditionalConferm(
      {super.key,
      required this.contentText,
      required this.onYes,
      required this.onNo});

  @override
  State<AdditionalConferm> createState() => _AdditionalConfermState();
}

class _AdditionalConfermState extends State<AdditionalConferm> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Are you sure ?"),
      content: Text(widget.contentText),
      actions: [
        TextButton(onPressed: widget.onNo, child: Text("No")),
        TextButton(
            onPressed: widget.onYes,
            child: Text("Yes", style: TextStyle(color: Colors.red)))
      ],
    );
  }
}
