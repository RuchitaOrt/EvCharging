import 'package:ev_charging_app/Provider/ChargingProvider.dart';
import 'package:ev_charging_app/Utils/CommonAppBar.dart';
import 'package:ev_charging_app/Utils/commoncolors.dart';
import 'package:ev_charging_app/model/SessionDetailResponse.dart';
import 'package:ev_charging_app/model/StartChargingSessionResponse.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'dart:math' as math;
import 'dart:async';

import 'package:provider/provider.dart';

class SessionChargingScreen extends StatefulWidget {
  final StartChargingSessionResponse intitalResponse;

  const SessionChargingScreen({
    super.key,
    required this.intitalResponse,
  });

  @override
  State<SessionChargingScreen> createState() => _SessionChargingScreenState();
}

class _SessionChargingScreenState extends State<SessionChargingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  double currentMeter = 0;
  Timer? _refreshTimer;
  String? status;
  String? cost;
  String? unitConsumed;
  String? outputPower;
  String? batteryPercentage = "10";
  String? endMeterReading;
  @override
  void initState() {
    super.initState();
    status = widget.intitalResponse.data!.session!.status!;
    cost = widget.intitalResponse.data!.session!.chargingTotalFee!;
    unitConsumed = widget.intitalResponse.data!.session!.chargingSpeed!;
    outputPower = widget.intitalResponse.data!.session!.energyTransmitted!;
    batteryPercentage ==
        "10"; // widget.intitalResponse.data!.session!.chargingSpeed;
    endMeterReading = widget.intitalResponse.data!.session!.endMeterReading;
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

  void _startPolling() {
    _refreshTimer = Timer.periodic(
      const Duration(seconds: 15),
      (_) async {
        final res =
            await context.read<ChargingProvider>().fetchChargingSessionDetails(
                  context: context,
                  sessionId: widget.intitalResponse.data!.session!.recId!,
                );
        setState(() {
          status = res!.data!.session!.status;
          cost = "${res.data!.costDetails!.energyCost.toString()!}";
          unitConsumed =
              "${res.data!.energyConsumption!.totalEnergy!.toString()} ${res.data!.energyConsumption!.unit}";
          outputPower =
              "${res.data!.chargerDetails!.powerOutput} ${res.data!.chargerDetails!.tariffUnit}";
          batteryPercentage == res.data!.session!.chargingSpeed;
          endMeterReading = res.data!.session!.endMeterReading;
          print("AFTER 15 sec ${outputPower}");
          // 🔴 Stop polling if session completed
          if (res!.data!.isActive == false) {
            _refreshTimer?.cancel();
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

    return Scaffold(
      backgroundColor: CommonColors.white,
      appBar: CommonAppBar(
        title: "Charging Session",
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  // print("Charging session ID ${data!.session!.recId!}");
                  final response = await provider.endSession(
                      context: context,
                      sessionId: widget.intitalResponse.data!.session!
                          .recId!, // 🔑 station id
                      endMeterReading: endMeterReading!);

                  setState(() {
                    status = response!.data!.session!.status;

                    cost = response.data!.cost!.toString();
                    unitConsumed = response.data!.energyConsumed!.toString();
                    outputPower = response.data!.session!.energyTransmitted!;
                    batteryPercentage == response.data!.session!.chargingSpeed;
                    endMeterReading = response.data!.meterStop.toString();
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
                onPressed: () async {
                  print(
                      "Charging STATION ID ${data!.session!.chargingStationId!}");
                  print("Charging gun ID ${data.session!.chargingGunId}");
                  final response = await provider.unlockConnector(
                      context: context,
                      chargingStationId:
                          data!.session!.chargingStationId!, // 🔑 station id
                      connectorId: int.parse(data.session!.chargingGunId!));
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
            // _header(data),
            //  AnimatedBuilder(
            //     animation: _animation,
            //     builder: (context, child) {
            //       return CustomPaint(
            //         painter: _ChargingPainter(_animation.value),
            //         size: const Size(200, 200),
            //       );
            //     },
            //   ),
            // Center(
            //   child: Transform.scale(
            //     scale: 1.7, // 👈 increase this (1.2 – 1.6 usually perfect)
            //     child: Lottie.asset(
            //       'assets/lottie/animationCharger.json',
            //       width: 200,
            //       height: 200,
            //       fit: BoxFit.contain,
            //       repeat: true,
            //     ),
            //   ),
            // ),
            ChargerAnimation(
              status: status!, // "Active" or "Complete"
            ),

            status == ""
                ? Container()
                : Center(
                    child: Text(
                      '${status}',
                      style: TextStyle(color: CommonColors.blue, fontSize: 22),
                    ),
                  ),
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
    );
  }

  Widget _infoTile(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.black)),
          Text(value, style: const TextStyle(color: Colors.black)),
        ],
      ),
    );
  }

  Widget _header(SessionDetailData data) {
    return Stack(
      children: [
        Container(
          height: 230,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0A1D3B), Color(0xFF06142E)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        Positioned(
          top: 20,
          left: 16,
          right: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Mercedes EQC",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "PB 10 EF 3243",
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          left: 0,
          child: Image.asset(
            "assets/images/car.png", // replace with your asset
            height: 150,
            fit: BoxFit.contain,
          ),
        ),
      ],
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
                          begin: 0, end: double.parse(batteryPercentage!)),
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
                    const Text(
                      "33 min remaining",
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
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
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.8,
      children: [
        _infoCard("Current Price", "₹ ${"${cost}" ?? 0}"),
        // _infoCard(
        //   "Battery",
        //   "${25.0 ?? 0} km",
        //   // "${data.session?.batteryKm ?? 0} km\n${data.session?.batteryPercentage ?? 0}%",
        // ),
        _infoCard("Units Consumed", "${unitConsumed ?? '--'}"),
        _infoCard("Output Power", "${outputPower ?? '--'}"),
      ],
    );
  }

  Widget _infoCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF101E3A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: Colors.white70)),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _ecoSection(SessionDetailData data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: _infoCard(
              "Output Power",
              "${24 ?? 0} kW",
            ),
          ),
          const SizedBox(width: 12),
          // Expanded(
          //   child: Column(
          //     children: [
          //       _infoCard("CO₂ saved", "${data.co2Saved ?? 0} kg"),
          //       const SizedBox(height: 12),
          //       _infoCard("Green kms", "${data.greenKm ?? 0} km"),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  // Widget _stopChargingButton(
  //     ChargingProvider provider, SessionDetailData data) {
  //   return Padding(
  //     padding: const EdgeInsets.all(16),
  //     child: ElevatedButton(
  //       onPressed: () async {
  //         final success = await provider.endSession(
  //           context: context,
  //           sessionId: data.session!.recId!,
  //           endMeterReading: data.session!.endMeterReading!,
  //         );

  //         if (success) Navigator.pop(context);
  //       },
  //       style: ElevatedButton.styleFrom(
  //         backgroundColor: const Color(0xFF101E3A),
  //         padding: const EdgeInsets.symmetric(vertical: 16),
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(14),
  //         ),
  //       ),
  //       child: const Text(
  //         "Slide to Stop Charging",
  //         style: TextStyle(color: Colors.white, fontSize: 16),
  //       ),
  //     ),
  //   );
  // }
}

class _ChargingPainter extends CustomPainter {
  final double progress;

  _ChargingPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    final basePaint = Paint()
      ..color = Colors.grey.shade800
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12;

    final progressPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Colors.greenAccent, Colors.green],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, basePaint);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
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
