import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;


Future<Position?> getLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();

  if (!serviceEnabled) {
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

Future<String> translateCityName(String cityName, String chosenLangCode , double lat , double lon) async {
   final url = Uri.parse(
            "https://api.opencagedata.com/geocode/v1/json?q=${lat}+${lon}&key=3c7e4ef5caf84d6f9ce0cfd17abf69e8&language=$chosenLangCode");
   final response = await http.get(url);
   if (response.statusCode == 200){
    var body = json.decode(response.body);
    var city = body["results"][0]["components"]["city"];
    return city;
   } else {
    // or make it a return
     throw Exception ("Failed to translate city name (HTTP ${response.statusCode})");
   }     


}
