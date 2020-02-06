import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  const Loader({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).accentColor,
      child: Center(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 100, horizontal: 100),
          children: <Widget>[
          Container(
            child: Image(image: AssetImage('assets/logo.png'))),
          SizedBox(height: 15,),
          Text(
            "Loading...",textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white
            ),
          ),
        ],)
      )
    );
  }
}