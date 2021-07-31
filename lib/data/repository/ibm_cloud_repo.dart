import 'dart:convert' as convert;
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart' as mimeSolve;
import 'package:mime_type/mime_type.dart';
import 'package:recyminer_app/data/datasource/remote/exception/api_error_handler.dart';
import 'package:recyminer_app/data/model/response/base/api_response.dart';
import 'package:recyminer_app/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IbmCloudRepo {
  Dio dioClient;
  final SharedPreferences sharedPreferences;

  IbmCloudRepo({@required this.sharedPreferences}) {
    dioClient = new Dio();
    dioClient
      ..options.baseUrl = '${AppConstants.BASE_IBM_CLOUD}'
      ..options.connectTimeout = 30000
      ..options.receiveTimeout = 30000
      ..httpClientAdapter
      ..options.headers = {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept': 'application/json',
      };
  }

  Future<ApiResponse> getToken() async {
    try {
      final response = await dioClient
          .post('${AppConstants.IBM_IDENTITY_TOKEN}', data: null);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> upload(File file, String token) async {
    try {
      File _file = File(file.path);
      String filename = _file.path.split('/').last;
      String mimeType = mime(filename);
      String mimee = mimeType.split('/')[0];
      String type = mimeType.split('/')[1];
      String length = _file.lengthSync().toString();
      var uri = Uri.parse(
          '${AppConstants.BASE_IBM_OCS}/${AppConstants.IBM_BUCKET}/${filename}');

      String fileName = file.path.split('/').last;
      final mimeTypeData = mimeSolve
          .lookupMimeType(file.path, headerBytes: [0xFF, 0xD8]).split('/');

      FormData data = FormData.fromMap({
        "file": await MultipartFile.fromFile(file.path,
            contentType: MediaType(mimeTypeData[0], mimeTypeData[1])),
      });

      Dio dio = new Dio();

      dio
        ..options.baseUrl = '${AppConstants.BASE_IBM_OCS}'
        ..options.connectTimeout = 30000
        ..options.receiveTimeout = 30000
        ..options.contentType = mimeType
        ..options.method = 'PUT'
        ..httpClientAdapter
        ..options.headers = {
          'Authorization': 'Bearer $token',
          'ibm-service-instance-id': '${AppConstants.IBM_INSTANCE_SERVICE}',
          //'Content-Type': mimeType,
          'Content-Length': length
        };

      List<int> imageBytes = file.readAsBytesSync();
      print(imageBytes);
      String base64Image = convert.base64Encode(imageBytes);

      var image = Image.memory(convert.base64Decode(base64Image));

      try {
        var resultDio = await dio.put(
            '${AppConstants.BASE_IBM_OCS}/${AppConstants.IBM_BUCKET}/${filename}',
            data: data);
        return ApiResponse.withSuccess(resultDio);
      } catch (e) {
        if (e.response != null) {
          if (e.response.statusCode == 403) {
            //update ibm and try again
            var errorResult = await getToken();

            if (errorResult.response != null &&
                errorResult.response.statusCode == 200) {
              await sharedPreferences.setString(AppConstants.TOKEN_IBM,
                  errorResult.response.data["access_token"]);
              //apiResponse.response.data.forEach((category) => _couponList.add(CouponModel.fromJson(category)));

              token = await sharedPreferences.getString(AppConstants.TOKEN_IBM);
              return upload(file, token);
            } else {
              return ApiResponse.withError(ApiErrorHandler.getMessage(e));
            }
          }
        }
        return ApiResponse.withError(ApiErrorHandler.getMessage(e));
      }

//      var request = new http.MultipartRequest("PUT", uri);
//      Map<String, String> headers = {
//        "Authorization": "Bearer ${token}",
//        'ibm-service-instance-id': '${AppConstants.IBM_INSTANCE_SERVICE}',
//        'Content-Type': 'image/jpeg'
//      };

      http.MultipartRequest request = http.MultipartRequest('PUT', uri);
      request.headers.addAll(<String, String>{
        'Authorization': 'Bearer $token',
        'ibm-service-instance-id': '${AppConstants.IBM_INSTANCE_SERVICE}',
        'Content-Type': mimeType
      });
      //only mobile
      request.files.add(http.MultipartFile(
        'file',
        _file.readAsBytes().asStream(),
        _file.lengthSync(),
        filename: filename,
      ));

      //Map<String, String> _fields = Map();
      //_fields.addAll(<String, String>{'message': message});
      //request.fields.addAll(_fields);
      http.StreamedResponse response = await request.send();

      var r = response;
      return ApiResponse.withSuccess(
          new Response(statusCode: r.statusCode, data: r.request));
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }

//    try {
//      Map<String, String> headers = {
//        "Authorization": "Bearer ${token}",
//        'ibm-service-instance-id': '${AppConstants.IBM_INSTANCE_SERVICE}',
//        'Content-Type': 'image/jpeg'
//      };
//      var filename = 'INVOICE-${getRandomString(5)}';
//      var stream = new http.ByteStream(DelegatingStream.typed(file.openRead()));
//      var length = await file.length();
//      var extension = p.extension(file.path);
//
//      var uri = Uri.parse(
//          '${AppConstants.BASE_IBM_OCS}/${AppConstants.IBM_BUCKET}/${filename}${extension}');
//
//      var request = new http.MultipartRequest("PUT", uri);
//      var multipartFile = new http.MultipartFile('file', stream, length,
//          filename: p.basename(file.path));
//      //contentType: new MediaType('image', 'png'));
//
//      request.files.add(multipartFile);
//      request.headers.addAll(headers);
//      var response = await request.send();
//      print(response.statusCode);
//      response.stream.transform(utf8.decoder).listen((value) {
//        print(value);
//      });
//
//      return ApiResponse.withSuccess(null);
//    } catch (e) {
//      // Get token again and retry
//
//      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
//    }
  }
}
