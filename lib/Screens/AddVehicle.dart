import 'package:ev_charging_app/Screens/MyVehicleScreen.dart';
import 'package:ev_charging_app/Screens/SelectVehicle.dart';
import 'package:ev_charging_app/Utils/CommonAppBar.dart';
import 'package:ev_charging_app/Utils/commoncolors.dart';
import 'package:ev_charging_app/Utils/commonimages.dart';
import 'package:ev_charging_app/Utils/commonstrings.dart';
import 'package:ev_charging_app/main.dart';
import 'package:ev_charging_app/widget/CustomDropdownField.dart';
import 'package:ev_charging_app/widget/TextWithAsterisk.dart';
import 'package:flutter/material.dart';
class VehicleUnit {
  final String image;
  final String type;

  VehicleUnit({required this.image, required this.type});
}

class AddVehicleScreen extends StatefulWidget {
   AddVehicleScreen({super.key});

  @override
  State<AddVehicleScreen> createState() => _AddehicleScreenState();
}

class _AddehicleScreenState extends State<AddVehicleScreen> {
  String? _selectedManufacturer;

  String? _selectedModel;

  String? _selectedRegistrationNo;

  String? _selectedBatteryType;

  String? _selectedBatteryCapacity;

  // Manufacturer
  String? get selectedManufacturer => _selectedManufacturer;

  set selectedManufacturer(String? value) {
    _selectedManufacturer = value;
    
  }

  // Model
  String? get selectedModel => _selectedModel;

  set selectedModel(String? value) {
    _selectedModel = value;
   
  }

  // Registration No
  String? get selectedRegistrationNo => _selectedRegistrationNo;

  set selectedRegistrationNo(String? value) {
    _selectedRegistrationNo = value;
    
  }

  // Battery Type
  String? get selectedBatteryType => _selectedBatteryType;

  set selectedBatteryType(String? value) {
    _selectedBatteryType = value;
   
  }

  // Battery Capacity
  String? get selectedBatteryCapacity => _selectedBatteryCapacity;

  set selectedBatteryCapacity(String? value) {
    _selectedBatteryCapacity = value;
   
  }

// Vehicle Manufacturers
final List<String> vehicleManufacturers = [
  "Tata",
  "Mahindra",
  "Hyundai",
  "MG",
  "Kia",
  "Hero Electric",
  "Ather",
  "Ola"
];

// Models
final List<String> vehicleModels = [ "Nexon EV", "Tiago EV", "Tigor EV"];

final List<String> vehicleRegNO = [ "MH043229999", "MH043999999", "MH0432299"];

// Battery Type
final List<String> batteryTypes = [
  "Lithium-ion",
  "LFP",
  "NMC",
  "Lead Acid"
];

// Battery Capacity (kWh)
final List<String> batteryCapacity = [
  "2.5 kWh",
  "3.0 kWh",
  "15 kWh",
  "24 kWh",
  "30 kWh",
  "40 kWh",
  "60 kWh"
];

  String selectedPlug = 'Plug Type A';

  int selectedUnitsIndex = 2;

final List<VehicleUnit> vehicleUnits = [
  VehicleUnit(image: CommonImagePath.veh1, type: "Type A"),
  VehicleUnit(image: CommonImagePath.veh2, type: "Type B"),
  VehicleUnit(image: CommonImagePath.veh3, type: "Type C"),
  VehicleUnit(image: CommonImagePath.veh4, type: "Type D"),
];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar:
      CommonAppBar(title: "Add Vehicle",),
   
      backgroundColor: CommonColors.neutral50,
      
      bottomNavigationBar:  Padding(
              padding: const EdgeInsets.only(left: 20,right: 20,top: 20),
              child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                             Navigator.push(
                      routeGlobalKey.currentContext!,
                      MaterialPageRoute(builder: (context) =>  SelectVehicle()),
                    );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CommonColors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text('Save',style: TextStyle(color: CommonColors.white),),
                      ),
                    ),
            ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
       CustomDropdownField(
          labelText: CommonStrings.strManufacturer,
          hintText: CommonStrings.strChooseManufacturer,
          value: selectedManufacturer,
          isMandatory: false,
          items: vehicleManufacturers,
          onChanged: (val) {
            selectedManufacturer = val;
          },
        ),
        SizedBox(height: 12,),
        CustomDropdownField(
          labelText: CommonStrings.strModel,
          hintText: CommonStrings.strChooseModel,
          value: selectedModel,
           isMandatory: false,
          items: vehicleModels,
          onChanged: (val) {
            selectedModel = val;
          },
        ),
         SizedBox(height: 12,),
         CustomDropdownField(
          labelText: CommonStrings.strVehicleRegNo,
          hintText: CommonStrings.strVehNoHint,
          value: selectedRegistrationNo,
           isMandatory: false,
          items: vehicleRegNO,
          onChanged: (val) {
            selectedRegistrationNo = val;
          },
        ),
         SizedBox(height: 12,),
        CustomDropdownField(
          labelText: CommonStrings.strBatteryType,
          hintText: CommonStrings.strChooseBatteryType,
           isMandatory: false,
          value: selectedBatteryType,
          items: batteryTypes,
          onChanged: (val) {
            selectedBatteryType = val;
          },
        ),
 SizedBox(height: 12,),
        CustomDropdownField(
          labelText: CommonStrings.strBatteryCapacity,
          hintText: CommonStrings.strChooseCapacity,
          value: selectedBatteryCapacity,
          items: batteryCapacity,
           isMandatory: false,
          onChanged: (val) {
            selectedBatteryCapacity = val;
          },
        ),
 SizedBox(height: 12,),
TextWithAsterisk(text: "Charger Type",isAstrick: false,),
          Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(vehicleUnits.length, (i) {
                      final sel = i == selectedUnitsIndex;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => selectedUnitsIndex = i),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                                // color: 
                                // sel
                                //     ? CommonColors.primary
                                //     : CommonColors.neutral200,
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(children: [
                             Image.asset(vehicleUnits[i].image,
                             width: 40,height: 40,
                             color: 
                              sel
                                    ? CommonColors.blue
                                    : CommonColors.hintGrey,
                             ),
                              // if (sel) const SizedBox(height: 6),
                              // if (sel)
                                 Text(vehicleUnits[i].type,
                                    style: TextStyle(fontWeight: FontWeight.w800,
                                        fontSize: 12, color:  sel
                                    ? CommonColors.blue
                                    : CommonColors.grey,))
                            ]),
                          ),
                        ),
                      );
                    })),
        ],
      ),
    );
  }
}