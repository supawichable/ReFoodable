import 'dart:typed_data';

import 'package:dart_geohash/dart_geohash.dart';

class GeoFire {
  static final GeoHasher _geoHasher = GeoHasher();

  static String getGeoHashForLocation(double latitude, double longitude) {
    return _geoHasher.encode(latitude, longitude);
  }
}
