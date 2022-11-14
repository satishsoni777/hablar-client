import 'package:dio/dio.dart';

extension ResponseExtension on Response {
  bool isSuccesFull() {
    return this.statusCode < 300 && this.statusCode >= 200;
  }
}
