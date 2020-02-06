import 'package:flutter/material.dart';
import 'package:bigwin/models/package.dart';
import 'package:bigwin/redux/store.dart';
import 'package:bigwin/ui/components/error_refresh.dart';
import 'package:bigwin/ui/components/loader.dart';
import 'package:bigwin/redux/actions.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../components/package_card.dart';
import '../../redux/app_state.dart';

class PackageList extends StatefulWidget {
  PackageList({Key key}) : super(key: key);

  @override
  _PackageListState createState() => _PackageListState();
}

class _PackageListState extends State<PackageList> {

 final RefreshController _refreshController = RefreshController(initialRefresh: false);

 @override
  void initState() {
    if(store.state.packageList == null) {
      store.dispatch(StartFetchPackages());
    }
    super.initState();
  }

  void _onRefresh() async{
    store.dispatch(StartFetchPackages());
    _refreshController.refreshCompleted();
  }

  //  Display packages
  Widget buildWidget(state, String screen) {
    if(state.packagesLoadingState == PackageLoadingState.LOADING) {
      return Loader();
    } else if(state.packagesLoadingState == PackageLoadingState.SUCCESS) {
      // Filter data to get today tips
      List<Package> packages = state.packageList;
      return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: packages.length,
        itemBuilder: (BuildContext context, int index) {
          return PackageCard(packages[index]);
        });
    } else {
      return ErrorRefresh(screen: screen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subscription'),
        backgroundColor: Color.fromRGBO(28, 28, 28, 1),
      ),
      body: StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          return Container(
            color: Color.fromRGBO(247, 248, 249, 1),
            child: SmartRefresher(
              enablePullDown: true,
              header: WaterDropMaterialHeader(backgroundColor: Color.fromRGBO(241, 181, 3, 1)),
              controller: _refreshController,
              onRefresh: _onRefresh,
              child: buildWidget(state, "PACKAGE")
            ) 
          );
        },
      )
    );
  }
}