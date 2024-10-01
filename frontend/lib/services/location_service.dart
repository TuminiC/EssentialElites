import '../models/resource.dart';
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;


class LocationService {

  static final LocationService _instance = LocationService._internal();

  factory LocationService() {
    return _instance;
  }

  LocationService._internal();
  Position? _lastPosition;
  List<Resource>? _cachedResources;

  Future<bool> requestLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }
  Future<List<Resource>> getNearbyResources() async {
    bool hasPermission = await requestLocationPermission();
    if (!hasPermission) {
      throw Exception('Location permission not granted');
    }
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      if (_lastPosition != null &&
          _cachedResources != null &&
          Geolocator.distanceBetween(
            _lastPosition!.latitude,
            _lastPosition!.longitude,
            position.latitude,
            position.longitude,
          ) < 1000) {
        // If the current position is within 100 meters of the last position, return cached resources
        print('Using cached resources');
        return _cachedResources!;
      }
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/resources'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'latitude': position.latitude, 'longitude': position.longitude}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _cachedResources = (data['resources'] as List)
        .map((resource) => Resource.fromJson(resource))
        .toList();
        _lastPosition = position;
        print(_cachedResources);
        return _cachedResources!;
      } else {
        throw Exception('Failed to load resources');
      }
    } catch (e) {
      print('Error getting resources: $e');
      rethrow;
    }
  }
}
  
  
