import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DirectionApi {
  PolylinePoints _polylinePoints = PolylinePoints();
  String _apiKey = "AIzaSyBQfNdXFkkIRwc0RP-JLSysKPvSKRe2o3E";
  LatLng initialPosition;
  LatLng finalPosition;
  var result;
  List<PointLatLng> points = [];

  DirectionApi({required this.initialPosition, required this.finalPosition});

  Future<dynamic> directionApi() async {
    //gets the coordinate blueprint of the path to be followed
    result = await _polylinePoints.getRouteBetweenCoordinates(
      _apiKey,
      PointLatLng(initialPosition.latitude, initialPosition.longitude),
      PointLatLng(finalPosition.latitude, finalPosition.longitude),
      optimizeWaypoints: true,
    );
    if (result!.points.isNotEmpty) {
      print(
          "total polyline coordinates obtained from directionApi is ${result!.points.length}");
      result!.points.forEach((PointLatLng point) {
        points.add(point);
      });
      return points;
    } else {
      print(
          "DirectionApi failed with the following message => ${result!.errorMessage}");
      return 0;
    }
  }
}
