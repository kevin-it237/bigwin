import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/event.dart';

class EventCard extends StatelessWidget {
  final Event event;

  EventCard(this.event);

  Color _setOddsColor(event) {
    if(event.live) {
      return Color.fromRGBO(20, 115, 230, 1);
    } else {
      // The event is finished
      if(event.won) {
        return Color.fromRGBO(19, 213, 45, 1);
      } else {
        return Color.fromRGBO(213, 19, 19, 1);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 12.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        color: Color.fromRGBO(28, 28, 28, 1),
        elevation: 10,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // First Column
            Container(
              padding: EdgeInsets.only(left: 10, top: 7, bottom: 8, right: 10),
              decoration: BoxDecoration(
                  color: Color.fromRGBO(17, 17, 17, 1),
                  borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(5.0),
                      topRight: const Radius.circular(5.0))),
              child:  Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    //child: Icon(Ionicons.md_football, size: 20, color: Colors.white,)
                    child: event.logo == null ? Icon(Ionicons.md_football, size: 20, color: Colors.white,) :
                    CachedNetworkImage(
                      width: 25,
                      height: 25,
                      placeholderFadeInDuration: Duration(seconds: 10),
                      imageUrl: event.logo,
                      placeholder: (context, url) => SizedBox(
                        child: CircularProgressIndicator(backgroundColor: Colors.white, strokeWidth: 2),
                        height: 12.0,
                        width: 12.0,
                      ),
                      errorWidget: (context, url, error) => Icon(Ionicons.md_football, size: 20, color: Colors.white,),
                    ),
                  ),
                  SizedBox(width: 10,),
                  Container(alignment: Alignment.center, child: Text(event.competition, style: TextStyle(color: Colors.white, fontSize: 13.0)),)
                ],
              )
            ),
            // SECOND Column
            Container(padding: EdgeInsets.only(top: 15, bottom: 15, left: 10, right: 10),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Color.fromRGBO(17, 17, 17, 1), width: 1), 
                left: BorderSide(color: Color.fromRGBO(17, 17, 17, 1), width: 1),
                right: BorderSide(color: Color.fromRGBO(17, 17, 17, 1), width: 1)),
                
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  // ODDS
                  Expanded(
                    flex: 17,
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: _setOddsColor(event),
                        borderRadius: new BorderRadius.all(Radius.circular(5.0))),
                      height: 75,
                      child: Text(event.odds, style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w900,color: Colors.white),),
                    ),
                  ),
                  // Paris infos
                  Expanded(
                    flex: 83,
                    child:  Container(
                      padding: EdgeInsets.only(left: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                          Text(event.match, style: TextStyle(fontSize: 12.0,color: Colors.white)),
                          Text(event.score, style: TextStyle(fontSize: 14.0,color: Colors.white, fontWeight: FontWeight.w600)),
                        ],),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Text(event.prono, style: TextStyle(fontSize: 18.5,color: Colors.white, fontWeight: FontWeight.bold)),),
                        Container(
                          margin: EdgeInsets.only(top: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                            Text(event.hour, style: TextStyle(fontSize: 11.0,color: Colors.white)),
                            Text(event.date, style: TextStyle(fontSize: 11.0,color: Colors.white)),
                        ],),)
                      ],),
                    ),
                  )
            ],),)
          ],
        ),
      ),
    );
  }
}