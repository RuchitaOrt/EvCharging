// import 'package:HyCharge/Utils/commonimages.dart';
// import 'package:flutter/material.dart';

// class VehicleDetailScreen extends StatelessWidget {
//   const VehicleDetailScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xffF7F7F7),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         centerTitle: true,
//         leading: const Icon(
//           Icons.arrow_back_ios,
//           size: 18,
//           color: Colors.black,
//         ),
//         title: const Text(
//           "Vehicle Details",
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: 18,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         actions: const [
//           Padding(
//             padding: EdgeInsets.only(right: 18),
//             child: Icon(
//               Icons.more_vert,
//               color: Color(0xffC64B4B),
//             ),
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(14),
//         child: Column(
//           children: [
//             _vehicleCard(),

//             const SizedBox(height: 14),

//             _statsCard(),

//             const SizedBox(height: 14),

//             _didYouKnowCard(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _vehicleCard() {
//     return Container(
//       padding: const EdgeInsets.only(
//         left: 14,
//         right: 14,
//         top: 10,
//         bottom: 14,
//       ),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(.08),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           )
//         ],
//       ),
//       child: Column(
//         children: [
//           Center(
//             child: Image.asset(
//               CommonImagePath.vehicle5,
//               height: 120,
//               fit: BoxFit.contain,
//             ),
//           ),

//           const SizedBox(height: 20),

//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Expanded(
//                 child: Text(
//                   "MG ZS EV",
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w700,
//                     color: Color(0xff2A2A2A),
//                   ),
//                 ),
//               ),

//               Row(
//                 children: const [
//                   Icon(
//                     Icons.car_rental,
//                     size: 16,
//                     color: Colors.grey,
//                   ),
//                   SizedBox(width: 4),
//                   Text(
//                     "MH04CB2523",
//                     style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w500,
//                       color: Colors.grey,
//                     ),
//                   ),
//                 ],
//               )
//             ],
//           ),

//           const SizedBox(height: 10),

//           const Row(
//             children: [
//               Icon(
//                 Icons.ev_station,
//                 size: 16,
//                 color: Colors.grey,
//               ),
//               SizedBox(width: 2),
//               Text(
//                 "CCS-2",
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),

//               SizedBox(width: 12),

//               Icon(
//                 Icons.battery_charging_full,
//                 size: 16,
//                 color: Colors.grey,
//               ),
//               SizedBox(width: 2),
//               Text(
//                 "Type-2",
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),

//               SizedBox(width: 12),

//               Icon(
//                 Icons.electrical_services,
//                 size: 16,
//                 color: Colors.grey,
//               ),
//               SizedBox(width: 2),
//               Text(
//                 "Wall",
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           )
//         ],
//       ),
//     );
//   }

//   Widget _statsCard() {
//     return Container(
//       padding: const EdgeInsets.symmetric(
//         horizontal: 12,
//         vertical: 16,
//       ),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(.08),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           )
//         ],
//       ),
//       child: const Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           _StatItem(
//             icon: Icons.ev_station,
//             iconColor: Color(0xff6A4CFF),
//             value: "0",
//             title: "Sessions",
//           ),
//           _StatItem(
//             icon: Icons.eco,
//             iconColor: Color(0xff4CD18A),
//             value: "0 km",
//             title: "Green Kms",
//           ),
//           _StatItem(
//             icon: Icons.bolt,
//             iconColor: Color(0xffFF7B6B),
//             value: "-",
//             title: "Last Charge",
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _didYouKnowCard() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(.08),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           )
//         ],
//       ),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment:
//                       CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       "Did you know?",
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xffEF533F),
//                       ),
//                     ),

//                     const SizedBox(height: 10),

//                     RichText(
//                       text: const TextSpan(
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: Colors.black,
//                         ),
//                         children: [
//                           TextSpan(
//                             text:
//                                 "Know more about your ",
//                           ),
//                           TextSpan(
//                             text:
//                                 "electric vehicle!",
//                             style: TextStyle(
//                               color:
//                                   Color(0xff34C884),
//                               fontWeight:
//                                   FontWeight.w700,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),

//                     const SizedBox(height: 14),

//                     const Text(
//                       "Charging an EV: Because trees give better hugs than gasoline pumps.",
//                       style: TextStyle(
//                         fontSize: 12,
//                         height: 1.4,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(width: 10),

//               Image.network(
//                 "https://cdn-icons-png.flaticon.com/512/427/427735.png",
//                 height: 90,
//               ),
//             ],
//           ),

//           const SizedBox(height: 16),

//           Row(
//             children: [
//               _dot(true),
//               _dot(false),
//               _dot(false),
//               _dot(false),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _dot(bool active) {
//     return Container(
//       margin: const EdgeInsets.only(right: 6),
//       width: active ? 10 : 8,
//       height: active ? 10 : 8,
//       decoration: BoxDecoration(
//         color:
//             active ? Colors.black : Colors.grey.shade300,
//         shape: BoxShape.circle,
//       ),
//     );
//   }
// }

// class _StatItem extends StatelessWidget {
//   final IconData icon;
//   final Color iconColor;
//   final String value;
//   final String title;

//   const _StatItem({
//     required this.icon,
//     required this.iconColor,
//     required this.value,
//     required this.title,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//          Icon(
//           icon,
//           color: iconColor,
//           size: 22,
//         ),
//         SizedBox(width: 5,),
//         Column(
//           mainAxisSize: MainAxisSize.max,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
           
           
//            Text(
//   value,
//   strutStyle: const StrutStyle(
//     height: 1,
//     forceStrutHeight: true,
//   ),
//   style: const TextStyle(
//     fontSize: 18,
//     fontWeight: FontWeight.w700,
//     height: 1,
//   ),
// ),
//             Text(
//               title,
//               style: const TextStyle(
//                 fontSize: 12,
//                 color: Colors.grey,
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }

import 'package:HyCharge/Utils/CommonAppBar.dart';
import 'package:HyCharge/Utils/commonimages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class VehicleDetailScreen extends StatelessWidget {
  final Map<String, dynamic> vehicle;

  const VehicleDetailScreen({
    super.key,
    required this.vehicle,
  });

  String _getValue(
    List<String> keys, {
    String fallback = '-',
  }) {
    for (final key in keys) {
      final value = vehicle[key];
      if (value != null && value.toString().trim().isNotEmpty) {
        return value.toString();
      }
    }
    return fallback;
  }

  @override
  Widget build(BuildContext context) {
    final vehicleName = _getValue([
      'vehicleName',
      'name',
      'modelName',
      'model',
    ], fallback: 'Electric Vehicle');

    final registrationNumber = _getValue([
      'registrationNumber',
      'registrationNo',
      'vehicleNumber',
      'vehicleRegistrationNumber',
      'numberPlate',
    ]);

    final connectorType = _getValue([
      'connectorType',
      'connector',
      'chargingConnector',
    ]);

    final batteryType = _getValue([
      'batteryType',
      'battery',
    ]);

    final chargingType = _getValue([
      'chargingType',
      'chargerType',
    ]);

    final sessions = _getValue([
      'totalSessions',
      'sessions',
      'sessionCount',
    ], fallback: '0');

    final greenKms = _getValue([
      'greenKms',
      'greenKm',
      'totalGreenKms',
    ], fallback: '0 km');

    final lastCharge = _getValue([
      'lastCharge',
      'lastChargeDate',
      'lastChargingDate',
    ]);

    return Scaffold(
      backgroundColor: const Color(0xffF7F7F7),
    appBar: CommonAppBar(
        title: "Vehicle Details",
        onBack: () {
          Navigator.pop(context);
        },
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            _vehicleCard(
              vehicleName: vehicleName,
              registrationNumber: registrationNumber,
              connectorType: connectorType,
              batteryType: batteryType,
              chargingType: chargingType,
            ),
            const SizedBox(height: 14),
            _statsCard(
              sessions: sessions,
              greenKms: greenKms,
              lastCharge: lastCharge,
            ),
            const SizedBox(height: 14),
            _didYouKnowCard(),
          ],
        ),
      ),
    );
  }

  Widget _vehicleCard({
    required String vehicleName,
    required String registrationNumber,
    required String connectorType,
    required String batteryType,
    required String chargingType,
  }) {
    final imagePath = vehicle['imagePath']?.toString();

    return Container(
      padding: const EdgeInsets.only(
        left: 14,
        right: 14,
        top: 10,
        bottom: 14,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Center(
            child: imagePath != null && imagePath.isNotEmpty
                ? Image.network(
                    imagePath,
                    height: 120,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Image.asset(
                      CommonImagePath.carskyblue,
                      height: 120,
                      fit: BoxFit.contain,
                    ),
                  )
                : Image.asset(
                    CommonImagePath.carskyblue,
                    height: 120,
                    fit: BoxFit.contain,
                  ),
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  vehicleName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff2A2A2A),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Icon(
                      Icons.car_rental,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        registrationNumber,
                        textAlign: TextAlign.right,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              _vehicleAttribute(
                Icons.ev_station,
                connectorType,
              ),
              _vehicleAttribute(
                Icons.battery_charging_full,
                batteryType,
              ),
              _vehicleAttribute(
                Icons.electrical_services,
                chargingType,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _vehicleAttribute(IconData icon, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Color(0xff2A2A2A),
          ),
        ),
      ],
    );
  }

  Widget _statsCard({
    required String sessions,
    required String greenKms,
    required String lastCharge,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Flexible(
            child: _StatItem(
              icon: Icons.ev_station,
              iconColor: const Color(0xff6A4CFF),
              value: sessions,
              title: 'Sessions',
            ),
          ),
          Flexible(
            child: _StatItem(
              icon: Icons.eco,
              iconColor: const Color(0xff4CD18A),
              value: greenKms,
              title: 'Green Kms',
            ),
          ),
          Flexible(
            child: _StatItem(
              icon: Icons.bolt,
              iconColor: const Color(0xffFF7B6B),
              value: lastCharge,
              title: 'Last Charge',
            ),
          ),
        ],
      ),
    );
  }

  Widget _didYouKnowCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Did you know?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xffEF533F),
                      ),
                    ),
                    const SizedBox(height: 10),
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(text: 'Know more about your '),
                          TextSpan(
                            text: 'electric vehicle!',
                            style: TextStyle(
                              color: Color(0xff34C884),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Charging an EV: Because trees give better hugs than gasoline pumps.',
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.4,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Image.network(
                'https://cdn-icons-png.flaticon.com/512/427/427735.png',
                height: 90,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.eco,
                  size: 70,
                  color: Color(0xff34C884),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _dot(true),
              _dot(false),
              _dot(false),
              _dot(false),
            ],
          ),
        ],
      ),
    );
  }

  Widget _dot(bool active) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      width: active ? 10 : 8,
      height: active ? 10 : 8,
      decoration: BoxDecoration(
        color: active ? Colors.black : Colors.grey.shade300,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String title;

  const _StatItem({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, color: iconColor, size: 22),
        const SizedBox(width: 5),
        Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                strutStyle: const StrutStyle(
                  height: 1,
                  forceStrutHeight: true,
                ),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  height: 1,
                ),
              ),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
