import 'package:ev_charging_app/Screens/ScanScreen.dart';
import 'package:ev_charging_app/Screens/SelectVehicleScreen.dart';
import 'package:ev_charging_app/Utils/commoncolors.dart';
import 'package:ev_charging_app/Utils/commonimages.dart';
import 'package:ev_charging_app/Utils/sizeConfig.dart';
import 'package:ev_charging_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../model/ChargingcomprehensiveHubResponse.dart';
import 'Map/NavigationScreen.dart';

class MapStationCardScreen extends StatefulWidget {
  final ChargingHub hub;
  const MapStationCardScreen({super.key, required this.hub});

  @override
  State<MapStationCardScreen> createState() => _MapStationCardScreenState();
}

class _MapStationCardScreenState extends State<MapStationCardScreen> {
  bool started = false;

  void _startNavigation() {
    setState(() => started = true);
    // navigate to NavigationScreen after small delay
    Future.delayed(const Duration(milliseconds: 450), () {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => NavigationScreen(hub: widget.hub,)));
    });
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: CommonColors.white,
      body: Stack(
        children: [
          Positioned(
            bottom: 18,
            left: 12,
            right: 12,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // small handle
                Container(
                    width: 48,
                    height: 4,
                    decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(4))),
                const SizedBox(height: 12),
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset(CommonImagePath.thunder),

                          const SizedBox(width: 8),

                          Text(
                            widget.hub.chargingHubName!,
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                          Spacer(), // <-- pushes cancel icon to the end
                          SvgPicture.asset(CommonImagePath.cancel),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: SizeConfig.blockSizeHorizontal * 25,
                                child: Text(
                                  'Address',
                                  style: TextStyle(
                                      color: CommonColors.blue, fontSize: 16),
                                ),
                              ),
                              Container(
                                  width: SizeConfig.blockSizeHorizontal * 50,
                                  child: Text(
                                    ': ${widget.hub.addressLine1}',
                                    maxLines: 4,
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  )),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                // <-- This gives flexible space to the left side
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width:
                                              SizeConfig.blockSizeHorizontal *
                                                  25,
                                          child: Text(
                                            'Status',
                                            style: TextStyle(
                                              color: CommonColors.blue,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            ': Open',
                                            maxLines: 4,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: CommonColors.accentGreen,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          width:
                                              SizeConfig.blockSizeHorizontal *
                                                  25,
                                          child: Text(
                                            'ETA',
                                            style: TextStyle(
                                              color: CommonColors.blue,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            ': 1.5 Min',
                                            maxLines: 4,
                                            style: TextStyle(
                                              fontSize: 12,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          width:
                                              SizeConfig.blockSizeHorizontal *
                                                  25,
                                          child: Text(
                                            'Plug Points ',
                                            style: TextStyle(
                                              color: CommonColors.blue,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            ': 4 type A  2 type B',
                                            maxLines: 4,
                                            style: TextStyle(
                                              fontSize: 12,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              /// RIGHT SIDE SVG IMAGE - NOW ALWAYS VISIBLE
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Image.asset(
                                    CommonImagePath.product,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      // swipe to start button
                      SwipeToStartButton(
                        onComplete: _startNavigation,
                        label: "Swipe To Start the Travel",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



/// ---------- Reached Destination Popup ----------
class ReachedPopup extends StatelessWidget {
  const ReachedPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.grey,
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: CommonColors.grey, borderRadius: BorderRadius.circular(12)),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            width: 60,
            height: 60,
            child: Image.asset(CommonImagePath.check),
          ),
          const SizedBox(height: 10),
          const Text('Successfully Reached your Destination',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.w600, color: CommonColors.white)),
          Divider(
            color: CommonColors.neutral50,
            thickness: 0.2,
          ),
          const SizedBox(height: 8),
          const Text('Hitech EV Station',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: CommonColors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          const Text(
              '830, Patrika Nagar, HITEC City,\n Madhapur, Telangana 500081',
              textAlign: TextAlign.center,
              style: TextStyle(color: CommonColors.white, fontSize: 12)),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    routeGlobalKey.currentContext!,
                    MaterialPageRoute(builder: (context) => ScanScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: CommonColors.white,
                  foregroundColor: CommonColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    // side: BorderSide(
                    //   color: CommonColors.blue.withOpacity(0.4),
                    //   width: 0.8,
                    // ),
                  ),
                ),
                child: const Text('Scan to Charge',
                    style: TextStyle(
                        color: CommonColors.blue,
                        fontWeight: FontWeight.w700))),
          )
        ]),
      ),
    );
  }
}

/// ---------- Reusable Widgets ----------
class BottomStationCard extends StatelessWidget {
  final VoidCallback? onTap;

  const BottomStationCard({this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    final cardW = screenW * 0.82;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: cardW,
        margin: const EdgeInsets.only(top: 4, bottom: 4),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
            color: CommonColors.cardWhite,
            borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.ev_station)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Hitech EV',
                            style: TextStyle(fontWeight: FontWeight.w600)),
                        SizedBox(height: 4),
                        Text('Madapur, Hyderabad',
                            style: TextStyle(fontSize: 12)),
                      ]),
                ),
                Column(children: [
                  Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 8),
                      decoration: BoxDecoration(
                          color: CommonColors.neutral200,
                          borderRadius: BorderRadius.circular(6)),
                      child: const Text('4.8 km')),
                ])
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.bolt, size: 18, color: Colors.black54),
                const SizedBox(width: 8),
                const Text('Type A 50-150kW'),
                const Spacer(),
                ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        backgroundColor: CommonColors.cardWhite,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                                color: CommonColors.primary.withOpacity(0.4)))),
                    child: const Text('Get Directions',
                        style: TextStyle(color: CommonColors.primary))),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class InfoTag extends StatelessWidget {
  final String text;
  final IconData icon;

  const InfoTag(this.icon, this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
          color: CommonColors.neutral200,
          borderRadius: BorderRadius.circular(6)),
      child: Row(
        children: [
          Icon(icon, size: 14),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

class TypeInfo extends StatelessWidget {
  final String type;
  final String price;

  const TypeInfo({required this.type, required this.price, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(type,
          style: const TextStyle(fontSize: 12, color: CommonColors.neutral500)),
      Text(price,
          style: const TextStyle(
              fontWeight: FontWeight.w600, color: CommonColors.primary)),
    ]);
  }
}

/// Simple gradient button used for swipe
class GradientButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const GradientButton({required this.label, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [Color(0xFF0A66FF), Color(0xFF4AB3FF)]),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Text(label,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600)),
      ),
    );
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
//                   'Swipe To Start the Travel',
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
