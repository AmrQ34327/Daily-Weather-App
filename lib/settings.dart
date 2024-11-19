import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsProvider extends ChangeNotifier {
  late Box _settingsBox;

  SettingsProvider() {
    _loadSettings();
  }

  void _loadSettings() {
    _settingsBox = Hive.box('settings');
    isDarkModeOn = _settingsBox.get('darkMode', defaultValue: false);
    isFahrenheit = _settingsBox.get('fahrenheit', defaultValue: false);
    isTimeFormat24 = _settingsBox.get('timeFormat24', defaultValue: false);
    windMetric = _settingsBox.get('windMetric', defaultValue: 'meter');
    currentLanguage = _settingsBox.get('language', defaultValue: 'English');
    curentLocale = Locale(currentLanguage == 'English'
        ? 'en'
        : currentLanguage == 'Italian'
            ? 'it'
            : 'de');
    notifyListeners();
  }

  void _saveSettings() {
    _settingsBox.put('darkMode', isDarkModeOn);
    _settingsBox.put('fahrenheit', isFahrenheit);
    _settingsBox.put('timeFormat24', isTimeFormat24);
    _settingsBox.put('windMetric', windMetric);
    _settingsBox.put('language', currentLanguage);
  }

  bool isDarkModeOn = false;
  bool isFahrenheit = false;
  bool isTimeFormat24 = false;
  String windMetric = "meter";
  String currentLanguage = "English";
  var curentLocale = const Locale('en');

  bool get getDarkMode => isDarkModeOn;
  bool get getFahrenheit => isFahrenheit;
  bool get getTimeFormat24 => isTimeFormat24;
  String get getWindMetric => windMetric;
  String get getCurrentLanguage => currentLanguage;
  Locale get getCurrentLocale => curentLocale;

  void toggleDarkMode() {
    isDarkModeOn = !isDarkModeOn;
    notifyListeners();
    _saveSettings();
  }

  void setWindMetric(String metric) {
    // is meter / kilometer / mile
    windMetric = metric;
    notifyListeners();
    _saveSettings();
  }

  void toggleFahrenheit() {
    isFahrenheit = !isFahrenheit;
    notifyListeners();
    _saveSettings();
  }

  void toggleTimeFormat24() {
    isTimeFormat24 = !isTimeFormat24;
    notifyListeners();
    _saveSettings();
  }

  void chooseLanguage(String language) {
    currentLanguage = language;
    _saveSettings();
    curentLocale = Locale(language == 'English'
        ? 'en'
        : language == 'Italian'
            ? 'it'
            : 'de');
    notifyListeners();
  }
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context, listen: true);
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.settings),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ListTile(
                title: Text(
                  AppLocalizations.of(context)!.timeFormat,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ChoiceChip(
                      label:
                          Text(AppLocalizations.of(context)!.timeFormat12Hour),
                      selected: !settings.getTimeFormat24,
                      onSelected: (selected) {
                        if (selected) {
                          settings.toggleTimeFormat24();
                        }
                      },
                    ),
                    SizedBox(width: width * .02), // was 8
                    ChoiceChip(
                      label:
                          Text(AppLocalizations.of(context)!.timeFormat24Hour),
                      selected: settings.getTimeFormat24,
                      onSelected: (selected) {
                        if (selected) {
                          settings.toggleTimeFormat24();
                        }
                      },
                    ),
                  ],
                ),
              ),
              ListTile(
                title: Text(
                  AppLocalizations.of(context)!.temperatureUnit,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ChoiceChip(
                      label: Text(AppLocalizations.of(context)!.celsius),
                      selected: !settings.getFahrenheit,
                      onSelected: (selected) {
                        if (selected) {
                          settings.toggleFahrenheit();
                        }
                      },
                    ),
                    SizedBox(width: width * .02),
                    ChoiceChip(
                      label: Text(AppLocalizations.of(context)!.fahrenheit),
                      selected: settings.getFahrenheit,
                      onSelected: (selected) {
                        if (selected) {
                          settings.toggleFahrenheit();
                        }
                      },
                    ),
                  ],
                ),
              ),
              ListTile(
                title: Text(
                  AppLocalizations.of(context)!.windSpeedText,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ChoiceChip(
                      label: const Text('m/s'),
                      selected:
                          settings.getWindMetric == 'meter' ? true : false,
                      onSelected: (selected) {
                        if (selected) {
                          settings
                              .setWindMetric('meter'); // or make it a method
                        }
                      },
                    ),
                    SizedBox(width: width * .02),
                    ChoiceChip(
                      label: const Text('km/h'),
                      selected:
                          settings.getWindMetric == 'kilometer' ? true : false,
                      onSelected: (selected) {
                        if (selected) {
                          settings.setWindMetric('kilometer');
                        }
                      },
                    ),
                    SizedBox(width: width * .02),
                    ChoiceChip(
                      label: const Text('mph'),
                      selected: settings.getWindMetric == 'mile' ? true : false,
                      onSelected: (selected) {
                        if (selected) {
                          settings.setWindMetric('mile');
                        }
                      },
                    ),
                  ],
                ),
              ),
              ListTile(
                title: Text(
                  AppLocalizations.of(context)!.currentLanguage,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                trailing: DropdownButton<String>(
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.white,
                  ),
                  onTap: () {
                    setState(() {});
                  },
                  dropdownColor: Colors.blue,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold),
                  value: settings.getCurrentLanguage,
                  items: <String>['English', 'Italian', 'German']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      settings.chooseLanguage(newValue);
                      if (newValue == 'English') {
                        settings.curentLocale = const Locale('en');
                      } else if (newValue == 'Italian') {
                        settings.curentLocale = const Locale('it');
                      } else if (newValue == 'German') {
                        settings.curentLocale = const Locale('de');
                      }
                    }
                  },
                ),
              ),
              ListTile(
                title: Text(
                  AppLocalizations.of(context)!.darkMode,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ChoiceChip(
                      label: Text(AppLocalizations.of(context)!.on),
                      selected: settings.getDarkMode,
                      onSelected: (selected) {
                        if (selected) {
                          settings.toggleDarkMode();
                        }
                      },
                    ),
                    SizedBox(width: width * .02),
                    ChoiceChip(
                      label: Text(AppLocalizations.of(context)!.off),
                      selected: !settings.getDarkMode,
                      onSelected: (selected) {
                        if (selected) {
                          settings.toggleDarkMode();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
