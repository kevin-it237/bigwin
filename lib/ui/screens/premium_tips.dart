import 'package:bigwin/models/event.dart';
import 'package:bigwin/redux/store.dart';
import 'package:bigwin/ui/components/error_refresh.dart';
import 'package:bigwin/ui/components/event_card.dart';
import 'package:bigwin/ui/components/loader.dart';
import 'package:bigwin/ui/components/no_game.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:bigwin/redux/actions.dart';

import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../redux/app_state.dart';

class PremiumTips extends StatefulWidget {
  PremiumTips({Key key}) : super(key: key);

  @override
  _PremiumTipsState createState() => _PremiumTipsState();
}

class _PremiumTipsState extends State<PremiumTips> {
  bool _isVip = false;
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  void pushToSubscribe(BuildContext context) {
    Navigator.pushNamed(context, "/package");
  }
  
  void pushToLogin(BuildContext context) {
    Navigator.pushNamed(context, "/login");
  }

  void _onRefresh() async {
    store.dispatch(StartFetchPremiumTips());
    _refreshController.refreshCompleted();
  }

  Widget buildWidget(state, String screen) {
    if(state.premiumLoadingState == PremiumLoadingState.LOADING) {
      return Loader();
    } else if(state.premiumLoadingState == PremiumLoadingState.SUCCESS) {
      // Filter data to get today tips
      List<Event> premiumTips = state.premiumTips;
      if(premiumTips.length > 0) {
        return ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: premiumTips.length,
          itemBuilder: (BuildContext context, int index) {
            return EventCard(premiumTips[index]);
          });
      } else {
        return NoGame();
      }
    } else {
      return ErrorRefresh(screen: screen);
    }
  }

  Widget buildContent(state) {
    if(state.accessToken != "") {
      return
        FlatButton(
          onPressed: () => pushToSubscribe(context),
          child: Text("See Packages", style: TextStyle(fontSize: 13.0, color: Colors.white, fontWeight: FontWeight.w600),),
          color: Color.fromRGBO(19, 213, 45, 1));
    } else {
      if(_isVip) {
        return StoreConnector<AppState, AppState>(
          converter: (store) => store.state,
          builder: (context, state) {
            return Container(
              padding: EdgeInsets.only(left: 3.0, right: 3.0, bottom: 5.0),
              child: SmartRefresher(
                enablePullDown: true,
                header: WaterDropMaterialHeader(backgroundColor: Color.fromRGBO(241, 181, 3, 1)),
                controller: _refreshController,
                onRefresh: _onRefresh,
                child: buildWidget(state, "PREMIUM")
              ) 
            );
          },
        );
      } else {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: Text("Subscribe Premium Tips to receive our best betting tips (Higher Odds, Higher Success Rate).", style: TextStyle(color: Colors.white, fontSize: 16.5), textAlign: TextAlign.center,),
            ),
            SizedBox(height: 15,),
            FlatButton(
                onPressed: () => pushToLogin(context),
                child: Text("Switch to VIP mode", style: TextStyle(fontSize: 13.0, color: Colors.black, fontWeight: FontWeight.w600),),
                color: Theme.of(context).buttonColor,)
          ],
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        return Container(
          alignment: Alignment.center,
          child: buildContent(state)
        );
      },
    );
  }
}