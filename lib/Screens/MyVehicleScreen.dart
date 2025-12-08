import 'package:ev_charging_app/Screens/AddVehicle.dart';
import 'package:ev_charging_app/Utils/CommonAppBar.dart';
import 'package:ev_charging_app/Utils/commoncolors.dart';
import 'package:ev_charging_app/Utils/commonimages.dart';
import 'package:ev_charging_app/main.dart';
import 'package:flutter/material.dart';

class MyVehicleScreen extends StatelessWidget {
  const MyVehicleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: CommonColors.neutral50,
      appBar:
      CommonAppBar(title: "My Vehicle",),
      
      
      
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          decoration: BoxDecoration(
                  color: CommonColors.white,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
             child: ListView(
  padding: const EdgeInsets.all(4),
  shrinkWrap: true,  // ListView will take only needed height
  physics: NeverScrollableScrollPhysics(), // If you want parent scroll only
  children: [
    _vehicleItem("Tata Nexon EV"),
    _vehicleItem("Hyundai Kona EV"),
    const SizedBox(height: 10),
    _addVehicleButton(),
  ],
),

          ),
        ),
      ),
    );
  }
  Widget _vehicleItem(String title) {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: CommonColors.neutral50,
      borderRadius: BorderRadius.circular(12),
     
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
         Image.asset(CommonImagePath.delete)
      ],
    ),
  );
}

Widget _addVehicleButton() {
  return GestureDetector(
    onTap: ()
    {
       Navigator.push(
                      routeGlobalKey.currentContext!,
                      MaterialPageRoute(builder: (context) =>  AddVehicleScreen()),
                    );
    },
    child: Container(
      decoration: BoxDecoration(
        color: CommonColors.neutral50,
        borderRadius: BorderRadius.circular(12),
       
      ),
      child:Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Icon(Icons.add),
          SizedBox(width: 10,),
          Text("Add New Vehicle"),],),
      )
     
    ),
  );
}
}