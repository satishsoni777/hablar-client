import 'package:flutter/material.dart';
import 'package:take_it_easy/navigation/navigation_manager.dart';

class GenderSelection extends StatelessWidget {
  const GenderSelection({super.key});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(0),
      content: SizedBox(
        height: 150,
        child: Column(
          children: [
            TextButton(
              onPressed: () {
                NavigationManager.instance.pop(Gender.m);
              },
              child: Text("Male"),
            ),
            TextButton(
              onPressed: () {
                NavigationManager.instance.pop(Gender.f);
              },
              child: Text("Female"),
            ),
            TextButton(
              onPressed: () {
                NavigationManager.instance.pop(Gender.o);
              },
              child: Text("Other"),
            ),
          ],
        ),
      ),
    );
  }
}

class Gender {
  static final String m = "m";
  static final String f = "f";
  static final String o = "o";
}
