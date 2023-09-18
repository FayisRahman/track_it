import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:track_it/database/data_transferer.dart';

class RoutesApi {
  PolylinePoints polylinePoints = PolylinePoints();

  List<LatLng> coordinates = [];
  List<PointLatLng> baseCoordinates = [];

  int listLength = 0;
  final String response;

  RoutesApi(this.response);

  void makeList() {
    baseCoordinates.clear();
    baseCoordinates.addAll(polylinePoints.decodePolyline(response));
    listLength = baseCoordinates.length;
  }

  void createCoordinateList() {
    for (int i = 0; i < listLength; i++) {
      coordinates.add(
          LatLng(baseCoordinates[i].latitude, baseCoordinates[i].longitude));
    }
  }
}
