import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:take_it_easy/modules/feedbacks/controller/feedback_controller.dart';
import 'package:take_it_easy/modules/feedbacks/models/feedbback_item.dart';
import 'package:take_it_easy/modules/feedbacks/widgets/read_report.dart';
import 'package:take_it_easy/navigation/navigation_manager.dart';
import 'package:take_it_easy/utils/string_utils.dart';

class ConversationalFeedback extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedbacks'),
      ),
      body: Consumer<FeedbackController>(
        builder:
            (BuildContext context, FeedbackController controller, Widget? a) {
          if (isNullOrEmptyList(controller.feedbacks))
            return Center(
              child: CircularProgressIndicator(),
            );
          else if (controller.isEmpty) {
            return Center(
              child: Text("Not Data found"),
            );
          }
          return ListView.separated(
            separatorBuilder: (BuildContext context, a) {
              return Container(
                height: 1.0,
                color: Colors.white10,
              );
            },
            itemCount: controller.feedbacks.length,
            itemBuilder: (BuildContext context, int index) {
              final ConversationalList feedback = controller.feedbacks[index];
              return FeedbackTile(feedback: feedback);
            },
          );
        },
      ),
    );
  }
}

class FeedbackTile extends StatelessWidget {
  FeedbackTile({required this.feedback});
  final ConversationalList feedback;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: !isNullOrEmpty(feedback.name)
          ? () {
              NavigationManager.instance.launchDialog(
                widget: ReadReport(
                  text: feedback.comment!,
                ),
              );
            }
          : null,
      leading: isNullOrEmpty(feedback.image)
          ? CircleAvatar()
          : CircleAvatar(
              backgroundImage: AssetImage(feedback.image ?? ''),
            ),
      title: isNullOrEmpty(feedback.name)
          ? Text("Unknow user")
          : Text(feedback.name ?? ''),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              isNullOrEmpty(feedback.name)
                  ? Expanded(
                      child: Text(
                        feedback.name ?? "",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  : Container(),
              Spacer(),
              Icon(Icons.star, color: Colors.amber),
              SizedBox(width: 4),
              Text('${feedback.rating?.toStringAsFixed(1)}'),
            ],
          ),
        ],
      ),
    );
  }
}
