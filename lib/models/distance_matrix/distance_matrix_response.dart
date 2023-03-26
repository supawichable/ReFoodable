import 'dart:convert';

import 'package:flutter/widgets.dart';

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
    List<DistanceMatrixItem>? returnResponses = [];
    json['rows'].asMap().forEach((key, value) {
      returnResponses.add(DistanceMatrixItem(
          status: value['elements'][0]['status'],
          text: value['elements'][0]['status'] == 'OK'
              ? value['elements'][0]['distance']['text']
              : null,
          value: value['elements'][0]['status'] == 'OK'
              ? value['elements'][0]['distance']['value']
              : null));
    });
    return DistanceMatrixResponse(
        status: json['status'], responses: returnResponses);
  }

  static DistanceMatrixResponse parseDistanceMatrix(String responseBody) {
    final parsed = json.decode(responseBody).cast<String, dynamic>();
    return DistanceMatrixResponse.fromJson(parsed);
  }
}
