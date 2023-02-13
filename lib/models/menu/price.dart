part of '_menu.dart';

@freezed
class Price with _$Price {
  const factory Price({
    required double price,
    required double compareAtPrice,
    required CurrencySymbol currency,
  }) = _Price;

  factory Price.fromJson(Map<String, dynamic> json) => _$PriceFromJson(json);
}

enum CurrencySymbol {
  @JsonValue('¥')
  jpy,
}
