import 'package:http/http.dart' as http;
import 'package:bigwin/redux/store.dart';

class Payment {

  // Handle payment with stripe
  static Future<http.Response> payWithStripe(String cardNumber, String cardExpMonth, String cardExpYear, String cardCvc, int userId, int planId) async {
    String url = "http://betwin.isjetokoss.xyz/api/v1/stripe/subscribe";
    String accessToken = store.state.accessToken;
    var response = await http.post(url, headers: {"X-Requested-With": "XMLHttpRequest", "Authorization": "Bearer $accessToken"}, body: {
      "card_number": "4242424242424242",
      "card_exp_month": "11",
      "card_exp_year": "2020",
      "card_cvc": "123",
      "user_id": userId.toString(),
      "plan_id": planId.toString()
    });
    return response;
  }

  // Handle payment with OM
  static void payWithOrange() {

  }

  // Handle payment with MOMO
  static void payWithMomo() {

  }
}