import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_weather_app/utils/location_helper.dart';
import 'package:flutter_weather_app/utils/weather.dart';
import 'package:geolocator/geolocator.dart';
import 'SettingPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePageAnalogCel extends StatefulWidget {
  @override
  _HomePageAnalogCelState createState() => _HomePageAnalogCelState();
}

class _HomePageAnalogCelState extends State<HomePageAnalogCel> with WidgetsBindingObserver{
  int temperature;
  String _Term;

  WeatherData weatherData;

  LocationHelper locationHelper;

  String locationName;
  Coords coords;

  AssetImage backgroundImage;

  getdata() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String _termValue = preferences.getString('selectedValue');
      String _termType = preferences.getString('_selectedValueTheme');

      if (_termValue == '°F') {
        setState(() {
          _Term = '°F';
        });
      } else {
        setState(() {
          _Term = '°C';
        });
      }
    } catch (e) {
      print("err 1 ${e}");
    }
  }

  bool permission = false;
  bool service = false;

  void checkpermission()  async {

    bool serviceEnabled;
    LocationPermission permissiond;

    setState(() {
      permission=true;
      service=true;
    });

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        service=false;
      });
    }

    permissiond = await Geolocator.checkPermission();
    if (permissiond == LocationPermission.denied) {
      permissiond = await Geolocator.requestPermission();
      if (permissiond == LocationPermission.denied) {
        setState(() {
          permission=false;
        });
      }
    }

    if (permissiond == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      setState(() {
        permission=false;
      });
    }

  }
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    /// If the app resumed(from background), check the status again.
    if (state == AppLifecycleState.resumed) {
      await checkpermission();
    }
  }

  void updateDisplayInfo() async {
    await weatherData.getCurrentTemperature();
    setState(() {
      temperature = (weatherData.currentTemperature - 273.15).round();
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

  @override
  void initState() {
    super.initState();
    initWeather();

    WidgetsBinding.instance.addObserver(this);
        () async {
      await checkpermission();
    }();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    getdata();

    if(service && permission) {
    if (temperature == null || locationName == null) {
      return Container(
        color: Color(0xFFFEFDF8),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
                backgroundColor: Colors.white,
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Text(
                  "Загрузка...",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w300,
                      decoration: TextDecoration.none,
                      color: Colors.black),
                ),
              )
            ],
          ),
        ),
      );
    } else {
      return Material(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFffffff),
                    Color(0xFFb6b8b5),
                  ],
                )),
            child: Column(
              children: <Widget>[
                IconBox(),
                SizedBox(height: 100),
                Container(
                  margin: EdgeInsets.all(25),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                        colors: [
                          Color(0xFFf6f6f6),
                          Color(0xFFdadada),
                        ],
                      )),
                  child: Container(
                    padding: EdgeInsets.all(60),
                    margin: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Color(0xFFedefee),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Text(
                                  'Outside temperature',
                                  style: TextStyle(
                                      fontSize: 14, color: Color(0xFF666666)),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  (temperature - 273.15).round().toString() +
                                      "°С",
                                  style: TextStyle(
                                      fontSize: 42,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(width: 20),
                            Image.asset(
                              "assets/images/gr.png",
                              height: 80,
                            ),
                          ],
                        ),
                        SizedBox(height: 40),
                        Container(
                          height: 3,
                          width: 180,
                          decoration: BoxDecoration(
                            color: Color(0xFFffffff),
                          ),
                        ),
                        SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                            ),
                            Text(locationName ?? "",
                                style: TextStyle(
                                    color: Color(0xFF666666),
                                    fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    } else {
      return Material(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFffffff),
                Color(0xFFb6b8b5),
              ],
            )),
            child: Column(
              children: <Widget>[
                IconBox(
                  temperature: temperature,
                  weatherData: weatherData,
                  reloadWeather: () async {
                    await weatherData.getCurrentTemperature();
                    setState(() {
                      temperature =
                          (weatherData.currentTemperature - 273.15).round();
                      locationName = weatherData.currentLocation;
                    });
                  },
                ),
                SizedBox(height: 20),
                Container(
                    child: Column(
                  children: [
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Outside',
                              style: TextStyle(
                                  fontSize: 14, color: Color(0xFF6e6e6d)),
                            ),
                            Text(
                              'temperature',
                              style: TextStyle(
                                  fontSize: 14, color: Color(0xFF6e6e6d)),
                            ),
                          ],
                        ),
                        SizedBox(width: 15),
                        Text(temperature.toString() + "°С",
                            style: TextStyle(
                                fontSize: 36, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                        ),
                        Text(locationName ?? "",
                            style: TextStyle(
                                color: Color(0xFF666666),
                                fontWeight: FontWeight.w600,
                                fontFamily:
                                    'assets/fonts/MyriadProRegular.ttf')),
                      ],
                    ),
                  ],
                )),
              ],
            ),
          ),
        ),
      );
    }
  }
}

class IconBox extends StatefulWidget {
  int temperature;
  Function reloadWeather;
  WeatherData weatherData;

  IconBox({
    this.temperature,
    this.weatherData,
    this.reloadWeather,
  });

  @override
  _IconBoxState createState() => _IconBoxState();
}

class _IconBoxState extends State<IconBox> with TickerProviderStateMixin {
  LocationHelper locationHelper;

  String locationName;
  Coords coords;

  AnimationController rotationController;

  @override
  void initState() {
    rotationController = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this);
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    int temperatureMax = 50;
    double delta = ((MediaQuery.of(context).size.height - 230) * 0.345);
    double temperatureMaxScreen =
        ((MediaQuery.of(context).size.height - 230) * 0.45);
    double deltaMin = ((MediaQuery.of(context).size.height - 230) * 0.155);
    double tempScreen =
        (widget.temperature / temperatureMax) * temperatureMaxScreen + delta;

    if (widget.temperature < 0 && widget.temperature >= -20) {
      int temperature = 20 - widget.temperature * -1;
      int temperatureMax = 20;
      double delta = ((MediaQuery.of(context).size.height - 230) * 0.145);
      double temperatureMaxScreen =
          ((MediaQuery.of(context).size.height - 230) * 0.345) -
              ((MediaQuery.of(context).size.height - 230) * 0.140);
      deltaMin = ((MediaQuery.of(context).size.height - 230) * 0.155);
      tempScreen =
          (temperature / temperatureMax) * temperatureMaxScreen + delta;
    }

    if (widget.temperature < 0 && widget.temperature > -21) {
      tempScreen = ((20 - widget.temperature) / 20) * delta + deltaMin;
    }

    if (tempScreen > (MediaQuery.of(context).size.height - 230)) {
      tempScreen = delta + (temperatureMaxScreen * 1.05);
    }

    if (widget.temperature < -20) {
      tempScreen = ((MediaQuery.of(context).size.height - 230) * 0.140);
    }



    return Container(
      margin: EdgeInsets.only(top: 80, left: 40, right: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: GestureDetector(
              onTap: () {
                rotationController.forward(from: 0.0);
                widget.reloadWeather();
              },
              child: Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Color(0xFFdddddd),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 0.5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                width: 60,
                height: 60,
                child: Container(
                  padding: EdgeInsets.all(6),
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(

                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(width: 3, color: Color(0xFFececec)),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFFf5f5f5),
                          Color(0xFFdbdbdb),
                        ],
                      )),

                  child: RotationTransition(
                    turns: Tween(begin: 0.0, end: 3.0).animate(rotationController),
                    child: Image.asset('assets/images/reload.png')),

                ),
              ),

            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height - 230,
            child: Container(

              child: Stack(
                children: [
                  Positioned(

                      child: Center(

                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(500)),
                            gradient: LinearGradient(
                              begin: Alignment.center,
                              end: Alignment.center,
                              colors: [
                                Color(0xFFcc2b33),
                                Color(0xFFf03941),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.8),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          width: 65,
                          height: tempScreen,
                        ),

                    ),
                    bottom: 30,
                    left: 0,
                    right: 0,
                  ),
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),

                      ),
                      child: Container(
                        child: Image.asset("assets/images/gr6.png"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // color: Colors.blue,
          ),
          Container(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingPage()),
                );
              },
              child: Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 0.5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  borderRadius: BorderRadius.circular(50),
                  color: Color(0xFFdddddd),
                ),
                width: 60,
                height: 60,
                child: Container(
                  padding: EdgeInsets.all(6),
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(

                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(width: 3, color: Color(0xFFececec)),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFFf5f5f5),
                          Color(0xFFdbdbdb),
                        ],
                      )),
                  child: Image.asset('assets/images/settings.png'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

