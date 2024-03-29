part of '_store.dart';

@freezed
@Deprecated('Use [GeoFirePoint] instead')
class Location with _$Location {
  const factory Location({
    @GeoPointConverter() GeoPoint? geoPoint,
    @GeoHashConverter() GeoHash? geoHash,
  }) = _Location;

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);

  factory Location.fromGeoPoint(GeoPoint geoPoint) {
    return Location(
      geoPoint: geoPoint,
      geoHash: GeoFire.getGeoHashForLocation(
        geoPoint.latitude,
        geoPoint.longitude,
      ),
    );
  }
}
