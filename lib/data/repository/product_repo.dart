import 'package:flutter/material.dart';
import 'package:recyminer_app/data/datasource/remote/dio/dio_client.dart';
import 'package:recyminer_app/data/datasource/remote/exception/api_error_handler.dart';
import 'package:recyminer_app/data/model/response/base/api_response.dart';
import 'package:recyminer_app/data/model/response/product_model.dart';
import 'package:recyminer_app/localization/language_constrants.dart';
import 'package:recyminer_app/utill/app_constants.dart';

class ProductRepo {
  final DioClient dioClient;

  ProductRepo({@required this.dioClient});

  Future<ApiResponse> getPopularProductList(String offset) async {
    try {
      final response = await dioClient
          .get('${AppConstants.POPULAR_PRODUCT_URI}?limit=10&&offset=$offset');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getDailyItemList() async {
    try {
      final response = await dioClient.get(AppConstants.DAILY_ITEM_URI);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getProductDetails(String productID) async {
    try {
      final response =
          await dioClient.get('${AppConstants.PRODUCT_DETAILS_URI}$productID');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> searchProduct(String productId) async {
    try {
      final response =
          await dioClient.get('${AppConstants.SEARCH_PRODUCT_URI}$productId');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getBrandOrCategoryProductList(String id) async {
    try {
      String uri = '${AppConstants.CATEGORY_PRODUCT_URI}$id';

      final response = await dioClient.get(uri);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> addProduct(Product productBody) async {
    try {
      var data = productBody.toApi();
      final response = await dioClient.post(AppConstants.CREATE_PRODUCT,
          data: productBody.toApi());
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  List<String> getAllUnitType({BuildContext context}) {
    return [
      getTranslated('kg', context),
      getTranslated('gm', context),
      getTranslated('pc', context),
    ];
  }
}
