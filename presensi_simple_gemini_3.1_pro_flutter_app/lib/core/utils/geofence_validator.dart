// lib/core/utils/geofence_validator.dart
//
// Geofence Validator — GPS Radius Check
// Zero-Trust Attendance Protocol
// ═══════════════════════════════════════════════════
// Validasi radius ≤ 100 meter sebelum scanner guru aktif [SRS-FR-MAPEL-002]

import 'package:geolocator/geolocator.dart';

/// Result of a geofence validation check.
sealed class GeofenceResult {
  const GeofenceResult();
}

/// Device is within the school geofence.
class GeofenceInside extends GeofenceResult {
  /// Distance from school center in meters.
  final double distanceMeters;
  const GeofenceInside(this.distanceMeters);
}

/// Device is outside the school geofence.
class GeofenceOutside extends GeofenceResult {
  /// Distance from school center in meters.
  final double distanceMeters;
  const GeofenceOutside(this.distanceMeters);
}

/// GPS permission was denied.
class GeofencePermissionDenied extends GeofenceResult {
  const GeofencePermissionDenied();
}

/// GPS service is disabled.
class GeofenceServiceDisabled extends GeofenceResult {
  const GeofenceServiceDisabled();
}

/// Validates that a device is within the school's geofence perimeter.
///
/// Tolerance: ≤ 100 meters from school center coordinates.
/// School coordinates are configured from backend (not hardcoded).
class GeofenceValidator {
  GeofenceValidator._();

  // School center coordinates (should be fetched from config API)
  // These are placeholder values for SMA Muhammadiyah Kasihan
  static const double _schoolLat = -7.801523;
  static const double _schoolLng = 110.323456;
  static const double _toleranceMeters = 100.0;

  /// Validate current position against school geofence.
  static Future<GeofenceResult> validate() async {
    // 1. Check if location services are enabled
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return const GeofenceServiceDisabled();
    }

    // 2. Check & request permission
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return const GeofencePermissionDenied();
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return const GeofencePermissionDenied();
    }

    // 3. Get current position (high accuracy)
    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );

    // 4. Calculate distance to school center
    final distanceMeters = Geolocator.distanceBetween(
      _schoolLat,
      _schoolLng,
      position.latitude,
      position.longitude,
    );

    // 5. Return result
    if (distanceMeters <= _toleranceMeters) {
      return GeofenceInside(distanceMeters);
    } else {
      return GeofenceOutside(distanceMeters);
    }
  }
}
