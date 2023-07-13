import 'package:take_it_easy/di/di_initializer.dart';
import 'package:take_it_easy/storage/shared_storage.dart';

import 'package:uuid/uuid.dart';

class Utils {
  Utils._();
  static Future<String> userId() async {
    final String? userId = (await DI.inject<SharedStorage>().getUserData()).uid;
    return userId ?? Uuid().v4();
  }
}
