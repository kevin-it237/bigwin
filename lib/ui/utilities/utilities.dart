import 'package:flutter/material.dart';
import '../../models/event.dart';
import '../../models/package.dart';
import 'dart:convert';

class Utilities {

  static const String ROOT_URL = "http://betwin.isjetokoss.xyz";

  // Display Modal Messages
  static void displayDialog(String message, BuildContext context) {
    final _formKey = GlobalKey<FormState>();
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
    List allEvents = responseJson["data"];
    List<Event> eventsToDisplay = [];
    allEvents.forEach((event) {
      String match = event["fixture"]["home"]["name"]+ " - " +event["fixture"]["away"]["name"];
      String odds = event["cote"].toStringAsFixed(2); 
      String competition = event["fixture"]["league"]["name"];
      String logo = event["fixture"]["league"]["logo"];
      String score = event["fixture"]["score"];
      String prono = "";
      if(event["winner"] != null) {
        prono = event["winner"]["name"]+ " Win";
      } else {
        List pronoList = event["odds"];
        if(pronoList.length > 0) {
          prono = event["odds"][0]["label"];
          if(event["odd_goals_quotient"] != null) {
            prono = prono +" "+ event["odd_goals_quotient"].toString();
          }
        }
      }
      String date = event["fixture"]["event_date"].split(" ")[0]; 
      List longhour = event["fixture"]["event_date"].split(" ")[1].split(":"); 
      String hour = longhour[0]+":"+longhour[1];
      bool oldDisplayable = event["old_displayable"];
      String category = event["category_tip"];
      bool live = false;
      if(event["status"] == "waiting" || event["status"] == "pending") live = true;
      bool won = event["pronostic_is_win"];
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
      int price = package["price"];
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

