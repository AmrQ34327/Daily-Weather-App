import 'package:flutter/material.dart';
import 'package:myapp/icons.dart';
import 'package:myapp/location_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'weather_service.dart';
import 'package:intl/intl.dart';
import 'settings.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(dir.path);
  await Hive.openBox('settings');
  runApp(
    ChangeNotifierProvider(
      create: (_) => SettingsProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context, listen: true);
    double width2 = MediaQuery.of(context).size.width;
    return MaterialApp(
        theme: settings.getDarkMode
            ? ThemeData(
                scaffoldBackgroundColor: const Color(0xFF121212),
                textTheme: TextTheme(
                  headlineSmall: TextStyle(
                    fontSize: width2 * 0.055,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  bodyMedium: TextStyle(
                    fontSize: width2 * 0.045,
                    fontWeight: FontWeight.bold,
                    color: Colors.white70,
                  ),
                ),
                colorScheme: const ColorScheme.dark(
                  primary: Color(0xFFBB86FC),
                  onPrimary: Colors.black,
                  secondary: Color(0xFF03DAC6),
                  onSecondary: Colors.black,
                  surface: Color(0xFF1E1E1E),
                  onSurface: Colors.white,
                ),
                appBarTheme: AppBarTheme(
                  backgroundColor: const Color(0xFF1F1F1F),
                  centerTitle: true,
                  foregroundColor: Colors.white,
                  titleTextStyle: TextStyle(
                    fontSize: width2 * 0.06,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                iconTheme: const IconThemeData(
                  color: Colors.white70,
                ),
                useMaterial3: true,
              )
            : ThemeData(
                scaffoldBackgroundColor: Colors.blue,
                textTheme: TextTheme(
                    headlineSmall: TextStyle(
                      fontSize: width2 * 0.055,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    bodyMedium: TextStyle(
                      fontSize: width2 * 0.045,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    )),
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
        initialRoute: '/',
        routes: {
          '/': (context) => const MyHomePage(),
          '/settings': (context) => const SettingsPage(),
        },
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('it'),
          Locale('de'),
        ],
        locale: settings.getCurrentLocale);
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final WeatherService _weatherService = WeatherService();
  Map<String, dynamic>? _weatherData;
  String? showedCity;
  String? italianCityName;
  String? germanCityName;

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
        var translations = await Future.wait([
          translateCityName(
              showedCity!, "it", position.latitude, position.longitude),
          translateCityName(
              showedCity!, "de", position.latitude, position.longitude),
        ]);
        italianCityName = translations[0];
        germanCityName = translations[1];
        var data = await _weatherService.getWeather(showedCity!);
        setState(() {
          _weatherData = data;
        });
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  String celsiusToFahrenheit(double celsius) {
    double fahrenheit = (celsius * 9 / 5) + 32;
    String strFahrenheit = fahrenheit.toString();
    var finFehr = strFahrenheit.split('.');
    String result = finFehr[0];
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    var temperature = _weatherData?["main"]["temp"];
    var mainWeather =
        _weatherData?["weather"][0]["main"]; // (Rain, Snow, Clouds etc.)

    DateTime now = DateTime.now();
    // 12 hour format under
    DateFormat dateFormat = DateFormat(
        'EEEE, M, yyyy\nh:mm a', settings.getCurrentLocale.toString());
    String showedDate = dateFormat.format(now);
    //24 hour format here
    DateFormat dateFormat2 = DateFormat('EEEE, M, yyyy\nHH:mm');
    String showedDate2 = dateFormat2.format(now);
    String countryCode = _weatherData?["sys"]["country"];
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    String translateWeather(String weather) {
      // lowercase the main weather
      var loweredWeather = mainWeather.toLowerCase();

      switch (loweredWeather) {
        case 'ash':
          return AppLocalizations.of(context)!.ash;
        case 'clear':
          return AppLocalizations.of(context)!.clear;
        case 'clouds':
          return AppLocalizations.of(context)!.clouds;
        case 'drizzle':
          return AppLocalizations.of(context)!.drizzle;
        case 'dust':
          return AppLocalizations.of(context)!.dust;
        case 'fog':
          return AppLocalizations.of(context)!.fog;
        case 'haze':
          return AppLocalizations.of(context)!.haze;
        case 'humidity':
          return AppLocalizations.of(context)!.humidity;
        case 'mist':
          return AppLocalizations.of(context)!.mist;
        case 'rain':
          return AppLocalizations.of(context)!.rain;
        case 'snow':
          return AppLocalizations.of(context)!.snow;
        case 'thunderstorm':
          return AppLocalizations.of(context)!.thunderstorm;
        case 'sand':
          return AppLocalizations.of(context)!.sand;
        case 'smoke':
          return AppLocalizations.of(context)!.smoke;
        case 'tornado':
          return AppLocalizations.of(context)!.tornado;
        case 'squall':
          return AppLocalizations.of(context)!.squalls;
        case _:
          return "Whatever";
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.title),
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
                        onPressed: () {
                          Navigator.pushNamed(context, '/settings');
                        },
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
                        settings.currentLanguage == "English"
                            ? "${_weatherData!["name"]}, $countryCode"
                            : settings.currentLanguage == "Italian"
                                ? "${italianCityName!}, $countryCode"
                                : "${germanCityName!}, $countryCode",
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
                        settings.isTimeFormat24 ? showedDate2 : showedDate,
                        style: TextStyle(
                          fontSize: width * 0.042,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    // Main Weather Condition
                    Positioned(
                      top: height * 0.36, // Below Time and Date and Temperature
                      left: width * 0.05,
                      child: Text(
                        translateWeather(mainWeather),
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
                            settings.isFahrenheit
                                ? "${AppLocalizations.of(context)!.temperatureText}: ${celsiusToFahrenheit(temperature)} °F"
                                : '${AppLocalizations.of(context)!.temperatureText}: ${temperature.toStringAsFixed(0)} °C',
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
                      child: isClearNight()
                          ? WeatherIconWidget(
                              weatherType: 'clearNight',
                              width: width * 0.22,
                              height: height * 0.22,
                            )
                          : WeatherIconWidget(
                              weatherType: mainWeather,
                              width: width * 0.22,
                              height: height * 0.22,
                            ),
                    ),

                    // Humidity
                    Positioned(
                      bottom: height * 0.10,
                      left: width * 0.05,
                      child: Row(
                        children: [
                          Text(
                            "${AppLocalizations.of(context)!.humidity}: ${_weatherData!["main"]["humidity"]} %",
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
                    // Wind Speed
                    Positioned(
                      bottom: height * 0.05,
                      left: width * 0.05,
                      child: Row(
                        children: [
                          Text(
                            settings.getWindMetric == 'meter'
                                ? "${AppLocalizations.of(context)!.windSpeedText}: ${_weatherData!["wind"]["speed"]} m/s"
                                : settings.getWindMetric == 'kilometer'
                                    ? "${AppLocalizations.of(context)!.windSpeedText}: ${changeWindSpeed(_weatherData!["wind"]["speed"], 'kilometer')} km/h"
                                    : "${AppLocalizations.of(context)!.windSpeedText}: ${changeWindSpeed(_weatherData!["wind"]["speed"], 'mile')} mph",
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

  bool isClearNight() {
    DateTime now = DateTime.now();
    int timeZoneOffset = _weatherData!['timezone'];
    int sunRiseunix = _weatherData!['sys']['sunrise'] + timeZoneOffset;
    int sunSetUnix = _weatherData!['sys']['sunset'] + timeZoneOffset;
    DateTime sunRise = DateTime.fromMillisecondsSinceEpoch(sunRiseunix * 1000);
    DateTime sunSet = DateTime.fromMillisecondsSinceEpoch(sunSetUnix * 1000);
    bool isNight = now.isAfter(sunSet) || now.isBefore(sunRise);

    if (isNight && _weatherData!["weather"][0]["main"] == 'Clear') {
      return true;
    } else {
      return false;
    }
  }
}

String changeWindSpeed(double speedInMeters, String metric) {
  if (metric == 'kilometer') {
    double speedinKilometer = speedInMeters * 3.6;
    return speedinKilometer.toStringAsFixed(2);
  }
  if (metric == 'mile') {
    double speedInMiles = speedInMeters * 2.236936;
    return speedInMiles.toStringAsFixed(2);
  } else {
    return "Null String";
  }
}
