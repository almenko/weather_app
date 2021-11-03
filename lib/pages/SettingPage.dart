import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cupertino_setting_control/cupertino_setting_control.dart';
import 'package:flutter_weather_app/pages/HomePage.dart';
import 'package:flutter_weather_app/pages/HomePageCel.dart';

import 'package:flutter_weather_app/utils/location_helper.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_weather_app/utils/weather.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'HomePageAnalog.dart';
import 'HomePageAnalogCel.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  String _selectedValue;
  String _selectedValueTheme;
  String _Term;
  Widget _tType;
  String locationName;
  int temperature;

  WeatherData weatherData;

  LocationHelper locationHelper;

  Coords coords;

  AssetImage backgroundImage;

  void updateDisplayInfo() async {
    await weatherData.getCurrentTemperature();
    setState(() {
      temperature = weatherData.currentTemperature;
      locationName = weatherData.currentLocation;
    });
  }

  void initWeather() async {
    setState(() {
      locationHelper = new LocationHelper();
    });

    Coords c = await locationHelper.getCurrentLocation();
    setState(() {
      coords = c;
    });

    weatherData = new WeatherData(locationData: c);

    updateDisplayInfo();
  }

  getdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedValue = prefs.getString('_selectedValue'); // f / c
      _selectedValueTheme = prefs.getString('_selectedValueTheme'); // f / c
    });
  }

  setdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('_selectedValue', _selectedValue); // f / c
    prefs.setString('_selectedValueTheme', _selectedValueTheme);


    if (_selectedValue == 'a') {
      setState(() {
        _Term = '°F';
      });
    } else {
      setState(() {
        _Term = '°C';
      });
    }

    if (_selectedValueTheme == 'c' && _selectedValue == 'a') {
      setState(() {
        _tType = HomePage();
      });
    } else if (_selectedValueTheme == 'c' && _selectedValue == 'b') {
      setState(() {
        _tType = HomePageCel();
      });
    } else if (_selectedValueTheme == 'd' && _selectedValue == 'a') {
      setState(() {
        _tType = HomePageAnalog();
      });
    } else {
      setState(() {
        _tType = HomePageAnalogCel();
      });
    }

    print(_Term);
    print(_tType);
  }

  @override
  void initState() {
    super.initState();
    getdata();
    initWeather();
    print(locationName);
  }

  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: GestureDetector(
          onTap: () async {
            setdata();

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => _tType ?? null),
            );
          },
          child: Text(
            "Готово",
            style: TextStyle(
              color: Color(0xFF007aff),
            ),
          ),
        ),
        middle: Text("настройки"),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Image.asset(
            'assets/images/settings.png',
            width: 20,
            color: Color(0xFFc4c4c4),
          ),
          onPressed: () {},
        ),
      ),
      child: GestureDetector(
        onTap: () {},
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFFf4f4f6),
          ),
          child: Column(
            children: <Widget>[
              SizedBox(height: 130),
              Column(
                children: [
                  Material(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          top: BorderSide(width: 1.0, color: Color(0xFFd9d9dc)),
                          bottom:
                              BorderSide(width: 1.0, color: Color(0xFFd9d9dc)),
                        ),
                      ),
                      padding: EdgeInsets.only(
                          top: 10, bottom: 10, left: 20, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Thermometer units',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
                          ),
                          CupertinoSegmentedControl(
                            borderColor: Color(0xFF007aff),
                            pressedColor: Color(0xFF007aff),
                            selectedColor: Color(0xFF007aff),
                            groupValue: this._selectedValue,
                            onValueChanged: (value) {
                              this.setState(() => this._selectedValue = value);
                            },
                            children: {
                              'a': Container(
                                padding: EdgeInsets.symmetric(horizontal: 30),
                                child: Text(
                                  '°F',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              'b': Container(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  '°C',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Material(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          top: BorderSide(width: 1.0, color: Color(0xFFd9d9dc)),
                          bottom:
                              BorderSide(width: 1.0, color: Color(0xFFd9d9dc)),
                        ),
                      ),
                      padding: EdgeInsets.only(
                          top: 10, bottom: 10, left: 20, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Themes',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
                          ),
                          CupertinoSegmentedControl(
                            borderColor: Color(0xFF007aff),
                            pressedColor: Color(0xFF007aff),
                            selectedColor: Color(0xFF007aff),
                            groupValue: this._selectedValueTheme,
                            onValueChanged: (value) {
                              this.setState(
                                  () => this._selectedValueTheme = value);
                            },
                            children: {
                              'c': Container(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  'Digital',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              'd': Container(
                                padding: EdgeInsets.all(8),
                                child: Text(
                                  'Analog',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Material(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          top: BorderSide(width: 1.0, color: Color(0xFFd9d9dc)),
                          bottom:
                              BorderSide(width: 1.0, color: Color(0xFFd9d9dc)),
                        ),
                      ),
                      padding: EdgeInsets.only(
                          top: 10, bottom: 10, left: 20, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Location',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(locationName ?? "",
                                  style: TextStyle(
                                      color: Color(0xFF666666),
                                      fontWeight: FontWeight.w600,
                                      fontFamily:
                                          'assets/fonts/MyriadProRegular.ttf')),
                              Icon(
                                Icons.location_on_outlined,
                                semanticLabel: '$locationName',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Material(
                    child: GestureDetector(
                      onTap: _launchURL,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            top: BorderSide(
                                width: 1.0, color: Color(0xFFd9d9dc)),
                            bottom: BorderSide(
                                width: 1.0, color: Color(0xFFd9d9dc)),
                          ),
                        ),
                        padding: EdgeInsets.only(
                            top: 10, bottom: 10, left: 20, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Privacy Policy',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                                fontFamily: 'assets/fonts/MyriadProRegular.ttf',
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Material(
                    child: GestureDetector(
                      onTap: _launchURL,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            top: BorderSide(
                                width: 1.0, color: Color(0xFFd9d9dc)),
                            bottom: BorderSide(
                                width: 1.0, color: Color(0xFFd9d9dc)),
                          ),
                        ),
                        padding: EdgeInsets.only(
                            top: 10, bottom: 10, left: 20, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Support',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                                fontFamily: 'assets/fonts/MyriadProRegular.ttf',
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _launchURL() async {
    const url = 'https://thermometer.web.ipapps.vaybay.fr/privacy-policy';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
