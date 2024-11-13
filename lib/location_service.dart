import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';


Future<Position?> getLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();

  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  if (permission == LocationPermission.whileInUse ||
      permission == LocationPermission.always ) {
    Position position = await Geolocator.getCurrentPosition();
    return position;
  }

  return null;
}

Future<String> getCityName(Position position) async {
  var latitude = position.latitude;
  var longitude = position.longitude;
  List<Placemark> placemarks =
      await placemarkFromCoordinates(latitude, longitude);
  return placemarks.first.locality.toString();
}
