import 'package:flutter/material.dart';
import 'package:recyminer_app/data/model/other/category_area.dart';
import 'package:recyminer_app/data/model/response/base/api_response.dart';
import 'package:recyminer_app/data/repository/statistics_repo.dart';

class StatisticsProvider extends ChangeNotifier {
  final StatisticsRepo statisticsRepo;

  List<CategoryArea> _categoryArea = [];

  StatisticsProvider({@required this.statisticsRepo}) {
    this._categoryArea.add(new CategoryArea(0, "Plastic"));
    this._categoryArea.add(new CategoryArea(0, "Paperboard"));
    this._categoryArea.add(new CategoryArea(0, "Glass"));
    this._categoryArea.add(new CategoryArea(0, "Organic"));
    this._categoryArea.add(new CategoryArea(0, "Others"));
  }

  bool _isLoading = false;
  bool _loading = false;
  bool get loading => _loading;
  List<CategoryArea> get categoryArea => _categoryArea;
  bool get isLoading => _isLoading;

  Future<void> getStatistics() async {
    ApiResponse apiResponse = await statisticsRepo.getStatistics();
    if (apiResponse.response != null &&
        apiResponse.response.statusCode == 200) {
      _categoryArea = [];

      var res = apiResponse.response.data[0];
      res.forEach((k, v) => {_categoryArea.add(CategoryArea.fromJson(k, v))});
    } else {
      //ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }
}
