import 'package:redux/redux.dart';
import '../models/package.dart';
import '../models/event.dart';
import '../ui/utilities/apiCall.dart';
import '../ui/utilities/utilities.dart';
import './app_state.dart';
import './actions.dart';

List<Middleware<AppState>> getMiddlewares() {
  return [
    TypedMiddleware<AppState, StartFetchTodayTips>(_doFetchTodatMiddleware()),
    TypedMiddleware<AppState, StartFetchComboTips>(_doFetchComboMiddleware()),
    TypedMiddleware<AppState, StartFetchOldTips>(_doFetchOldMiddleware()),
    TypedMiddleware<AppState, StartFetchPremiumTips>(_doFetchPremiumMiddleware()),
    TypedMiddleware<AppState, StartFetchPackages>(_doFetchPackagesMiddleware()),
  ];
}

Middleware<AppState> _doFetchTodatMiddleware() {
  return (Store<AppState> store, action, NextDispatcher next) {
    next(action);

    if (action is StartFetchTodayTips) {
      try {
        String url = Utilities.ROOT_URL + "/api/v1/predict/getpredict";
        getTips(url).then((response) {
          List<Event> allEvents = Utilities.makeEvents(response);
          // Filter event by category
          allEvents = allEvents.where((e) => e.category == "Today's Tips").toList();
          store.dispatch(GetTodayTips(results: allEvents));
        }).catchError((error) {
          print(error);
          store.dispatch(FetchFailedTodayTips());
        });
      } catch (e) {
        store.dispatch(FetchFailedTodayTips());
      }
    }
  };
}

Middleware<AppState> _doFetchComboMiddleware() {
  return (Store<AppState> store, action, NextDispatcher next) {
    next(action);

    if (action is StartFetchComboTips) {
      String url = Utilities.ROOT_URL + "/api/v1/predict/getpredict";
      try {
        getTips(url).then((response) {
          List<Event> allEvents = Utilities.makeEvents(response);
          // Filter event by category
          allEvents = allEvents.where((e) => e.category == "Combo Tips").toList();
          store.dispatch(GetComboTips(results: allEvents));
        }
        ).catchError((error) {
          store.dispatch(FetchFailedComboTips());
        });
      } catch (e) {
        store.dispatch(FetchFailedComboTips());
      }
    }
  };
}

Middleware<AppState> _doFetchOldMiddleware() {
  return (Store<AppState> store, action, NextDispatcher next) {
    next(action);

    if (action is StartFetchOldTips) {
      String url = Utilities.ROOT_URL + "/api/v1/pronostics?tip=old";
      try {
        getTips(url).then((response) {
          List<Event> allEvents = Utilities.makeEvents(response);
          // Filter event by category
          allEvents = allEvents.where((e) => e.category == "VIP Tips").toList();
          store.dispatch(GetOldTips(results: allEvents));
        }
        ).catchError((error) {
          store.dispatch(FetchFailedOldTips());
        });
      } catch (e) {
        store.dispatch(FetchFailedOldTips());
      }
    }
  };
}

Middleware<AppState> _doFetchPremiumMiddleware() {
  return (Store<AppState> store, action, NextDispatcher next) {
    next(action);

    if (action is StartFetchPremiumTips) {
      try {
        String url = Utilities.ROOT_URL + "/api/v1/predict/getpredict";
        getPremiumTips(url).then((response) {
          List<Event> allEvents = Utilities.makeEvents(response);
          store.dispatch(GetPremiumTips(results: allEvents));
        }
        ).catchError((error) {
          store.dispatch(FetchFailedPremiumTips());
        });
      } catch (e) {
        store.dispatch(FetchFailedPremiumTips());
      }
    }
  };
}

Middleware<AppState> _doFetchPackagesMiddleware() {
  return (Store<AppState> store, action, NextDispatcher next) {
    next(action);

    if (action is StartFetchPackages) {
      try {
        String url = Utilities.ROOT_URL + "/api/v1/plans";
        getPackages(url).then((response) {
          List<Package> allPackages = Utilities.makePackages(response);
          store.dispatch(GetPackages(results: allPackages));
        }
        ).catchError((error) {
          store.dispatch(FetchFailedPackages());
        });
      } catch (e) {
        store.dispatch(FetchFailedPackages());
      }
    }
  };
}