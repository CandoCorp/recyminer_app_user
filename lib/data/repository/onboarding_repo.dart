import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:recyminer_app/data/datasource/remote/dio/dio_client.dart';
import 'package:recyminer_app/data/datasource/remote/exception/api_error_handler.dart';
import 'package:recyminer_app/data/model/response/base/api_response.dart';
import 'package:recyminer_app/data/model/response/onboarding_model.dart';
import 'package:recyminer_app/utill/images.dart';

class OnBoardingRepo {
  final DioClient dioClient;

  OnBoardingRepo({@required this.dioClient});

  Future<ApiResponse> getOnBoardingList(BuildContext context) async {
    try {
      List<OnBoardingModel> onBoardingList = [
        OnBoardingModel(Images.on_boarding_1, "Let's recycling",
            "Recycle the things you dont  need"),
        OnBoardingModel(Images.on_boarding_2, "Get points",
            "Upload your invoices to get rewards"),
        OnBoardingModel(Images.on_boarding_3, "Wait for the miner",
            "The miner will be there to recollect the things you dont need"),
      ];

      Response response = Response(
          requestOptions: RequestOptions(path: ''),
          data: onBoardingList,
          statusCode: 200);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
