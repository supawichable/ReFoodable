import 'dart:convert';

class DistanceMatrixResponse {
  final String? status;
  final String? distance;

  DistanceMatrixResponse({this.status, this.distance});

  factory DistanceMatrixResponse.fromJson(Map<String, dynamic> json) {
    return DistanceMatrixResponse(
      status: json['status'] as String?,
      distance: json['rows'][0]['elements']?[0]['distance']?['text'],
    );
  }

  static DistanceMatrixResponse parseDistanceMatrix(String responseBody) {
    final parsed = json.decode(responseBody).cast<String, dynamic>();
    return DistanceMatrixResponse.fromJson(parsed);
  }
}
