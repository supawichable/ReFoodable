import 'package:dart_geohash/dart_geohash.dart';
import 'package:gdsctokyo/models/store/_store.dart';

class GeoFire {
  static final GeoHasher _geoHasher = GeoHasher();

  static GeoHash getGeoHashForLocation(double latitude, double longitude) {
    return GeoHash(_geoHasher.encode(latitude, longitude));
  }

  /// Returns a list of geohashes that are within the given radius of the center
  ///
  /// Example:
  /// ```dart
  /// final bounds = GeoFire.getGeoHashQueryBounds(
  ///                  Location.fromGeoPoint(GeoPoint(0, 0)), 1000);
  /// for (final bound in bounds) {
  ///   final query = FirebaseFirestore.instance.stores
  ///                   .orderBy('location.geohash')
  ///                   .startAt(bound.startHash)
  ///                   .endAt(bound.endHash);
  ///  final querySnapshot = await query.get();
  /// // Do something with the querySnapshot
  // static List<Bound> getGeoHashQueryBounds(Location center, double radiusInM) {

  // }
}

class Bound {
  final String startHash;
  final String endHash;

  const Bound(this.startHash, this.endHash);
}
