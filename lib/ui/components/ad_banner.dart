import 'package:flutter/material.dart';
import 'package:admob_flutter/admob_flutter.dart';
import '../utilities/utilities.dart';

class AbBanner extends StatelessWidget {
  const AbBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: AdmobBanner(
        adUnitId: "ca-app-pub-3940256099942544/2934735716",
        adSize: AdmobBannerSize.BANNER,
        listener: (AdmobAdEvent event, Map<String, dynamic> args) {
          switch (event) {
            case AdmobAdEvent.loaded:
              print('Admob banner loaded!');
              break;

            case AdmobAdEvent.opened:
              print('Admob banner opened!');
              break;

            case AdmobAdEvent.closed:
              print('Admob banner closed!');
              break;

            case AdmobAdEvent.failedToLoad:
              print('Admob banner failed to load. Error code: ${args['errorCode']}');
              break;

            default:
              print("Nothing");
          }
        }
      ),
    );
  }
}
