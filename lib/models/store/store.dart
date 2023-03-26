part of '_store.dart';

@freezed
class Store with _$Store {
  const factory Store({
    String? name,
    @GeoFirePointConverter() GeoFirePoint? location,
    String? ownerId,
    @TimestampConverter() DateTime? createdAt,
    @TimestampConverter() DateTime? updatedAt,

    ///  Location is required, so address might not be needed
    String? address,
    String? email,
    String? phone,
    String? photoURL,
    List<FoodCategory>? category,
  }) = _Store;

  factory Store.fromJson(Map<String, dynamic> json) => _$StoreFromJson(json);

  static Store fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) =>
      Store.fromJson(snapshot.data()!);
}

extension StoreX on Store {
  Map<String, dynamic> toFirestore() => toJson()
    ..update('updated_at', (_) => FieldValue.serverTimestamp(),
        ifAbsent: FieldValue.serverTimestamp)
    ..putIfAbsent('created_at', FieldValue.serverTimestamp);
}

/// enums for food category
/// add more as needed
enum FoodCategory {
  japanese,
}

extension Prop on FoodCategory {
  String get name {
    switch (this) {
      case FoodCategory.japanese:
        return 'Japanese';
    }
  }

  IconData get icon {
    switch (this) {
      case FoodCategory.japanese:
        return Icons.restaurant;
    }
  }
}
