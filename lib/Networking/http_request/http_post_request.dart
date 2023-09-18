import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class HttpPostRequest {
  late http.Response response;
  late var body;
  late var ans;

  Future<dynamic> sendRequest(
      LatLng currentPosition, LatLng finalPosition) async {
    response = await http.post(
      Uri.parse('https://routes.googleapis.com/directions/v2:computeRoutes'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'X-Goog-Api-Key': 'AIzaSyBQfNdXFkkIRwc0RP-JLSysKPvSKRe2o3E',
        'X-Goog-FieldMask':
            'routes.duration,routes.distanceMeters,routes.polyline,routes.legs.polyline,routes.legs.steps.polyline'
      },
      body: jsonEncode({
        "origin": {
          "location": {
            "latLng": {
              "latitude": currentPosition.latitude,
              "longitude": currentPosition.longitude,
            }
          }
        },
        "destination": {
          "location": {
            "latLng": {
              "latitude": finalPosition.latitude,
              "longitude": finalPosition.longitude,
            }
          }
        },
        "travelMode": "DRIVE",
        "routingPreference": "TRAFFIC_AWARE",
        "departureTime": "2023-10-15T15:01:23.045123456Z",
        "polylineQuality": "HIGH_QUALITY",
        "computeAlternativeRoutes": false,
        "routeModifiers": {
          "avoidTolls": false,
          "avoidHighways": false,
          "avoidFerries": false
        },
        "languageCode": "en-US",
        "units": "IMPERIAL",
      }),
    );
    if (response.statusCode == 200) {
      body = jsonDecode(response.body);

      return body["routes"][0]["polyline"]["encodedPolyline"];
    }
  }
}
