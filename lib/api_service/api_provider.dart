import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

/// A [ApiProvider] class is used to network API call
/// Allows all classes implementing [Client] to be mutually composable.
class ApiProvider {
  static final ApiProvider _singletonApiProvider = ApiProvider._internal();

  factory ApiProvider() {
    return _singletonApiProvider;
  }

  ApiProvider._internal();

  /// It returns a map of strings.
  Future<Map<String, String>> getHeaderValue() async {
    Map<String, String> header = {
      'Content-Type': 'application/x-www-form-urlencoded',
      "Authorization": "Bearer  <----***your secret key will be here***---->",
    };

    return header;
  }

  ///Used to call a get method
  Future callGetMethod(
      http.Client client, String url, Map<String, String> mHeader) async {
    var baseUrl = Uri.parse(url);
    if (kDebugMode) {
      print('Request Url==>$baseUrl');
    }
    if (kDebugMode) {
      print('Request Header==>$mHeader');
    }
    try {
      return await client
          .get(baseUrl, headers: mHeader)
          .then((Response response) {
        log("response.body-----------${response.body}");
        return response.body;
      });
    } catch (e) {
      if (kDebugMode) {
        print("e----------------$e");
      }
    }
  }

  ///used to call a post method
  Future callPostMethod(http.Client client, String url,
      Map<String, String> body, Map<String, String> mHeader) async {
    var baseUrl = Uri.parse(url);
    if (kDebugMode) {
      print('Request Url==>$baseUrl');
    }
    if (kDebugMode) {
      print('Request Header==>$mHeader');
    }
    if (kDebugMode) {
      print('Request body==>$body');
    }
    try {
      return await client
          .post(baseUrl, headers: mHeader, body: {}).then((Response response) {
        log("response.body-----------${response.body}");
        return response.body;
      });
    } on SocketException catch (e) {
      print("e----------------$e");
    }
  }

  ///call post method
  Future callPostMethodWithEncoded(http.Client client, String url,
      Map<String, String> body, Map<String, String> mHeader) async {
    var baseUrl = Uri.parse(url);
    print('Request Url==>$baseUrl');
    print('Request Header==>$mHeader');
    print('Request body==>$body');

    var request = http.Request('POST', baseUrl);
    request.bodyFields = body;
    log("request.bodyFields----------${request.bodyFields}");
    request.headers.addAll(mHeader);
    http.StreamedResponse response = await request.send();

    return response.stream.bytesToString();
  }
}
