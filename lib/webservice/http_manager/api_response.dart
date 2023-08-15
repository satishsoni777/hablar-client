import 'package:dio/dio.dart';

class ApiResponse {
  ApiResponse(this.response,
      {this.error = false, this.data, this.statusCode = 200, this.success=true});
  factory ApiResponse.response(final Response<dynamic> response) {
    return ApiResponse(
      response,
      data: response.data,
      statusCode: response.statusCode,
    );
  }
  final Response<dynamic> response;
  final bool error;
  final bool success;
  final dynamic? data;
  final int? statusCode;
}
