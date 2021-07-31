import 'package:flutter/material.dart';
import 'package:recyminer_app/data/datasource/remote/dio/dio_client.dart';
import 'package:recyminer_app/data/datasource/remote/exception/api_error_handler.dart';
import 'package:recyminer_app/data/model/response/base/api_response.dart';
import 'package:recyminer_app/utill/app_constants.dart';

class StatisticsRepo {
  final DioClient dioClient;

  StatisticsRepo({@required this.dioClient});

  Future<ApiResponse> getStatistics() async {
    try {
      final response = await dioClient.get('${AppConstants.STATISTICS}');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
