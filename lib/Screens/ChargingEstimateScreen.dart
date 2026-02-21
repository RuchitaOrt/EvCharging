import 'dart:async';

import 'package:HyCharge/Bottomsheet/showAddMoneyBottomSheet.dart';
import 'package:HyCharge/Provider/ChargingEstimateProvider.dart';
import 'package:HyCharge/Provider/ChargingProvider.dart';
import 'package:HyCharge/Provider/WalletProvider.dart';
import 'package:HyCharge/Screens/MainTab.dart';
import 'package:HyCharge/Screens/SessionChargingScreen.dart';
import 'package:HyCharge/Utils/AuthStorage.dart';
import 'package:HyCharge/Utils/CommonAppBar.dart';
import 'package:HyCharge/Utils/ShowDialog.dart';
import 'package:HyCharge/Utils/commoncolors.dart';
import 'package:HyCharge/Utils/commonstrings.dart';
import 'package:HyCharge/main.dart';
import 'package:HyCharge/model/ChargingcomprehensiveHubResponse.dart';
import 'package:HyCharge/widget/GlobalLists.dart';
import 'package:HyCharge/widget/custom_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChargingEstimateScreen extends StatefulWidget {
  final Charger? selectedCharger;
  final String? selectedStationID;
  const ChargingEstimateScreen(
      {super.key, this.selectedCharger, this.selectedStationID});

  @override
  State<ChargingEstimateScreen> createState() => _ChargingEstimateScreenState();
}

class _ChargingEstimateScreenState extends State<ChargingEstimateScreen> {
  double currentWalletPrice = 0.0;
  String? selectedStationID;


  @override
  Widget build(BuildContext context) {
    final walletProvider = context.watch<WalletProvider>();

    currentWalletPrice = walletProvider.currentBalance;

    print("Current BALANCE ${walletProvider.currentBalance}");
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: CommonAppBar(
          title: "Plugin and Charge",
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
                // color: CommonColors.neutral50,
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.black12,
                //     blurRadius: 8,
                //     offset: Offset(0, -2),
                //   ),
                // ],
                ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // ⭐ VERY IMPORTANT
              children: [
                // Container(
                //   padding: const EdgeInsets.all(14),
                //   decoration: BoxDecoration(
                //     color: CommonColors.neutral50,
                //     borderRadius: BorderRadius.circular(10),
                //   ),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Row(
                //         children: const [
                //           Icon(Icons.local_offer,
                //               color: Colors.orange, size: 18),
                //           SizedBox(width: 8),
                //           Text(
                //             "Apply Coupon",
                //             style: TextStyle(fontSize: 12),
                //           ),
                //         ],
                //       ),
                //       InkWell(
                //         onTap: () {},
                //         child: DottedUnderlineText(
                //           text: "View Coupons",
                //           dotColor: CommonColors.blue,
                //           style: const TextStyle(
                //             fontSize: 10,
                //             color: CommonColors.blue,
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                // const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Wallet credits", style: TextStyle(fontSize: 12)),
                    Text("₹ ${currentWalletPrice}",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w700)),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
  width: double.infinity,
  height: 44,
  child: Consumer<ChargingProvider>(
    builder: (context, provider, _) => ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: CommonColors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: provider.loading
          ? null // disable button while loading
          : () async {
              final chargingEstimate =
                  context.read<ChargingEstimateProvider>();
              final userId = await AuthStorage.getUserId();
              if (userId == null) return;

              final enteredAmount = chargingEstimate.amount;
              print("RRenteredAmount");
print(enteredAmount);
              if (enteredAmount == 0) {
                showToast("Please enter amount");
              } else if (currentWalletPrice >= enteredAmount) {
                // ✅ start session
                final response = await provider.startSession(
                  context: context,
                  chargingGunId: widget.selectedCharger!.recId!,
                  chargingStationId: widget.selectedStationID!,
                  userId: userId,
                  chargeTagId: "B4A63CDF",
                  connectorId: int.parse(widget.selectedCharger!.connectorId!),
                  startMeterReading: "0",
                  chargingTariff: "typeATariff",
                  costLimit: chargingEstimate.amount.toString(),
                  energyLimit: chargingEstimate.units.toString(),
                  timeLimit: chargingEstimate.time.toString(),
                  batteryIncreaseLimit: chargingEstimate.percentage.toString()

                );

                if (response != null && response.success) {
                  showToast("Charging session started successfully!");
                  print("BEFORE STSRT");
                  print(response.data!.session!.recId);
                  print(response.data!.batteryStateOfCharge!.startSoC);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SessionChargingScreen(
                        args: SessionChargingArgs(
                          sessionId: response.data!.session!.recId!,
                          status: response.data!.session!.status ?? "",
                          cost: response.data!.session!.chargingTotalFee!.toString() ?? "0",
                          unitConsumed: response.data!.session!.energyTransmitted!.toString() ?? "0",
                          outputPower: response.data!.session!.chargingGun!.powerOutput.toString() ?? "0",
                          batteryPercentage:response.data!.batteryStateOfCharge!.startSoC==null?"0": response.data!.batteryStateOfCharge!.startSoC.toString() ?? "0",
                          endMeterReading: response.data!.session!.endMeterReading!.toString() ?? "0",
                          duration: response.data!.session!.duration.toString() ??"0"
                        ),
                      ),
                    ),
                  );
                } else {
                  showToast("Failed to start session");
                }
              } else {
                showToast("Wallet does not have sufficient amount");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MainTab(
                      isLoggedIn: GlobalLists.islLogin,
                      currentIndex: 3,
                      iscreditopen: true,
                    ),
                  ),
                );
              }
            },
      child: provider.loading
          ? const SizedBox(
              height: 22,
              width: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(CommonColors.white),
              ),
            )
          : const Text(
              "Start Charging",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
    ),
  ),
)
,
           
              ],
            ),
          ),
        ),
        backgroundColor: CommonColors.neutral50,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 👇 TabBar moved OUT of AppBar
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 16, bottom: 16),
              child: Text("Select Charging Type",
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600)),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                indicatorSize: TabBarIndicatorSize.label,
                indicator: BoxDecoration(
                  // color: CommonColors.blue,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                labelColor: CommonColors.blue,
                unselectedLabelColor: Colors.black54,
                tabs: [
                  Tab(text: "Amount"),
                  Tab(text: "Units"),
                  // Tab(text: "Time"),
                  Tab(text: "Time"),
                ],
              ),
            ),

            // 👇 Content
             Expanded(
              child: _TabViews(
                widget.selectedCharger,widget.selectedStationID
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class _EstimateCard extends StatelessWidget {
  final String label1;
  final String label2;
  final String label3;
  final String labelvalue1;
  final String labelvalue2;
  final String labelvalue3;

  const _EstimateCard(
    this.label1,
    this.label2,
    this.label3,
    this.labelvalue1,
    this.labelvalue2,
    this.labelvalue3,
  );

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _infoColumn(label1, labelvalue1),
            const VerticalDivider(thickness: 1),
            _infoColumn(label2, labelvalue2),
            const VerticalDivider(thickness: 1),
            _infoColumn(label3, labelvalue3),
          ],
        ),
      ),
    );
  }
    Widget _infoColumn(String title, String value) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            color: CommonColors.blue,
            fontSize: 13,
          ),
        ),
        Text(value),
      ],
    );
  }
}

// class _EstimateCard extends StatelessWidget {
//   final String label1;
//   final String label2;
//   final String label3;
//   final String labelvalue1;
//   final String labelvalue2;
//   final String labelvalue3;

//   const _EstimateCard(this.label1, this.label2, this.label3, this.labelvalue1,
//       this.labelvalue2, this.labelvalue3);

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<ChargingEstimateProvider>(
//       builder: (_, p, __) {
//         return AnimatedContainer(
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeOut,
//           margin: const EdgeInsets.all(16),
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(16),
//             boxShadow: const [
//               BoxShadow(color: Colors.black12, blurRadius: 8),
//             ],
//           ),
//           child: IntrinsicHeight(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 _infoColumn("${label1}", "${labelvalue1}"),
//                 const VerticalDivider(thickness: 1),
//                 _infoColumn("${label2}", "${labelvalue2}"),
//                 const VerticalDivider(thickness: 1),
//                 _infoColumn("${label3}", "${labelvalue3}"),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _infoColumn(String title, String value) {
//     return Column(
//       children: [
//         Text(
//           title,
//           style: TextStyle(
//             color: CommonColors.blue,
//             fontSize: 13,
//           ),
//         ),
//         Text(value),
//       ],
//     );
//   }
// }

class _TabViews extends StatelessWidget {
   final Charger? selectedCharger;
  final String? selectedStationID;
   _TabViews(this.selectedCharger, this.selectedStationID);
 Timer? _debounce;
  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _AmountTab(selectedCharger: selectedCharger,selectedStationID: selectedStationID,),
            textInfo(),
            const SizedBox(height: 8),
            // _EstimateCard("Time", "Unit", "Percentage", "-", "-", "0 %"),
             Consumer<ChargingEstimateProvider>(
  builder: (_, p, __) {
    return _EstimateCard(
      "Time",
      "Unit",
      "Percentage",
      "${p.time} min",
      "${p.units.toStringAsFixed(2)}",
      "${p.percentage} %",
    );
  },
),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
  //           _sliderTab(
  //             label: "Select Units (kWh)",
  //             min: 1,
  //             max: 40,
  //             onChange: (v) 
  //             {
  //                            final value = v ?? 0;

  // final provider = context.read<ChargingEstimateProvider>();



  // if (_debounce?.isActive ?? false) _debounce!.cancel();

  // _debounce = Timer(const Duration(milliseconds: 600), () {
  //   provider.estimateCharging(
  //     context: context,
  //     chargingGunId: selectedCharger!.recId.toString(),
  //     chargingStationId: selectedStationID!,
  //     connectorId: selectedCharger!.connectorId.toString(),
  //     desiredEnergy: v,
  //   );
  // });
  //             },
  //             valueSelector: (p) => p.units,
  //           ),
  _sliderTab(
  label: "Select Units (kWh)",
  min: 1,
  max: 40,
  

  // 👇 While dragging → only update value
//   onChanged: (v) {
//     // context.read<ChargingEstimateProvider>().units = v;
//       context.read<ChargingEstimateProvider>().activeMode = "units";
//    context.read<ChargingEstimateProvider>().setUnits(v);
//   },

//   // 👇 When user releases → call API
//   onChangeEnd: (v) {
//     final provider = context.read<ChargingEstimateProvider>();
// provider.activeMode = "units";
//     provider.estimateCharging(
//       context: context,
//       chargingGunId: selectedCharger!.recId.toString(),
//       chargingStationId: selectedStationID!,
//       connectorId: selectedCharger!.connectorId.toString(),
//       desiredEnergy: v,
//     );
//   },
onChanged: (v) {
  final provider = context.read<ChargingEstimateProvider>();
  provider.isDragging = true;
  provider.activeMode = "units";
  provider.setUnits(v);
},

onChangeEnd: (v) {
  final provider = context.read<ChargingEstimateProvider>();
  provider.isDragging = false;
  provider.activeMode = "units";

  provider.estimateCharging(
    context: context,
    chargingGunId: selectedCharger!.recId.toString(),
    chargingStationId: selectedStationID!,
    connectorId: selectedCharger!.connectorId.toString(),
    desiredEnergy: v,
  );
},

  valueSelector: (p) => p.units,
),

            textInfo(),
            const SizedBox(height: 8),
            // _EstimateCard(
            //     "Time", "Percentage", "Amount", "-", "0 %", "₹ 0"),
            Consumer<ChargingEstimateProvider>(
  builder: (_, p, __) {
    return _EstimateCard(
      "Time",
      "Percentage",
      "Amount",
      "${p.time} min",
      "${p.percentage} %",
      "₹ ${p.amount}",
    );
  },
),

          ],
        ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // _sliderTab(
                  //   label: "Charging Time (hrs)",
                  //   min: 0,
                  //   max: 80,
                  //   onChange: (v) =>
                  //       context.read<ChargingEstimateProvider>().updateByTime(v),
                  //   valueSelector: (p) => p.time,
                  // ),
                   Padding(
              padding: const EdgeInsets.only(left: 24, top: 16, bottom: 16),
              child: Text("Select Time in min",
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w400)),
            ),
                Padding(
                  padding: const EdgeInsets.only(left: 24,right: 24,),
                  child:
                  Selector<ChargingEstimateProvider, double>(
  selector: (_, p) => p.time,
  builder: (context, timeValue, __) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: 3,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
      ),
      child: Slider(
        value: timeValue.clamp(0, 80),
        min: 0,
        max: 80,
        activeColor: CommonColors.blue,
        onChanged: (v) {
          final provider = context.read<ChargingEstimateProvider>();
          provider.isDragging = true;
          provider.activeMode = "time";
          provider.setTime(v);
        },
        onChangeEnd: (v) {
          final provider = context.read<ChargingEstimateProvider>();
          provider.isDragging = false;
          provider.activeMode = "time";

          provider.estimateCharging(
            context: context,
            chargingGunId: selectedCharger!.recId.toString(),
            chargingStationId: selectedStationID!,
            connectorId: selectedCharger!.connectorId.toString(),
            desiredDuration: v.round(),
          );
        },
      ),
    );
  },
)

//                    Consumer<ChargingEstimateProvider>(
//                         builder: (_, p, __) {
//                        return SliderTheme(
//                         data: SliderTheme.of(_).copyWith(
//                         trackHeight: 3,
//                         thumbShape:
//                             const RoundSliderThumbShape(enabledThumbRadius: 8),
//                         overlayShape:
//                             const RoundSliderOverlayShape(overlayRadius: 14),
//                                        ),
//                          child:
//                          Selector<ChargingEstimateProvider, double>(
//   selector: (_, p) => p.time,
//   builder: (_, timeValue, __) {
//     return SliderTheme(
//       data: SliderTheme.of(context).copyWith(
//         trackHeight: 3,
//         thumbShape:
//             const RoundSliderThumbShape(enabledThumbRadius: 8),
//         overlayShape:
//             const RoundSliderOverlayShape(overlayRadius: 14),
//       ),
//       child: Slider(
//         value: timeValue.clamp(0, 80),
//         min: 0,
//         max: 80,
//         activeColor: CommonColors.blue,
//         onChanged: (v) {
//           final provider = context.read<ChargingEstimateProvider>();
//           provider.isDragging = true;
//           provider.activeMode = "time";
//           provider.setTime(v);
//         },
//         onChangeEnd: (v) {
//           final provider = context.read<ChargingEstimateProvider>();
//           provider.isDragging = false;
//           provider.activeMode = "time";

//           provider.estimateCharging(
//             context: context,
//             chargingGunId: selectedCharger!.recId.toString(),
//             chargingStationId: selectedStationID!,
//             connectorId: selectedCharger!.connectorId.toString(),
//             desiredDuration: v.round(),
//           );
//         },
//       ),
//     );
//   },
// )

// //                           Slider(
// //                            value: p.time,
// //                            min: 0,
// //                             activeColor: CommonColors.blue,
// //                            max: 80,
// //                            onChanged: (v) {
// //   final provider = context.read<ChargingEstimateProvider>();
// //   provider.isDragging = true;
// //   provider.activeMode = "time";
// //   provider.setTime(v);
// // },

// // onChangeEnd: (v) {
// //   final provider = context.read<ChargingEstimateProvider>();
// //   provider.isDragging = false;
// //   provider.activeMode = "time";

// //   provider.estimateCharging(
// //     context: context,
// //     chargingGunId: selectedCharger!.recId.toString(),
// //     chargingStationId: selectedStationID!,
// //     connectorId: selectedCharger!.connectorId.toString(),
// //     desiredDuration: v.round(),
// //   );
// // },



  
// //                          ),
//                        );
//                      }
//                    ),
                ),
              
                   Padding(
                     padding: const EdgeInsets.only(left: 24,right: 24),
                     child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          "0 min",
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          "1h 20m",
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                                       ),
                   ),
                                   const SizedBox(height: 24),
                                  Center(
                                    child: Selector<ChargingEstimateProvider, double>(
                                      selector: (_, p) => p.time,
                                      builder: (_, timeValue, __) {
                                        return Text(
                                          formatAsMinutes(timeValue),
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        );
                                      },
                                    ),
                                  ),

                                   const SizedBox(height: 8),
                  textInfo(),
                  
                const SizedBox(height: 8),
                Consumer<ChargingEstimateProvider>(
  builder: (_, p, __) {
    return _EstimateCard(
      "Unit",
      "Percentage",
      "Amount",
      "${p.units.toStringAsFixed(2)}",
      "${p.percentage} %",
      "₹ ${p.amount}",
    );
  },
),

                  //    _EstimateCard("Unit","Percentage","Amount","20","20 %","₹ 2000"),
                ],
              ),
        // Column(
        //   mainAxisAlignment: MainAxisAlignment.start,
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //     _sliderTab(
        //       label: "Battery %",
        //       min: 1,
        //       max: 100,
        //       onChange: (v) => context
        //           .read<ChargingEstimateProvider>()
        //           .updateByPercentage(v),
        //       valueSelector: (p) => p.percentage,
        //     ),
        //     textInfo(),
        //     const SizedBox(height: 8),
        //     _EstimateCard("Time", "Unit", "Amount", "-", "-", "₹ 0"),
        //   ],
        // ),
      ],
    );
  }
  String formatAsMinutes(double minutes) {
  return "${minutes.round()} min";
}

String _formatMinutes(double minutes) {
  int hrs = minutes ~/ 60;
  int mins = (minutes % 60).round();

  if (hrs == 0) return "$mins min";
  if (mins == 0) return "$hrs h";
  return "${hrs}h ${mins}m";
}

  Widget textInfo() {
    return Padding(
      padding: const EdgeInsets.only(left: 24),
      child: Text("Estimates Value",
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400)),
    );
  }
  Widget _sliderTab({
  required String label,
  required double min,
  required double max,
  required Function(double) onChanged,
  required Function(double) onChangeEnd,
  required double Function(ChargingEstimateProvider) valueSelector,
}) {
  return Selector<ChargingEstimateProvider, double>(
    selector: (_, p) => valueSelector(p),
    builder: (_, value, __) {

      final clampedValue = value.clamp(min, max);

      return Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            SliderTheme(
               data: SliderTheme.of(routeGlobalKey.currentContext!).copyWith(
        trackHeight: 3,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
      ),
              child: Slider( activeColor: CommonColors.blue,
                min: min,
                max: max,
                value: clampedValue,
                onChanged: onChanged,
                onChangeEnd: onChangeEnd,
              ),
            ),
          ],
        ),
      );
    },
  );
}

// Widget _sliderTab({
//   required String label,
//   required double min,
//   required double max,
//   required Function(double) onChanged,
//   required Function(double) onChangeEnd,
//   required double Function(ChargingEstimateProvider) valueSelector,
// }) {
//   return Consumer<ChargingEstimateProvider>(
//     builder: (_, p, __) {
//       final value = valueSelector(p).clamp(min, max);

//       return Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(label,
//                 style: const TextStyle(
//                     fontSize: 12, fontWeight: FontWeight.w400)),
//             const SizedBox(height: 20),

//             Slider(
//               activeColor: CommonColors.blue,
//               min: min,
//               max: max,
//               value: value,
//               onChanged: onChanged,       // 👈 only UI update
//               onChangeEnd: onChangeEnd,   // 👈 API call here
//             ),

//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 4),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(min.toStringAsFixed(1),
//                       style: const TextStyle(
//                           fontSize: 10, color: Colors.black54)),
//                   Text(max.toStringAsFixed(1),
//                       style: const TextStyle(
//                           fontSize: 10, color: Colors.black54)),
//                 ],
//               ),
//             ),

//             Center(
//               child: Text(
//                 value.toStringAsFixed(1),
//                 style: const TextStyle(
//                     fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//             )
//           ],
//         ),
//       );
//     },
//   );
// }
}
//   Widget _sliderTab({
//     required String label,
//     required double min,
//     required double max,
//     required Function(double) onChange,
//     required double Function(ChargingEstimateProvider) valueSelector,
//   }) {
//     return Consumer<ChargingEstimateProvider>(
//       builder: (_, p, __) {
//         final value = valueSelector(p).clamp(min, max);

//         return Padding(
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(label,
//                   style: const TextStyle(
//                       fontSize: 12, fontWeight: FontWeight.w400)),
//               const SizedBox(height: 20),
//               SliderTheme(
//                 data: SliderTheme.of(_).copyWith(
//                   trackHeight: 3,
//                   thumbShape:
//                       const RoundSliderThumbShape(enabledThumbRadius: 8),
//                   overlayShape:
//                       const RoundSliderOverlayShape(overlayRadius: 14),
//                 ),
//                 child: Column(
//                   children: [
//                     Slider(
//                       activeColor: CommonColors.blue,
//                       min: min,
//                       max: max,
//                       value: value,
//                       onChanged: onChange,
//                     ),

//                     // 👇 Min & Max labels
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 4),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             label.contains("%")
//                                 ? "${min.toStringAsFixed(1)} %"
//                                 : min.toStringAsFixed(1),
//                             style: const TextStyle(
//                               fontSize: 10,
//                               color: Colors.black54,
//                             ),
//                           ),
//                           Text(
//                             label.contains("%")
//                                 ? "${max.toStringAsFixed(1)} %"
//                                 : max.toStringAsFixed(1),
//                             style: const TextStyle(
//                               fontSize: 10,
//                               color: Colors.black54,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Center(
//                 child: Text(
//                   label.contains("%")
//                       ? "${value.toStringAsFixed(1)} %"
//                       : value.toStringAsFixed(1),
//                   style: const TextStyle(
//                       fontSize: 20, fontWeight: FontWeight.bold),
//                 ),
//               )
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

class _AmountTab extends StatefulWidget {
  final Charger? selectedCharger;
  final String? selectedStationID;


  const _AmountTab({
    required this.selectedCharger,
    required this.selectedStationID,
  });
  @override
  State<_AmountTab> createState() => _AmountTabState();
}

class _AmountTabState extends State<_AmountTab> {
 Timer? _debounce;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ChargingEstimateProvider>();

    return SingleChildScrollView(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          Text("How much amount do you wamt to charge for (Excl of Taxes)",
              style:
                  const TextStyle(fontSize: 12, fontWeight: FontWeight.w400)),
          CustomTextFieldWidget(
            title: "",
            isMandatory: false,
            hintText: CommonStrings.strAmountHint,
            textEditingController: provider.controller,
            textInputType: TextInputType.number,
            leadingIcon: Text("₹",
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            onChange: (val) {
              // final value = double.tryParse(val) ?? 0;
              // print("val of textfield");
              // print(val);
              // provider.calculateFromAmount(value);
              provider.activeMode = "amount";
provider.setAmount(val);

              final value = double.tryParse(val) ?? 0;

  // provider.amount = value;

  if (_debounce?.isActive ?? false) _debounce!.cancel();
provider.activeMode = "amount";
  _debounce = Timer( Duration(milliseconds: 600), () {
   provider.estimateCharging(
  context: context,
  chargingGunId: widget.selectedCharger!.recId.toString(),
  chargingStationId: widget.selectedStationID!,
  connectorId:  widget.selectedCharger!.connectorId.toString(),
  desiredCost: provider.amount,
);

  });
            },
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
