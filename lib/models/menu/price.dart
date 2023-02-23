part of '_menu.dart';

@freezed
class Price with _$Price {
  const factory Price({
    required double amount,
    required CurrencySymbol currency,
    double? compareAtPrice,
  }) = _Price;

  factory Price.fromJson(Map<String, dynamic> json) => _$PriceFromJson(json);
}

enum CurrencySymbol {
  jpy,
}

extension on CurrencySymbol {
  String get symbol {
    switch (this) {
      case CurrencySymbol.jpy:
        return '¥';
    }
  }
}
