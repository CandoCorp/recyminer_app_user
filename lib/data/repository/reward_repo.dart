import 'package:flutter/material.dart';
import 'package:json_object_lite/json_object_lite.dart' as jsonobject;
import 'package:recyminer_app/data/datasource/remote/dio/dio_client.dart';
import 'package:recyminer_app/data/datasource/remote/exception/api_error_handler.dart';
import 'package:recyminer_app/data/model/response/base/api_response.dart';
import 'package:recyminer_app/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wilt/wilt.dart';

class RewardRepo {
  final DioClient dioClient;
  final Wilt connection;
  final SharedPreferences sharedPreferences;

  RewardRepo(
      {@required this.dioClient, this.connection, this.sharedPreferences});

  Future<int> getPointsFromSharePreferences() async {
    var result = sharedPreferences.getInt('POINTS');
    if (result != null) return result;
    return 0;
  }

  Future<ApiResponse> getPoints() async {
    try {
      dynamic document = jsonobject.JsonObjectLite<dynamic>();
      //String returnedDocRev;
      var userId = sharedPreferences.getInt(AppConstants.USER_ID);

      connection.login(AppConstants.IBM_CLOUDANT_USERNAME,
          AppConstants.IBM_CLOUDANT_PASSWORD);

      connection.db = 'wilt_example';

      var res = await connection.getDocument(userId.toString());
      if (!res.error) {
        document = res.jsonCouchResponse;

        //String returnedDocRev = WiltUserUtils.getDocumentRev(document);
        bool demo = document.contains("points");
        sharedPreferences.setInt('POINTS', 0);
        return ApiResponse.withSuccess(null);
      } else {
        return ApiResponse.withError(ApiErrorHandler.getMessage('Error'));
      }
      ;
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> updatePoints(int points) async {
    try {
      String returnedDocRev;
      var userId = sharedPreferences.getString(AppConstants.TOKEN);

      var res = await connection.getDocument(userId);
      if (!res.error) {
        final dynamic x = res.jsonCouchResponse;
        returnedDocRev = WiltUserUtils.getDocumentRev(x);

        x.points += points;

        res = await connection.putDocument(userId, x, returnedDocRev);
        if (!res.error) {
          final dynamic successUpdate = res.jsonCouchResponse;
          if (successUpdate.ok) {
            returnedDocRev = WiltUserUtils.getDocumentRev(successUpdate);
          } else {
            return ApiResponse.withError(ApiErrorHandler.getMessage('Error'));
          }
        } else {
          return ApiResponse.withError(ApiErrorHandler.getMessage('Error'));
        }
      } else {
        return ApiResponse.withError(ApiErrorHandler.getMessage('Error'));
      }
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getSettings() async {
    try {
      final response = await dioClient.get('${AppConstants.STATISTICS}');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
