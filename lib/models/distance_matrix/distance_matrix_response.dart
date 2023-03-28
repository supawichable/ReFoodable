import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:gdsctokyo/util/logger.dart';

class DistanceMatrixItem {
  final String? status;
  final String? text;
  final double? value;

  DistanceMatrixItem({this.status, this.text, this.value});
}

class DistanceMatrixResponse {
  final String? status;
  final List<DistanceMatrixItem>? responses;

  DistanceMatrixResponse({this.status, this.responses});

  factory DistanceMatrixResponse.fromJson(Map<String, dynamic> json) {
    final rows = json['rows'] as List?;
    if (rows?.isEmpty ?? true) {
      // INVALID_REQUEST らしい
      return DistanceMatrixResponse(status: json['status'], responses: []);
    }
    final List<DistanceMatrixItem> returnResponses = (rows?[0]?['elements']
                as List?)
            ?.map((response) => DistanceMatrixItem(
                status: response['status'] as String?,
                text: response['distance']?['text'] as String?,
                value: (response['distance']?['value'] as num?)?.toDouble()))
            .toList() ??
        [];
    return DistanceMatrixResponse(
        status: json['status'], responses: returnResponses);
  }

  static DistanceMatrixResponse parseDistanceMatrix(String responseBody) {
    final parsed = json.decode(responseBody).cast<String, dynamic>();
    return DistanceMatrixResponse.fromJson(parsed);
  }
}
