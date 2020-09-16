import 'package:bitcoin_ticker/coin_data.dart';
import 'package:bitcoin_ticker/networking.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {

  String selectedCurrency = 'EUR';
  String exchangeRate = null;
  String errMsg="";

  List<DropdownMenuItem> getDropDownItems(){
    List<DropdownMenuItem<String>> dropdownMenueItems = [];
    for (String currency in currenciesList){
      var newItem = DropdownMenuItem(child: Text(currency),value: currency);
      dropdownMenueItems.add(newItem);
    }
    return dropdownMenueItems;
  }
  List<Text> getPickerCurrencys(){
    List<Text> pickerCurrencies = [];
    for (String currency in currenciesList){
      var newItem = Text(currency);
      pickerCurrencies.add(newItem);
    }
    return pickerCurrencies;
  }
  @override
  void initState() {
    super.initState();
    var data = getExchangeRate('BTC', selectedCurrency);
  }
  void updateUI(dynamic data) {
    setState(() {
      if (data == null) {
        exchangeRate = null;
        if(NetworkHelper.responseErrMsg.length>3){
          errMsg = NetworkHelper.responseErrMsg;
        } else {
          errMsg = 'Exchangerate not available!';
        }
        return;
      }
      double rate = data['rate'] as double;
      exchangeRate = (rate).toStringAsFixed(2);
    });
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
                  '1 BTC = ${exchangeRate?? '?'} USD',
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
            /*child: DropdownButton(
                value: selectedCurrency,
                items: getDropDownItems(),
                onChanged: (value) {
                  setState(() {
                    selectedCurrency = value;
                  });
                }),*/
            child: CupertinoPicker(itemExtent: 32.0,
                onSelectedItemChanged: (selectedIndex) {
              print(selectedIndex);
            }, children: getPickerCurrencys()),
          ),
        ],
      ),
    );
  }

  dynamic  getExchangeRate  (String cryptoCur,String fiatCur) async {
    const String apiKey = 'CAC34217-5841-4748-8FE5-7082FEC14FEB';
    String url = 'https://rest.coinapi.io/v1/exchangerate/$cryptoCur/$fiatCur?apikey=$apiKey';
    print(url);
    //String url = 'http://10.0.2.2:3000/products';
    //String url = 'http://localhost:3000/products';

    NetworkHelper nwH = NetworkHelper(url);
    dynamic  data = await nwH.getWeatherData();
    updateUI(data);
    return data;
  }
}
