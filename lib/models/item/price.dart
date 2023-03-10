part of '_item.dart';

@freezed
class Price with _$Price {
  const factory Price({
    required double amount,
    required Currency currency,
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
