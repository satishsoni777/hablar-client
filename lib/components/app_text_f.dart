
import 'package:flutter/material.dart';

class AppTextF extends StatelessWidget {
  const AppTextF({
    super.key,
    required this.controller,
    this.onChanged,
    this.textInputType,
    this.hintText,
  });
  final TextEditingController controller;
  final Function(String)? onChanged;
  final TextInputType? textInputType;
  final String? hintText;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextFormField(
        controller: controller,
        onChanged: onChanged,
        keyboardType: textInputType,
        decoration: InputDecoration(hintText: hintText, border: OutlineInputBorder(), contentPadding: EdgeInsets.only(left: 12, right: 12, top: 10, bottom: 10)),
      ),
    );
  }
}
