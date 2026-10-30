// import 'package:HyCharge/Provider/VehicleProvider.dart';
// import 'package:HyCharge/Screens/MainTab.dart';
// import 'package:HyCharge/Screens/Vehicle/MyVehicleScreen.dart';
// import 'package:HyCharge/Screens/Vehicle/VehicleDetailScreen.dart';
// import 'package:HyCharge/Utils/commoncolors.dart';
// import 'package:HyCharge/Utils/commonimages.dart';
// import 'package:HyCharge/main.dart';
// import 'package:HyCharge/widget/GlobalLists.dart';
// import 'package:HyCharge/widget/LogoutConfirmationSheet.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class ManageVehicleScreen extends StatefulWidget {
//   const ManageVehicleScreen({super.key});

//   @override
//   State<ManageVehicleScreen> createState() => _ManageVehicleScreenState();
// }

// class _ManageVehicleScreenState extends State<ManageVehicleScreen> {
//   @override
//   void initState() {
//     super.initState();

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<VehicleProvider>().getUserVehicleList(context);
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//         onWillPop: () async {
    
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (_) => MainTab(isLoggedIn: GlobalLists.islLogin),
//         ),
//       );
   
//     return false; // ✅ now it's Future<bool>
//   },
//       child: Scaffold(
//         backgroundColor: const Color(0xffF7F7F7),
//         appBar: AppBar(
//           backgroundColor: Colors.white,
//           elevation: 0,
//           centerTitle: true,
//           leading: GestureDetector(
//             onTap: ()
//             {
//                Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (_) => MainTab(isLoggedIn: GlobalLists.islLogin),
//         ),
//       );
//             },
//             child: const Icon(
//               Icons.arrow_back_ios,
//               size: 18,
//               color: Colors.black,
//             ),
//           ),
//           title: const Text(
//             "Manage Vehicle",
//             style: TextStyle(
//               fontSize: 17,
//               fontWeight: FontWeight.w600,
//               color: Colors.black,
//             ),
//           ),
//           actions: const [
//             Padding(
//               padding: EdgeInsets.only(right: 16),
//               child: Row(
//                 children: [
//                   Icon(
//                     Icons.help_outline,
//                     size: 14,
//                     color:   CommonColors.blue,
//                   ),
//                   SizedBox(width: 3),
//                   Text(
//                     "FAQ",
//                     style: TextStyle(
//                         fontFamily: 'Poppins',
//                       color: CommonColors.blue,
//                       fontSize: 12,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//         body: 
//         Consumer<VehicleProvider>(
//         builder: (context, provider, child) {
//       if (provider.isLoading) {
//         return const Center(
//           child: CircularProgressIndicator(),
//         );
//       }
      
//       if (provider.userVehicles.isEmpty) {
//         return const Center(
//           child: Padding(
//             padding: EdgeInsets.only(top: 40),
//             child: Text("No Vehicle Found"),
//           ),
//         );
//       }
      
//       return Padding(
//         padding: const EdgeInsets.only(top: 20,bottom: 20),
//         child: ListView.separated(
//           shrinkWrap: true,
//           physics: const ScrollPhysics(),
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           itemCount: provider.userVehicles.length,
//           separatorBuilder: (_, __) => const SizedBox(height: 14),
//           itemBuilder: (context, index) {
//             final vehicle = provider.userVehicles[index];
        
//             return _vehicleCard(
//               title: provider.getModelName(vehicle.carModelID),
//               vehicleNo: vehicle.carRegistrationNumber ?? "",
//               image: CommonImagePath.vehicle1,
//               recid: vehicle.recId!,
//               isAutoCharge: true
//               // isAutoCharge: vehicle.autoChargeEnabled ?? false,
//             );
//           },
//         ),
//       );
//         },
//       ),
//         // Column(
//         //   children: [
//         //     const SizedBox(height: 14),
      
//         //     /// Vehicle 1
//         //     Padding(
//         //       padding: const EdgeInsets.symmetric(horizontal: 16),
//         //       child: _vehicleCard(
//         //         title: "Tata Nexon EV",
//         //         vehicleNo: "MH04CB2522",
//         //         image:
//         //            CommonImagePath.vehicle1,
//         //         isAutoCharge: true,
//         //       ),
//         //     ),
      
//         //     const SizedBox(height: 14),
      
//         //     /// Vehicle 2
//         //     Padding(
//         //       padding: const EdgeInsets.symmetric(horizontal: 16),
//         //       child: _vehicleCard(
//         //         title: "MG ZS EV",
//         //         vehicleNo: "MH04CB2523",
//         //         image:
//         //            CommonImagePath.vehicle2
//         //       ),
//         //     ),
//         //   ],
//         // ),
//         bottomNavigationBar: Container(
//           padding: const EdgeInsets.fromLTRB(
//             16,
//             10,
//             16,
//             18,
//           ),
//           color: Colors.white,
//           child: SizedBox(
//             height: 48,
//             child: ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: CommonColors.blue,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 elevation: 0,
//               ),
//               onPressed: () {
//                  Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => 
//        VehicleSelectionScreen(isVehicleAdded: true,)
      
//       ),
//         );
//               },
//               child: const Text(
//                 "Add Vehicle",
//                 style: TextStyle(
//                   fontSize: 15,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

// Widget _vehicleCard({
//   required String title,
//   required String vehicleNo,
//   required String image,
//   required String recid,
//   bool isAutoCharge = false,
  
// }) {
//   return GestureDetector(
//     onTap: () {
//       Navigator.push(
//         routeGlobalKey.currentContext!,
//         MaterialPageRoute(
//           builder: (_) => VehicleDetailScreen(),
//         ),
//       );
//     },
//     child: Container(
//       padding: const EdgeInsets.fromLTRB(
//         18,
//         16,
//         12,
//         16,
//       ),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(.08),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment:
//                   CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w700,
//                     color: Colors.black,
//                   ),
//                 ),

//                 const SizedBox(height: 10),

//                 Row(
//                   children: [
//                     const Icon(
//                       Icons.directions_car,
//                       size: 15,
//                       color: Colors.grey,
//                     ),
//                     const SizedBox(width: 5),
//                     Text(
//                       vehicleNo,
//                       style: const TextStyle(
//                         fontSize: 13,
//                         color: Colors.grey,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ],
//                 ),

//                 if (isAutoCharge) ...[
//                   const SizedBox(height: 16),

//                   Column(
//                     children: [
//                       Stack(
//                         clipBehavior: Clip.none,
//                         children: [
//                           Container(
//                             width: 38,
//                             height: 30,
//                             decoration: BoxDecoration(
//                               borderRadius:
//                                   BorderRadius.circular(8),
//                               border: Border.all(
//                                 color: Colors.grey.shade300,
//                               ),
//                             ),
//                             child: const Center(
//                               child: Icon(
//                                 Icons.bolt,
//                                 size: 20,
//                               ),
//                             ),
//                           ),

//                           Positioned(
//                             top: -2,
//                             right: -2,
//                             child: Container(
//                               width: 8,
//                               height: 8,
//                               decoration:
//                                   const BoxDecoration(
//                                 color:
//                                     Color(0xFFFF8A00),
//                                 shape: BoxShape.circle,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),

//                       const SizedBox(height: 2),

//                       const Text(
//                         "AutoCharge",
//                         style: TextStyle(
//                           fontSize: 8,
//                           color: Colors.grey,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ],
//             ),
//           ),

//           const SizedBox(width: 10),

//           Align(
//             alignment: Alignment.centerRight,
//             child: Image.asset(
//               image,
//               width: 135,
//               height: 90,
//               fit: BoxFit.contain,
//             ),
//           ),
//           GestureDetector(
//             onTap: ()
//             async {
//                 showModalBottomSheet(
//                         backgroundColor: CommonColors.white,
//                         context: context,
//                         shape: RoundedRectangleBorder(
//                           borderRadius:
//                               BorderRadius.vertical(top: Radius.circular(20)),
//                         ),
//                         isScrollControlled: true,
//                         builder: (_) => ConfirmationSheet(
//                           title: "Are you sure you want to delete? ",
//                           singleButton: "",
//                           imagePath: CommonImagePath.delete, // Your SVG/PNG
//                           isSingleButton: false,
//                           onBackToHome: () {},
//                           onCancel: () => Navigator.pop(context),
//                           onLogout: () async {
//                            final success = await  context.read<VehicleProvider>().deleteVehicle(
//   context,
//   recid
// );

// if (success) {
//   Navigator.pop(context);
// }
//                           },
//                           firstbutton: 'Cancel',
//                           secondButton: 'Delete',
//                           subHeading: '',
//                         ),
//                       );
              
//             },
//             child: Image.asset(CommonImagePath.delete,width: 20,height: 20,))
//         ],
//       ),
//     ),
//   );
// }
// }

import 'package:HyCharge/Provider/VehicleProvider.dart';
import 'package:HyCharge/Screens/MainTab.dart';
import 'package:HyCharge/Screens/Vehicle/MyVehicleScreen.dart';
import 'package:HyCharge/Screens/Vehicle/VehicleDetailScreen.dart';
import 'package:HyCharge/Utils/commoncolors.dart';
import 'package:HyCharge/Utils/commonimages.dart';
import 'package:HyCharge/main.dart';
import 'package:HyCharge/widget/CommonButton.dart';
import 'package:HyCharge/widget/GlobalLists.dart';
import 'package:HyCharge/widget/LogoutConfirmationSheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class ManageVehicleScreen extends StatefulWidget {
  const ManageVehicleScreen({super.key});

  @override
  State<ManageVehicleScreen> createState() =>
      _ManageVehicleScreenState();
}

class _ManageVehicleScreenState extends State<ManageVehicleScreen> {
  static const Color navy = Color(0xFF142D70);
  static const Color pageBackground = Color(0xFFF2F5FA);
  static const Color secondaryText = Color(0xFF68758C);
  static const Color dividerColor = Color(0xFFE1E7F0);
  static const Color iconBackground = Color(0xFFF0F4FC);
  static const Color deleteRed = Color(0xFFFF3434);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VehicleProvider>().getUserVehicleList(context);
    });
  }

  void _goToHome() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MainTab(
          isLoggedIn: GlobalLists.islLogin,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _goToHome();
        return false;
      },
      child: Scaffold(
        backgroundColor: CommonColors.neutral50,

        // APP BAR
        appBar: AppBar(
          backgroundColor: CommonColors.neutral50,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          toolbarHeight: 62,
          leadingWidth: 58,
          leading: Padding(
            padding: const EdgeInsets.only(left: 12),
            child: IconButton(
              onPressed: _goToHome,
              style: IconButton.styleFrom(
                backgroundColor: Colors.white,
                shape: const CircleBorder(),
                fixedSize: const Size(42, 42),
              ),
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: navy,
                size: 22,
              ),
            ),
          ),
          title: const Text(
            'Manage Vehicle',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Color(0xFF172443),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: InkWell(
                onTap: () {
                  // Keep the existing FAQ action unchanged.
                },
                borderRadius: BorderRadius.circular(20),
                child: const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.help_outline_rounded,
                        size: 17,
                        color: navy,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'FAQ',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: navy,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),

        // VEHICLE LIST
        body: Consumer<VehicleProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: navy,
                ),
              );
            }

            if (provider.userVehicles.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 84,
                        height: 84,
                        decoration: const BoxDecoration(
                          color: iconBackground,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.directions_car_outlined,
                          size: 42,
                          color: navy,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'No Vehicle Found',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF172443),
                        ),
                      ),
                      const SizedBox(height: 7),
                      const Text(
                        'Add your vehicle to get started.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(
                16,
                12,
                16,
                20,
              ),
              itemCount: provider.userVehicles.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: 8),
            itemBuilder: (context, index) {
  final vehicle = provider.userVehicles[index];

  return _vehicleCard(
    title: provider.getModelName(vehicle.carModelID),
    vehicleNo: vehicle.carRegistrationNumber ?? '',
    image: CommonImagePath.carskyblue,
    recid: vehicle.recId!,
    vehicle: vehicle,
    isAutoCharge: true,
  );
},
            );
          },
        ),

        // FIXED BOTTOM ADD VEHICLE BUTTON
        bottomNavigationBar: Container(
          padding: EdgeInsets.fromLTRB(
            18,
            12,
            18,
            MediaQuery.of(context).padding.bottom + 14,
          ),
          decoration: const BoxDecoration(
    color: CommonColors.cardWhite,
    border: Border(
      top: BorderSide(color: Color(0xFFE1E5EB), width: 1), // outlineVariant divider
    ),
  ),
          child: 
          CommonButton(
      title: 'Add Vehicle',
     
      onPressed: () async {
         Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => VehicleSelectionScreen(
                      isVehicleAdded: true,
                    ),
                  ),
                );
      },
    ),
          
          // SizedBox(
          //   height: 56,
          //   width: double.infinity,
          //   child: ElevatedButton(
          //     onPressed: () {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //           builder: (_) => VehicleSelectionScreen(
          //             isVehicleAdded: true,
          //           ),
          //         ),
          //       );
          //     },
          //     style: ElevatedButton.styleFrom(
          //       backgroundColor: navy,
          //       foregroundColor: Colors.white,
          //       elevation: 0,
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(17),
          //       ),
          //     ),
          //     child: const Text(
          //       'Add Vehicle',
          //       style: TextStyle(
          //         fontFamily: 'Poppins',
          //         fontSize: 15,
          //         fontWeight: FontWeight.w700,
          //         color: Colors.white,
          //       ),
          //     ),
          //   ),
          // ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // VEHICLE CARD
  // ---------------------------------------------------------------------------

Widget _vehicleCard({
  required String title,
  required String vehicleNo,
  required String image,
  required String recid,
  required dynamic vehicle,
  bool isAutoCharge = false,
}) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(23),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => VehicleDetailScreen(
        vehicle: {
          'vehicleName': title,
          'registrationNumber': vehicleNo,
          'vehicleId': recid,
          'imagePath': image,
          'connectorType': '-',
          'batteryType': '-',
          'chargingType': '-',
          'totalSessions': '0',
          'greenKms': '0 km',
          'lastCharge': '-',
        },
      ),
    ),
  );
},
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(23),
            border: Border.all(
              color: const Color(0xFFE8EDF5),
              width: 0.8,
            ),
            boxShadow: [
              BoxShadow(
                color: navy.withOpacity(0.045),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // TOP ROW: VEHICLE DETAILS AND IMAGE
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  2,
                  16,
                  2,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF172443),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                             SvgPicture.asset(CommonImagePath.car_navy,width: 14,height: 14,),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  vehicleNo,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300,
                                    color: CommonColors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      flex: 5,
                      child: SizedBox(
                        height: 80,
                        child: Image.asset(
                          image,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) {
                            return const Icon(
                              Icons.directions_car_rounded,
                              color: navy,
                              size: 55,
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // DIVIDER
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Divider(
                  height: 1,
                  thickness: 1,
                  color: dividerColor,
                ),
              ),

              // BOTTOM ROW: AUTOCHARGE AND DELETE
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  11,
                  16,
                  11,
                ),
                child: Row(
                  children: [
                    // AUTOCHARGE ICON
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
  width: 42,
  height: 42,
  decoration: BoxDecoration(
    shape: BoxShape.circle,
    color: Colors.white,
    border: Border.all(
      color: const Color(0xFFDCE4F0),
      width: 1.2,
    ),
  ),
  child: Center(
    child: SvgPicture.asset(
      CommonImagePath.chargingGreen,
      width: 18,
      height: 18,
      fit: BoxFit.contain,
      color: CommonColors.black,
    ),
  ),
),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: isAutoCharge
                                  ? const Color(0xFF2BC878)
                                  : const Color(0xFFFFB52E),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(width: 10),

                     Expanded(
                      child: Text(
                        'AutoCharge',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 10,
                          fontWeight: FontWeight.w300,
                          color: CommonColors.black,
                        ),
                      ),
                    ),

                    // DELETE BUTTON
                    Material(
                      color: const Color(0xFFFFEEEE),
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () {
                          _showDeleteConfirmation(recid);
                        },
                        child: SizedBox(
                          width: 39,
                          height: 39,
                          child: Center(
                            child: Image.asset(
                              CommonImagePath.delete,
                              width: 14,
                              height: 14,
                              color: const Color.fromARGB(255, 237, 13, 13),
                              errorBuilder: (_, __, ___) {
                                return const Icon(
                                  Icons.delete_outline_rounded,
                                  size: 21,
                                  color: Color.fromARGB(255, 247, 5, 5),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // DELETE CONFIRMATION
  // ---------------------------------------------------------------------------

  void _showDeleteConfirmation(String recid) {
    showModalBottomSheet(
      backgroundColor: CommonColors.white,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      isScrollControlled: true,
      builder: (_) => ConfirmationSheet(
        title: 'Are you sure you want to delete?',
        singleButton: '',
        imagePath: CommonImagePath.delete,
        isSingleButton: false,
        onBackToHome: () {},
        onCancel: () => Navigator.pop(context),
        onLogout: () async {
          final success = await context
              .read<VehicleProvider>()
              .deleteVehicle(context, recid);

          if (success && mounted) {
            Navigator.pop(context);
          }
        },
        firstbutton: 'Cancel',
        secondButton: 'Delete',
        subHeading: '',
      ),
    );
  }
}
