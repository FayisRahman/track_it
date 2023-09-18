import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:track_it/database/marker_data.dart';
import 'package:track_it/Networking/http_request/http_request.dart';
import 'package:track_it/Networking/direction_api.dart';

class RoadsApi {
  MarkerData markerData = MarkerData();

  List<PointLatLng> directionPoints = [];
  int pathLengthCounter = 0;
  String directionPath = '';
  Uri? url;
  late var response;
  List decodedResponse = [];
  final List<LatLng> _polylineCoordinates = [];
  Set<Polyline> _polylines = {};
  LatLng initialPosition;
  LatLng finalPosition;

  RoadsApi({required this.initialPosition, required this.finalPosition});

  Future<Set<Polyline>> roadsApi() async {
    pathLengthCounter = 0;
    //to get distance between the coordinates

    //gets the coordinate blueprint of the path to be followed
    directionPoints = await DirectionApi(
            initialPosition: initialPosition, finalPosition: finalPosition)
        .directionApi();

    for (PointLatLng point in directionPoints) {
      if (pathLengthCounter == 0) {
        directionPath += "${point.latitude},${point.longitude}";
      } else if (pathLengthCounter < 100) {
        directionPath += "%7C${point.latitude},${point.longitude}";
      } else if (pathLengthCounter == 100) {
        //http request to roadsapi..to get the interpolated coordinates with directionpoints as an input
        //the http response is converted to a list by decoding the json file
        //the list is inside a dictionary named "snappedPoints"

        response = await HttpRequest(
                "https://roads.googleapis.com/v1/snapToRoads?interpolate=true&path=$directionPath")
            .getResponse("roadsApi");
        decodedResponse.clear();
        decodedResponse.addAll(response['snappedPoints']);

        for (int i = 0; i < decodedResponse.length; i++) {
          _polylineCoordinates.add(
            LatLng(
              decodedResponse[i]['location']['latitude'],
              decodedResponse[i]['location']['longitude'],
            ),
          );
        }

        directionPath = "${point.latitude},${point.longitude}";
        pathLengthCounter = 0;
      }
      pathLengthCounter++;
    }

    response = await HttpRequest(
            "https://roads.googleapis.com/v1/snapToRoads?interpolate=true&path=$directionPath")
        .getResponse("roadsApi");
    decodedResponse.clear();
    decodedResponse.addAll(response['snappedPoints']);
    for (int i = 0; i < decodedResponse.length; i++) {
      _polylineCoordinates.add(
        LatLng(
          decodedResponse[i]['location']['latitude'],
          decodedResponse[i]['location']['longitude'],
        ),
      );
    }

    print(
        "total number of polyline coordinates obtained from roads api is ${_polylineCoordinates.length}");

    _polylines = {};

    _polylines.add(
      Polyline(
        polylineId: const PolylineId('1'),
        points: _polylineCoordinates,
        color: Colors.indigoAccent,
        width: 5,
      ),
    );

    return _polylines;
  }
}
