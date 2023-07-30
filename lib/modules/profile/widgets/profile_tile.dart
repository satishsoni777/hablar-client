import 'package:flutter/material.dart';

class ProfileTile extends StatelessWidget {
  const ProfileTile({
    Key? key,
    required this.title,
    required this.icon,
    this.onPressed,
    this.leading,
  }) : super(key: key);
  final String title;
  final VoidCallback? onPressed;
  final Widget? leading;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white12),
      ),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(fontSize: 14),
        ),
        leading: Icon(
          icon,
          size: 16,
        ),
        isThreeLine: false,
        onTap: onPressed,
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 14,
        ),
      ),
    );
  }
}
