import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey = "8bf3184247f73e66a56a1160b1387084";

  // this func returns a map (the json)
  Future<Map<String, dynamic>> getWeather(String cityName) async {
    // units=metric, which tells the API to return the temperature in Celsius (instead of Kelvin)
    // Uri.parse() takes a URL string and converts it into a Uri object, which Flutter http package requires to make network calls.
    final url = Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric");
    // can make it units=Imperial for fahrnenhiet
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to load weather data");
    }
  }
}
