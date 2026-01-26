import 'package:ev_charging_app/Provider/HubProvider.dart';
import 'package:ev_charging_app/Screens/Controller/discount_widget.dart';
import 'package:ev_charging_app/Screens/Controller/filter_chips_widget.dart';
import 'package:ev_charging_app/Screens/Controller/mapMarkers.dart';
import 'package:ev_charging_app/Screens/Controller/map_controller.dart';
import 'package:ev_charging_app/Screens/Controller/station_card_widget.dart';
import 'package:ev_charging_app/Screens/SearchBarWidget.dart';
import 'package:ev_charging_app/Screens/auth/login_bottom_sheet.dart';
import 'package:ev_charging_app/Utils/AuthStorage.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
class MapScreen extends StatefulWidget {
  final bool isLogin;
  const MapScreen({super.key, this.isLogin = false});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late MapController controller;
  late String mapsStyle;
  @override
 void initState()  {
    super.initState();
    controller = MapController();
    print("LOGGED IN init");
loadData();
  }
loadData() {
 WidgetsBinding.instance.addPostFrameCallback((_) async {
   mapsStyle = await DefaultAssetBundle.of(context)
       .loadString('assets/map_styles/dark_map.json');
      context.read<HubProvider>().loadHubs(context);
      // if (!widget.isLogin) {
      //   showLoginSheet(context);
      // }
      final isLoggedIn = await AuthStorage.isLoggedIn();
      print("LOGGED IN ${isLoggedIn}");
    if (!isLoggedIn) {
      showLoginSheet(context);
    }
    });
}
  void showLoginSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
     builder: (_) {
      return WillPopScope(
        onWillPop: () async => false, // ❌ BACK BUTTON BLOCKED
        child: const LoginSheetWidget(),
      );
    },
    );
  }
@override
Widget build(BuildContext context) {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarBrightness: Brightness.light,
    statusBarIconBrightness:Brightness.light
  ));
  return Consumer<HubProvider>(
    builder: (_, hubProvider, __) {
      // Zoom to first marker once
      // if (!hubProvider.hasZoomedToFirst &&
      //     hubProvider.firstMarkerPosition != null) {
      //   WidgetsBinding.instance.addPostFrameCallback((_) {
      //     controller.zoomTo(hubProvider.firstMarkerPosition!);
      //     hubProvider.hasZoomedToFirst = true;
      //   });
      // }
      return Scaffold(
        body: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                // target location
                target: controller.center,
                // target: hubProvider.firstMarkerPosition!,
                zoom: 12,
                tilt: 45,
                bearing: 0,
              ),
              myLocationEnabled: false,
              myLocationButtonEnabled: false,
              markers: hubProvider.markers,
              onMapCreated: controller.onMapCreated,
              onCameraIdle: () {
                // hubProvider.loadHubs(context);
              },
              zoomControlsEnabled: false,
              style: mapsStyle,
              compassEnabled: false,
              mapToolbarEnabled: false,
              buildingsEnabled: false,
              trafficEnabled: false,
              polylines: hubProvider.polyLines,
              onTap: (LatLng){
                print('MapScreen Click');
                // hubProvider.clearRoute();
              },
              onLongPress: (LatLong) async {
                print('MapScreen Click');
                hubProvider.clearRoute();
                // final Position position = await MapController().getCurrentPosition();
                // // drawRoute(LatLng(19.262147, 72.983966), LatLng(19.193039, 72.953840));
                // hubProvider.drawRoute(LatLng(position.latitude, position.longitude), LatLng(19.196262, 72.962967));

              },

            ),
            const Positioned(top: 60, left: 20, right: 20, child: SearchBarWidget()),
            const Positioned(top: 130, left: 20, child: FilterChipsWidget()),
            const Positioned(top: 190, right: 20, child: DiscountWidget(label: "10 %")),
            if (hubProvider.isRouteLoading)
              const Center(child: CircularProgressIndicator(color: Colors.green,)),

           /* if (hubProvider.loading)
              const Center(child: CircularProgressIndicator()),
            const Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: StationCardWidget(),
            ),*/
          ],
        ),
      );
    },
  );
}

}
