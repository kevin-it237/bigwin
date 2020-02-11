import '../models/event.dart';
import '../models/package.dart';

class AppState {
  String accessToken;
  Map<String, dynamic> userData;
  List<Event> todayTips;
  List<Event> comboTips;
  List<Event> premiumTips;
  List<Event> oldTips;
  List<Package> packageList;
  final TodayLoadingState todayLoadingState;
  final ComboLoadingState comboLoadingState;
  final PremiumLoadingState premiumLoadingState;
  final OldLoadingState oldLoadingState;
  final PackageLoadingState packagesLoadingState;

  AppState({
    this.todayTips,
    this.comboTips,
    this.premiumTips,
    this.oldTips,
    this.packageList,
    this.accessToken = "",
    this.userData,
    this.todayLoadingState = TodayLoadingState.LOADING,
    this.comboLoadingState = ComboLoadingState.LOADING, 
    this.premiumLoadingState = PremiumLoadingState.LOADING, 
    this.oldLoadingState = OldLoadingState.LOADING, 
    this.packagesLoadingState = PackageLoadingState.LOADING
  });

  AppState copy({
    String accessToken,
    Map<String, dynamic> userData,
    List<Event> todayTips,
    List<Event> comboTips,
    List<Event> premiumTips,
    List<Event> oldTips,
    List<Package> packageList,
    TodayLoadingState todayLoadingState,
    ComboLoadingState comboLoadingState,
    PremiumLoadingState premiumLoadingState,
    OldLoadingState oldLoadingState,
    PackageLoadingState packagesLoadingState
  }) => AppState(
      oldTips: oldTips ?? this.oldTips,
      todayTips: todayTips ?? this.todayTips,
      premiumTips: premiumTips ?? this.premiumTips,
      comboTips: comboTips ?? this.comboTips,
      packageList: packageList ?? this.packageList,
      oldLoadingState: oldLoadingState ?? this.oldLoadingState,
      todayLoadingState: todayLoadingState ?? this.todayLoadingState,
      comboLoadingState: comboLoadingState ?? this.comboLoadingState,
      premiumLoadingState: premiumLoadingState ?? this.premiumLoadingState,
      packagesLoadingState: packagesLoadingState ?? this.packagesLoadingState,
      accessToken: accessToken ?? this.accessToken,
      userData: userData ?? this.userData
  );
}

enum TodayLoadingState {
  LOADING,
  SUCCESS,
  FAILED
}

enum ComboLoadingState {
  LOADING,
  SUCCESS,
  FAILED
}

enum OldLoadingState {
  LOADING,
  SUCCESS,
  FAILED
}

enum PremiumLoadingState {
  LOADING,
  SUCCESS,
  FAILED
}

enum PackageLoadingState {
  LOADING,
  SUCCESS,
  FAILED
}
