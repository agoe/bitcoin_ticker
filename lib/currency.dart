

import 'package:flutter/foundation.dart';

class Currency{
  final double exchangeRate;
  final String symbol;
  final String name;

  Currency({@required this.exchangeRate, @required this.symbol, this.name});

  factory Currency.fromJson(dynamic json) {
    return Currency(exchangeRate: json['quantity'], symbol: json['name'] );
  }

  @override
  String toString() {
    return 'Currency{symbol: $symbol, name: $name}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Currency &&
          runtimeType == other.runtimeType &&
          symbol == other.symbol &&
          name == other.name;

  @override
  int get hashCode => symbol.hashCode ^ name.hashCode;
}