import 'package:flutter/material.dart';
import 'package:take_it_easy/modules/feedbacks/models/feedbback_item.dart';
import 'package:take_it_easy/modules/feedbacks/services/feedback_service.dart';
import 'package:take_it_easy/navigation/navigation_manager.dart';
import 'package:take_it_easy/utils/string_utils.dart';

class FeedbackController extends ChangeNotifier {
  FeedbackController(this.feedbackService);
  final FeedbackService feedbackService;
  List<ConversationalList> _feedbacks = <ConversationalList>[];
  bool isEmpty = false;

  Future<void> getFeedback() async {
    try {
      final List<ConversationalList> res = await feedbackService.getFeedbacks();
      if (!isNullOrEmptyList(res))
        _feedbacks.addAll(res);
      else {
        isEmpty = true;
      }
    } catch (e) {
      NavigationManager.instance.showToast();
    }
    notifyListeners();
  }

  List<ConversationalList> get feedbacks => _feedbacks;
}
