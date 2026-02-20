import 'package:HyCharge/Provider/ChargingProvider.dart';
import 'package:HyCharge/Screens/MainTab.dart';
import 'package:HyCharge/Utils/CommonAppBar.dart';
import 'package:HyCharge/Utils/commoncolors.dart';
import 'package:HyCharge/Utils/commonimages.dart';
import 'package:HyCharge/Utils/sizeConfig.dart';

import 'package:HyCharge/widget/GlobalLists.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'dart:math' as math;
import 'dart:async';
  import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SessionChargingScreen extends StatefulWidget {
  // final StartChargingSessionResponse intitalResponse;
  final SessionChargingArgs args;

  const SessionChargingScreen({
    super.key,
    required this.args,
  });

  //  SessionChargingScreen({
  //   super.key,
  //   required this.args,
  // });

  @override
  State<SessionChargingScreen> createState() => _SessionChargingScreenState();
}

class _SessionChargingScreenState extends State<SessionChargingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  int totalMinutes = 100;
  int? remainingMinutes;
  double currentMeter = 0;
  Timer? _refreshTimer;
  String? status;
  String? cost;
  String? unitConsumed;
  String? outputPower;
  String? batteryPercentage="0";
  String? endMeterReading;
Timer? _durationTimer;
DateTime? _sessionStartTime;
String duration = "00:00";
final String recId ="";
  @override
  void initState() {
    super.initState();
    // Example: if you pass startTime in args
// _sessionStartTime = DateTime.parse(widget.args.startTime);

// If not available, start from now
_sessionStartTime = DateTime.now();

_startDurationTimer();

    // status = widget.intitalResponse.data!.session!.status!;
    // cost = widget.intitalResponse.data!.session!.chargingTotalFee!;
    // unitConsumed = widget.intitalResponse.data!.session!.chargingSpeed!;
    // outputPower = widget.intitalResponse.data!.session!.energyTransmitted!;
    // batteryPercentage ==
    //      widget.intitalResponse.data!.batteryStateOfCharge!.currentSoC;
    // endMeterReading = widget.intitalResponse.data!.session!.endMeterReading;
    
    status = widget.args.status!;
    cost = widget.args.cost;
    unitConsumed = widget.args.unitConsumed;
    outputPower = widget.args.outputPower;
    batteryPercentage =widget.args.batteryPercentage;
      print("BATTERY");
    print(outputPower);
    print("BATTERY");
    print(batteryPercentage);

    endMeterReading = widget.args.endMeterReading;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.repeat();
    _startPolling();
  }
void _startDurationTimer() {
  _durationTimer = Timer.periodic(const Duration(seconds: 1), (_) {
    if (_sessionStartTime == null) return;

    final diff = DateTime.now().difference(_sessionStartTime!);

    final minutes = diff.inMinutes.remainder(60);
    final seconds = diff.inSeconds.remainder(60);
    final hours = diff.inHours;

    setState(() {
      duration =
          "${hours.toString().padLeft(2, '0')}:"
          "${minutes.toString().padLeft(2, '0')}:"
          "${seconds.toString().padLeft(2, '0')}";
    });
  });
}

  void _startPolling() {
    _refreshTimer = Timer.periodic(
      const Duration(seconds: 10),
      (_) async {
        final res =
            await context.read<ChargingProvider>().fetchChargingSessionDetails(
                  context: context,
                  sessionId: widget.args.sessionId!,
                );
        setState(() {
          status = res!.data!.session!.status == null
              ? ""
              : res!.data!.session!.status;
          cost = "${res.data!.costDetails!.totalCost!.toString()!}";
          unitConsumed =
              "${res.data!.session!.energyTransmitted!.toString()} ${res.data!.session!.energyTransmitted!.toString()}";
          outputPower =
              "${res.data!.chargerDetails!.powerOutput} ${res.data!.chargerDetails!.tariffUnit}";
         print("outputPower ${res.data!.chargerDetails!.powerOutput} ${res.data!.chargerDetails!.tariffUnit}");
         
          // batteryPercentage = res!.data!.session!.active==1? res.data!.batteryStateOfCharge.currentSoC.toString():res.data!.batteryStateOfCharge.endSoC.toString();
          final isActive = res?.data?.session?.active == 1;

          batteryPercentage = isActive
              ? res?.data?.batteryStateOfCharge?.currentSoC?.toString() ?? "0"
              : res?.data?.batteryStateOfCharge?.endSoC?.toString() ?? "0";
          print("AFTER 15 sec batteryStateOfCharge");
          print(res.data!.batteryStateOfCharge!.currentSoC.toString());

          endMeterReading = res.data!.session!.endMeterReading.toString();
          print("AFTER 15 sec ${outputPower}");
          // 🔴 Stop polling if session completed
          if (res!.data!.isActive == false) {
            _refreshTimer?.cancel();
              _durationTimer?.cancel(); 
          }
        });
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ChargingProvider>();
    final data = provider.sessionDetails?.data;

    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MainTab(
              isLoggedIn: GlobalLists.islLogin,
              currentIndex: 1,
            ),
          ),
        );
        return false; // prevent default pop
      },
      child: Scaffold(
        backgroundColor: CommonColors.white,
        appBar: CommonAppBar(
          title: "Charging Session",
          onBack: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MainTab(
                  isLoggedIn: GlobalLists.islLogin,
                  currentIndex: 1,
                ),
              ),
            );
          },
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: status == "Completed"
                      ? null
                      : () async {
                          // print("Charging session ID ${data!.session!.recId!}");
                          final response = await provider.endSession(
                              context: context,
                              sessionId:
                                  widget.args.sessionId!, // 🔑 station id
                              endMeterReading: endMeterReading!);

                          setState(() {
                            _durationTimer?.cancel();

                            status = response!.data!.session!.status;

                            cost = response.data!.cost!.toString();
                            unitConsumed =
                                response.data!.session!.energyTransmitted.toString();
                            outputPower =
                                response.data!.session!.chargingGun!.powerOutput.toString();
                            batteryPercentage =response
                                .data!.batteryStateOfCharge!.endSoC==null?"0" :response
                                .data!.batteryStateOfCharge!.endSoC
                                .toString();
                            endMeterReading =
                                response.data!.meterStop.toString();
                          });
                          // if (success) {
                          //   Navigator.pop(context);
                          // }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CommonColors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    "Stop Charging",
                    style: const TextStyle(color: CommonColors.white),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: status == "Completed"
                      ? null
                      : () async {
                        _durationTimer?.cancel();

                          print(
                              "Charging STATION ID ${data!.session!.chargingStationId!}");
                          print(
                              "Charging gun ID ${data.session!.chargingGunId}");
                          final response = await provider.unlockConnector(
                              context: context,
                              chargingStationId: data!
                                  .session!.chargingStationId!, // 🔑 station id
                              connectorId:
                                  int.parse(data.session!.chargingGunId!));
                          status = response!.data!.status;

                          if (response.success) {
                            Navigator.pop(context);
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CommonColors.white,
                    side: const BorderSide(
                      color: CommonColors.blue, // 👈 border color
                      width: 1.5, // 👈 border width
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    "Unlock Session",
                    style: const TextStyle(color: CommonColors.blue),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            
              ChargerAnimation(
                status: status!, // "Active" or "Complete"
              ),

              status == ""
                  ? Container()
                  : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                          child: Text(
                            '${status}',
                            style:
                                TextStyle(color: CommonColors.blue, fontSize: 22),
                          ),
                        ),
                       SizedBox(width: 60,),
                         GestureDetector(
                          onTap: ()
                          async {
print("REFRESH CLICKED");
final res =
            await context.read<ChargingProvider>().fetchChargingSessionDetails(
                  context: context,
                  sessionId: widget.args.sessionId!,
                );
        setState(() {
          status = res!.data!.session!.status == null
              ? ""
              : res!.data!.session!.status;
          cost = "${res.data!.costDetails!.totalCost!.toString()!}";
          unitConsumed =
              "${res.data!.session!.energyTransmitted!.toString()} ${res.data!.session!.energyTransmitted!.toString()}";
          outputPower =
              "${res.data!.chargerDetails!.powerOutput} ${res.data!.chargerDetails!.tariffUnit}";
         print("outputPower ${res.data!.chargerDetails!.powerOutput} ${res.data!.chargerDetails!.tariffUnit}");
         
          // batteryPercentage = res!.data!.session!.active==1? res.data!.batteryStateOfCharge.currentSoC.toString():res.data!.batteryStateOfCharge.endSoC.toString();
          final isActive = res?.data?.session?.active == 1;

          batteryPercentage = isActive
              ? res?.data?.batteryStateOfCharge?.currentSoC?.toString() ?? "0"
              : res?.data?.batteryStateOfCharge?.endSoC?.toString() ?? "0";
          print("AFTER 15 sec batteryStateOfCharge");
          print(res.data!.batteryStateOfCharge!.currentSoC.toString());

          endMeterReading = res.data!.session!.endMeterReading.toString();
        
       
        });

                            
                          },
                          child: Icon(Icons.refresh)),
                    ],
                  ),
                

Row(
  children: [
    Expanded(
      child: SelectableText(
        "${widget.args.sessionId}",
        style: TextStyle(fontSize: 12),
      ),
    ),
    IconButton(
      icon: Icon(Icons.copy),
      onPressed: () {
        Clipboard.setData( ClipboardData(text:  "${widget.args.sessionId}",));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Copied to clipboard")),
        );
      },
    )
  ],
)
,
               
              SizedBox(
                height: 10,
              ),
              _batteryProgress(),
              _infoGrid(),

              //  _ecoSection(data),
              // _stopChargingButton(provider, data),

              // const Spacer(),

              /// Bottom Buttons
            ],
          ),
        ),
      ),
    );
  }

  Widget _batteryProgress() {
    // final double percentage = 10; // data.session?.batteryPercentage ?? 0;

    return Padding(
      padding: const EdgeInsets.only(left: 18, right: 18),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF101E3A),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    TweenAnimationBuilder<double>(
                      tween: Tween(
                          begin: 0,
                          end: (batteryPercentage == null || batteryPercentage == "null")
                              ? 0.0
                              : double.parse(
                                  batteryPercentage.toString() ?? "0.0")),
                      duration: const Duration(seconds: 1),
                      builder: (_, value, __) {
                        return VerticalBatteryIndicator(
                          percentage: value,
                          height: 80,
                          width: 36,
                        );
                      },
                    ),
                    const Icon(
                      Icons.flash_on,
                      color: Colors.white,
                      size: 18,
                    ),
                  ],
                ),

                const SizedBox(width: 16),

                // Divider look (like screenshot)
                Container(
                  height: 80,
                  width: 1,
                  color: Colors.white24,
                ),

                const SizedBox(width: 16),

                // Text section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Battery (estimated)",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "$batteryPercentage%",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    //  Text(
                    //   "${(double.parse(batteryPercentage!) / 100) * totalMinutes} min remaining",
                    //   style: TextStyle(
                    //     color: Colors.white54,
                    //     fontSize: 12,
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget _batteryProgress(SessionDetailData data) {
  //   // final percentage = data.session?.batteryPercentage ?? 0;
  //   final double percentage = 10;
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(
  //       horizontal: 14,
  //     ),
  //     child: Container(
  //       padding: const EdgeInsets.all(4),
  //       decoration: BoxDecoration(
  //         color: const Color(0xFF101E3A),
  //         borderRadius: BorderRadius.circular(16),
  //       ),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         mainAxisAlignment: MainAxisAlignment.start,
  //         children: [
  //           Stack(
  //             alignment: Alignment.center,
  //             children: [
  //               Padding(
  //                 padding: const EdgeInsets.all(8.0),
  //                 child: TweenAnimationBuilder<double>(
  //                   tween: Tween(begin: 0, end: percentage),
  //                   duration: const Duration(seconds: 1),
  //                   builder: (_, value, __) {
  //                     return BatteryIndicator(
  //                       percentage: value,
  //                       width: 80,
  //                       height: 30,
  //                     );
  //                   },
  //                 ),
  //               ),
  //               const Icon(
  //                 Icons.flash_on,
  //                 color: Colors.white,
  //                 size: 24,
  //               ),
  //             ],
  //           ),
  //           const SizedBox(height: 20),
  //           Text(
  //             "Battery (estimated)",
  //             style: TextStyle(color: Colors.white70),
  //           ),
  //           Text(
  //             "$percentage%",
  //             style: TextStyle(
  //               color: Colors.white,
  //               fontSize: 18,
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _infoGrid() {

    print("UI COST $cost");
print("UI UNIT $unitConsumed");
print("UI OUTPUT $outputPower");

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      crossAxisSpacing: 8,
      mainAxisSpacing: 12,
      childAspectRatio: 1.8,
      children: [
        _infoCard(
            "Current Price", "₹ ${"${cost}" ?? 0}", CommonImagePath.current),
        // _infoCard(
        //   "Battery",
        //   "${25.0 ?? 0} km",
        //   // "${data.session?.batteryKm ?? 0} km\n${data.session?.batteryPercentage ?? 0}%",
        // ),
        _infoCard(
            "Units ", "${unitConsumed ?? '--'}", CommonImagePath.unitconsumed),
        _infoCard("Output Power", "${outputPower}",
            CommonImagePath.poweroutput),
           
             _infoCard("Duration", "${duration}",
            CommonImagePath.poweroutput), 
      ],
    );
  }

  Widget _infoCard(String title, String value, String image) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF101E3A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(image, width: 20, height: 20, color: Colors.white),
          SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(color: Colors.white70, fontSize: 14)),
                 
              const Spacer(),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              )

              //         Text(
              //           "9.33333rrrr33",
              //           // value,
              //           maxLines: 1,
              // overflow: TextOverflow.ellipsis,
              //           style: TextStyle(
              //             color: Colors.white,
              //             fontSize: 18,
              //             fontWeight: FontWeight.bold,
              //           ),
              //         ),
            ],
          ),
        ],
      ),
    );
  }
}

class BatteryIndicator extends StatelessWidget {
  final double percentage; // 0–100
  final double width;
  final double height;

  const BatteryIndicator({
    super.key,
    required this.percentage,
    this.width = 120,
    this.height = 50,
  });

  @override
  Widget build(BuildContext context) {
    final fillPercent = (percentage.clamp(0, 100)) / 100;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Battery body
        Container(
          width: width,
          height: height,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: CommonColors.accentGreen, width: 2),
          ),
          child: Stack(
            children: [
              FractionallySizedBox(
                widthFactor: fillPercent,
                child: Container(
                  decoration: BoxDecoration(
                    color: CommonColors.accentGreen,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Battery head
        Container(
          width: 6,
          height: height * 0.4,
          margin: const EdgeInsets.only(left: 4),
          decoration: BoxDecoration(
            color: CommonColors.accentGreen,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }
}

class VerticalBatteryIndicator extends StatelessWidget {
  final double percentage; // 0–100
  final double width;
  final double height;

  const VerticalBatteryIndicator({
    super.key,
    required this.percentage,
    this.width = 36,
    this.height = 80,
  });

  @override
  Widget build(BuildContext context) {
    final fillPercent = (percentage.clamp(0, 100)) / 100;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Battery head
        Container(
          width: width * 0.4,
          height: 6,
          decoration: BoxDecoration(
            color: CommonColors.accentGreen,
            borderRadius: BorderRadius.circular(2),
          ),
        ),

        const SizedBox(height: 2),

        // Battery body
        Container(
          width: width,
          height: height,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: CommonColors.accentGreen,
              width: 2,
            ),
          ),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              FractionallySizedBox(
                heightFactor: fillPercent,
                child: Container(
                  decoration: BoxDecoration(
                    color: CommonColors.accentGreen,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ChargerAnimation extends StatefulWidget {
  final String status; // "Active" or "Complete"

  const ChargerAnimation({super.key, required this.status});

  @override
  State<ChargerAnimation> createState() => _ChargerAnimationState();
}

class _ChargerAnimationState extends State<ChargerAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void didUpdateWidget(covariant ChargerAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.status == "Active") {
      _controller.repeat(); // ▶️ play
    } else {
      _controller.stop(); // ⏸ stop at current frame
    }
  }

  @override
  void dispose() {
    _controller.dispose();
   
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Transform.scale(
        scale: 1.7,
        child: Lottie.asset(
          'assets/lottie/animationCharger.json',
          controller: _controller,
          onLoaded: (composition) {
            _controller.duration = composition.duration;

            if (widget.status == "Active") {
              _controller.repeat();
            } else {
              _controller.value = 1.0; // 👈 optional: end frame for Complete
              _controller.stop();
            }
          },
          width: 200,
          height: 200,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class SessionChargingArgs {
  final String sessionId;
  final String status;
  final String cost;
  final String unitConsumed;
  final String outputPower;
  final String batteryPercentage;
  final String endMeterReading;
  final String duration;

  SessionChargingArgs({
    required this.sessionId,
    required this.status,
    required this.cost,
    required this.unitConsumed,
    required this.outputPower,
    required this.batteryPercentage,
    required this.endMeterReading, required this.duration,
  });
}
