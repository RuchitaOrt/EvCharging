import 'package:HyCharge/Provider/VehicleProvider.dart';
import 'package:HyCharge/Screens/Vehicle/MyVehicleScreen.dart';
import 'package:HyCharge/Screens/Vehicle/VehicleDetailScreen.dart';
import 'package:HyCharge/Utils/commoncolors.dart';
import 'package:HyCharge/Utils/commonimages.dart';
import 'package:HyCharge/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void showMyVehiclesBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return Container(
        height: 280,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(22),
          ),
        ),
        child: Column(
          children: [

            const SizedBox(height: 10),

            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(20),
              ),
            ),

            const SizedBox(height: 16),

            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 18,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "My Vehicles",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 14),

            // SizedBox(
            //   height: 120,
            //   child: ListView(
            //     scrollDirection: Axis.horizontal,
            //     padding: const EdgeInsets.symmetric(
            //       horizontal: 16,
            //     ),
            //     children: [

            //       _vehicleCard(
            //         selected: true,
            //         title: "Tata Nexon EV",
            //         number: "MH04CB2522",
            //         image: CommonImagePath.vehicle1,
            //       ),

            //       const SizedBox(width: 12),

            //       _vehicleCard(
            //         selected: false,
            //         title: "MG ZS EV",
            //         number: "MH04CB2523",
            //         image: CommonImagePath.vehicle2,
            //       ),
            //     ],
            //   ),
            // ),
SizedBox(
  height: 120,
  child: Consumer<VehicleProvider>(
    builder: (context, provider, child) {
      return provider.userVehicles.length ==0?Container(child: Center(child: Text("Add Vehicle here to apply")),): ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: provider.userVehicles.length,
        itemBuilder: (context, index) {
          final vehicle = provider.userVehicles[index];

          return  Padding(
  padding: const EdgeInsets.only(right: 12),
  child: GestureDetector(
    onTap: () {
        provider.selectUserVehicle(vehicle.recId!);
    },
    child: _vehicleCard(
      selected: provider.selectedUserVehicleId == vehicle.recId,
      title: provider.getModelName(vehicle.carModelID),
      number: vehicle.carRegistrationNumber ?? "",
      image: CommonImagePath.vehicle5,
    ),
  ),
);
        },
      );
    },
  ),
),
            const Spacer(),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [

                  Expanded(
                    flex: 4,
                    child: OutlinedButton.icon(
                      onPressed: () {
                           Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => 
     VehicleSelectionScreen(isVehicleAdded: true,)
      
    ));
                      },
                    
                      label: const Text("Add New"),
                      style: OutlinedButton.styleFrom(
                        minimumSize:
                            const Size(0, 35),
                        foregroundColor:
                            Colors.black,
                        side: BorderSide(
                          color: Colors.grey.shade300,
                        ),
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                            10,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Consumer<VehicleProvider>(
                    builder: (context,provider,child) {
                      return provider.userVehicles.length ==0?Container():Expanded(
                        flex: 5,
                        child: ElevatedButton(
                          onPressed: () async {
                           final provider =
      Provider.of<VehicleProvider>(context, listen: false);

  final vehicle = provider.userVehicles.firstWhere(
    (e) => e.recId == provider.selectedUserVehicleId,
  );

  final success = await provider.setDefaultVehicle(
    context,
    vehicle.recId!,
  );

  if (success!.success!) {
     await provider.getUserVehicleList(context); 
    Navigator.pop(context);
  }

                          },
                          style:
                              ElevatedButton.styleFrom(
                            minimumSize:
                                const Size(0, 35),
                            backgroundColor:
                                CommonColors.blue,
                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                10,
                              ),
                            ),
                          ),
                          child: const Text(
                            "Apply",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight:
                                  FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    }
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );

}
Widget _vehicleCard({
  required bool selected,
  required String title,
  required String number,
  required String image,
}) {
  return Container(
    width: 110,
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: selected
          ? const Color(0xffE8FFF3)
          : Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: selected
            ? const Color(0xff53C98B)
            : Colors.grey.shade300,
      ),
    ),
    child: Column(
      children: [
        Image.asset(
          image,
          height: 45,
        ),
        const SizedBox(height: 6),
        Text(
          title,
          maxLines: 2,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          number,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    ),
  );
}
