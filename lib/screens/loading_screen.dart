import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:track_it/Networking/gps_location.dart';
import 'gps_screen.dart';
import 'package:provider/provider.dart';
import 'package:track_it/database/data_transferer.dart';

class LoadingScreen extends StatefulWidget {
  static const String id = "LoadingScreen";

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  GpsLocation gpsLocation = GpsLocation();

  void getLocationData() async {
    //get currentuser and its location only once
    //to not notice gap when getting location
    // await gpsLocation.getCurrentUser();
    await Provider.of<TransferData>(context, listen: false)
        .initializeSharedPref();
    await gpsLocation.getFirstLocation();
    Provider.of<TransferData>(context, listen: false)
        .addCurrentUserPosition(gpsLocation.currentPosition!);
    if (context.mounted) {
      await Provider.of<TransferData>(context, listen: false).getIcon();
    }
    if (context.mounted) {
      Provider.of<TransferData>(context, listen: false).createMarkers();
      Provider.of<TransferData>(context, listen: false).createOriginalSet();
    }
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => GpsScreen(
                  gpsLocation: gpsLocation,
                )),
        (route) => false,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getLocationData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpinKitWaveSpinner(
              color: Colors.blue[700]!,
              waveColor: Colors.blue,
            ),
            const SizedBox(
              height: 10,
            ),
            const Text("Fetching Data..Please be patient", ),
          ],
        ),
      ),
    );
  }
}
