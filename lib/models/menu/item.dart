part of '_menu.dart';

@freezed
class Item with _$Item {
  const factory Item(
      {required String name,
      @PriceConverter() required Price price,
      required String addedBy,
      @TimestampConverter() required DateTime createdAt,
      @TimestampConverter() required DateTime updatedAt}) = _Item;

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

  factory Item.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) =>
      Item.fromJson(snapshot.data()!);
}
