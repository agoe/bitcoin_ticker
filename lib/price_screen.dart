import 'dart:io' show Platform;

import 'package:bitcoin_ticker/coin_data.dart';
import 'package:bitcoin_ticker/currency.dart';
import 'package:bitcoin_ticker/networking.dart';
import 'package:bitcoin_ticker/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();

}

class _PriceScreenState extends State<PriceScreen> {
  Currency selectedCurrency = Currency(exchangeRate: 1.0, symbol: 'EUR');
  double exchangeRate = null;
  String errMsg="";


  Map<String,Currency> currencies = new Map();


  DropdownButton<Currency> getAndroidDropDownButton() {
    List<DropdownMenuItem<Currency>> getDropDownItems() {
      List<DropdownMenuItem<Currency>> dropdownMenueItems = [];
      /*for (String currency in currenciesList) {
        var newItem = DropdownMenuItem(child: Text(currency), value: currency);
        dropdownMenueItems.add(newItem);
      }*/

      for (Currency currency in this.currencies.values) {
        var newItem = DropdownMenuItem<Currency>(child: Text('${currency.symbol} ${currency.exchangeRate}'), value: currency);
        print("CropCurreny ${currency.symbol}");
        dropdownMenueItems.add(newItem);
      }
      return dropdownMenueItems;
    }

    return DropdownButton<Currency>(
        value: selectedCurrency,
        items: getDropDownItems(),
        onChanged: (Currency value) {
          setState(() {
            selectedCurrency = value;
          });
        });
  }

  CupertinoPicker getIOSPicker() {
    return CupertinoPicker(
        itemExtent: 32.0,
        backgroundColor: Colors.lightBlue,
        onSelectedItemChanged: (selectedIndex) {
          print(selectedIndex);
        },
        children: getPickerCurrencyItems());
  }

  List<Text> getPickerCurrencyItems() {
    List<Text> pickerCurrencies = [];
    for (String currency in currenciesList) {
      var newItem = Text(currency);
      pickerCurrencies.add(newItem);
    }
    return pickerCurrencies;
  }
  @override
  void initState() {
    super.initState();
    getExchangeRate('BTC','EUR');// selectedCurrency);
    loadCurrencies();

  }

  void loadCurrencies() async{
     CurrencyModel currencyModel = CurrencyModel();
     currencies = await currencyModel.getCurrencies();
     if (currencies.length<=1){

       Future.delayed(Duration.zero, (){
         /*Get.defaultDialog(
            onConfirm: () {print("Ok");/*Navigator.pop(context);*/},
            middleText: "Dialog made in 3 lines of code");*/
         showOkAlertDialog(
           context: context,
           title: 'Only EURO Quotes',
           alertStyle: AdaptiveStyle.cupertino,
           message: 'error:'+NetworkHelper.gerErrMsg("FIAT"),
         );
       });
     }
     updateUIFiat(currencies);
  }

  void updateUICrypto(dynamic data) {
    setState(() {
      if (data == null) {
        exchangeRate = null;
        if(NetworkHelper.hasError("CRYPTO")){
          errMsg = NetworkHelper.gerErrMsg("CRYPTO");
        } else {
          errMsg = 'Exchangerate not available!';
        }
        return;
      }
      double rate = data['rate'] as double;
      exchangeRate = CurrencyModel.round2(rate);
    });
  }
  void updateUIFiat(Map<String,Currency> currenciesArg) {
    setState(() {
      if (currencies == null) {
        exchangeRate = null;
        if(NetworkHelper.hasError("FIAT")){
          errMsg = NetworkHelper.gerErrMsg( "FIAT");
        } else {
          errMsg = 'FiatQuotes not available!';
        }
        return;
      }
      this.currencies = currencies;
    });
  }

  Widget getPicker() {
    if (Platform.isIOS) {
      return getIOSPicker();
    } else if (Platform.isAndroid) {
      return getAndroidDropDownButton();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                child: Text(
                  '1 BTC = ${exchangeRate == null ? '?' :CurrencyModel.round2( exchangeRate* selectedCurrency.exchangeRate  )} ${selectedCurrency.symbol}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? getIOSPicker() : getAndroidDropDownButton(),
          ),
        ],
      ),
    );
  }

  dynamic  getExchangeRate  (String cryptoCur,String fiatCur) async {
    const String apiKey = 'CAC34217-5841-4748-8FE5-7082FEC14FEB';
    String url = 'http://localhost:3000/products/exchangerate/$cryptoCur/$fiatCur';
    String url2 = 'https://rest.coinapi.io/v1/exchangerate/$cryptoCur/$fiatCur?apikey=$apiKey';
    print(url);
    //String url = 'http://10.0.2.2:3000/products';
    //String url = 'http://localhost:3000/products';

    NetworkHelper nwH = NetworkHelper(url,"CRYPTO");
    dynamic  data = await nwH.getData();
    if (data == null){
      Future.delayed(Duration.zero, (){
        /*Get.defaultDialog(
            onConfirm: () {print("Ok");/*Navigator.pop(context);*/},
            middleText: "Dialog made in 3 lines of code");*/
        showOkAlertDialog(
          context: context,
          title: 'No Crypto Quotes available',
          alertStyle: AdaptiveStyle.cupertino,
          message: 'error:'+NetworkHelper.gerErrMsg("CRYPTO"),
        );
      });
    }
    updateUICrypto(data);
    return data;
  }

  double calcCryptoExchangeRate(double exchangeRateToEuro,String fiatSymbol){

    double fiatQuote = currencies[fiatSymbol].exchangeRate;

  }

}
