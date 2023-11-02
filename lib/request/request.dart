import 'dart:convert';

import 'package:http/http.dart';
import 'package:oasis_dni/request/request_method.dart';
import 'package:oasis_dni/utils/request_helper.dart';

abstract class IRequest<T> {
  String getPath();

  RequestMethod getMethod() {
    return RequestMethod.GET;
  }

  T getModel(Map<String, dynamic> json);

  Future<T> request(String value) async {
    String url = getPath() + value;
    try {
      Response response =
          await RequestHelper.getAuthRequest(url, requestMethod: getMethod());
      if (response.statusCode == 200) {
        // get json from response
        Map<String, dynamic> json = RequestHelper.getJsonFromResponse(response);
        return getModel(json);
      } else {
        return Future.error(response.body);
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<List<T>> requestData() async {
    String url = getPath();
    List<T> empty = [];
    try {
      Response response =
          await RequestHelper.getAuthRequest(url, requestMethod: getMethod());
      if (response.statusCode == 200) {
        // get json from response
        List jsonResponse = json.decode(response.body);
        return jsonResponse
            .map((data) => getModel(data as Map<String, dynamic>))
            .toList();
      } else {
        return empty;
      }
    } catch (e) {
      print("Error: $e");
      return empty;
      // return Future.error(e);
    }
  }
}
