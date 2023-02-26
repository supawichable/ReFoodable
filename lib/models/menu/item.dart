part of '_menu.dart';

@Freezed(unionKey: 'type')
class Item with _$Item {
  /// Use this to parse data from Firestore \
  /// **This is for internal use only.** \
  /// The only part you need is `asData()`
  const factory Item.data(
      {required String name,
      @PriceConverter() required Price price,
      required String addedBy,
      @TimestampConverter() required DateTime createdAt,
      @TimestampConverter() required DateTime updatedAt,
      @JsonKey(name: 'photoURL') String? photoURL}) = ItemData;

  /// Use this to generate payload to Firestore when creating a new item
  ///
  /// Example:
  /// ```dart
  /// final item = Item.create(
  ///     name: 'My Item',
  ///     price: Price(
  ///       amount: 1000,
  ///       currency: Currency.jpy,
  ///     ),
  ///     addedBy: 'User ID',
  ///     photoURL: 'Photo URL',
  /// );
  ///
  /// final itemRef = FirebaseFirestore.instance.stores
  ///                   .doc(storeId).items.add(item);
  /// ```
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
  /// Convert [Item] to [ItemData] \
  /// This is to show `createdAt` and `updatedAt` \
  /// by making sure that you intend to read as data. \
  /// and not to create a new item.
  ///
  /// Example:
  /// ```dart
  /// final snapshot = await FirebaseFirestore.instance
  ///                    .stores.doc(storeId)
  ///                    .items.doc(itemId)
  ///                    .get();
  /// final item = snapshot.data()!.asData()!;
  /// ```
  ItemData? asData() => mapOrNull(
        data: (data) => data,
      )!;

  Map<String, dynamic> toFirestore() => toJson()
    ..putIfAbsent('created_at', FieldValue.serverTimestamp)
    ..putIfAbsent('updated_at', FieldValue.serverTimestamp);
}
