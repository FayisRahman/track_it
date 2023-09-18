import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerData {
  List<String> markerId = [
    "Hospitals1",
    'Restaurants1',
    'Shopping1',
    'Hotels1',
    'Atms1',
    'Pharmacy2',
    "Hospitals2",
    'Restaurants2',
    'Restaurants3',
    'Hotels2',
    'Hotels3',
    'Restaurants4',
  ];
  List<String> markerTitle = [
    "Al-Shifa",
    "Grill Story",
    "Lulu",
    "OYO",
    "SBI ATM",
    "Koya's Pharamceuticals",
    "Al-Shifa Dental clinic",
    "Grill Stories",
    "Lulu accessories",
    "OYO",
    "Hell's kitchen",
    "Koya's Thattukada",
  ];
  List<LatLng> markerPosition = [
    const LatLng(10.5, 76.5),
    const LatLng(10.54, 76.54),
    const LatLng(10.56, 76.56),
    const LatLng(10.58, 76.58),
    const LatLng(10.6, 76.6),
    const LatLng(10.62, 76.62),
    const LatLng(10.1, 76.5),
    const LatLng(10.3, 76.54),
    const LatLng(10.4, 76.56),
    const LatLng(10.0, 76.58),
    const LatLng(10.65, 76.6),
    const LatLng(10.78, 76.62),
  ];
}
