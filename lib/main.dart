import 'package:flutter/material.dart';
import 'package:myapp/icons.dart';
import 'package:myapp/location_service.dart';
import 'package:geolocator/geolocator.dart';
import 'weather_service.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    double width2 = MediaQuery.of(context).size.width;
    return MaterialApp(
      title: 'Daily Weather',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.blue,
        textTheme: TextTheme(
          headlineSmall: TextStyle(
            fontSize: width2 * 0.055,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(183, 19, 22, 207)),
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.teal,
          centerTitle: true,
          foregroundColor: Colors.white,
          titleTextStyle: TextStyle(
            fontSize: width2 * 0.06,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: const MyHomePage(title: 'Daily Weather'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final WeatherService _weatherService = WeatherService();
  Map<String, dynamic>? _weatherData;
  String? showedCity;

  @override
  void initState() {
    super.initState();

    // Initialize location and weather data in initState
    getWeatherAndLocation();
  }

  Future<void> getWeatherAndLocation() async {
    try {
      Position? position = await getLocation();
      if (position != null) {
        showedCity = await getCityName(position);
        var data = await _weatherService.getWeather(showedCity!);
        setState(() {
          _weatherData = data;
        });
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  double celsiusToFahrenheit(double celsius) {
    // String -> Double. First(Make the func take String)
    return (celsius * 9 / 5) + 32;
  }

  @override
  Widget build(BuildContext context) {
    var temperature = _weatherData?["main"]["temp"];
    var temperature2 = temperature.toString();
    var showedTemperature = temperature2.split('.');

    var mainWeather =
        _weatherData?["weather"][0]["main"]; // (Rain, Snow, Clouds etc.)

    DateTime now = DateTime.now();
    DateFormat dateFormat = DateFormat('EEEE, M, yyyy\nh:mm a');
    String showedDate = dateFormat.format(now);

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
          child: _weatherData == null
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              : Stack(
                  children: <Widget>[
                    // Settings Icon at the top-right corner
                    Positioned(
                      top: height * 0.03,
                      right: width * 0.04,
                      child: IconButton(
                        onPressed: null,
                        icon: Icon(
                          Icons.settings,
                          color: Colors.white,
                          size: width * 0.08,
                        ),
                      ),
                    ),

                    // Location Text (first widget)
                    Positioned(
                      top: height * 0.03,
                      left: width * 0.04,
                      child: Text(
                        _weatherData!["name"] +
                            ", " +
                            _weatherData!["sys"]["country"],
                        style: TextStyle(
                          fontSize: width * 0.07,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    // Time and Date (second widget)
                    Positioned(
                      top: height * 0.09, // Just below the location
                      left: width * 0.05,
                      child: Text(
                        showedDate,
                        style: TextStyle(
                          fontSize: width * 0.042,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    // Main Weather Condition (third widget)
                    Positioned(
                      top: height * 0.36, // Below Time and Date
                      left: width * 0.05,
                      child: Text(
                        mainWeather,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),

                    // Temperature (fourth widget)
                    Positioned(
                      top: height * 0.30,
                      left: width * 0.05,
                      child: Row(
                        children: [
                          Text(
                            'Temperature: ${showedTemperature[0]} °C',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          SizedBox(width: width * 0.03),
                          WeatherIconWidget(
                            weatherType: 'Temperature',
                            width: width * 0.06,
                            height: height * 0.06,
                          ),
                        ],
                      ),
                    ),

                    // Weather Icon (fifth widget)
                    Positioned(
                      top: height * 0.40, // Below Temperature
                      left: width * 0.30,
                      child: WeatherIconWidget(
                        weatherType: mainWeather,
                        width: width * 0.22,
                        height: height * 0.22,
                      ),
                    ),

                    // Humidity and Wind Speed (last widgets)
                    Positioned(
                      bottom: height * 0.10,
                      left: width * 0.05,
                      child: Row(
                        children: [
                          Text(
                            "Humidity: ${_weatherData!["main"]["humidity"]} %",
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          SizedBox(width: width * 0.03),
                          WeatherIconWidget(
                              weatherType: 'Humidity',
                              width: width * 0.06,
                              height: height * 0.06),
                        ],
                      ),
                    ),

                    Positioned(
                      bottom: height * 0.05, // Below Humidity and Wind Speed
                      left: width * 0.05,
                      child: Row(
                        children: [
                          Text(
                            "Wind Speed: ${_weatherData!["wind"]["speed"]} m/s",
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          SizedBox(width: width * 0.03),
                          WeatherIconWidget(
                              weatherType: 'Wind',
                              width: width * 0.06,
                              height: height * 0.06),
                        ],
                      ),
                    ),
                  ],
                )),
    );
  }
}
