import 'package:flutter/material.dart';
import 'package:take_it_easy/components/app_button.dart';

class Disclaimer extends StatelessWidget {
  const Disclaimer({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(actions: <Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[Container(), CloseButton()],
      ),
      AppButton(onPressed: () {}),
    ]);
  }
}
