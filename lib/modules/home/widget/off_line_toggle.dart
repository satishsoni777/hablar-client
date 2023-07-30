import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:take_it_easy/modules/home/controller/home_controller.dart';

class OfflineToggle extends StatelessWidget {
  const OfflineToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(
      builder: (BuildContext context, HomeController provider, Widget? c) {
        return Switch(
          onChanged: (bool v) {
            provider.toggleOffOn(v);
          },
          value: provider.isOffline,
        );
      },
    );
  }
}
