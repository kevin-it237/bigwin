import 'package:redux/redux.dart';
import './app_state.dart';
import './middleware.dart';
import './reducers.dart';

final store = Store<AppState>(
    reducer,
    initialState: AppState(),
    middleware: getMiddlewares()
);