import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'redux/app_state.dart';
import 'ui/home.dart';
import 'ui/components/auth/login.dart';
import 'ui/components/auth/signup.dart';
import 'ui/screens/packages.dart';
import 'ui/components/payment/payment_methods.dart';
import 'ui/components/payment/payment_history.dart';
import 'ui/screens/profile.dart';
import 'ui/components/payment/stripe.dart';
import 'redux/store.dart';
import 'ui/utilities/utilities.dart';

void main() {
  Admob.initialize("ca-app-pub-3940256099942544~3347511713");
  runApp(App(store: store));
}

class App extends StatelessWidget {
  // This widget is the root of your application.
  final Store<AppState> store;
  App({this.store});

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        title: 'BIGWIN',
        color: Color.fromRGBO(28, 28, 28, 1),
        theme: ThemeData(
          primaryColor: Color.fromRGBO(28, 28, 28, 1),
          accentColor: Color.fromRGBO(28, 28, 28, 1),
          fontFamily: "Raleway",
          buttonColor: Color.fromRGBO(241, 181, 3, 1),
          indicatorColor: Color.fromRGBO(241, 181, 3, 1),
          backgroundColor: Color.fromRGBO(35, 35, 35, 1),
          canvasColor: Colors.white,
          primaryColorDark: Color.fromRGBO(28, 28, 28, 1),
          primaryColorLight: Color.fromRGBO(20, 115, 230, 1)
        ),

        home: Home(),

        routes: <String, WidgetBuilder> {
          '/home': (BuildContext context) => Home(),
          '/login': (BuildContext context) => Login(),
          '/signup': (BuildContext context) => SignUp(),
          '/package': (BuildContext context) => PackageList(),
          '/payment': (BuildContext context) => PaymentMethods(),
          '/profile': (BuildContext context) => Profile(),
          '/stripe': (BuildContext context) => Stripe(),
          '/payment_history': (BuildContext context) => PaymentHistory(),
        },
    ),);
  }
}