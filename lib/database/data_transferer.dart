import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:track_it/database/marker_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransferData extends ChangeNotifier {
  late SharedPreferences prefs;
  MarkerData markerData = MarkerData();
  var markerIconSmall;
  var markerIconBig;
  String searchBarTitle = "Search Here";
  IconData icon = Icons.search;
  List<Marker> _markers = [];
  List<Marker> _orginalSetMarker = [];
  List<Marker> markerState = [];
  String searchItem = "";
  Set<Polyline> polylineSet = {};
  LatLng? currentUserPosition;
  LatLng? destination;
  bool needGetDirection = false;
  var userMapIcon;
  var heading;
  bool showDistance = false;

  get markers {
    return _markers.toSet();
  }

  get originalMarker {
    return _orginalSetMarker;
  }

  get presentlength {
    return markerState.length;
  }

  Future<void> initializeSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  void changeShowDistance(bool value) {
    showDistance = value;
    notifyListeners();
  }

  void addCurrentUserPosition(Position postion) {
    currentUserPosition = LatLng(postion.latitude, postion.longitude);
    notifyListeners();
  }

  void changeGetDirection(bool value) {
    needGetDirection = value;
    notifyListeners();
  }

  void changeButtonSearchBar(String title) {
    searchBarTitle = title;
    icon = Icons.arrow_back;
  }

  //changes the search
  void changeSearchBarDisplayText(String text) {
    searchItem = text;
    notifyListeners();
  }

  void revertSearchBar() {
    searchBarTitle = "Search Here";
    icon = Icons.search;
    notifyListeners();
  }

  Future<void> getIcon() async {
    markerIconSmall =
        await getBytesFromAsset('assets/images/bitmap icon.png', 80);
    markerIconBig =
        await getBytesFromAsset('assets/images/bitmap icon.png', 100);
    userMapIcon = await getBytesFromAsset('assets/images/userIcon.png', 80);
  }

  //to convert an image to bitmapDiscripto icon(bytedata)
  Future<Uint8List?> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    Codec codec = await instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ImageByteFormat.png))
        ?.buffer
        .asUint8List();
  }

  void addTappedMarker(LatLng tappedCoordinate) {
    _markers = List.from(markerState);
    _markers.add(
      Marker(
        markerId: MarkerId(tappedCoordinate.toString()),
        infoWindow: InfoWindow(
            title:
                "${tappedCoordinate.latitude},${tappedCoordinate.longitude}"),
        position: tappedCoordinate,
        icon: BitmapDescriptor.fromBytes(markerIconBig),
      ),
    );
    notifyListeners();
  }

  void createOriginalSet() {
    _orginalSetMarker = List.from(_markers);
  }

  void goBack() {
    _markers = List.from(_orginalSetMarker);
  }

  //gets back the original set of markers
  void createMarkers() {
    if (_markers.isEmpty) {
      for (int i = 0; i < markerData.markerId.length; i++) {
        _markers.add(
          Marker(
            markerId: MarkerId(markerData.markerId[i]),
            infoWindow: InfoWindow(title: markerData.markerTitle[i]),
            position: markerData.markerPosition[i],
            icon: BitmapDescriptor.fromBytes(markerIconSmall),
          ),
        );
      }
    }
    markerState = List.from(_markers);
  }

  //continuosly filter the search list so as to give the optimum search results
  void filterMarker(String filteringName) {
    _markers.clear();

    for (int i = 0; i < markerData.markerId.length; i++) {
      if (markerData.markerId[i]
          .toLowerCase()
          .contains(filteringName.toLowerCase())) {
        _markers.add(
          Marker(
            markerId: MarkerId(markerData.markerId[i]),
            infoWindow: InfoWindow(title: markerData.markerTitle[i]),
            position: markerData.markerPosition[i],
            icon: BitmapDescriptor.fromBytes(markerIconSmall),
          ),
        );
      }
    }
    markerState = List.from(_markers);
    notifyListeners();
  }

  //pins the marker u selected from search screen in the map
  void createSelectedMarker(String title) {
    _markers.clear();

    for (int i = 0; i < markerData.markerId.length; i++) {
      if (markerData.markerTitle[i] == title) {
        destination = markerData.markerPosition[i];
        _markers.add(
          Marker(
            markerId: MarkerId(markerData.markerId[i]),
            infoWindow: InfoWindow(title: markerData.markerTitle[i]),
            position: markerData.markerPosition[i],
            icon: BitmapDescriptor.fromBytes(markerIconBig),
          ),
        );
      }
    }
    markerState = List.from(_markers);
  }

  void roadsApi(Set<Polyline> polylines) {
    polylineSet = polylines;
    notifyListeners();
  }
}
