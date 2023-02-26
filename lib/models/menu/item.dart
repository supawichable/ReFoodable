part of '_menu.dart';

@Freezed(unionKey: 'type')
class Item with _$Item {
  /// Use this to read data from Firestore
  const factory Item.data(
      {required String name,
      @PriceConverter() required Price price,
      required String addedBy,
      @TimestampConverter() required DateTime createdAt,
      @TimestampConverter() required DateTime updatedAt,
      @JsonKey(name: 'photoURL') String? photoURL}) = ItemData;

  /// Use this to generate payload to Firestore when creating a new item
  const factory Item.create(
      {required String name,
      @PriceConverter() required Price price,
      required String addedBy,
      @JsonKey(name: 'photoURL') String? photoURL}) = ItemCreate;

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

  static ItemData fromFirestore(
          DocumentSnapshot<Map<String, dynamic>> snapshot) =>
      ItemData.fromJson(snapshot.data()!);
}

extension ItemX on Item {
  ItemData? asData() => mapOrNull(
        data: (data) => data,
      )!;

  Map<String, dynamic> toFirestore() => toJson()
    ..putIfAbsent('created_at', FieldValue.serverTimestamp)
    ..putIfAbsent('updated_at', FieldValue.serverTimestamp);
}
