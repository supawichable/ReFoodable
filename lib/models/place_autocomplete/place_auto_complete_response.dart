import 'dart:convert';

import 'package:gdsctokyo/models/place_autocomplete/autocomplete_prediction.dart';

/// The Autocomplete response contains place predictions and status
class PlaceAutocompleteResponse {
  final String? status;
  final List<AutocompletePrediction>? predictions;

  PlaceAutocompleteResponse({this.status, this.predictions});

  factory PlaceAutocompleteResponse.fromJson(Map<String, dynamic> json) {
    return PlaceAutocompleteResponse(
        status: json['status'] as String?,
        predictions: json['predictions']
            ?.map<AutocompletePrediction>(
                (json) => AutocompletePrediction.fromJson(json))
            .toList());
  }

  static PlaceAutocompleteResponse parseAutocompleteResult(
      String responseBody) {
    final parsed = json.decode(responseBody).cast<String, dynamic>();

    return PlaceAutocompleteResponse.fromJson(parsed);
  }
}
