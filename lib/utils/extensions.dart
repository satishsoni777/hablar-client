// ignore: import_of_legacy_library_into_null_safe
import 'package:dio/dio.dart';

extension ResponseExtension on Response {
  bool isSuccesFull() {
    return this.statusCode! < 300 && this.statusCode! >= 200;
  }
}
