
import 'package:flutter/material.dart';
import 'package:HyCharge/Services/VehicleService.dart';
import 'package:HyCharge/model/CarManufacturerResponse.dart';
import 'package:HyCharge/model/EvModelResponse.dart';
import 'package:HyCharge/model/VehicleListResponse.dart';

class VehicleProvider extends ChangeNotifier {
  final VehicleService _service = VehicleService();

  bool isLoading = false;

  ///---------------------------------------------------------
  /// API DATA
  ///---------------------------------------------------------

  List<CarManufacturerData> manufacturers = [];

  List<EvModelData> evModels = [];

  List<Vehicle> userVehicles = [];

  ///---------------------------------------------------------
  /// TAB
  ///---------------------------------------------------------

  String selectedTab = "All";

  void changeTab(String tab) {
    selectedTab = tab;
    notifyListeners();
  }
List<String> get tabs {
  final names = manufacturers
      .map((e) => e.manufacturerName ?? "")
      .where((e) => e.isNotEmpty)
      .toSet() // removes duplicates
      .toList();

  return ["All", ...names];
}
  // List<String> get tabs {
  //   return [
  //     "All",
  //     ...manufacturers
  //         .map((e) => e.manufacturerName ?? "")
  //         .where((e) => e.isNotEmpty)
  //         .toList(),
  //   ];
  // }

  ///---------------------------------------------------------
  /// SEARCH
  ///---------------------------------------------------------

  String searchText = "";

  void searchVehicle(String value) {
    searchText = value;
    notifyListeners();
  }

  ///---------------------------------------------------------
  /// SELECTED MODEL
  ///---------------------------------------------------------

  EvModelData? selectedModel;

  void selectModel(EvModelData model) {
    selectedModel = model;
    notifyListeners();
  }

  ///---------------------------------------------------------
  /// USER VEHICLE
  ///---------------------------------------------------------

  Vehicle? selectedUserVehicle;

  void selectUserVehicle(Vehicle vehicle) {
    selectedUserVehicle = vehicle;
    notifyListeners();
  }

  ///---------------------------------------------------------
  /// FILTERED MODELS
  ///---------------------------------------------------------

  List<EvModelData> getFilteredModels(String tab) {
    List<EvModelData> list;

    if (tab == "All") {
      list = evModels;
    } else {
      final manufacturer = manufacturers.firstWhere(
        (e) => e.manufacturerName == tab,
        orElse: () => CarManufacturerData(),
      );

      if (manufacturer.recId == null) {
        return [];
      }

      list = evModels.where((e) {
        return e.manufacturerId == manufacturer.recId;
      }).toList();
    }

    if (searchText.isEmpty) {
      return list;
    }

    return list.where((e) {
      return (e.modelName ?? "")
          .toLowerCase()
          .contains(searchText.toLowerCase());
    }).toList();
  }

  ///---------------------------------------------------------
  /// GET MODELS BY MANUFACTURER
  ///---------------------------------------------------------

  List<EvModelData> getModelsByManufacturer(String manufacturerId) {
    return evModels.where((e) {
      return e.manufacturerId == manufacturerId;
    }).toList();
  }

  ///---------------------------------------------------------
  /// GET MANUFACTURERS
  ///---------------------------------------------------------

  Future<void> getManufacturers(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    final response = await _service.getCarManufacturer(context);

    if (response != null) {
      manufacturers = response.data ?? [];
    }
print("Manufacturer Count : ${manufacturers.length}");

for (var e in manufacturers) {
  print(e.manufacturerName);
}
    isLoading = false;
    notifyListeners();
  }

  ///---------------------------------------------------------
  /// GET EV MODELS
  ///---------------------------------------------------------

  Future<void> getEvModels(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    final response = await _service.getEvModels(context);

    if (response != null) {
      evModels = response.data ?? [];
    }

    isLoading = false;
    notifyListeners();
  }

  ///---------------------------------------------------------
  /// GET USER VEHICLES
  ///---------------------------------------------------------

  Future<void> getUserVehicleList(BuildContext context) async {
    print("getUserVehicleList 1");
    isLoading = true;
    notifyListeners();

    final response = await _service.getUserVehicleList(context);
     print("getUserVehicleList 2");
print(response);
    if (response != null) {
      userVehicles = response.vehicles;
    }

    isLoading = false;
    notifyListeners();
  }

  ///---------------------------------------------------------
  /// ADD VEHICLE
  ///---------------------------------------------------------

Future<bool> addVehicle(
  BuildContext context, {
  required String manufacturerId,
  required String modelId,
  required String registrationNumber,
}) async {
  isLoading = true;
  notifyListeners();

  final body = {
    "evManufacturerID": manufacturerId,
    "carModelID": modelId,
    "carRegistrationNumber": registrationNumber,
  };

  final response = await _service.addVehicle(context, body);
  print("object");
  print(response!.success);
  isLoading = false;
  notifyListeners();

  if (response != null && response.success == true) {
    await getUserVehicleList(context);
    return true;
  }

  return false;
}

  ///---------------------------------------------------------
  /// HELPERS
  ///---------------------------------------------------------

  String getManufacturerName(String? id) {
    try {
      return manufacturers
              .firstWhere((e) => e.recId == id)
              .manufacturerName ??
          "";
    } catch (_) {
      return "";
    }
  }

  String getModelName(String? id) {
    try {
      return evModels.firstWhere((e) => e.recId == id).modelName ?? "";
    } catch (_) {
      return "";
    }
  }

  EvModelData? getModel(String? id) {
    try {
      return evModels.firstWhere((e) => e.recId == id);
    } catch (_) {
      return null;
    }
  }

  CarManufacturerData? getManufacturer(String? id) {
    try {
      return manufacturers.firstWhere((e) => e.recId == id);
    } catch (_) {
      return null;
    }
  }

  ///---------------------------------------------------------
  /// LOAD ALL DATA
  ///---------------------------------------------------------

  Future<void> loadInitialData(BuildContext context) async {
    await Future.wait([
      getManufacturers(context),
      getEvModels(context),
      getUserVehicleList(context),
    ]);
  }
  String? selectedVehicleId;

void selectVehicle(String recId) {
  selectedVehicleId = recId;
  notifyListeners();
}
}