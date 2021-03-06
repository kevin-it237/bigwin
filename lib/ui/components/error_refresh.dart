import 'package:bigwin/redux/actions.dart';
import 'package:bigwin/redux/store.dart';
import 'package:flutter/material.dart';

class ErrorRefresh extends StatelessWidget {
  final String screen;
  ErrorRefresh({Key key, this.screen}) : super(key: key);

  void onTap() {
    store.dispatch(StartFetchTodayTips());
    store.dispatch(StartFetchComboTips());
    store.dispatch(StartFetchOldTips());
    store.dispatch(StartFetchPremiumTips());
    store.dispatch(StartFetchPackages());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor,
      child: Center(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 100, horizontal: 100),
          children: <Widget>[
          Container(
            child: Image(image: AssetImage('assets/logo.png'))),
          SizedBox(height: 15,),
          Text(
            "Loading Failed.",textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white
            ),
          ),
          SizedBox(height: 13,),
          InkWell(
            child: Text("Reload", style: TextStyle(color: Theme.of(context).buttonColor, fontSize: 17, fontWeight: FontWeight.w600),textAlign: TextAlign.center,),
            onTap: () => onTap() ,
          ),
        ],)
      )
    );
  }
}