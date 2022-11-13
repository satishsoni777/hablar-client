import 'package:flutter/material.dart';

class AppTxtFld extends StatelessWidget {
  const AppTxtFld({this.key,this.controller, this.hintText});
  final TextEditingController?controller;
  final String ?hintText;
  final Key? key;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: key,
      child: TextFormField(
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              15,
            ),
          ),
          prefixIcon: Icon(Icons.laptop),
          hintText: hintText ?? 'Channel Name',
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'required field';
          } else {
            return null;
          }
        },
        controller: controller,
      ),
    );
  }
}
