import 'package:ev_charging_app/Screens/ProfileScreen.dart';
import 'package:ev_charging_app/Screens/ScanScreen.dart';
import 'package:ev_charging_app/Screens/SelectVehicleScreen.dart';
import 'package:ev_charging_app/Utils/CommonAppBar.dart';
import 'package:ev_charging_app/Utils/commoncolors.dart';
import 'package:ev_charging_app/Utils/commonimages.dart';
import 'package:flutter/material.dart';

class PayScreen extends StatefulWidget {
  const PayScreen({super.key});
  @override
  State<PayScreen> createState() => _PayScreenState();
}

class _PayScreenState extends State<PayScreen> {
    bool started = false;

  void _startNavigation() {
    setState(() => started = true);
    // navigate to NavigationScreen after small delay
    Future.delayed(const Duration(milliseconds: 450), () {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (_) =>  ScanScreen()));
    });
  }

  int selectedUnitIndex = 3;
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: CommonColors.neutral50,
    appBar:
      CommonAppBar(title: "Pay",),
      
      bottomNavigationBar:   Padding(
        padding: const EdgeInsets.all(8.0),
        child: SwipeToStartButton(onComplete: _startNavigation,label: "Proceed To Pay",),
      ),
      body: Column(children: [
         Padding(
           padding: const EdgeInsets.all(8.0),
           child: ElevatedButton(
             onPressed: () {},
             style: ElevatedButton.styleFrom(
               backgroundColor: CommonColors.white,
               foregroundColor: CommonColors.blue,
               shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.circular(12),
                 side: BorderSide(
                   color: CommonColors.blue,
                   width: 0.8,
                 ),
               ),
             ),
             child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 Image.asset(CommonImagePath.charger),
                 SizedBox(width: 10,),
                 const Text(
                   "Plug Type A",
                   style: TextStyle(
                       fontSize: 12,
                       color: CommonColors.blue,
                       fontWeight: FontWeight.w600),
                 ),
               ],
             ),
           ),
         ),
        SizedBox(
            width: double.infinity,
            height: 140,
            child: Image.asset(CommonImagePath.car, fit: BoxFit.contain)),
        Positioned(
          left: 12,
          right: 12,
          bottom: 20,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                  color: CommonColors.cardWhite,
                  borderRadius: BorderRadius.circular(14)),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Units', style: TextStyle(fontWeight: FontWeight.w600)),
                    SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: CommonColors.cardWhite,
                          borderRadius: BorderRadius.circular(14)),
                      // units selector
                      child: Row(
                          children: List.generate(4, (i) {
                        final sel = i == selectedUnitIndex;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => selectedUnitIndex = i),
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                  color: sel
                                      ? CommonColors.blue
                                      : CommonColors.neutral200,
                                  borderRadius: BorderRadius.circular(8)),
                              child: Column(children: [
                                Text('${(i + 1).toStringAsFixed(0)}.00 kW',
                                    style: TextStyle(
                                        color: sel
                                            ? Colors.white
                                            : CommonColors.blue,
                                        fontWeight: FontWeight.w600)),
                                const SizedBox(height: 6),
                                Text('₹${(i + 1) * 10}',
                                    style: TextStyle(
                                        color:
                                            sel ? Colors.white : Colors.black54))
                              ]),
                            ),
                          ),
                        );
                      })),
                    ),
                    const SizedBox(height: 12),
                    // fees row & proceed button
                     Text('Fee', style: TextStyle(fontWeight: FontWeight.w600)),
                    SizedBox(height: 10),
                    Row(children: [
                      Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:  [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Charging Fee',
                                      style: TextStyle(fontSize: 12)),
                                      Text('₹100 / kW',
                                  style: TextStyle(fontWeight: FontWeight.w600))
                                ],
                              ),
                               SizedBox(height: 4),
                               Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Transaction Fee',
                                      style: TextStyle(fontSize: 12)),
                                      Text('0 / kW',
                                  style: TextStyle(fontWeight: FontWeight.w600))
                                ],
                              ),
                              Divider(color: CommonColors.grey.withOpacity(0.4),),
                               Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Total Fee',
                                      style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
                                      Text('100 ₹',
                                  style: TextStyle(fontWeight: FontWeight.w600))
                                ],
                              ),
                              SizedBox(height: 6),
                             
                            ]),
                      ),
                     
                    ]),
                  ]),
            ),
          ),
        ),

                            
      ]),
    );
  }
}
