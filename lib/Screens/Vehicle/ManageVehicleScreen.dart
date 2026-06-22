import 'package:HyCharge/Screens/Vehicle/MyVehicleScreen.dart';
import 'package:HyCharge/Screens/Vehicle/VehicleDetailScreen.dart';
import 'package:HyCharge/Utils/commoncolors.dart';
import 'package:HyCharge/Utils/commonimages.dart';
import 'package:HyCharge/main.dart';
import 'package:flutter/material.dart';

class ManageVehicleScreen extends StatelessWidget {
  const ManageVehicleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F7F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: const Icon(
          Icons.arrow_back_ios,
          size: 18,
          color: Colors.black,
        ),
        title: const Text(
          "Manage Vehicle",
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Row(
              children: [
                Icon(
                  Icons.help_outline,
                  size: 18,
                  color: Color(0xffD57A7A),
                ),
                SizedBox(width: 3),
                Text(
                  "FAQ",
                  style: TextStyle(
                    color: Color(0xffD57A7A),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 14),

          /// Vehicle 1
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _vehicleCard(
              title: "Tata Nexon EV",
              vehicleNo: "MH04CB2522",
              image:
                 CommonImagePath.vehicle1,
              isAutoCharge: true,
            ),
          ),

          const SizedBox(height: 14),

          /// Vehicle 2
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _vehicleCard(
              title: "MG ZS EV",
              vehicleNo: "MH04CB2523",
              image:
                 CommonImagePath.vehicle2
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(
          16,
          10,
          16,
          18,
        ),
        color: Colors.white,
        child: SizedBox(
          height: 48,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: CommonColors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            onPressed: () {
               Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => 
     VehicleSelectionScreen(isVehicleAdded: true,)
    
    ),
  );
            },
            child: const Text(
              "Add Vehicle",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

Widget _vehicleCard({
  required String title,
  required String vehicleNo,
  required String image,
  bool isAutoCharge = false,
}) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        routeGlobalKey.currentContext!,
        MaterialPageRoute(
          builder: (_) => VehicleDetailScreen(),
        ),
      );
    },
    child: Container(
      padding: const EdgeInsets.fromLTRB(
        18,
        16,
        12,
        16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    const Icon(
                      Icons.directions_car,
                      size: 15,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      vehicleNo,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                if (isAutoCharge) ...[
                  const SizedBox(height: 16),

                  Column(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: 38,
                            height: 30,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.bolt,
                                size: 20,
                              ),
                            ),
                          ),

                          Positioned(
                            top: -2,
                            right: -2,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration:
                                  const BoxDecoration(
                                color:
                                    Color(0xFFFF8A00),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 2),

                      const Text(
                        "AutoCharge",
                        style: TextStyle(
                          fontSize: 8,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(width: 10),

          Align(
            alignment: Alignment.centerRight,
            child: Image.asset(
              image,
              width: 135,
              height: 90,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    ),
  );
}
}