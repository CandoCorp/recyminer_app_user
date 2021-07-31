import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:recyminer_app/data/datasource/remote/dio/dio_client.dart';
import 'package:recyminer_app/data/datasource/remote/exception/api_error_handler.dart';
import 'package:recyminer_app/data/model/body/review_body.dart';
import 'package:recyminer_app/data/model/response/base/api_response.dart';
import 'package:recyminer_app/utill/app_constants.dart';

class ProductDetailsRepo {
  final DioClient dioClient;

  ProductDetailsRepo({@required this.dioClient});

  Future<ApiResponse> getProduct(String productID) async {
    try {
      final response =
          await dioClient.get(AppConstants.PRODUCT_DETAILS_URI + productID);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<http.StreamedResponse> submitReview(
      ReviewBody reviewBody, File file, String token) async {
    http.MultipartRequest request = http.MultipartRequest('POST',
        Uri.parse('${AppConstants.BASE_URL}${AppConstants.SUBMIT_REVIEW_URI}'));
    request.headers.addAll(<String, String>{'Authorization': 'Bearer $token'});
    if (file != null) {
      request.files.add(http.MultipartFile(
          'fileUpload[0]', file.readAsBytes().asStream(), file.lengthSync(),
          filename: file.path.split('/').last));
    }
    request.fields.addAll(<String, String>{
      'product_id': reviewBody.productId,
      'comment': reviewBody.comment,
      'rating': reviewBody.rating
    });
    http.StreamedResponse response = await request.send();
    print(response.reasonPhrase);
    return response;
  }
}
