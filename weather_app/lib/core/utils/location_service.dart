import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../exceptions/weather_exceptions.dart';

class LocationService {
  Future<Position> getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        bool enabled = await Geolocator.openLocationSettings();
        if (!enabled) {
          throw LocationException(
            'Location services are disabled. Please enable location services in your device settings.',
          );
        }
      }

      PermissionStatus permissionStatus = await Permission.location.status;
      
      if (permissionStatus.isDenied) {
        permissionStatus = await Permission.location.request();
        
        if (permissionStatus.isDenied) {
          throw LocationException(
            'Location permissions are denied. Please grant location permission in app settings.',
          );
        }
      }
      
      if (permissionStatus.isPermanentlyDenied) {
        await openAppSettings();
        throw LocationException(
          'Location permissions are permanently denied. Please enable them in app settings.',
        );
      }

      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
        timeLimit: const Duration(seconds: 10),
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw LocationException('Location request timed out');
        },
      );
    } on LocationException {
      rethrow;
    } catch (e) {
      throw LocationException('Failed to get location: $e');
    }
  }
}