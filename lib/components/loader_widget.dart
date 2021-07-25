import 'package:flutter/material.dart';

class ProgressLoader extends StatelessWidget {
  const ProgressLoader({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
      height: 40.0,
      width: 40.0,
      child: Column(
        children: [CircularProgressIndicator()],
      ),
    ));
  }
}
