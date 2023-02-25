part of '_menu.dart';

@freezed
class Price with _$Price {
  const factory Price({
    required double amount,
    required Currency currency,
    double? compareAtPrice,
  }) = _Price;

  factory Price.fromJson(Map<String, dynamic> json) => _$PriceFromJson(json);
}

@JsonEnum(valueField: 'symbol')
enum Currency {
  @JsonValue('¥')
  jpy,
}
