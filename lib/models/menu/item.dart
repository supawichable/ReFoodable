part of '_menu.dart';

@freezed
class Item with _$Item {
  const factory Item(
      {required String id,
      required String name,
      required Price price,
      required DateTime updatedAt,
      required DateTime createdAt}) = _Item;

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

  factory Item.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) =>
      Item.fromJson({"id": snapshot.id, ...snapshot.data()!});
}
