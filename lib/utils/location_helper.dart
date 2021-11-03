import 'package:geolocator/geolocator.dart';

class Coords {
  double latitude;
  double longitude;

  Coords({
    this.latitude,
    this.longitude,
  });
}

class LocationHelper {
  Coords coords;

  Coords getCurrentLocationData() {
    return this.coords;
  }

  Future<Coords> getCurrentLocation() async {
    try {
      this.coords = Coords();
      Position position = await Geolocator.getCurrentPosition();

      this.coords.latitude = position.latitude;
      this.coords.longitude = position.longitude;
    } catch (e) {
      print(e);
    }

    return this.coords;
  }
}
