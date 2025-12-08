
import 'package:ev_charging_app/Screens/MainTab.dart';
import 'package:ev_charging_app/Screens/SelectVehicle.dart';

import 'package:ev_charging_app/Utils/commoncolors.dart';
import 'package:ev_charging_app/Utils/commonimages.dart';
import 'package:ev_charging_app/Utils/sizeConfig.dart';
import 'package:ev_charging_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return WillPopScope(
       onWillPop: () async {
      // Navigate to MainTab instead of popping
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainTab()),
      );
      return false; // prevent default pop
    },
      child: Scaffold(
        backgroundColor: CommonColors.neutral50,
        
          appBar: AppBar(
          backgroundColor:  CommonColors.neutral50,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.black87),
            onPressed: () 
            { Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MainTab()),
        );
      
            }
          ),
          actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Image.asset(CommonImagePath.upload),
          )
          ],
          centerTitle: true,
          title: const Text(
            "Payment",
            style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
          ),
        ),
        bottomNavigationBar:    Padding(
                padding: const EdgeInsets.only(left: 20,right: 20,top: 20),
                child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                               Navigator.push(
                        routeGlobalKey.currentContext!,
                        MaterialPageRoute(builder: (context) =>  MainTab()),
                      );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: CommonColors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text('Start charging',style: TextStyle(color: CommonColors.white),),
                        ),
                      ),
              ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(children: [
              const SizedBox(height: 20),
              // Card
              Stack(
        clipBehavior: Clip.none,
        children: [
      // ========= CARD ==========
      Container(
        width: w * 0.86,
        padding: const EdgeInsets.only(top: 45, bottom: 20, left: 18, right: 18),
        decoration: BoxDecoration(
          color: CommonColors.cardWhite,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 12,
              offset: Offset(0, 6),
            )
          ],
        ),
        child: Column(
          children: [
            const Text(
              'Payment Success!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your payment has been successfully done',
              style: TextStyle(color: Colors.black54, fontSize: 12),
            ),
      
            const SizedBox(height: 18),
            const Divider(),
            const SizedBox(height: 12),
      
            // Total Payment
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: const [
                  Text("Total Payment", style: TextStyle(fontSize: 14)),
                  SizedBox(height: 5),
                  Text(
                    "₹4000.00",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                ],
              ),
            ),
      
            const SizedBox(height: 30),
      
            // Rows
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _detailColumn('Charger Station', 'Hitech EV Station'),
                _detailColumn('Start Time', '25 Aug 2025, 13:22'),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _detailColumn('Duration', '1hr 30min'),
                _detailColumn('Payment Method', 'Debit Card'),
              ],
            ),
      
            const SizedBox(height: 20),
      
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:  [
                Image.asset(CommonImagePath.download),
                SizedBox(width: 6),
                Text(
                  'Get PDF Receipt',
                  style: TextStyle(color: Colors.black54, fontSize: 16),
                ),
              ],
            )
          ],
        ),
      ),
      
      // ========= HALF-IN HALF-OUT ICON ==========
      Positioned(
        top: -22, // half outside the card
        left: 0,
        right: 0,
        child: Center(
          child: Container(
            width: 64,
            height: 64,
           
            child: Image.asset(CommonImagePath.check)
          ),
        ),
      )
        ],
      )
      ,
        //       Container(
        //         width: w * 0.86,
        //         padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
        //         decoration: BoxDecoration(
        //           color: CommonColors.cardWhite,
        //           borderRadius: BorderRadius.circular(14),
        //           boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 12, offset: Offset(0, 6))],
        //         ),
        //         child: Column(children: [
        //           // success icon
        //           Container(
        //               width: 64,
        //               height: 64,
        //               decoration: BoxDecoration(color: CommonColors.accentGreen, shape: BoxShape.circle),
        //               child: const Icon(Icons.check, color: Colors.white, size: 34)),
        //           const SizedBox(height: 12),
        //           const Text('Payment Success!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        //           const SizedBox(height: 8),
        //           const Text('Your payment has been successfully done', style: TextStyle(color: Colors.black54,fontSize: 12,)),
        //           const SizedBox(height: 18),
        //           const Divider(),
        //           const SizedBox(height: 12),
        //           Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        //     Text("Total Payment", style: const TextStyle(fontSize: 14, )),
        //     const SizedBox(height: 5),
        //     Text("₹4000.00", style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 24,),),
        //   ]),
        // ),
        // SizedBox(height: 30),
        //           // details grid
        //           Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        //             _detailColumn('Charger Station', 'Hitech EV Station'),
        //             _detailColumn('Start Time', '25 Aug 2025, 13:22'),
        //           ]),
        //           const SizedBox(height: 12),
        //           Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        //             _detailColumn('Duration', '1hr 30min'),
        //             _detailColumn('Payment Method', 'Debit Card'),
        //           ]),
        //           const SizedBox(height: 14),
                  
        //           Row(
        //             mainAxisAlignment: MainAxisAlignment.center,
        //             children: [
        //                IconButton(
        //       icon: const Icon(Icons.file_download_outlined, color: Colors.black87),
        //       onPressed: () {},
        //     ),
        //               Text('Get PDF Receipt', style: TextStyle(color: Colors.black54,fontSize: 16,)),
        //             ],
        //           ),
        //         ]),
        //       ),
              const SizedBox(height: 20),
      
           
            ]),
          ),
        ),
      ),
    );
  }

  static Widget _detailColumn(String title, String value) {
    return Container(
      width: SizeConfig.blockSizeHorizontal*37,
       decoration: BoxDecoration(
       color: CommonColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: CommonColors.grey, // choose your color here
          width: 0.3,
        ),
       
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontSize: 12, color: Colors.black45)),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 12,),),
        ]),
      ),
    );
  }
}
