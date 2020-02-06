import '../models/event.dart';
import '../models/package.dart';
// Set User token 
class SetToken {
  final String token;

  SetToken({this.token});
}

// TODAY TIPS STATE MANAGEMENT
class StartFetchTodayTips {}

class GetTodayTips {
  final List<Event> results;

  GetTodayTips({this.results});
}

class FetchFailedTodayTips {}

// COMBO TIPS STATE MANAGEMENT
class StartFetchComboTips {}

class GetComboTips {
  final List<Event> results;

  GetComboTips({this.results});
}

class FetchFailedComboTips {}

// OLD TIPS STATE MANAGEMENT
class StartFetchOldTips {}

class GetOldTips {
  final List<Event> results;

  GetOldTips({this.results});
}

class FetchFailedOldTips {}

// PREMIUM TIPS STATE MANAGEMENT
class StartFetchPremiumTips {}

class GetPremiumTips {
  final List<Event> results;

  GetPremiumTips({this.results});
}

class FetchFailedPremiumTips {}

// PACKAGES LIST  STATE MANAGEMENT
class StartFetchPackages {}

class GetPackages {
  final List<Package> results;

  GetPackages({this.results});
}

class FetchFailedPackages {}
