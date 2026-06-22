import 'package:HyCharge/Screens/Vehicle/MyVehicleScreen.dart';
import 'package:HyCharge/Screens/Vehicle/VehicleDetailScreen.dart';
import 'package:HyCharge/Utils/commoncolors.dart';
import 'package:HyCharge/Utils/commonimages.dart';
import 'package:HyCharge/main.dart';
import 'package:flutter/material.dart';

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

            SizedBox(
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                children: [

                  _vehicleCard(
                    selected: true,
                    title: "Tata Nexon EV",
                    number: "MH04CB2522",
                    image: CommonImagePath.vehicle1,
                  ),

                  const SizedBox(width: 12),

                  _vehicleCard(
                    selected: false,
                    title: "MG ZS EV",
                    number: "MH04CB2523",
                    image: CommonImagePath.vehicle2,
                  ),
                ],
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

                  Expanded(
                    flex: 5,
                    child: ElevatedButton(
                      onPressed: () {},
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
