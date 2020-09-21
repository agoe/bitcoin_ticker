

import 'dart:collection';

import 'package:bitcoin_ticker/currency.dart';
import 'package:bitcoin_ticker/networking.dart';
import 'package:get/get.dart';

const String apiKey = 'b49b64a9010c7637af890fcc03d25bc6';

class CurrencyModel {


  Future<Map<String, Currency>> getCurrencies() async {
    Map<String, Currency> currencies = SplayTreeMap<String, Currency>();
    String url = 'http://localhost:3000/products/fiatquotes/eur';
    print("getCurrencies");
    print(url);
    NetworkHelper nwH = NetworkHelper(url, "FIAT");
    dynamic data = await nwH.getData();
    if (data == null) {
      currencies['EUR'] = Currency(exchangeRate: 1.0, symbol: 'EUR');
      return currencies;
    }
    Map<String, dynamic> rates = data['rates'];

    rates.forEach((key, value) =>
    currencies[key] = (Currency(exchangeRate: value, symbol: key)));
    currencies['EUR'] = Currency(exchangeRate: 1.0, symbol: 'EUR');
    //currencies.sort((a,b) => a.symbol.compareTo(b.symbol));
    return currencies;
  }

  static double round2(double num){
    return  (( num *100).roundToDouble())/100;
  }
}