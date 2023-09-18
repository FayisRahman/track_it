import 'package:track_it/Networking/http_request/http_request.dart';

class DistanceApi {
  final String initialPosition;
  final String finalPosition;
  late var response;

  DistanceApi({required this.initialPosition, required this.finalPosition});

  Future<String> getDistance() async {
    response = await HttpRequest(
      "https://maps.googleapis.com/maps/api/distancematrix/json?destinations=${finalPosition}&origins=$initialPosition&units=imperial",
    ).getResponse("distanceApi");
    print({'$initialPosition,$finalPosition'});
    return response['rows'][0]['elements'][0]['distance']['text'];
  }
}
