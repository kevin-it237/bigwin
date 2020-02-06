import 'package:bigwin/models/event.dart';
import 'package:bigwin/redux/actions.dart';
import 'package:bigwin/redux/store.dart';
import 'package:bigwin/ui/components/error_refresh.dart';
import 'package:bigwin/ui/components/event_card.dart';
import 'package:bigwin/ui/components/loader.dart';
import 'package:bigwin/ui/components/no_game.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../../redux/app_state.dart';

class OldTips extends StatelessWidget {

  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  void _onRefresh() async{
    store.dispatch(StartFetchOldTips());
    _refreshController.refreshCompleted();
  }

  //  Display pronostiques
  Widget buildWidget(state, String screen) {
    if(state.oldLoadingState == OldLoadingState.LOADING) {
      return Loader();
    } else if(state.oldLoadingState == OldLoadingState.SUCCESS) {
      // Filter data to get today tips
      List<Event> oldTips = state.oldTips;
      if(oldTips.length > 0) {
        return ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: oldTips.length,
          itemBuilder: (BuildContext context, int index) {
            return EventCard(oldTips[index]);
          });
      } else {
        return NoGame();
      }
    } else {
      return ErrorRefresh(screen: screen);
    }
  }

  @override
  Widget build(BuildContext context) {
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
            child: buildWidget(state, "OLD")
          ) 
        );
      },
    );
  }
}