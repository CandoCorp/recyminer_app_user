import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:recyminer_app/helper/time_helper.dart';
import 'package:recyminer_app/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wilt/wilt.dart';

class SettingsProvider extends ChangeNotifier {
  List<String> valueList = ["Daily", "Weekly", "Monthly"];
  int _frequencyIndex = 0;
  //String _frequencyTrashOut = "M";
  //String get frequencyTrashOut => _frequencyTrashOut;

  Duration _timeTrashOut = new Duration();
  String get timeTrashOut => printDuration(_timeTrashOut);

  final SharedPreferences sharedPreferences;
  SettingsProvider({@required this.sharedPreferences});

  void updateFrequencyTrashOut(int index) {
    _frequencyIndex = index;
    sharedPreferences.setInt(AppConstants.FREQ, _frequencyIndex);
    notifyListeners();
  }

  Duration getTimeTrashOut() {
    return _timeTrashOut;
  }

  int getFrequency() {
    return _frequencyIndex;
  }

  void updateTimeTrashOut(Duration timeTrashOut2) {
    _timeTrashOut = timeTrashOut2;
    sharedPreferences.setString(AppConstants.TIME_TRASH, timeTrashOut);
    notifyListeners();
  }

  Future<bool> saveToDb(dynamic document) async {
    const hostName =
        '5eb9c727-3bf1-4515-a60d-a6d8f919d1d8-bluemix.cloudantnosqldb.appdomain.cloud';
    const serverPort = 443;
    const useSSL = true;
    const userName = 'apikey-v2-ys07048m3xpcj8xmigtsldfdlfr1o7n2xjsfcxp7ti2';
    const userPassword = '68b5a910ecd12e2398dd2a8bfdc8c15b';

    /// Create a test client
    final wilting = Wilt(hostName, port: serverPort, useSSL: useSSL);
    // Login if we are using authentication. If you are using authentication
    // try the example with this commented out, you should see all
    // the operations fail with 'not authorised'.
    wilting.login(userName, userPassword);

    /// Create a test document
    wilting.db = 'wilt_example';
    String returnedDocRev;
    //var x = getRandomString(32);
    //var putId = '$x';

    var res = await wilting.getDocument(document.userId.toString());
    if (!res.error) {
      final dynamic successResponse = res.jsonCouchResponse;
      returnedDocRev = WiltUserUtils.getDocumentRev(successResponse);
      //print('EXAMPLE:: Example document read OK, revision is $returnedDocRev');
    } else {
      return false;
    }

    if (returnedDocRev.isEmpty) {
      // Create
      dynamic create =
          await wilting.putDocument(document.userId.toString(), document);
      if (!create.error) {
        final dynamic successResponse = create.jsonCouchResponse;
        if (successResponse.ok) {
          returnedDocRev = WiltUserUtils.getDocumentRev(successResponse);
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } else {
      // Update
      res = await wilting.putDocument(
          document.userId.toString(), document, returnedDocRev);
      if (!res.error) {
        final dynamic successResponse = res.jsonCouchResponse;
        if (successResponse.ok) {
          returnedDocRev = WiltUserUtils.getDocumentRev(successResponse);
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    }
  }
}
