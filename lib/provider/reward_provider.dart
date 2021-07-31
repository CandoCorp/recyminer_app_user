import 'package:flutter/material.dart';
import 'package:recyminer_app/data/model/response/base/api_response.dart';
import 'package:recyminer_app/data/repository/reward_repo.dart';

class RewardProvider extends ChangeNotifier {
  final RewardRepo rewardRepo;

  int _points = 0;

  RewardProvider({@required this.rewardRepo, shared});

  bool _isLoading = false;
  bool _loading = false;
  bool get loading => _loading;
  int get points => _points;
  bool get isLoading => _isLoading;

  Future<void> getPoints() async {
    ApiResponse apiResponse = await rewardRepo.getPoints();
    _points = await rewardRepo.getPointsFromSharePreferences();

    if (apiResponse.response != null &&
        apiResponse.response.statusCode == 200) {
      var res = apiResponse.response.data[0];
    } else {
      //ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }

  Future<void> getSettings() async {
    ApiResponse apiResponse = await rewardRepo.getSettings();
    if (apiResponse.response != null &&
        apiResponse.response.statusCode == 200) {
      //_points = [];

      var res = apiResponse.response.data[0];
      //res.forEach((k, v) => {_points.add(CategoryArea.fromJson(k, v))});
    } else {
      //ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }
}
