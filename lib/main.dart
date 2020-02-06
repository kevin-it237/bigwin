import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'redux/app_state.dart';
import 'ui/home.dart';
import 'ui/components/auth/login.dart';
import 'ui/components/auth/signup.dart';
import 'ui/screens/packages.dart';
import 'ui/components/payment_methods.dart';
import 'ui/screens/profile.dart';
import 'redux/store.dart';

void main() => runApp(App(store: store));

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
          canvasColor: Color.fromRGBO(20, 115, 230, 1),
          primaryColorDark: Color.fromRGBO(28, 28, 28, 1),
        ),

        home: Home(),

        routes: <String, WidgetBuilder> {
          '/home': (BuildContext context) => App(),
          '/login': (BuildContext context) => Login(),
          '/signup': (BuildContext context) => SignUp(),
          '/package': (BuildContext context) => PackageList(),
          '/payment': (BuildContext context) => PaymentMethods(),
          '/profile': (BuildContext context) => Profile(),
        },
    ),);
  }
}