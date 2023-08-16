import 'package:flutter/material.dart';

class ReadReport extends StatelessWidget {
  const ReadReport({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text(text),
    );
  }
}
