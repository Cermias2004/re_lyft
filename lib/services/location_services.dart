import 'package:geolocator/geolocator.dart';

class LocationService {
  static Position? _cachedPosition;

  static Future<Position?> getUserPosition() async {
    if (_cachedPosition != null) return _cachedPosition!;

    final permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever)
      {return null;}

      final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      _cachedPosition = position;
      return position;
  }
}
