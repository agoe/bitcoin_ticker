import 'dart:convert';
import 'package:http/http.dart' as http;

class NetworkHelper {

  final String url;
  final String urlName;

  //static String responseErrMsg="";
  static String responseStatusCode="";
  static Map<String, String> _errMessages =Map<String, String>();

  static bool hasError(String urlName){
    return _errMessages.containsKey(urlName);
  }
  static String gerErrMsg(String urlName){
    return _errMessages.containsKey(urlName)? _errMessages[urlName] :'';
  }

  static  addErrMsg(String urlName,String errMsg){
    _errMessages.putIfAbsent(urlName, () => errMsg);
  }

  NetworkHelper(this.url,this.urlName);

  Future getData() async {
    try {
      try{_errMessages.remove(urlName);} catch(e){};
      responseStatusCode="";
      http.Response response = await http.get(url);
      responseStatusCode= responseStatusCode;
      if (response.statusCode == 200){
        print(response.body);
        /* double temp = jsonDecode(response.body)  ["main"]["temp"] as double;
      int id = jsonDecode(response.body) ["weather"][0]["id"] as int;
      String name = jsonDecode(response.body) ["name"] as String;
      print('Temperatur ${temp} id ${id}  City ${name}');*/
        return jsonDecode(response.body);
      }else {
        try {
          addErrMsg(urlName,  jsonDecode(response.body)['error'] as String);
        }
        catch(e){
          print('Response Status Code: '+response.statusCode.toString());
          print("Cannot jsondecode body to get error message");
          print(e);
        }
        print('Response ' + response.statusCode.toString());
        print( 'Respone reasonPhrase '+response.reasonPhrase);
        print( 'Respone body '+response.body);
      }
    }
    catch(e){
      print("get url: "+e.toString());
      addErrMsg(urlName,e.toString());
    }

  }

}