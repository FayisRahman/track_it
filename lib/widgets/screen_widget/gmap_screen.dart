// import 'dart:async';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:provider/provider.dart';
//
// import '../../database/data_transferer.dart';
// import '../../screens/search_screen.dart';
// import '../filter_buttons.dart';
// import '../floating_action_buttons/fab_1.dart';
// import '../floating_action_buttons/fab_2.dart';
// import '../loader.dart';
// import '../search_bars/search_bar_button.dart';
//
// class GmapScreen extends StatelessWidget {
//   final GoogleMapController myController;
//   final LatLng? currentCoordinates;
//   final void Function(GoogleMapController?) onMapCreated;
//   final void Function(LatLng?) onTapMap;
//   final prefs;
//   final void Function() changeIsPressed;
//   final Set<Marker> userMarkerIcon;
//   final String distance;
//   final bool isPressed;
//   final void Function(dynamic transferData, bool State)
//       getDirectionButtonFunctions;
//
//   GmapScreen(
//       {super.key,
//       required this.myController,
//       this.currentCoordinates,
//       required this.onMapCreated,
//       required this.onTapMap,
//       this.prefs,
//       required this.changeOnPressed,
//       required this.userMarkerIcon,
//       required this.changeIsPressed});
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<TransferData>(
//       builder: (BuildContext context, TransferData, Widget? child) {
//         return Stack(
//           children: [
//             GoogleMap(
//               compassEnabled: false,
//               zoomControlsEnabled: false,
//               initialCameraPosition:
//                   CameraPosition(target: currentCoordinates!, zoom: 19),
//               onMapCreated: (controller) => onMapCreated(controller),
//               markers: Set.from(TransferData.markers)..addAll(userMarkerIcon),
//               mapType: MapType.normal,
//               polylines: TransferData.polylineSet,
//               onLongPress: onTapMap,
//               // cameraTargetBounds: CameraTargetBounds(
//               //   LatLngBounds(
//               //       southwest: LatLng(11, 75), northeast: LatLng(11.59, 77)),
//               // ),
//             ),
//             Column(
//               children: [
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 ButtonSearchBar(
//                   onPressed: () {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (BuildContext context) => SearchScreen(
//                             prefs,
//                           ),
//                         ));
//                   },
//                   title: TransferData.searchBarTitle,
//                   icon: TransferData.icon,
//                   iconOnPressed: () {
//                     if (TransferData.icon == Icons.arrow_back) {
//                       changeIsPressed;
//                       TransferData.goBack();
//                       TransferData.changeSearchBarDisplayText("");
//                       TransferData.revertSearchBar();
//                       TransferData.changeShowDistance(false);
//                       TransferData.roadsApi({});
//                     }
//                   },
//                 ),
//                 SingleChildScrollView(
//                   scrollDirection: Axis.horizontal,
//                   child: Row(
//                     children: [
//                       FilterButton(
//                         title: "Restaurants",
//                         onPressed: () {
//                           TransferData.filterMarker("Restaurants");
//                           TransferData.changeButtonSearchBar("Restaurant");
//                         },
//                         icon: Icons.fastfood_outlined,
//                       ),
//                       FilterButton(
//                         title: "Hospitals",
//                         onPressed: () {
//                           TransferData.filterMarker("Hospitals");
//                           TransferData.changeButtonSearchBar("Hospitals");
//                         },
//                         icon: Icons.local_hospital_outlined,
//                       ),
//                       FilterButton(
//                         title: "Shopping",
//                         onPressed: () {
//                           TransferData.filterMarker("Shopping");
//                           TransferData.changeButtonSearchBar("Shopping");
//                         },
//                         icon: Icons.shopping_cart_outlined,
//                       ),
//                       FilterButton(
//                         title: "Hotels",
//                         onPressed: () {
//                           TransferData.filterMarker("Hotels");
//                           TransferData.changeButtonSearchBar("Hotels");
//                         },
//                         icon: Icons.hotel_outlined,
//                       ),
//                       FilterButton(
//                         title: "ATMs",
//                         onPressed: () {
//                           TransferData.filterMarker("ATMs");
//                           TransferData.changeButtonSearchBar("ATMs");
//                         },
//                         icon: Icons.atm,
//                       ),
//                       FilterButton(
//                           title: "Pharmacy",
//                           onPressed: () {
//                             TransferData.filterMarker("Pharmacy");
//                             TransferData.changeButtonSearchBar("Pharmacy");
//                           },
//                           icon: Icons.local_pharmacy_outlined),
//                     ],
//                   ),
//                 ),
//                 const Expanded(
//                   child: SizedBox(),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(10),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       TransferData.showDistance
//                           ? Column(
//                               children: [
//                                 FilterButton(
//                                     title: distance.toString(),
//                                     onPressed: () {},
//                                     icon: Icons.directions),
//                               ],
//                             )
//                           : const Column(),
//                       Column(
//                         children: [
//                           FAB1(
//                             onPressed: () {
//                               //to get back to our current location
//                               myController?.animateCamera(
//                                 CameraUpdate.newCameraPosition(
//                                   CameraPosition(
//                                       target: currentCoordinates!, zoom: 19),
//                                 ),
//                               );
//                             },
//                           ),
//                           const SizedBox(
//                             height: 10,
//                           ),
//                           FAB2(
//                             onPressed: () async {
//                               //to get to search screen
//                               Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (BuildContext context) =>
//                                         SearchScreen(
//                                       prefs,
//                                     ),
//                                   ));
//                             },
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 TransferData.needGetDirection
//                     ? Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           FilterButton(
//                             title: "Get Direction",
//                             onPressed: () async {
//                               showDialog(
//                                   barrierDismissible: false,
//                                   context: context,
//                                   builder: (context) {
//                                     return const Loader();
//                                   });
//                               changeIsPressed;
//                               await getDirectionButtonFunctions(
//                                   TransferData, false);
//                               Navigator.pop(context);
//                               while (isPressed) {
//                                 await Future.delayed(
//                                     const Duration(seconds: 8));
//                                 await getDirectionButtonFunctions(
//                                     TransferData, true);
//                               }
//                             },
//                             icon: Icons.add_location_outlined,
//                           ),
//                         ],
//                       )
//                     : const Row(),
//               ],
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
