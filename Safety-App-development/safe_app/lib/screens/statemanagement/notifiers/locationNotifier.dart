// ignore_for_file: prefer_const_constructors

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:safe_app/services/providers/geolocation_provider.dart';

//final locationProvider =
 //   Provider<LocationProvider>((ref) => LocationProvider());

//final positionProvider = FutureProvider((ref) {
//  return ref.read(locationProvider).getCurrentPosition();
//});

//final locationController = StateNotifierProvider<LocationNotifier,Position>((ref) => LocationNotifier());

///
///notify context of mainscreen when user location is changed
///
class LocationNotifier extends StateNotifier<Position> {
  late LocationProvider locationProvider;
  LocationNotifier()
      : super(Position(
            longitude: 45.4336,
            latitude: -75.7229,
            timestamp: DateTime.now(),
            accuracy: 0.0,
            altitude: 0.0,
            heading: 0,
            speed: 0,
            speedAccuracy: 0)) {
    locationProvider = LocationProvider();
    
  }

  void getCurrentPosition() async {
    state = await locationProvider.getCurrentPosition();
  }
}
