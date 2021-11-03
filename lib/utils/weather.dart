import 'dart:convert';
import 'dart:io';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_weather_app/utils/location_helper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const apiKey = 'a6b9ecd457e7f4c5e33615525644d594';
const url = 'https://api.openweathermap.org/data/2.5';

class WeatherData {
  WeatherData({@required this.locationData});

  Coords locationData;
  int currentTemperature;
  String currentLocation;

  Future<void> getCurrentTemperature() async {
    print(1);
    final requestUrl =
        '${url}/weather?lat=${locationData.latitude}&lon=${locationData.longitude}&appid=$apiKey';
    print(2);
    final response = await http.get(Uri.parse(requestUrl));
    print(3);

    if (response.statusCode == 200) {
      String data = response.body;

      print("resp ${data}");
      var currentWeather = jsonDecode(data);
      print(currentWeather);
      try {
        currentLocation = currentWeather['name'];

        if (currentWeather['main']['temp'] is double) {
          this.currentTemperature = currentWeather['main']['temp'].round();
        } else {
          this.currentTemperature = currentWeather['main']['temp'];
        }

        if (this.currentTemperature == null) {
          this.currentTemperature = 0;
        }
      } catch (e) {
        print(e);
      }
    } else {
      print('Could not fetch temperature!');
    }
  }
}
