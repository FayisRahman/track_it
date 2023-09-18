import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GpsLocation {
  final _auth = FirebaseAuth.instance;
  final _cloud = FirebaseFirestore.instance;
  late final User _currentUser;
  late final LocationPermission permission;
  Position? currentPosition;
  List<double> geoLocationLatitude = [];
  List<double> geoLocationLongitude = [];
  Set<Marker> locationCoordinate = {};
  List<String> userId = [];
  dynamic longitude;
  dynamic latitude;
  StreamController<Position?> controller = StreamController<Position?>();

  Future<void> requestPermission() async {
    permission = await Geolocator.requestPermission();
  }

  get currentUserId {
    return _currentUser.displayName;
  }

  Future<void> locate() async {
    currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
  }

  Future<int> getCurrentUser() async {
    try {
      final User? user = await _auth.currentUser;
      if (user != null) {
        _currentUser = user;
      }
    } catch (e) {
      print(e.toString());
    }
    return 0;
  }

  Future<void> getFirstLocation() async {
    await requestPermission();
    currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    // await addFirstLocation(currentPosition);
  }

  Stream<Position?> getLocation() async* {
    while (true) {
      await Future.delayed(const Duration(seconds: 2));
      currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);
      yield currentPosition;
    }
  }

  Future<void> addFirstLocation(currentPosition) async {
    final userDisplayName = _currentUser.displayName.toString().trim();
    try {
      await _cloud.collection("Location").doc(userDisplayName).set({
        "latitude": currentPosition?.latitude,
        "longitude": currentPosition?.longitude,
      });
    } catch (e) {
      print(e.toString());
      await _cloud.collection("Location").doc(userDisplayName).update({
        "latitude": currentPosition?.latitude,
        "longitude": currentPosition?.longitude,
      });
    }
    await locator();
  }

  void coordinates() {
    locationCoordinate.clear();
    for (var i = 0; i < geoLocationLongitude.length; i++) {
      locationCoordinate.add(
        Marker(
          icon: BitmapDescriptor.defaultMarkerWithHue(
            userId[i] == currentUserId
                ? BitmapDescriptor.hueBlue
                : BitmapDescriptor.hueRed,
          ),
          markerId: MarkerId(userId[i]),
          infoWindow:
              InfoWindow(title: userId[i] == currentUserId ? "You" : userId[i]),
          position: LatLng(geoLocationLatitude[i], geoLocationLongitude[i]),
        ),
      );
    }
  }

  Future<void> locator() async {
    geoLocationLongitude.clear();
    geoLocationLatitude.clear();
    locationCoordinate.clear();
    userId.clear();
    await _cloud.collection("Location").get().then((value) {
      for (var data in value.docs) {
        userId.add(data.id.toString());
        geoLocationLatitude
            .add(double.parse(data.data()["latitude"].toString()));
        geoLocationLongitude
            .add(double.parse(data.data()["longitude"].toString()));
      }
      coordinates();
    }, onError: (e) => print(e));
  }
}
