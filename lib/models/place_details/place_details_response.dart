import 'dart:convert';

class PlaceDetailsResponse {
  final String? status;
  final double? lat;
  final double? lng;

  PlaceDetailsResponse({this.status, this.lat, this.lng});

  factory PlaceDetailsResponse.fromJson(Map<String, dynamic> json) {
    return PlaceDetailsResponse(
        status: json['status'] as String?,
        lat: json['result']['geometry']['location']['lat'] as double?,
        lng: json['result']['geometry']['location']['lng'] as double?);
  }

  static PlaceDetailsResponse parsePlaceDetails(String responseBody) {
    final parsed = json.decode(responseBody).cast<String, dynamic>();
    return PlaceDetailsResponse.fromJson(parsed);
  }
}
