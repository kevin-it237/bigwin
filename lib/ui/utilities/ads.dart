import 'package:admob_flutter/admob_flutter.dart';
import 'utilities.dart';

AdmobInterstitial interstitialAd = AdmobInterstitial(
  adUnitId: "ca-app-pub-3940256099942544/4411468910",
  listener: (AdmobAdEvent event, Map<String, dynamic> args) {
    if (event == AdmobAdEvent.loaded) print("Loaded");
    if (event == AdmobAdEvent.closed) interstitialAd.dispose();
    if (event == AdmobAdEvent.failedToLoad) {
      // Start hoping they didn't just ban your account :)
      print("Error code: ${args['errorCode']}");
    }
  },
);


void showInterstitial() async {
  interstitialAd.load();
  if (await interstitialAd.isLoaded) {
    interstitialAd.show();
  }
}