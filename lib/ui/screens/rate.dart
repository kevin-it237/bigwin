import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:rate_my_app/rate_my_app.dart';

class Rate extends StatefulWidget {
  Rate({Key key}) : super(key: key);

  @override
  _RateState createState() => _RateState();
}

RateMyApp rateMyApp = RateMyApp(
  preferencesPrefix: 'rateMyApp_',
  minDays: 7,
  minLaunches: 10,
  remindDays: 7,
  remindLaunches: 10,
  googlePlayIdentifier: 'fr.skyost.example',
  appStoreIdentifier: '1491556149',
);

class _RateState extends State<Rate> {

  void share(BuildContext context) {
    final RenderBox box = context.findRenderObject();
    Share.share('Download BIGWIN and enjoy hundreds of football tips each day for free. https://app.bigwin.com', 
    subject: 'Check out our app',
    sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  void rateApp() {
    rateMyApp.init().then((_) {
      rateMyApp.showRateDialog(
      context,
      title: 'Rate this app', // The dialog title.
      message: 'If you like this app, please take a little bit of your time to review it !\nIt really helps us and it shouldn\'t take you more than one minute.', // The dialog message.
      rateButton: 'RATE', // The dialog "rate" button text.
      // noButton: 'NO THANKS', // The dialog "no" button text.
      laterButton: 'MAYBE LATER', // The dialog "later" button text.
      listener: (button) { // The button click listener (useful if you want to cancel the click event).
        switch(button) {
          case RateMyAppDialogButton.rate:
            print('Clicked on "Rate".');
            break;
          case RateMyAppDialogButton.later:
            print('Clicked on "Later".');
            break;
          case RateMyAppDialogButton.no:
            print('Clicked on "No".');
            break;
        }
        return true; // Return false if you want to cancel the click event.
      },
      ignoreIOS: false, // Set to false if you want to show the native Apple app rating dialog on iOS.
      dialogStyle: DialogStyle(), // Custom dialog styles.
    );
  });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(20),
       child: ListView(
         children: <Widget>[
          SizedBox(height: 40,),
          Icon(Icons.thumb_up, size: 60, color: Colors.white,),
          SizedBox(height: 20,),
          Text("We Care Your Opinion!", style: TextStyle(fontSize: 23, color: Colors.white, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
          SizedBox(height: 15,),
          Text("Please consider rating our app.", style: TextStyle(fontSize: 16, color: Colors.white), textAlign: TextAlign.center,),
          Text("Ratings allow us to make the app better.", style: TextStyle(fontSize: 16, color: Colors.white), textAlign: TextAlign.center,),
          SizedBox(height: 15,),
          Text("Please share our app with your friends to support us..", style: TextStyle(fontSize: 16, color: Colors.white), textAlign: TextAlign.center,),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
              child: FlatButton(
              onPressed: () => share(context),
              child: Text("Share", style: TextStyle(fontSize: 13.0, color: Colors.black, fontWeight: FontWeight.w600),),
              color: Colors.white,
            ),),
            SizedBox(width: 20,),
            Container(
              padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
              child: FlatButton(
              onPressed: rateApp,
              child: Text("Rate", style: TextStyle(fontSize: 13.0, color: Colors.white, fontWeight: FontWeight.w600),),
              color: Theme.of(context).primaryColorLight,
            ),),
          ],)
         ],
       ),
    );
  }
}