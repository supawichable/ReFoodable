part of '_item.dart';

@freezed
class Price with _$Price {
  const factory Price({
    double? amount,
    @Default(Currency.jpy) Currency currency,
    double? compareAtPrice,
  }) = _Price;

  factory Price.fromJson(Map<String, dynamic> json) => _$PriceFromJson(json);
}

enum Currency {
  jpy,
}

extension CurrencySymbol on Currency {
  String get symbol {
    switch (this) {
      case Currency.jpy:
        return '¥';
    }
  }
}
