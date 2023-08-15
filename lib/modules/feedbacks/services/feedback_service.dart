import 'package:take_it_easy/modules/feedbacks/models/feedbback_item.dart';
import 'package:take_it_easy/resources/strings/app_strings.dart';
import 'package:take_it_easy/utils/extensions.dart';
import 'package:take_it_easy/webservice/http_manager/http_manager.dart';

abstract class FeedbackService {
  Future<List<ConversationalList>> getFeedbacks();
  Future<bool> submitFeedback();
}

class FeedbackServiceImpl extends HttpManager implements FeedbackService {
  @override
  Future<List<ConversationalList>> getFeedbacks() async {
    final response =
        await sendRequest(HttpMethod.GET, endPoint: Endpoints.getFeedback);
    if (response.isSuccesFull() && response.data is List<dynamic>) {
      return (response.data as List<dynamic>)
          .map((e) => ConversationalList.fromJson(e))
          .toList();
    } else
      throw response;
  }

  @override
  Future<bool> submitFeedback() async {
    final response =
        await sendRequest(HttpMethod.POST, endPoint: Endpoints.subFeedback);
    if (response.isSuccesFull()) {
      return true;
    } else
      throw response;
  }
}
