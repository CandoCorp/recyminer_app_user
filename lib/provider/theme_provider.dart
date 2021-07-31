import 'package:flutter/foundation.dart';
import 'package:recyminer_app/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  final SharedPreferences sharedPreferences;
  ThemeProvider({@required this.sharedPreferences}) {
    _loadCurrentTheme();
  }

  bool _darkTheme = true;
  bool get darkTheme => _darkTheme;

  bool _moreThanOnce = false;
  bool get moreThanOnce => _moreThanOnce;

  bool _fullCapacity = false;
  bool get fullCapacity => _fullCapacity;

  void toggleTheme() {
    _darkTheme = !_darkTheme;
    sharedPreferences.setBool(AppConstants.THEME, _darkTheme);
    notifyListeners();
  }

  void _loadCurrentTheme() async {
    _darkTheme = sharedPreferences.getBool(AppConstants.THEME) ?? false;
    notifyListeners();
  }

  void toogleMoreThanOnce() {
    _moreThanOnce = !_moreThanOnce;
    sharedPreferences.setBool(AppConstants.MORE_THAN_ONCE, _moreThanOnce);
    notifyListeners();
  }

  void tooglefullCapacity() {
    _fullCapacity = !fullCapacity;
    sharedPreferences.setBool(AppConstants.FULL_CAPACITY, fullCapacity);
    notifyListeners();
  }

  void _loadCurrentMoreThanOnce() async {
    _moreThanOnce =
        sharedPreferences.getBool(AppConstants.MORE_THAN_ONCE) ?? false;
    notifyListeners();
  }
}
