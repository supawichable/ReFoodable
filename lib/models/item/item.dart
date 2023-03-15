part of '_item.dart';

@freezed
class Item with _$Item {
  const factory Item(
      {String? name,
      @PriceConverter() Price? price,
      String? addedBy,
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
    ..putIfAbsent('created_at', FieldValue.serverTimestamp);
}
