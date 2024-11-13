import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';

class WeatherIconWidget extends StatelessWidget {
  final String weatherType; // "clear", "clouds", "rain", etc.
  final double width;
  final double height;

  const WeatherIconWidget(
      {super.key,
      required this.weatherType,
      this.width = 40,
      this.height = 40});

  @override
  Widget build(BuildContext context) {
    String svgAsset = 'weather_icons/$weatherType.svg';

    return SvgPicture.asset(
      svgAsset,
      width: width, // Size can be adjusted as needed
      height: height,
    );
  }
}
