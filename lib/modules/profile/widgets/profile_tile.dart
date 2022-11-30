import 'dart:ffi';

import 'package:flutter/material.dart';

class ProfileTile extends StatelessWidget {
  const ProfileTile({ Key? key, required this.title,this.onPressed,
  this.leading,
   }) : super(key: key);
  final Widget title;
  final VoidCallback ?onPressed;
  final Widget ?leading;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(border: Border.all(
        color: Colors.white12
      )),
      child: ListTile(
        title: title,
        leading: leading,
        onTap: onPressed,
        trailing:Icon(Icons.arrow_forward_ios)
      ),
    );
  }
}