import 'package:bigwin/redux/store.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:convert';
import 'utilities.dart';

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();


// Get Free, Today and combo types
Future<http.Response> getTips(String url) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String accessToken = prefs.getString("openToken");
  if(accessToken == null) {
    String tokenUrl = Utilities.ROOT_URL + "/api/v1/auth/default-access-token";
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

// Get premium tips
Future<http.Response> getPremiumTips(String url) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accessToken = prefs.getString("token");
    var response = await http.get(url, headers: {"X-Requested-With": "XMLHttpRequest", "Authorization": "Bearer $accessToken"});
    return response;
  } catch (e) {
  }
}

// Get packages
Future<http.Response> getPackages(String url) async {
  try {
    String accessToken = store.state.accessToken;
    var response = await http.get(url, headers: {"X-Requested-With": "XMLHttpRequest", "Authorization": "Bearer $accessToken"});
    return response;
  } catch (e) {
  }
}

Future<http.Response> getUserInfos() async {
  try {
    String accessToken = store.state.accessToken;
    var url = Utilities.ROOT_URL + '/api/v1/auth/user';
    var response = await http.get(url, headers: {"X-Requested-With": "XMLHttpRequest", "Authorization": "Bearer $accessToken"});
    return response;
  } catch (e) {
  }
}

/// Send ID Token for notifications **/
void sendToken(String fCMToken, String authToken) async {
  String tokenUrl = Utilities.ROOT_URL + "/api/v1/auth/update-fcm-token";
  try {
  var tokenResponse = await http.post(tokenUrl, headers: {"X-Requested-With": "XMLHttpRequest",  "Authorization": "Bearer $authToken"},  body: {'token': fCMToken});
  final responseJson = json.decode(tokenResponse.body);
  print(responseJson);
  } catch (e) {
  print(e);
  }
}

void setFCMToken(String authToken) {
  _firebaseMessaging.getToken()
      .then((fCMtoken) {
  print(fCMtoken);
  sendToken(fCMtoken, authToken);
  })
      .catchError((onError) {
  print(onError);
  });
}
/// End **/