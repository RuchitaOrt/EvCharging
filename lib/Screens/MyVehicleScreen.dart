
import 'package:ev_charging_app/Provider/VehicleProvider.dart';
import 'package:ev_charging_app/Provider/user_vehicle_provider.dart';
import 'package:ev_charging_app/Screens/AddVehicle.dart';
import 'package:ev_charging_app/Utils/CommonAppBar.dart';
import 'package:ev_charging_app/Utils/ShowDialog.dart';
import 'package:ev_charging_app/Utils/commoncolors.dart';
import 'package:ev_charging_app/Utils/commonimages.dart';
import 'package:ev_charging_app/main.dart';
import 'package:ev_charging_app/model/VehicleListResponse.dart';
import 'package:ev_charging_app/widget/LogoutConfirmationSheet.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyVehicleScreen extends StatefulWidget {
  const MyVehicleScreen({super.key});

  @override
  State<MyVehicleScreen> createState() => _MyVehicleScreenState();
}

class _MyVehicleScreenState extends State<MyVehicleScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => context.read<VehicleProvider>().loadVehicles(context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CommonColors.neutral50,
      appBar: CommonAppBar(title: "My Vehicle"),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          decoration: BoxDecoration(
            color: CommonColors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Consumer<VehicleProvider>(
              builder: (context, provider, _) {
                if (provider.loading) {
                  return const Center(child: CircularProgressIndicator());
                }

                return ListView(
                  padding: const EdgeInsets.all(4),
                  shrinkWrap: true,
                  children: [
                    ...provider.vehicles.map(
                      (v) => _vehicleItem(v.carRegistrationNumber!, v.recId!,v),
                    ),
                    const SizedBox(height: 10),
                    _addVehicleButton(),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _vehicleItem(String title, String vehicleId,Vehicle vehicle) {
    return GestureDetector(
      onTap: ()
      {
         Navigator.push(
          routeGlobalKey.currentContext!,
          MaterialPageRoute(builder: (_) => AddVehicleScreen(isEdit: true,vehicle: vehicle,)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: CommonColors.neutral50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    backgroundColor: CommonColors.white,
                    context: context,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    isScrollControlled: true,
                    builder: (_) => ConfirmationSheet(
                      title: "Are you sure you want to delete? ",
                      singleButton: "",
                      imagePath: CommonImagePath.delete, // Your SVG/PNG
                      isSingleButton: false,
                      onBackToHome: () {},
                      onCancel: () => Navigator.pop(context),
                      onLogout: () async {

                         final provider = context.read<UserVehicleProvider>();

  final ok = await provider.deleteVehicle(context, vehicleId);
                        // final ok = await context
                        //     .read<UserVehicleProvider>()
                        //     .deleteVehicle(context, vehicleId);
      
                        if (ok) {
                          Navigator.pop(context);
                        showToast("${provider.message}");
      
                          // 🔥 REFRESH LIST
                          context.read<VehicleProvider>().loadVehicles(context);
                        }
                      },
                      firstbutton: 'Cancel',
                      secondButton: 'Delete',
                      subHeading: '',
                    ),
                  );
                },
                child: Image.asset(CommonImagePath.delete)),
          ],
        ),
      ),
    );
  }

  Widget _addVehicleButton() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          routeGlobalKey.currentContext!,
          MaterialPageRoute(builder: (_) => AddVehicleScreen(isEdit: false,)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: CommonColors.neutral50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add),
              SizedBox(width: 10),
              Text("Add New Vehicle"),
            ],
          ),
        ),
      ),
    );
  }
}
