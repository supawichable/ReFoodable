part of '_item.dart';

@freezed
class Item with _$Item {
  /// Use this to parse data from Firestore \
  /// **This is for internal use only.** \
  /// The only part you need is `asData()`
  const factory Item(
      {required String name,
      @PriceConverter() required Price price,
      required String addedBy,
      @TimestampConverter() DateTime? createdAt,
      @TimestampConverter() DateTime? updatedAt,
      String? photoURL}) = _Item;

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

  static Item fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) =>
      Item.fromJson(snapshot.data()!);
}

extension ItemX on Item {
  Map<String, dynamic> toFirestore() => toJson()
    ..update('updated_at', (_) => FieldValue.serverTimestamp(),
        ifAbsent: FieldValue.serverTimestamp)
    ..update('created_at', (_) => FieldValue.serverTimestamp(),
        ifAbsent: FieldValue.serverTimestamp);
}
