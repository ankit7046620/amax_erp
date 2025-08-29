import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  // 🔒 Private constructor
  LocationService._privateConstructor();

  // 🟢 Single instance available globally
  static final LocationService instance = LocationService._privateConstructor();

  /// Check and request permission
  Future<bool> checkPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("❌ Location services are disabled");
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("❌ Location permission denied");
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print("❌ Location permission permanently denied");
      return false;
    }

    return true; // ✅ Permission granted
  }

  /// Get current location with address
  Future<Map<String, String>> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      Placemark place = placemarks.first;
      String address =
          "${place.locality}, ${place.administrativeArea}, ${place.country}";

      return {
        'latitude': position.latitude.toString(),
        'longitude': position.longitude.toString(),
        'location': address,
      };
    } catch (e) {
      print("❌ Error while fetching location: $e");
      return {
        'latitude': '',
        'longitude': '',
        'location': 'Error: $e',
      };
    }
  }
}
