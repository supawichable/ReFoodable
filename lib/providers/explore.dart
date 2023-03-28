import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gdsctokyo/extension/firebase_extension.dart';
import 'package:gdsctokyo/models/explore/_explore.dart';
import 'package:gdsctokyo/util/logger.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:location/location.dart';
import 'package:rxdart/rxdart.dart';

final _geo = GeoFlutterFire();
final _fireStore = FirebaseFirestore.instance;

final currentLocationProvider =
    StateNotifierProvider<CurrentLocationNotifier, LocationState>(
  (ref) => CurrentLocationNotifier(),
);

class CurrentLocationNotifier extends StateNotifier<LocationState> {
  static final _location = Location();
  CurrentLocationNotifier() : super(const LocationState.standby());

  void _updateLocation(double latitude, double longitude) {
    state = LocationState.success(
      locationData: LocationData.fromMap({
        'latitude': latitude,
        'longitude': longitude,
      }),
      latLng: LatLng(latitude, longitude),
      geoFirePoint: GeoFirePoint(latitude, longitude),
    );
    return;
  }

  void setStateByLatLng(LatLng latLng) {
    _updateLocation(latLng.latitude, latLng.longitude);
  }

  void setStateByGeoFirePoint(GeoFirePoint geoFirePoint) {
    _updateLocation(geoFirePoint.latitude, geoFirePoint.longitude);
  }

  void setStateByLocationData(LocationData locationData) {
    if (locationData.latitude == null || locationData.longitude == null) {
      state = const LocationState.failure(
        message: 'Location is null',
      );

      return;
    }
    _updateLocation(locationData.latitude!, locationData.longitude!);
  }

  /// This internally sets the state to [LocationState.success] (if it is)
  /// but also returns the [LocationData] if you want to use it.
  /// Keep in mind that it doesn't return [LocationState] because
  /// that would be redundant.
  Future<LocationData?> getCurrentLocation() async {
    final locationData = await _location.getLocation();
    setStateByLocationData(locationData);
    return locationData;
  }
}

final mapControllerProvider =
    StateProvider<GoogleMapController?>((ref) => null);

/// This will be used to pass the query input to the stream
class StoreQueryInput {
  final double radius;
  final GeoFirePoint center;

  StoreQueryInput({required this.radius, required this.center});
}

final storeQueryInputProvider = StateNotifierProvider<StoreQueryInputNotifier,
    BehaviorSubject<StoreQueryInput>>((ref) => StoreQueryInputNotifier());

double calculateDistanceMath(lat1, lon1, lat2, lon2) {
  var p = 0.017453292519943295;
  var c = cos;
  var a = 0.5 -
      c((lat2 - lat1) * p) / 2 +
      c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
  return 12742 * asin(sqrt(a));
}

class StoreQueryInputNotifier
    extends StateNotifier<BehaviorSubject<StoreQueryInput>> {
  static final _queryInput = BehaviorSubject<StoreQueryInput>.seeded(
      StoreQueryInput(
          radius: 0, center: _geo.point(latitude: 0, longitude: 0)));

  StoreQueryInputNotifier() : super(_queryInput);

  void updateQueryInput(StoreQueryInput queryInput) {
    _queryInput.add(queryInput);
  }

  Future<void> updateStoreStreamFromMapController(
      GoogleMapController mapController) async {
    final visibleRegion = await mapController.getVisibleRegion();
    final northeast = visibleRegion.northeast;
    final southwest = visibleRegion.southwest;
    final center = LatLng((northeast.latitude + southwest.latitude) / 2,
        (northeast.longitude + southwest.longitude) / 2);

    final radiusMeasuringEdge = LatLng(center.latitude, northeast.longitude);

    /// Calculate distance between center and radiusMeasuringEdge
    final radius = calculateDistanceMath(center.latitude, center.longitude,
        radiusMeasuringEdge.latitude, radiusMeasuringEdge.longitude);

    updateQueryInput(StoreQueryInput(
        radius: radius,
        center: _geo.point(
            latitude: center.latitude, longitude: center.longitude)));
  }
}

final storesStreamProvider = StreamProvider<List<DocumentSnapshot>>((ref) {
  final queryInput = ref.read(storeQueryInputProvider);
  return queryInput.switchMap((input) {
    return _fireStore.stores.withinAsSingleStreamSubscription(
      input.center,
      input.radius,
    );
  });
});

final storeDistanceProvider = StateProvider<Map<String, String>>((ref) {
  return {};
});
