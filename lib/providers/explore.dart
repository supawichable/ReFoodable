import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gdsctokyo/extension/firebase_extension.dart';
import 'package:gdsctokyo/models/explore/_explore.dart';
import 'package:gdsctokyo/models/store/_store.dart';
import 'package:gdsctokyo/util/logger.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:location/location.dart' as location;
import 'package:rxdart/rxdart.dart';
import 'package:google_maps_webservice_ex/places.dart' as places_ex;

final _geo = GeoFlutterFire();
final _fireStore = FirebaseFirestore.instance;
final _places =
    places_ex.GoogleMapsPlaces(apiKey: dotenv.get('ANDROID_GOOGLE_API_KEY'));

final currentLocationProvider =
    StateNotifierProvider<CurrentLocationNotifier, LocationState>(
  (ref) => CurrentLocationNotifier(),
);

class CurrentLocationNotifier extends StateNotifier<LocationState> {
  static final _location = location.Location();
  CurrentLocationNotifier() : super(const LocationState.standby());

  void _updateLocation(double latitude, double longitude) {
    state = LocationState.success(
      locationData: location.LocationData.fromMap({
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

  void setStateByLocationData(location.LocationData locationData) {
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
  Future<location.LocationData?> getCurrentLocation() async {
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
  return acos(
          sin(lat1) * sin(lat2) + cos(lat1) * cos(lat2) * cos(lon2 - lon1)) *
      6371;
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

final placesProvider = StreamProvider((ref) {
  final queryInput = ref.read(storeQueryInputProvider);
  return queryInput.switchMap((input) {
    final nearByConvenienceStoreFuture = _places.searchNearbyWithRadius(
      places_ex.Location(
          lat: input.center.latitude, lng: input.center.longitude),
      input.radius,
      keyword: 'コンビニ',
      type: 'convenience_store',
    );

    final nearBySuperMarketFuture = _places.searchNearbyWithRadius(
        places_ex.Location(
            lat: input.center.latitude, lng: input.center.longitude),
        input.radius,
        keyword: 'スーパー',
        type: 'supermarket');

    // convert into stream and combine both stream with an arbitrary function combinePlaces
    // you can use `combinePlaces` however you want. I will implement the function later
    return Rx.combineLatest2(Stream.fromFuture(nearByConvenienceStoreFuture),
        Stream.fromFuture(nearBySuperMarketFuture),
        (places_ex.PlacesSearchResponse convenienceStoreResponse,
            places_ex.PlacesSearchResponse superMarketResponse) {
      return [
        ...convenienceStoreResponse.results,
        ...superMarketResponse.results
      ];
    });
  });
});

final placesAndStoresWrapperProvider = StateProvider((ref) {
  final AsyncValue<List<places_ex.PlacesSearchResult>> places =
      ref.watch(placesProvider);
  final AsyncValue<List<DocumentSnapshot<Object?>>> storeDocuments =
      ref.watch(storesStreamProvider);

  final placesWCommonFields = places.whenOrNull(
          data: (data) =>
              data.where((place) => place.geometry != null).map((place) {
                final object = PlaceOrStore(
                    id: place.placeId,
                    name: place.name,
                    address: place.formattedAddress,
                    types: place.types,
                    geoFirePoint: _geo.point(
                        latitude: place.geometry!.location.lat,
                        longitude: place.geometry!.location.lng),
                    type: PlaceOrStoreType.place);

                return object;
              }).toList()) ??
      [];

  final storesWCommonFields = storeDocuments.whenOrNull(
          data: (data) => data
              .map((storeDoc) {
                final store =
                    Store.fromJson(storeDoc.data() as Map<String, dynamic>);
                if (store.location == null || store.name == null) {
                  return null;
                }
                // remove from places if placeId matches the place.id and the location is very close
                placesWCommonFields.removeWhere((place) =>
                    place.id == store.placeId &&
                    place.geoFirePoint.distance(
                            lat: store.location!.latitude,
                            lng: store.location!.longitude) <
                        0.1);

                return PlaceOrStore(
                    id: storeDoc.id,
                    name: store.name!,
                    address: store.address,
                    types: store.category?.map((e) => e.name).toList() ?? [],
                    geoFirePoint: store.location!,
                    type: PlaceOrStoreType.store);
              })
              .whereType<PlaceOrStore>()
              .toList()) ??
      [];

  final placesAndStores = [...placesWCommonFields, ...storesWCommonFields];
  return placesAndStores;
});

enum PlaceOrStoreType { place, store }

class PlaceOrStore {
  final PlaceOrStoreType type;
  final String id;
  final String name;
  final String? address;
  final List<String> types;
  final GeoFirePoint geoFirePoint;

  PlaceOrStore(
      {required this.id,
      required this.name,
      required this.address,
      required this.types,
      required this.geoFirePoint,
      required this.type});
}

final storeDistanceProvider = StateProvider<Map<String, String>>((ref) {
  return {};
});
