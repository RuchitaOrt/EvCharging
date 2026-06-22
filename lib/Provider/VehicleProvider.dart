// import 'package:HyCharge/Services/user_vehicle_service.dart';
// import 'package:HyCharge/Services/vehicle_service.dart';
// import 'package:HyCharge/model/VehicleListResponse.dart';
// import 'package:HyCharge/model/user_vehicle_update_response.dart';
// import 'package:flutter/material.dart';

// class VehicleProvider extends ChangeNotifier {
//   final VehicleApiService _repo = VehicleApiService();

//   bool loading = false;
//   List<Vehicle> vehicles = [];

//   Future<void> loadVehicles(BuildContext context) async {
//     loading = true;
//     notifyListeners();

//     try {
//       final response = await _repo.getUserVehicleList(context);
//       vehicles = response;
//     } catch (e) {
//       debugPrint("Vehicle load error: $e");
//     }

//     loading = false;
//     notifyListeners();
//   }

// }
import 'package:HyCharge/model/VehicleModel.dart';
import 'package:flutter/material.dart';

class VehicleProvider extends ChangeNotifier {

  int selectedIndex = -1;

  String selectedTab = "All";

  List<VehicleModel> vehicles = [];

  List<VehicleModel> get filteredVehicles {

    if(selectedTab == "All"){
      return vehicles;
    }

    return vehicles
        .where((e) => e.brand == selectedTab)
        .toList();
  }

  void changeTab(String tab){
    selectedTab = tab;
    notifyListeners();
  }

  void selectVehicle(int id){

    for(var item in vehicles){
      item.isSelected = item.id == id;
    }

    selectedIndex = id;

    notifyListeners();
  }
}