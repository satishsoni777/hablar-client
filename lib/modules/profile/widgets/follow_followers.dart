import 'package:flutter/material.dart';
import 'package:take_it_easy/style/theme/app_theme.dart';

class FollowFollowers extends StatelessWidget {
  const FollowFollowers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.only(top: 4, bottom: 4, left: 20, right: 20),
            decoration:
                BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: AppColors.border)),
            child: Column(
              children: [
                Text(
                  "345",
                  style: TextStyle(fontSize: 12),
                ),
                Text(
                  "Followers",
                  style: TextStyle(fontSize: 12),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 4, bottom: 4, left: 20, right: 20),
            decoration:
                BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: AppColors.border)),
            child: Column(
              children: [
                Text(
                  "345",
                  style: TextStyle(fontSize: 12),
                ),
                Text(
                  "Following",
                  style: TextStyle(fontSize: 12),
                )
              ],
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * .05,
          ),
        ],
      ),
    );
  }
}
