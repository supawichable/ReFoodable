part of '_item.dart';

@freezed
class Item with _$Item {
  const factory Item(
      {String? name,
      @PriceConverter() Price? price,
      String? addedBy,
      String? id,
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
