import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:track_it/Networking/roads_api.dart';
import 'package:track_it/screens/search_screen.dart';
import '../Networking/gps_location.dart';
import 'package:track_it/widgets/search_bars/search_bar_button.dart';
import 'package:track_it/widgets/floating_action_buttons/fab_1.dart';
import 'package:track_it/widgets/floating_action_buttons/fab_2.dart';
import 'package:track_it/widgets/filter_buttons.dart';
import 'package:track_it/database/marker_data.dart';
import 'package:provider/provider.dart';
import 'package:track_it/database/data_transferer.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:track_it/Networking/distance_api.dart';
import '../widgets/loader.dart';
import 'package:track_it/Networking/http_request/http_post_request.dart';
import 'package:track_it/Networking/route_api.dart';

class GpsScreen extends StatefulWidget {
  static const String id = "GpsScreen";
  GpsLocation? gpsLocation;

  GpsScreen({
    super.key,
    this.gpsLocation,
  });

  @override
  State<GpsScreen> createState() => _GpsScreenState();
}

class _GpsScreenState extends State<GpsScreen> with TickerProviderStateMixin {
  HttpPostRequest httpPostRequest = HttpPostRequest();
  MarkerData markerData = MarkerData();
  late final SharedPreferences _prefs;
  GoogleMapController? myController;
  final gcontroller = Completer<GoogleMapController>();
  String? userId;
  late GpsLocation gpsLocation;
  Set<Marker> locationCoordinate = {};
  LatLng? _currentCoordinates;
  MapType mapType = MapType.normal;
  int count = 0;
  IconData icon = Icons.search;
  late var markerIcon;
  String searchBar = "Search Here";
  String title = "Search Here";
  Set<Polyline> _polylinesResponse = {};
  bool needGetDirection = true;
  List<Marker> markerList = [];
  Set<Marker> markers = {};
  double newHeading = 0.0;
  bool isPressed = false;
  String distance = "";
  bool firstTime = true;
  int presentLength = 0;
  List<Marker> userMarkerIcon = [const Marker(markerId: MarkerId("value"))];
  final Duration duration = const Duration(milliseconds: 300);
  Set<Marker> setMarker = {};
  int screenNumber = 0;
  Color color = Colors.white60;
  late var responseAns;
  late RoutesApi routes;

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void _onMapCreated(controller) {
    myController = controller;
  }

  Marker userMarker(double heading) {
    return Marker(
      markerId: const MarkerId("You"),
      infoWindow: const InfoWindow(title: "You"),
      position: Provider.of<TransferData>(context, listen: false)
          .currentUserPosition!,
      icon: BitmapDescriptor.fromBytes(
          Provider.of<TransferData>(context, listen: false).userMapIcon),
      rotation: heading,
      anchor: const Offset(0.5, 0.5),
    );
  }

  Future<void> getDirectionButtonFunctions(
      dynamic TransferData, bool isFirstTime) async {
    responseAns = await httpPostRequest.sendRequest(
        TransferData.currentUserPosition!, TransferData.destination!);
    routes = RoutesApi(responseAns);
    routes.makeList();
    routes.createCoordinateList();
    TransferData.roadsApi({
      Polyline(
        polylineId: const PolylineId('1'),
        points: routes.coordinates,
        color: Colors.indigoAccent,
        width: 5,
      ),
    });
  }

  Future<void> getLocation() async {
    gpsLocation.getLocation().listen((currentPosition) {
      //dont need it now since not taking other location
      // gpsLocation.addFirstLocation(currentPosition);
      Provider.of<TransferData>(context, listen: false)
          .addCurrentUserPosition(currentPosition!);
      //dont need it now since not taking all other users location
      // setState(() {
      //   locationCoordinate = gpsLocation.locationCoordinate;
      // });
    });
  }

  void initializer() async {
    _prefs = Provider.of<TransferData>(context, listen: false).prefs;
    Future.wait([
      getLocation(),
      rotateUserIcon(),
    ]).then((value) => null);
  }

  Future<void> rotateUserIcon() async {
    FlutterCompass.events?.listen((event) async {
      newHeading = event.heading!;
      _updateUserMarkerRotation(newHeading);
    });
  }

  void _updateUserMarkerRotation(double newHeading) {
    userMarkerIcon[0] = userMarker(newHeading);
    setState(() {
      userMarkerIcon.toSet();
    });
  }

  void _onTapMap(LatLng tappedCoordinate) {
    Provider.of<TransferData>(context, listen: false)
        .addTappedMarker(tappedCoordinate);
  }

  @override
  void initState() {
    super.initState();
    gpsLocation = widget.gpsLocation!;
    setState(() {
      _currentCoordinates = LatLng(gpsLocation.currentPosition!.latitude,
          gpsLocation.currentPosition!.longitude);
      // locationCoordinate = gpsLocation.locationCoordinate;
    });
    initializer();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TransferData>(
      builder: (context, TransferData, child) {
        return Scaffold(
          body: Column(
            children: [
              Expanded(
                flex: 10,
                child: screenNumber == 0
                    ? Stack(
                        children: [
                          GoogleMap(
                            compassEnabled: false,
                            zoomControlsEnabled: false,
                            initialCameraPosition: CameraPosition(
                                target: _currentCoordinates!, zoom: 19),
                            onMapCreated: (controller) =>
                                _onMapCreated(controller),
                            markers: Set.from(TransferData.markers)
                              ..addAll(userMarkerIcon),
                            mapType: mapType,
                            polylines: TransferData.polylineSet,
                            onLongPress: _onTapMap,
                            // cameraTargetBounds: CameraTargetBounds(
                            //   LatLngBounds(
                            //       southwest: LatLng(11, 75), northeast: LatLng(11.59, 77)),
                            // ),
                          ),
                          Column(
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              ButtonSearchBar(
                                onPressed: () {
                                  print(TransferData.currentUserPosition);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            SearchScreen(
                                          _prefs,
                                        ),
                                      ));
                                },
                                title: TransferData.searchBarTitle,
                                icon: TransferData.icon,
                                iconOnPressed: () {
                                  if (TransferData.icon == Icons.arrow_back) {
                                    setState(() {
                                      isPressed = false;
                                    });
                                    TransferData.goBack();
                                    TransferData.changeSearchBarDisplayText("");
                                    TransferData.revertSearchBar();
                                    TransferData.changeShowDistance(false);
                                    TransferData.roadsApi({});
                                  }
                                },
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    FilterButton(
                                      title: "Restaurants",
                                      onPressed: () async {
                                        TransferData.filterMarker(
                                            "Restaurants");
                                        TransferData.changeButtonSearchBar(
                                            "Restaurant");
                                      },
                                      icon: Icons.fastfood_outlined,
                                    ),
                                    FilterButton(
                                      title: "Hospitals",
                                      onPressed: () {
                                        TransferData.filterMarker("Hospitals");
                                        TransferData.changeButtonSearchBar(
                                            "Hospitals");
                                      },
                                      icon: Icons.local_hospital_outlined,
                                    ),
                                    FilterButton(
                                      title: "Shopping",
                                      onPressed: () {
                                        TransferData.filterMarker("Shopping");
                                        TransferData.changeButtonSearchBar(
                                            "Shopping");
                                      },
                                      icon: Icons.shopping_cart_outlined,
                                    ),
                                    FilterButton(
                                      title: "Hotels",
                                      onPressed: () {
                                        TransferData.filterMarker("Hotels");
                                        TransferData.changeButtonSearchBar(
                                            "Hotels");
                                      },
                                      icon: Icons.hotel_outlined,
                                    ),
                                    FilterButton(
                                      title: "ATMs",
                                      onPressed: () {
                                        TransferData.filterMarker("ATMs");
                                        TransferData.changeButtonSearchBar(
                                            "ATMs");
                                      },
                                      icon: Icons.atm,
                                    ),
                                    FilterButton(
                                        title: "Pharmacy",
                                        onPressed: () {
                                          TransferData.filterMarker("Pharmacy");
                                          TransferData.changeButtonSearchBar(
                                              "Pharmacy");
                                        },
                                        icon: Icons.local_pharmacy_outlined),
                                  ],
                                ),
                              ),
                              const Expanded(
                                child: SizedBox(),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    TransferData.showDistance
                                        ? Column(
                                            children: [
                                              FilterButton(
                                                  title: distance.toString(),
                                                  onPressed: () {},
                                                  icon: Icons.directions),
                                            ],
                                          )
                                        : const Column(),
                                    Column(
                                      children: [
                                        FAB1(
                                          onPressed: () {
                                            //to get back to our current location
                                            myController?.animateCamera(
                                              CameraUpdate.newCameraPosition(
                                                CameraPosition(
                                                    target: TransferData
                                                        .currentUserPosition!,
                                                    zoom: 19),
                                              ),
                                            );
                                          },
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        FAB2(
                                          onPressed: () async {
                                            //to get to search screen
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          SearchScreen(
                                                    _prefs,
                                                  ),
                                                ));
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              TransferData.needGetDirection
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        FilterButton(
                                          title: "Get Direction",
                                          onPressed: () async {
                                            showDialog(
                                                barrierDismissible: false,
                                                context: context,
                                                builder: (context) {
                                                  return const Loader();
                                                });
                                            isPressed = true;
                                            await getDirectionButtonFunctions(
                                                TransferData, false);
                                            Navigator.pop(context);
                                            await getDirectionButtonFunctions(
                                                TransferData, true);
                                          },
                                          icon: Icons.add_location_outlined,
                                        ),
                                      ],
                                    )
                                  : const Row(),
                            ],
                          ),
                        ],
                      )
                    : screenNumber == 1
                        ? Column()
                        : Column(),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  height: 65,
                  width: double.infinity,
                  color: const Color(0xFF1A1A1C),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              screenNumber = 0;
                            });
                          },
                          icon: CircleAvatar(
                            backgroundColor: screenNumber == 0
                                ? color
                                : const Color(0xFF1A1A1C),
                            radius: 15,
                            child: const Icon(
                              Icons.explore_outlined,
                              color: Colors.white60,
                            ),
                          ),
                        ),
                        Container(
                          color: Colors.white30,
                          width: 1,
                          height: double.infinity,
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              screenNumber = 1;
                            });
                          },
                          icon: CircleAvatar(
                            backgroundColor: screenNumber == 1
                                ? color
                                : const Color(0xFF1A1A1C),
                            child: const Icon(
                              Icons.fastfood_outlined,
                              color: Colors.white60,
                            ),
                          ),
                        ),
                        Container(
                          color: Colors.white30,
                          width: 1,
                          height: double.infinity,
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.account_balance_wallet_outlined,
                            color: Colors.white60,
                          ),
                        ),
                        Container(
                          color: Colors.white30,
                          width: 1,
                          height: double.infinity,
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.info_outlined,
                            color: Colors.white60,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
