import 'package:flutter/material.dart';

class EndCallDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('End Call'),
      content: Text('Are you sure you want to end the call?'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(true); // Close the dialog
            // Perform the action to end the call here
          },
          child: Text('End Call'),
        ),
      ],
    );
  }
}
