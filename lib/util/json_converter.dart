import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_geohash/dart_geohash.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gdsctokyo/models/item/_item.dart';
import 'package:gdsctokyo/models/store/_store.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';

class GeoPointConverter extends JsonConverter<GeoPoint, GeoPoint> {
  const GeoPointConverter();

  @override
  GeoPoint fromJson(GeoPoint json) => json;

  @override
  GeoPoint toJson(GeoPoint object) => object;
}

class GeoHashConverter extends JsonConverter<GeoHash, String> {
  const GeoHashConverter();

  @override
  GeoHash fromJson(String json) => GeoHash(json);

  @override
  String toJson(GeoHash object) => object.geohash;
}

class LocationConverter extends JsonConverter<Location, Map<String, dynamic>> {
  const LocationConverter();

  @override
  Location fromJson(Map<String, dynamic> json) {
    final geoPoint = json['geo_point'] as GeoPoint?;
    final geoHash = json['geo_hash'] as String?;
    if (geoPoint == null || geoHash == null) {
      return const Location(
        geoPoint: null,
        geoHash: null,
      );
    }
    return Location(
      geoPoint: const GeoPointConverter().fromJson(geoPoint),
      geoHash: const GeoHashConverter().fromJson(geoHash),
    );
  }

  @override
  Map<String, dynamic> toJson(Location object) {
    return {
      'geo_point': object.geoPoint == null
          ? null
          : const GeoPointConverter().toJson(object.geoPoint!),
      'geo_hash': object.geoHash == null
          ? null
          : const GeoHashConverter().toJson(object.geoHash!),
    }..removeWhere((key, value) => value == null);
  }
}

class GeoFirePointConverter
    extends JsonConverter<GeoFirePoint?, Map<String, dynamic>> {
  const GeoFirePointConverter();

  @override
  GeoFirePoint? fromJson(Map<String, dynamic> json) {
    final geoPoint = json['geopoint'] as GeoPoint?;

    if (geoPoint == null) {
      return null;
    }

    return GeoFlutterFire()
        .point(latitude: geoPoint.latitude, longitude: geoPoint.longitude);
  }

  @override
  Map<String, dynamic> toJson(GeoFirePoint? object) {
    return {
      'geopoint': object?.geoPoint,
      'geohash': object?.hash,
    };
  }
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

class PriceConverter extends JsonConverter<Price, Map<String, dynamic>> {
  const PriceConverter();

  @override
  Price fromJson(Map<String, dynamic> json) {
    return Price(
      amount: (json['amount'] as num).toDouble(),
      currency: Currency.values.firstWhere(
        (e) => e.toString() == 'Currency.${json['currency']}',
      ),
      compareAtPrice: (json['compare_at_price'] as num?)?.toDouble(),
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
