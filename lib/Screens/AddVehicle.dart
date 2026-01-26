import 'package:ev_charging_app/Provider/car_manufacturer_provider.dart';
import 'package:ev_charging_app/Provider/hardware_master_provider.dart';
import 'package:ev_charging_app/Provider/user_vehicle_provider.dart';
import 'package:ev_charging_app/Screens/MyVehicleScreen.dart';
import 'package:ev_charging_app/Screens/SelectVehicle.dart';
import 'package:ev_charging_app/Utils/CommonAppBar.dart';
import 'package:ev_charging_app/Utils/ShowDialog.dart';
import 'package:ev_charging_app/Utils/commoncolors.dart';
import 'package:ev_charging_app/Utils/commonimages.dart';
import 'package:ev_charging_app/Utils/commonstrings.dart';
import 'package:ev_charging_app/main.dart';
import 'package:ev_charging_app/model/VehicleListResponse.dart';
import 'package:ev_charging_app/model/battery_capacity_model.dart';
import 'package:ev_charging_app/model/battery_type_model.dart';
import 'package:ev_charging_app/model/car_manufacturer_model.dart';
import 'package:ev_charging_app/model/ev_model.dart';
import 'package:ev_charging_app/widget/CustomDropdownField.dart';
import 'package:ev_charging_app/widget/TextWithAsterisk.dart';
import 'package:ev_charging_app/widget/custom_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VehicleUnit {
  final String image;
  final String type;

  VehicleUnit({required this.image, required this.type});
}

class AddVehicleScreen extends StatefulWidget {
  final bool isEdit;
  final Vehicle? vehicle;
  AddVehicleScreen({super.key, required this.isEdit, this.vehicle});

  @override
  State<AddVehicleScreen> createState() => _AddehicleScreenState();
}

class _AddehicleScreenState extends State<AddVehicleScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      loadData();
    });
  }

  loadData() async {
    final provider = context.read<HardwareMasterProvider>();
    await provider.loadAll(context);
    if (widget.isEdit && widget.vehicle != null) {
      _bindEditData(provider);
      setState(() {}); // refresh UI once
    }
  }

  void _bindEditData(HardwareMasterProvider p) {
    final v = widget.vehicle!;
    print(v);
  print( v.evManufacturerID);
 
    /// Manufacturer
    final manufacturer = p.manufacturers.firstWhere(
      (e) => e.recId == v.evManufacturerID,
      orElse: () => CarManufacturer(
        recId: '',
        manufacturerName: '',
        manufacturerLogoImage: '',
        active: 0,
      ),
    );

    selectedManufacturer = manufacturer.manufacturerName;
    selectedManufacturerID = manufacturer.recId;

    /// Models (depends on manufacturer)
    final models = p.modelsByManufacturer(manufacturer.recId);

    final model = models.firstWhere(
      (e) => e.recId == v.carModelID,
      orElse: () => EVModel(
        recId: '',
        modelName: '',
        manufacturerId: '',
        manufacturerName: '',
        batteryTypeId: '',
        batteryTypeName: '',
        batteryCapacityId: '',
        batteryCapacityValue: '',
        carModelImage: '',
        active: 0,
      ),
    );

    selectedModel = model.modelName;
    selectedModelID = model.recId;

    /// Battery Type
    final batteryType = p.batteryTypes.firstWhere(
      (e) => e.recId == v.batteryTypeId,
      orElse: () => BatteryType(recId: '', batteryType: '', active: 0),
    );

    selectedBatteryType = batteryType.batteryType;
    selectedBatteryTypeID = batteryType.recId;

    /// Battery Capacity
    final capacity = p.batteryCapacities.firstWhere(
      (e) => e.recId == v.batteryCapacityId,
      orElse: () => BatteryCapacity(
        recId: '',
        batteryCapacity: '',
        batteryCapacityUnit: '',
        active: 0,
      ),
    );

    selectedBatteryCapacity = capacity.batteryCapacity;
    selectedBatteryCapacityID = capacity.recId;

    /// Registration number
    registrationNoController.text = v.carRegistrationNumber ?? '';
  }

  TextEditingController registrationNoController = TextEditingController();

  String? _selectedManufacturer;

  String? _selectedModel;

  String? _selectedRegistrationNo;

  String? _selectedBatteryType;

  String? _selectedBatteryCapacity;

  // Manufacturer
  String? get selectedManufacturer => _selectedManufacturer;
  String? selectedChargerTypeId;

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
// Selected values

  String? selectedBatteryTypeID; // ID for API

  String? selectedBatteryCapacityID; // ID for API
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
  final List<String> vehicleModels = ["Nexon EV", "Tiago EV", "Tigor EV"];

  final List<String> vehicleRegNO = ["MH043229999", "MH043999999", "MH0432299"];

// Battery Type
  final List<String> batteryTypes = ["Lithium-ion", "LFP", "NMC", "Lead Acid"];

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
  String? selectedManufacturerID;

  String? selectedModelID; // for API usage

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: "Add Vehicle",
      ),
      backgroundColor: CommonColors.neutral50,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              final provider = context.read<UserVehicleProvider>();
           if(!widget.isEdit){
await provider.addVehicle(
                context: context,
                evManufacturerID: selectedManufacturerID!,
                carModelID: selectedModelID!,
                carModelVariant: selectedModel,
                carRegistrationNumber: registrationNoController.text,
                defaultConfig: 0,
                batteryTypeId: selectedBatteryTypeID!,
                batteryCapacityId: selectedBatteryCapacityID!,
              );

              if (provider.vehicle != null) {
                showToast("${provider.message}");

                Navigator.pop(context); // or move to another screen
              } else {
                showToast("${provider.message}");
              }
              Navigator.push(
                routeGlobalKey.currentContext!,
                MaterialPageRoute(builder: (context) => MyVehicleScreen()),
              );
           }else{
           final ok = await context.read<UserVehicleProvider>().updateVehicle(
  context,
  recId: widget.vehicle!.recId!,
  evManufacturerID: selectedManufacturerID!,
  carModelID: selectedModelID!,
  carModelVariant: selectedModel!,
  carRegistrationNumber: registrationNoController.text,
  defaultConfig: 0,
  batteryTypeId: selectedBatteryTypeID!,
  batteryCapacityId: selectedBatteryCapacityID!,
);

if (ok) {
 showToast("${provider.message}");
  Navigator.pop(context);
}
else{
  showToast("${provider.message}");
}

            
              Navigator.push(
                routeGlobalKey.currentContext!,
                MaterialPageRoute(builder: (context) => MyVehicleScreen()),
              );
           }
              
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: CommonColors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: const Text(
              'Save',
              style: TextStyle(color: CommonColors.white),
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Consumer<HardwareMasterProvider>(
            builder: (_, p, __) => CustomDropdownField(
              labelText: CommonStrings.strManufacturer,
              hintText: CommonStrings.strChooseManufacturer,
              value: selectedManufacturer,
              items: p.manufacturers.map((e) => e.manufacturerName).toList(),
              onChanged: (val) {
                setState(() {
                  selectedManufacturer = val;

                  // find the id based on the selected name
                  final selected = p.manufacturers.firstWhere(
                    (e) => e.manufacturerName == val,
                    orElse: () => CarManufacturer(
                      recId: '',
                      manufacturerName: '',
                      manufacturerLogoImage: '',
                      active: 0,
                    ),
                  );

                  selectedManufacturerID =
                      selected.recId.isNotEmpty ? selected.recId : null;

                  // reset dependent fields
                  selectedModel = null;
                  selectedModelID = null;
                });
              },
            ),
          ),

          SizedBox(
            height: 12,
          ),

          Consumer<HardwareMasterProvider>(
            builder: (_, p, __) {
              // find selected manufacturer
              final manufacturer = p.manufacturers.firstWhere(
                (e) => e.manufacturerName == selectedManufacturer,
                orElse: () => CarManufacturer(
                    recId: '',
                    manufacturerName: '',
                    manufacturerLogoImage: '',
                    active: 0),
              );

              // get models for this manufacturer
              final models = manufacturer.recId.isEmpty
                  ? []
                  : p.modelsByManufacturer(manufacturer.recId);

              return CustomDropdownField(
                labelText: "Model",
                hintText: "Select model",
                value: selectedModel,
                items: models.map<String>((e) => e.modelName).toList(),
                onChanged: (val) {
                  setState(() {
                    selectedModel = val;

                    // find model ID based on selected name
                    final selected = models.firstWhere(
                      (e) => e.modelName == val,
                      orElse: () => EVModel(
                        recId: '',
                        modelName: '',
                        manufacturerId: '',
                        manufacturerName: '',
                        batteryTypeId: '',
                        batteryTypeName: '',
                        batteryCapacityId: '',
                        batteryCapacityValue: '',
                        carModelImage: '',
                        active: 0,
                      ),
                    );

                    selectedModelID =
                        selected.recId.isNotEmpty ? selected.recId : null;
                  });
                },
              );
            },
          ),

          SizedBox(
            height: 12,
          ),
          CustomTextFieldWidget(
            isMandatory: false,
            title: CommonStrings.strVehicleRegNo,
            hintText: CommonStrings.strVehNoHint,
            onChange: (val) {},
            textEditingController: registrationNoController,
            autovalidateMode: AutovalidateMode.disabled,
          ),

          SizedBox(
            height: 12,
          ),
          // Battery Type Dropdown

// Battery Type Dropdown
          Consumer<HardwareMasterProvider>(
            builder: (_, p, __) {
              return CustomDropdownField(
                labelText: CommonStrings.strBatteryType,
                hintText: CommonStrings.strChooseBatteryType,
                isMandatory: false,
                value: selectedBatteryType,
                items:
                    p.batteryTypes.map<String>((e) => e.batteryType).toList(),
                onChanged: (val) {
                  setState(() {
                    selectedBatteryType = val;

                    // safely get ID
                    final selected = p.batteryTypes.firstWhere(
                      (e) => e.batteryType == val,
                      orElse: () => BatteryType(
                        recId: '', // safe default
                        batteryType: '',
                        active: 0,
                      ),
                    );
                    selectedBatteryTypeID =
                        selected.recId.isNotEmpty ? selected.recId : null;
                  });
                },
              );
            },
          ),
          SizedBox(height: 12),

// Battery Capacity Dropdown
          Consumer<HardwareMasterProvider>(
            builder: (_, p, __) {
              return CustomDropdownField(
                labelText: CommonStrings.strBatteryCapacity,
                hintText: CommonStrings.strChooseCapacity,
                isMandatory: false,
                value: selectedBatteryCapacity,
                items: p.batteryCapacities
                    .map<String>((e) => e.batteryCapacity)
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    selectedBatteryCapacity = val;

                    final selected = p.batteryCapacities.firstWhere(
                      (e) => e.batteryCapacity == val,
                      orElse: () => BatteryCapacity(
                        recId: '',
                        batteryCapacity: '',
                        batteryCapacityUnit: '',
                        active: 0,
                      ),
                    );
                    selectedBatteryCapacityID =
                        selected.recId.isNotEmpty ? selected.recId : null;
                  });
                },
              );
            },
          ),
          SizedBox(height: 12),

// Charger Type Selection (tiles with image)
          TextWithAsterisk(text: "Charger Type", isAstrick: false),
          SizedBox(height: 8),
          Consumer<HardwareMasterProvider>(
            builder: (_, p, __) {
              if (p.loading) {
                return const Center(child: CircularProgressIndicator());
              }

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: p.chargerTypes.map((item) {
                  final isSelected =
                      item.charger.recId == selectedChargerTypeId;

                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedChargerTypeId = item.charger.recId;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSelected
                                ? CommonColors.blue
                                : Colors.transparent,
                            width: 2,
                          ),
                          color: isSelected
                              ? CommonColors.blue.withOpacity(0.08)
                              : Colors.transparent,
                        ),
                        child: Column(
                          children: [
                            if (item.imageBytes != null)
                              Image.memory(
                                item.imageBytes!,
                                width: 40,
                                height: 40,
                                fit: BoxFit.contain,
                              )
                            else
                              Container(
                                width: 40,
                                height: 40,
                                color: Colors.grey.shade300,
                              ),
                            const SizedBox(height: 6),
                            Text(
                              item.charger.chargerType,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 12,
                                color: isSelected
                                    ? CommonColors.blue
                                    : CommonColors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
