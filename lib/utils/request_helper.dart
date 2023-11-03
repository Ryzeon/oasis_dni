import 'dart:convert';

import 'package:http/http.dart';
import 'package:oasis_dni/auth/auth_factory.dart';
import 'package:oasis_dni/env/environment.dart';
import 'package:oasis_dni/request/request_method.dart';

class RequestHelper {
  static Map<String, dynamic> getJsonFromResponse(Response response) {
    return response.body.isNotEmpty ? jsonDecode(response.body) : null;
  }

  static Future<Response> getAuthRequest(String url,
      {RequestMethod requestMethod = RequestMethod.GET,
      Map<String, dynamic>? bodydata}) async {
    return getRequestToServer(url,
        requestMethod: requestMethod, bodydata: bodydata, auth: true);
  }

  static Future<Response> getRequestToServer(String url,
      {RequestMethod requestMethod = RequestMethod.GET,
      Map<String, dynamic>? bodydata,
      bool auth = false}) async {
    print("Request to $url");
    if (!url.contains("://")) {
      url = Envionment.apiUrl + url;
    }
    print("Request to fix $url");
    try {
      final uriData = Uri.parse(url);
      final requestHeaders = {
        "Content-Type": "application/json",
      };
      if (auth) {
        requestHeaders["Authorization"] =
            "Bearer ${await AuthFactory.instance.authProvider.getToken()}";
        // await AuthFactory.instance.authProvider.getToken();
      }
      print("Sending request to $url");
      print("With headers $requestHeaders");
      print("With body $bodydata");
      final Response response;
      switch (requestMethod) {
        case RequestMethod.GET:
          response = await get(
            uriData,
            headers: requestHeaders,
          );
          break;
        case RequestMethod.POST:
          response = await post(uriData,
              headers: requestHeaders, body: json.encoder.convert(bodydata));
          break;
        case RequestMethod.PUT:
          response = await put(uriData,
              headers: requestHeaders, body: json.encoder.convert(bodydata));
          break;
        case RequestMethod.DELETE:
          response = await delete(uriData, headers: requestHeaders);
          break;
        default:
          response = await get(uriData, headers: requestHeaders);
          break;
      }
      print("Response from ${response.statusCode}");
      if (response.statusCode == 402) {
        await AuthFactory.instance.authProvider.refresh();
        return getRequestToServer(url,
            requestMethod: requestMethod, bodydata: bodydata, auth: auth);
      }
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }
}
