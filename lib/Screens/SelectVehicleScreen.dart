import 'package:ev_charging_app/Screens/PayScreen.dart';
import 'package:ev_charging_app/Utils/CommonAppBar.dart';
import 'package:ev_charging_app/Utils/commoncolors.dart';
import 'package:ev_charging_app/Utils/commonimages.dart';
import 'package:ev_charging_app/Utils/commonstrings.dart';
import 'package:ev_charging_app/Utils/sizeConfig.dart';
import 'package:ev_charging_app/widget/CustomDropdownField.dart';
import 'package:flutter/material.dart';

class SelectVehicleScreen extends StatefulWidget {
  const SelectVehicleScreen({super.key});
  @override
  State<SelectVehicleScreen> createState() => _SelectVehicleScreenState();
}

class _SelectVehicleScreenState extends State<SelectVehicleScreen> {
  String selectedVehicle = 'BMW X1';
  String selectedPlug = 'Plug Type A';
  int selectedUnitsIndex = 2;
  final units = [CommonImagePath.veh1, CommonImagePath.veh2, CommonImagePath.veh3, CommonImagePath.veh4];
String? _selectedRegistrationNo;
  String? get selectedRegistrationNo => _selectedRegistrationNo;

  set selectedRegistrationNo(String? value) {
    _selectedRegistrationNo = value;
    
  }
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

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: CommonColors.neutral50,
      appBar:
      CommonAppBar(title: "Select Vehicle",),
      
       bottomNavigationBar:   Padding(
        padding: const EdgeInsets.all(8.0),
        child: SwipeToStartButton(onComplete: _startNavigation,label: "Swipe To Proceed",),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          SizedBox(
              width: double.infinity,
              height: 140,
              child: Image.asset(CommonImagePath.car, fit: BoxFit.contain)),
          Positioned(
            left: 12,
            right: 12,
            bottom: 20,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                  color: CommonColors.cardWhite,
                  borderRadius: BorderRadius.circular(14)),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                // car image
                Row(children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: CommonColors.neutral50),
                        color: CommonColors.white,
                        borderRadius: BorderRadius.circular(12),
                         boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                           
                             
                              CustomDropdownField(
              labelText: "Select your Vehicle",
              isMandatory: true,
              hintText: CommonStrings.strChooseVehicle,
              value: selectedRegistrationNo,
              items: vehicleManufacturers,
              onChanged: (val) {
                selectedRegistrationNo = val;
              },
            ),
                            ]),
                      ),
                    ),
                  ),
                ]),
                const SizedBox(height: 12),
               Container(
                width: SizeConfig.blockSizeHorizontal*100,
                      decoration: BoxDecoration(
                        border: Border.all(color: CommonColors.neutral50),
                        color: CommonColors.white,
                        borderRadius: BorderRadius.circular(12),
                         boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 6),
                                Text('Selected Vehicle Details',
                            style: TextStyle(fontWeight: FontWeight.w600)),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Container(
                              width: SizeConfig.blockSizeHorizontal*30,
                              child: Text('Battery Type')),
                             Text('Lithium',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Container(
                                width: SizeConfig.blockSizeHorizontal*30,
                              child: Text('Battery Units')),
                              Text('Units',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Container(
                                width: SizeConfig.blockSizeHorizontal*30,
                              child: Text('Plug Point')),
                              Text('Type A',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                         
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                             Container(
                                width: SizeConfig.blockSizeHorizontal*30,
                              child: Text('Time')),
                            Text('1 hour',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                          ],
                        ),
                            ]),
                      ),
                    ),
                // selected details
               
                // unit tiles
 const SizedBox(height: 12),
                Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: CommonColors.neutral50),
                        color: CommonColors.white,
                        borderRadius: BorderRadius.circular(12),
                         boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Select Vehicle Plug',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600)),
                              SizedBox(
                                height: 15,
                              ),
                                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(units.length, (i) {
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
                             Image.asset(units[i],
                             width: 30,height: 30,
                             color: 
                              sel
                                    ? CommonColors.blue
                                    : CommonColors.hintGrey,
                             ),
                              // if (sel) const SizedBox(height: 6),
                              // if (sel)
                              //   const Text('Selected',
                              //       style: TextStyle(
                              //           fontSize: 11, color: Colors.white))
                            ]),
                          ),
                        ),
                      );
                    })),
                            ]),
                      ),
                    ),
              
                const SizedBox(height: 12),
            
              ]),
            ),
          ),
        ],
      ),
    );
  }
   bool started = false;
    void _startNavigation() {
    setState(() => started = true);
    // navigate to NavigationScreen after small delay
    Future.delayed(const Duration(milliseconds: 450), () {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (_) =>  PayScreen()));
    });
  }
}

// class SwipeToStartButton extends StatefulWidget {
//   final VoidCallback onComplete;
//   const SwipeToStartButton({required this.onComplete, super.key});

//   @override
//   State<SwipeToStartButton> createState() => _SwipeToStartButtonState();
// }

// class _SwipeToStartButtonState extends State<SwipeToStartButton> {
//   double _dx = 0;
//   bool _done = false;

//   @override
//   Widget build(BuildContext context) {
//     final fullW = MediaQuery.of(context).size.width - 96;
//     final handleSize = 48.0;
//     final limit = fullW - handleSize;

//     final progress = (_dx / limit).clamp(0.0, 1.0);

//     return Stack(
//       children: [
//         /// Background with gradient progress
//         Container(
//           height: 56,
//           decoration: BoxDecoration(
//             border: Border.all(color: CommonColors.neutral500),
//             color: CommonColors.white,
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Stack(
//             children: [
//               /// ▬▬▬▬▬▬ GRADIENT PROGRESS FILL ▬▬▬▬▬▬
//               AnimatedContainer(
//                 duration: const Duration(milliseconds: 80),
//                 width: (progress * fullW),
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [
//                       CommonColors.blue,
//                       CommonColors.blue.withOpacity(0.6),
//                     ],
//                     begin: Alignment.centerLeft,
//                     end: Alignment.centerRight,
//                   ),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),

//               /// ❇️ Text on top
//               Center(
//                 child: Text(
//                   'Swipe To Proceed',
//                   style: TextStyle(
//                     color: CommonColors.blue,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),

//         /// Draggable Handle
//         Positioned(
//           left: _dx,
//           top: 4,
//           child: GestureDetector(
//             onHorizontalDragUpdate: (details) {
//               setState(() {
//                 _dx += details.delta.dx;
//                 if (_dx < 0) _dx = 0;
//                 if (_dx > limit) _dx = limit;

//                 if (_dx >= limit && !_done) {
//                   _done = true;
//                   widget.onComplete();
//                 }
//               });
//             },
//             onHorizontalDragEnd: (d) {
//               if (!_done) {
//                 setState(() {
//                   _dx = 0;
//                 });
//               }
//             },
//             child: Padding(
//               padding: const EdgeInsets.only(left: 8),
//               child: Container(
//                 width: handleSize,
//                 height: 48,
//                 decoration: BoxDecoration(
//                   color: CommonColors.blue,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: const Padding(
//                   padding: EdgeInsets.all(8.0),
//                   child: Icon(Icons.double_arrow, color: Colors.white),
//                 ),
//               ),
//             ),
//           ),
//         )
//       ],
//     );
//   }
// }

// class SwipeToStartButton extends StatefulWidget {
//   final String label;
//   final VoidCallback onComplete;
//   const SwipeToStartButton({required this.onComplete, super.key, required this.label});

//   @override
//   State<SwipeToStartButton> createState() => _SwipeToStartButtonState();
// }

// class _SwipeToStartButtonState extends State<SwipeToStartButton> {
//   double _dx = 0;
//   bool _done = false;

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         final fullW = constraints.maxWidth;      // real width
//         final handleSize = 48.0;
//         final limit = fullW - handleSize;

//         // percentage progress
//         final progress = (_dx / limit).clamp(0.0, 1.0);

//         return Stack(
//           children: [
//             /// Background container
//             Container(
//               height: 56,
//               decoration: BoxDecoration(
//                 border: Border.all(color: CommonColors.neutral500),
//                 color: CommonColors.white,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Stack(
//                 children: [
//                   /// Progress fill
//                   AnimatedContainer(
//                     duration: const Duration(milliseconds: 80),
//                     width: (progress * fullW),
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [
//                           CommonColors.blue,
//                           CommonColors.blue.withOpacity(0.6),
//                         ],
//                         begin: Alignment.centerLeft,
//                         end: Alignment.centerRight,
//                       ),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),

//                   /// Text
//                    Center(
//                     child: Text(
//                       'Swipe To Proceed',
//                       style: TextStyle(
//                         color: CommonColors.blue,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ),

//             /// Swipe Handle
//             Positioned(
//               left: _dx,
//               top: 4,
//               child: GestureDetector(
//                 onHorizontalDragUpdate: (details) {
//                   setState(() {
//                     _dx += details.delta.dx;
//                     if (_dx < 0) _dx = 0;
//                     if (_dx > limit) _dx = limit;

//                     if (_dx >= limit && !_done) {
//                       _done = true;
//                       widget.onComplete();
//                     }
//                   });
//                 },
//                 onHorizontalDragEnd: (_) {
//                   if (!_done) {
//                     setState(() {
//                       _dx = 0;
//                     });
//                   }
//                 },
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 8),
//                   child: Container(
//                     width: handleSize,
//                     height: 48,
//                     decoration: BoxDecoration(
//                       color: CommonColors.blue,
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: const Icon(Icons.double_arrow, color: Colors.white),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
class SwipeToStartButton extends StatefulWidget {
  final String label;
  final VoidCallback onComplete;

  const SwipeToStartButton({
    required this.onComplete,
    required this.label,
    super.key,
  });

  @override
  State<SwipeToStartButton> createState() => _SwipeToStartButtonState();
}

class _SwipeToStartButtonState extends State<SwipeToStartButton> {
  double _dx = 0;
  bool _done = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final fullW = constraints.maxWidth;
        final handleSize = 48.0;

        const leftPadding = 8.0;   // restored left spacing
        const rightPadding = 8.0;  // right spacing

        // Usable drag width
        final usableWidth = fullW - handleSize - leftPadding - rightPadding;

        // Actual drag position mapped inside usable area
        final progress = (_dx / usableWidth).clamp(0.0, 1.0);

        return Stack(
          children: [
            /// Background container
            Container(
              height: 56,
              decoration: BoxDecoration(
                border: Border.all(color: CommonColors.neutral500),
                color: CommonColors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  /// Progress Fill
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 80),
                    margin: const EdgeInsets.only(left: leftPadding),
                    width: progress * (fullW - leftPadding - rightPadding),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          CommonColors.blue,
                          CommonColors.blue.withOpacity(0.6),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),

                  /// Center Text
                  Center(
                    child: Text(
                      widget.label,
                      style: TextStyle(
                        color: CommonColors.blue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                ],
              ),
            ),

            /// Swipe Handle
            Positioned(
              left: leftPadding + _dx, // left padding restored
              top: 4,
              child: GestureDetector(
                onHorizontalDragUpdate: (details) {
                  setState(() {
                    _dx += details.delta.dx;

                    if (_dx < 0) _dx = 0;
                    if (_dx > usableWidth) _dx = usableWidth;

                    if (_dx >= usableWidth && !_done) {
                      _done = true;
                      widget.onComplete();
                    }
                  });
                },
                onHorizontalDragEnd: (_) {
                  if (!_done) {
                    setState(() => _dx = 0);
                  }
                },
                child: Container(
                  width: handleSize,
                  height: 48,
                  decoration: BoxDecoration(
                    color: CommonColors.blue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child:Image.asset(CommonImagePath.swipe,color: CommonColors.white,),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
