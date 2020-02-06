import 'package:redux/redux.dart';
import './app_state.dart';
import './actions.dart';

final reducer = combineReducers<AppState>([
  TypedReducer<AppState, SetToken>(_setTokenActionReducer),

  TypedReducer<AppState, StartFetchTodayTips>(_dofetchTodayReducer),
  TypedReducer<AppState, GetTodayTips>(_getfetchTodayReducer),
  TypedReducer<AppState, FetchFailedTodayTips>(_fetchFailedTodayReducer),

  TypedReducer<AppState, StartFetchComboTips>(_dofetchComboReducer),
  TypedReducer<AppState, GetComboTips>(_getfetchComboReducer),
  TypedReducer<AppState, FetchFailedComboTips>(_fetchFailedComboReducer),

  TypedReducer<AppState, StartFetchOldTips>(_dofetchOldReducer),
  TypedReducer<AppState, GetOldTips>(_getfetchOldReducer),
  TypedReducer<AppState, FetchFailedOldTips>(_fetchFailedOldReducer),

  TypedReducer<AppState, StartFetchPremiumTips>(_dofetchPremiumReducer),
  TypedReducer<AppState, GetPremiumTips>(_getfetchPremiumReducer),
  TypedReducer<AppState, FetchFailedPremiumTips>(_fetchFailedPremiumReducer),  
  
  TypedReducer<AppState, StartFetchPackages>(_dofetchPackageReducer),
  TypedReducer<AppState, GetPackages>(_getfetchPackageReducer),
  TypedReducer<AppState, FetchFailedPackages>(_fetchFailedPackageReducer),
]);

AppState _setTokenActionReducer(AppState appState, SetToken action) {
  return appState.copy(
    accessToken: action.token
  );
}

// TODAY TIPS REDUCERS
AppState _dofetchTodayReducer(AppState appState, StartFetchTodayTips action) {
  return appState.copy(
    todayLoadingState: TodayLoadingState.LOADING,
    todayTips: []
  );
}

AppState _getfetchTodayReducer(AppState appState, GetTodayTips action) {
  return appState.copy(
    todayLoadingState: TodayLoadingState.SUCCESS,
    todayTips: action.results
  );
}

AppState _fetchFailedTodayReducer(AppState appState, FetchFailedTodayTips action) {
  return appState.copy(
    todayLoadingState: TodayLoadingState.FAILED
  );
}

// COMBO TIPS REDUCERS
AppState _dofetchComboReducer(AppState appState, StartFetchComboTips action) {
  return appState.copy(
    comboLoadingState: ComboLoadingState.LOADING,
    comboTips: []
  );
}

AppState _getfetchComboReducer(AppState appState, GetComboTips action) {
  return appState.copy(
    comboLoadingState: ComboLoadingState.SUCCESS,
    comboTips: action.results
  );
}

AppState _fetchFailedComboReducer(AppState appState, FetchFailedComboTips action) {
  return appState.copy(
    comboLoadingState: ComboLoadingState.FAILED
  );
}

// OLD TIPS REDUCERS
AppState _dofetchOldReducer(AppState appState, StartFetchOldTips action) {
  return appState.copy(
    oldLoadingState: OldLoadingState.LOADING,
    oldTips: []
  );
}

AppState _getfetchOldReducer(AppState appState, GetOldTips action) {
  return appState.copy(
    oldLoadingState: OldLoadingState.SUCCESS,
    oldTips: action.results
  );
}

AppState _fetchFailedOldReducer(AppState appState, FetchFailedOldTips action) {
  return appState.copy(
    oldLoadingState: OldLoadingState.FAILED
  );
}

// PREMIUM TIPS REDUCERS
AppState _dofetchPremiumReducer(AppState appState, StartFetchPremiumTips action) {
  return appState.copy(
    premiumLoadingState: PremiumLoadingState.LOADING,
    premiumTips: []
  );
}

AppState _getfetchPremiumReducer(AppState appState, GetPremiumTips action) {
  return appState.copy(
    premiumLoadingState: PremiumLoadingState.SUCCESS,
    premiumTips: action.results
  );
}

AppState _fetchFailedPremiumReducer(AppState appState, FetchFailedPremiumTips action) {
  return appState.copy(
    premiumLoadingState: PremiumLoadingState.FAILED
  );
}

// PACKAGE LIST REDUCERS
AppState _dofetchPackageReducer(AppState appState, StartFetchPackages action) {
  return appState.copy(
    packagesLoadingState: PackageLoadingState.LOADING,
    packageList: []
  );
}

AppState _getfetchPackageReducer(AppState appState, GetPackages action) {
  return appState.copy(
    packagesLoadingState: PackageLoadingState.SUCCESS,
    packageList: action.results
  );
}

AppState _fetchFailedPackageReducer(AppState appState, FetchFailedPackages action) {
  return appState.copy(
    packagesLoadingState: PackageLoadingState.FAILED
  );
}