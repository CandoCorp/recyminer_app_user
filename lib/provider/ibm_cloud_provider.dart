import 'dart:io';

import 'package:flutter/material.dart';
import 'package:recyminer_app/data/model/response/base/api_response.dart';
import 'package:recyminer_app/data/repository/ibm_cloud_repo.dart';
import 'package:recyminer_app/helper/api_checker.dart';
import 'package:recyminer_app/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IbmCloudProvider extends ChangeNotifier {
  final IbmCloudRepo ibmCloudRepo;
  final SharedPreferences sharedPreferences;

  IbmCloudProvider({@required this.ibmCloudRepo, this.sharedPreferences});
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> getToken(BuildContext context) async {
    ApiResponse apiResponse = await ibmCloudRepo.getToken();
    if (apiResponse.response != null &&
        apiResponse.response.statusCode == 200) {
      await sharedPreferences.setString(
          AppConstants.TOKEN_IBM, apiResponse.response.data["access_token"]);
      //apiResponse.response.data.forEach((category) => _couponList.add(CouponModel.fromJson(category)));
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }

  Future<bool> uploadPhoto(File file) async {
    String token = await sharedPreferences.getString(AppConstants.TOKEN_IBM);
    if (token == null) {
      ApiResponse apiResponse = await ibmCloudRepo.getToken();
      if (apiResponse.response != null &&
          apiResponse.response.statusCode == 200) {
        token = apiResponse.response.data["access_token"];

        await sharedPreferences.setString(
            AppConstants.TOKEN_IBM, apiResponse.response.data["access_token"]);
      }
      notifyListeners();
    }

    ApiResponse apiResponse = await ibmCloudRepo.upload(file, token);

    if (apiResponse.response != null &&
        apiResponse.response.statusCode == 200) {
      return true;
    }
    notifyListeners();
    return false;
  }
}
