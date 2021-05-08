import 'package:flutter/material.dart';
import 'package:take_it_easy/enums/widget_enum.dart';

class AppPadding extends StatelessWidget {
  const AppPadding({this.bodyPadding=BodyPadding.LeftRight, this.child});
  final Widget child;
  final BodyPadding bodyPadding;

  EdgeInsets get _getPadding {
    switch (bodyPadding) {
      case BodyPadding.LeftRight:
        return const EdgeInsets.only(left: 16, right: 16);
      case BodyPadding.TopBotton:
        return const EdgeInsets.only(top: 16, bottom: 16);
      case BodyPadding.All:
        return const EdgeInsets.all(16);
      default:
        return const EdgeInsets.all(4);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: _getPadding,
      child: child,
    );
  }
}
