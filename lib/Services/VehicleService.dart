import 'package:HyCharge/Utils/APIManager.dart';
import 'package:HyCharge/model/CarManufacturerResponse.dart';
import 'package:HyCharge/model/EvModelResponse.dart';
import 'package:HyCharge/model/VehicleListResponse.dart';
import 'package:HyCharge/model/user_vehicle_model.dart';
import 'package:flutter/material.dart';

class VehicleService {
  Future<CarManufacturerResponse?> getCarManufacturer(
      BuildContext context) async {
    final result = await APIManager().apiRequest(
      context,
      API.carManufacturerList,
    );

    return result as CarManufacturerResponse;
  }

  Future<EvModelResponse?> getEvModels(
      BuildContext context,
     
  ) async {
    final result = await APIManager().apiRequest(
      context,
      API.evModelList,
      
    );

    return result as EvModelResponse;
  }

  Future<UserVehicleResponse?> addVehicle(
    BuildContext context,
    Map<String, dynamic> body,
  ) async {
    final result = await APIManager().apiRequest(
      context,
      API.userVehicleAdd,
      jsonval: body,
    );

    return result as UserVehicleResponse;
  }

  Future<VehicleListResponse?> getUserVehicleList(
      BuildContext context) async {
    final result = await APIManager().apiRequest(
      context,
      API.userVehicleList,
    );
 print("getUserVehicleList ${result}");

    return result as VehicleListResponse;
  }
}