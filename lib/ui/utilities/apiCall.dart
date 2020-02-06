import 'package:bigwin/redux/store.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

Future<http.Response> getTips(String url) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String accessToken = prefs.getString("openToken");
  if(accessToken == null) {
    String tokenUrl = "http://betwin.isjetokoss.xyz/api/v1/auth/default-access-token";
    try {
      var tokenResponse = await http.get(tokenUrl, headers: {"X-Requested-With": "XMLHttpRequest"});
      final responseJson = json.decode(tokenResponse.body);
      accessToken = responseJson["data"]["access_token"];
    } catch (e) {
      print(e);
    }
  }
  var response = await http.get(url, headers: {"X-Requested-With": "XMLHttpRequest", "Authorization": "Bearer $accessToken"});
  return response;
}

Future<http.Response> getPackages(String url) async {
  String accessToken = store.state.accessToken;
  var response = await http.get(url, headers: {"X-Requested-With": "XMLHttpRequest", "Authorization": "Bearer $accessToken"});
  return response;
}