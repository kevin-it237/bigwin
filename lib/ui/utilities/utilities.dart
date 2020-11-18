import 'package:flutter/material.dart';
import '../../models/event.dart';
import '../../models/package.dart';
import 'dart:convert';

class Utilities {

  static const String ROOT_URL = "http://josspredictfoot.herokuapp.com";

  static const String AD_MOB_ID = "ca-app-pub-4621796908396700~5537551260";

  static const String AD_BANNER_UNIT_ID = "ca-app-pub-4621796908396700/9308085943";

  static const String AD_INTER_UNIT_ID = "ca-app-pub-4621796908396700/9308085943";

  // Display Modal Messages
  static void displayDialog(String message, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Infos"),
          content: Text(message),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Construct single Event
  static List<Event> makeEvents(response) {
    final responseJson = json.decode(response.body);
    List allEvents = responseJson;
    List<Event> eventsToDisplay = [];
    allEvents.forEach((event) {
      String match = event["fixture"]["homeTeam"]["team_name"]+ " - " +event["fixture"]["awayTeam"]["team_name"];
      String odds = event["coast"].toStringAsFixed(2); 
      String competition = event["championship"]["name"];
      String logo = event["championship"]["logo"];
      String score = "";
      String prono = event["prediction"];
      String date = event["date"]; 
      String hour = event["fixture"]["event_date"];
      bool oldDisplayable = true;
      String category = event["type_prediction"];
      bool live = false;
      if(event["fixture"]["statuts"] == "PENDING") live = true;
      bool won = event["iswin"];
      // Create an event
      Event newEvent = Event(competition: competition, match: match, odds: odds, score: score, prono: prono, hour: hour, date: date, won: won, live: live, logo: logo, category: category, oldDisplayable: oldDisplayable);
      eventsToDisplay.add(newEvent);
    });
    return eventsToDisplay;
  }

  // Construct single package (Payment options)
  static List<Package> makePackages(response) {
    final responseJson = json.decode(response.body);
    List<Package> packages = [];
    List allPackages = responseJson["data"];
    allPackages.forEach((package) {
      int id = package["id"];
      String name = package["name"];
      double price = package["price"];
      String interval = package["interval"];
      int intervalCount = package["interval_count"];
      String categoryTip = package["category_tip"];
       
      // Create a package
      Package newPackage = Package(id: id, name: name, price: price, interval: interval, intervalCount: intervalCount, categoryTip: categoryTip);
      packages.add(newPackage);
    });
    return packages;
  }
}

