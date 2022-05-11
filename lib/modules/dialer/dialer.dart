import 'package:flutter/material.dart';
import 'package:take_it_easy/components/app_button.dart';
import 'package:take_it_easy/style/app_colors.dart';
import 'package:take_it_easy/style/spacing.dart';

class Dialer extends StatelessWidget {
  const Dialer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacing.sizeBoxHt20,
            CircleAvatar(
              radius: 40,
              child: Icon(Icons.people),
            ),
            Spacing.sizeBoxHt20,
            Text('unknown'),
            Spacing.sizeBoxHt20,
            Text("Timer"),
            const Spacer(),
            AppButton(
                shapeBorder: CircleBorder(),
                child: Icon(Icons.call),
                borderRadius: 35,
                color: AppColors.lightRed,
                height: 70.0,
                onPressed: (){},
                width: 70),
            Spacing.sizeBoxHt40,
          ],
        ),
      ),
    );
  }

  Widget _callActivity(BuildContext context) {
    return Card(
      child: Row(
        children: [],
      ),
    );
  }
}
