import 'dart:convert';

import 'package:http/http.dart' as http;

class HttpRequest {
  String? directionPathway;
  String _apiKey = "AIzaSyBQfNdXFkkIRwc0RP-JLSysKPvSKRe2o3E";
  String? url;
  Uri? requestUrl;
  String? initialPosition;
  String? finalPosition;
  http.Response? response;
  HttpRequest(this.url);

  Future<dynamic> getResponse(String requestType) async {
    requestUrl = Uri.parse("$url&key=$_apiKey");

    response = await http.get(requestUrl!);

    if (response?.statusCode == 200) {
      return jsonDecode(response!.body);
    } else {
      print(
          "$requestType: Http request failed with status code = ${response?.statusCode}");
      return 0;
    }
  }

  // Future<dynamic> getDistance() async {
  //   distanceUrl = Uri.parse(
  //       "https://maps.googleapis.com/maps/api/distancematrix/json?origins=$initialPosition&destinations=$finalPosition&units=imperial&key=$_apiKey");
  //
  //   distanceResponse = await http.get(distanceUrl!);
  //
  //   if (distanceResponse?.statusCode == 200) {
  //     return jsonDecode(distanceResponse!.body)["rows"][0]["elements"][0]
  //         ['distance']['text'];
  //   } else {
  //     print(
  //         "DistanceApi: Http request failed with status code = ${roadResponse?.statusCode}");
  //     return 0;
  //   }
  // }
}
