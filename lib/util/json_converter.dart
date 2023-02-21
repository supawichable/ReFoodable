import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gdsctokyo/models/result/_result.dart';

class GeoPointConverter extends JsonConverter<GeoPoint, GeoPoint> {
  const GeoPointConverter();

  @override
  GeoPoint fromJson(json) => json;

  @override
  GeoPoint toJson(GeoPoint object) => object;
}

class TimestampConverter extends JsonConverter<DateTime, Timestamp> {
  const TimestampConverter();

  @override
  DateTime fromJson(Timestamp json) {
    return json.toDate();
  }

  @override
  Timestamp toJson(DateTime object) {
    return Timestamp.fromDate(object);
  }
}

class DocumentReferenceConverter
    extends JsonConverter<DocumentReference, DocumentReference> {
  const DocumentReferenceConverter();

  @override
  DocumentReference fromJson(json) => json;

  @override
  DocumentReference toJson(DocumentReference object) => object;
}

class ResultErrorConverter extends JsonConverter<ResultError, Map> {
  const ResultErrorConverter();

  @override
  ResultError fromJson(Map json) {
    return ResultError(message: json['message'], code: json['code']);
  }

  @override
  Map toJson(ResultError object) {
    return {'message': object.message, 'code': object.code};
  }
}
