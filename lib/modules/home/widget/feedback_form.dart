import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class FeedbackDialog extends StatefulWidget {
  @override
  _FeedbackDialogState createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends State<FeedbackDialog> {
  double _rating = 3.0;
  TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Rate this user'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          RatingBar.builder(
            initialRating: _rating,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (newRating) {
              setState(() {
                _rating = newRating;
              });
            },
          ),
          TextFormField(
            controller: _commentController,
            decoration: InputDecoration(labelText: 'Leave a Comment'),
            maxLines: 3,
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
            // TODO: Process the rating and comment
            print('Rating: $_rating');
            print('Comment: ${_commentController.text}');
          },
          child: Text('Submit'),
        ),
      ],
    );
  }
}