import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gdsctokyo/models/menu/_menu.dart';
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

class CollectionReferenceConverter
    extends JsonConverter<CollectionReference, CollectionReference> {
  const CollectionReferenceConverter();

  @override
  CollectionReference fromJson(json) => json;

  @override
  CollectionReference toJson(CollectionReference object) => object;
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

class PriceConverter extends JsonConverter<Price, Map<String, dynamic>> {
  const PriceConverter();

  @override
  Price fromJson(Map<String, dynamic> json) {
    return Price(
      amount: (json['amount'] as num).toDouble(),
      currency: CurrencySymbol.values.firstWhere(
        (e) => e.toString() == 'CurrencySymbol.${json['currency']}',
      ),
      compareAtPrice: (json['compare_at_price'] as num).toDouble(),
    );
  }

  @override
  Map<String, dynamic> toJson(Price object) {
    return {
      'amount': object.amount,
      'currency': object.currency.name,
      'compare_at_price': object.compareAtPrice,
    };
  }
}
