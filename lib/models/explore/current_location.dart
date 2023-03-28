part of '_explore.dart';

@Freezed(unionKey: 'result')
class LocationState with _$LocationState {
  const factory LocationState.success({
    required LocationData locationData,
    required LatLng latLng,
    required GeoFirePoint geoFirePoint,
  }) = LocationSuccess;

  const factory LocationState.standby() = LocationStandby;

  const factory LocationState.failure({
    required String message,
  }) = LocationFailure;
}
