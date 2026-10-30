import 'package:HyCharge/Provider/ChargingProvider.dart';
import 'package:HyCharge/Screens/ActiveSessionsScreen.dart';
import 'package:HyCharge/Screens/DetailScreen.dart';
// import 'package:HyCharge/Screens/ChargingHistoryScreen.dart';
import 'package:HyCharge/Screens/MainTab.dart';
import 'package:HyCharge/Utils/CommonAppBar.dart';
import 'package:HyCharge/Utils/ShowDialog.dart';
import 'package:HyCharge/Utils/commoncolors.dart';
import 'package:HyCharge/Utils/commonimages.dart';
import 'package:HyCharge/main.dart';

import 'package:HyCharge/widget/GlobalLists.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';

class SessionChargingScreen extends StatefulWidget {
  // final StartChargingSessionResponse intitalResponse;
  final SessionChargingArgs args;

  const SessionChargingScreen({
    super.key,
    required this.args,
  });



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
  String? batteryPercentage = "0";
  String? endMeterReading;
  String? stationName;
  String? ConnectorGunID;
  Timer? _durationTimer;
  DateTime? _sessionStartTime;
  String duration = "00:00";
  final String recId = "";
  String? _sessionId;
bool _isWaitingForSession = true;
 
String message = 'Waiting for charger confirmation...';

bool hasError = false;
bool isWaiting = false;

String? sessionId;

  @override
  void initState() {
    super.initState();

    status = widget.args.status;
    duration = formatBackendDuration(widget.args.duration);

    // Start counting from the duration received from ActiveSessionsScreen.
    _elapsedSeconds = durationToSeconds(duration);

    cost = widget.args.cost;
    print("COST ${cost}");
    unitConsumed = widget.args.unitConsumed;
    outputPower = widget.args.outputPower;
    batteryPercentage = widget.args.batteryPercentage;
    stationName = widget.args.stationName;
    endMeterReading = widget.args.endMeterReading;
    ConnectorGunID = widget.args.ConnectorGunID;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.repeat();
_sessionId = widget.args.sessionId;
_isWaitingForSession = _sessionId!.isEmpty;

_sessionId = widget.args.sessionId;
  _isWaitingForSession = _sessionId == null || _sessionId!.isEmpty;
print("PRASAD ${_sessionId}");
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (!mounted) return;

    if (_isWaitingForSession) {
      _waitForSessionId();
    } 
    else {
      _startDurationTimer();
      _startPolling();
    }
  });
  }
Future<void> _waitForSessionId() async {
  if (isWaiting || !mounted) return;

  setState(() {
    isWaiting = true;
    hasError = false;
    message = 'Connecting to your charging station...';
  });

  try {
    final result = await context
        .read<ChargingProvider>()
        .pollForSessionId(
          context: context,
          authorizationReference:
              widget.args.authorizationReference!,
        );

    if (!mounted) return;

    final id = result?.data?.sessionId;

    if (id != null && id.isNotEmpty) {
      setState(() {
        _sessionId = id;
        _isWaitingForSession = false;
        status = 'Active';
        message = 'Your charging session has been confirmed.';
      });

      // Start session-related timers only after receiving the ID.
      _startDurationTimer();
      _startPolling();
    } else {
      setState(() {
        hasError = true;
        message =
            'We are still waiting for the charger to respond.';
      });
    }
  } catch (e) {
    if (!mounted) return;

    setState(() {
      hasError = true;
      message =
          'We could not confirm your charging session. Please try again.';
    });
  } finally {
    if (mounted) {
      setState(() {
        isWaiting = false;
      });
    }
  }
}
Future<void> _waitForSession() async {
  if (isWaiting) return;

  setState(() {
    isWaiting = true;
    hasError = false;
    message = 'Connecting to your charging station...';
  });

  try {
    final provider = context.read<ChargingProvider>();

    final result = await provider.pollForSessionId(
      context: context,
      authorizationReference: widget.args.authorizationReference!,
    );

    if (!mounted) return;

    final receivedSessionId = result?.data?.sessionId;

    if (receivedSessionId != null &&
        receivedSessionId.isNotEmpty) {
      setState(() {
        sessionId = receivedSessionId;
        status = 'Active';
        hasError = false;
        message = 'Your charging session has been confirmed.';
      });
    } else {
      setState(() {
        hasError = true;
        message =
            'We are still waiting for the charger to respond.';
      });
    }
  } catch (e) {
    if (!mounted) return;

    setState(() {
      hasError = true;
      message =
          'We could not confirm your charging session. '
          'Please try again.';
    });
  } finally {
    if (mounted) {
      setState(() {
        isWaiting = false;
      });
    }
  }
}
  int _elapsedSeconds = 0;

  String formatBackendDuration(String? raw) {
  if (raw == null || raw.trim().isEmpty || raw == "null") {
    return "00:00:00";
  }

  final value = raw.trim();

  // Numeric value represents minutes: "1" = 00:01:00
  if (!value.contains(':')) {
    final totalMinutes = double.tryParse(value)?.toInt() ?? 0;

    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;

    return "${hours.toString().padLeft(2, '0')}:"
        "${minutes.toString().padLeft(2, '0')}:00";
  }

  final parts = value.split(':');

  // HH:mm:ss — preserve the existing duration.
  if (parts.length == 3) {
    final hours = int.tryParse(parts[0]) ?? 0;
    final minutes = int.tryParse(parts[1]) ?? 0;
    final seconds = double.tryParse(parts[2])?.toInt() ?? 0;

    return "${hours.toString().padLeft(2, '0')}:"
        "${minutes.toString().padLeft(2, '0')}:"
        "${seconds.toString().padLeft(2, '0')}";
  }

  // mm:ss — convert to HH:mm:ss.
  if (parts.length == 2) {
    final totalMinutes = int.tryParse(parts[0]) ?? 0;
    final seconds = double.tryParse(parts[1])?.toInt() ?? 0;

    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;

    return "${hours.toString().padLeft(2, '0')}:"
        "${minutes.toString().padLeft(2, '0')}:"
        "${seconds.toString().padLeft(2, '0')}";
  }

  return "00:00:00";
}

  String formatBackendDurationPartner(String? raw) {
    if (raw == null || raw.trim().isEmpty || raw == "null") {
      return "00:00:00";
    }

    final value = raw.trim();

    // API sends only seconds, such as "1" or "2".
    if (!value.contains(':')) {
      final seconds = double.tryParse(value)?.toInt() ?? 0;
      final hours = seconds ~/ 3600;
      final minutes = (seconds % 3600) ~/ 60;
      final remainingSeconds = seconds % 60;

      return "${hours.toString().padLeft(2, '0')}:"
          "${minutes.toString().padLeft(2, '0')}:"
          "${remainingSeconds.toString().padLeft(2, '0')}";
    }

    // API sends a duration such as "00:01:02".
    final parts = value.split(':');

    if (parts.length >= 3) {
      final hours = int.tryParse(parts[0]) ?? 0;
      final minutes = int.tryParse(parts[1]) ?? 0;
      final seconds = int.tryParse(parts[2].split('.').first) ?? 0;

      return "${hours.toString().padLeft(2, '0')}:"
          "${minutes.toString().padLeft(2, '0')}:"
          "${seconds.toString().padLeft(2, '0')}";
    }

    // Supports "mm:ss".
    if (parts.length == 2) {
      final minutes = int.tryParse(parts[0]) ?? 0;
      final seconds = int.tryParse(parts[1].split('.').first) ?? 0;

      return "${(minutes ~/ 60).toString().padLeft(2, '0')}:"
          "${(minutes % 60).toString().padLeft(2, '0')}:"
          "${seconds.toString().padLeft(2, '0')}";
    }

    return "00:00:00";
  }

  int durationToSeconds(String duration) {
    final parts = duration.split(':');
    if (parts.length != 3) return 0;

    final hours = int.tryParse(parts[0]) ?? 0;
    final minutes = int.tryParse(parts[1]) ?? 0;
    final seconds = int.tryParse(parts[2]) ?? 0;

    return hours * 3600 + minutes * 60 + seconds;
  }

  void _startDurationTimer() {
    _durationTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _elapsedSeconds++;

      final hours = _elapsedSeconds ~/ 3600;
      final minutes = (_elapsedSeconds % 3600) ~/ 60;
      final seconds = _elapsedSeconds % 60;

      setState(() {
        duration = "${hours.toString().padLeft(2, '0')}:"
            "${minutes.toString().padLeft(2, '0')}:"
            "${seconds.toString().padLeft(2, '0')}";
      });
    });
  }


bool _isPollingRequestInProgress = false;

void _startPolling() {
  _refreshTimer?.cancel();

  // Fetch immediately when the screen opens, instead of waiting 10 seconds.
  _fetchSessionDetails();

  _refreshTimer = Timer.periodic(
    const Duration(seconds: 10),
    (_) => _fetchSessionDetails(),
  );
}

Future<void> _fetchSessionDetails() async {
  final id = _sessionId;

  if (!mounted ||
      id == null ||
      id.isEmpty ||
      _isPollingRequestInProgress) {
    return;
  }

  _isPollingRequestInProgress = true;

  try {
    final res = await context
        .read<ChargingProvider>()
        .fetchChargingSessionDetails(
          context: context,
          sessionId: id,
        );

    if (!mounted || res?.data == null) return;

    final data = res!.data!;

    final newStatus = data.status ?? status ?? '';

    final apiCost =
        data.cost ?? data.cost;

    final apiEnergy = data.energyDelivered;

    // Preserve existing values if a later response omits them.
    final newCost = apiCost?.toString() ?? cost ?? '0';
    final newUnitConsumed =
        apiEnergy?.toString() ?? unitConsumed ?? '0';

    final newOutputPower = apiEnergy != null
        ? '$apiEnergy kWh'
        : outputPower ?? '0 kWh';

    final batteryValue = data.isActive == true
        ? data.batteryStateOfCharge?.currentSoC
        : data.batteryStateOfCharge?.endSoC ??
            data.batteryStateOfCharge?.currentSoC;

    final newBatteryPercentage =
        batteryValue?.toString() ?? batteryPercentage ?? '0';

    final newEndMeterReading =
        data.meterCurrent?.toString() ?? endMeterReading ?? '';

    final newStationName =
        data.locationName ?? stationName ?? '';

    debugPrint('POLL SESSION ID: $id');
    debugPrint('POLL STATUS: $newStatus');
    debugPrint('POLL COST: $newCost');
    debugPrint('POLL ENERGY: $newUnitConsumed');
    debugPrint('POLL OUTPUT: $newOutputPower');

    if (!mounted) return;

    setState(() {
      status = newStatus;
      cost = newCost;
       print("COST 2 ${cost}");
      unitConsumed = newUnitConsumed;
      outputPower = newOutputPower;
      batteryPercentage = newBatteryPercentage;
      endMeterReading = newEndMeterReading;
      stationName = newStationName;
    });
print("UI COST setState $cost");
    print("UI UNIT setState $unitConsumed");
    print("UI OUTPUT setState $outputPower");
    if (data.isActive == false ||
        newStatus.toUpperCase() == 'COMPLETED') {
      _refreshTimer?.cancel();
      _durationTimer?.cancel();

      if (await Vibration.hasVibrator() ?? false) {
        Vibration.vibrate(duration: 800);
      }

      if (!mounted) return;

      showToast('Charging session completed');
      print("Session ID 1 ${id}");
        Navigator.push(
            routeGlobalKey.currentContext!,
            MaterialPageRoute(builder: (context) =>
            DetailScreen(recID: id!, bookingType: id.contains("L")?"L":"P",),)
            //  ChargingHistoryScreen(initialTabIndex:  id.contains("L")?0: 1,)),
          );
    }
  } catch (e, stackTrace) {
    debugPrint('Session polling failed: $e');
    debugPrintStack(stackTrace: stackTrace);
  } finally {
    _isPollingRequestInProgress = false;
  }
}


  @override
  void dispose() {
    _controller.dispose();
    _refreshTimer?.cancel();

    _durationTimer?.cancel();
    super.dispose();
  }

@override
Widget build(BuildContext context) {
  final provider = context.watch<ChargingProvider>();

  final bool isPreparing = _isWaitingForSession ||
      _sessionId == null ||
      _sessionId!.isEmpty;

  final String currentStatus =
      (status ?? '').toLowerCase().trim();

  final bool isCharging = !isPreparing &&
      (currentStatus == 'active' ||
          currentStatus == 'charging');

  final Color navy = const Color(0xFF142B70);
  final Color muted = const Color(0xFF667085);
  final Color green = const Color(0xFF27C36A);

  return WillPopScope(
    onWillPop: () async {
      _navigateBack();
      return false;
    },
    child: Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Charging Session',
          style: TextStyle(
            color: Color(0xFF101828),
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Color(0xFF142B70),
          ),
          onPressed: _navigateBack,
        ),
      ),

      // bottomNavigationBar: !isPreparing &&
      //         status != null &&
      //         currentStatus != 'completed'
      //     ? Container(
      //         color: Colors.white,
      //         padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      //         child: SafeArea(
      //           top: false,
      //           child: SizedBox(
      //             height: 50,
      //             child: ElevatedButton(
      //               onPressed: () async {
      //                 final result = await stopSessionDialog(
      //                   context,
      //                   amount: cost,
      //                   units: unitConsumed,
      //                 );

      //                 if (result != true || !mounted) return;

      //                 final id = _sessionId;
      //                 if (id == null || id.isEmpty) return;

      //                 final response = await context
      //                     .read<ChargingProvider>()
      //                     .endUnifiedSession(
      //                       context: context,
      //                       sessionId: id,
      //                       endMeterReading: endMeterReading ?? '',
      //                     );

      //                 if (!mounted) return;

      //                 _durationTimer?.cancel();
      //                 _refreshTimer?.cancel();

      //                 if (await Vibration.hasVibrator() ?? false) {
      //                   Vibration.vibrate(
      //                     pattern: [0, 500, 200, 500],
      //                   );
      //                 }

      //                 showToast('Charging session stopped');

      //                 Navigator.push(
      //                   routeGlobalKey.currentContext!,
      //                   MaterialPageRoute(
      //                     builder: (_) => ChargingHistoryScreen(
      //                       initialTabIndex:id.contains("L")?0: 1,
      //                     ),
      //                   ),
      //                 );
      //               },
      //               style: ElevatedButton.styleFrom(
      //                 backgroundColor: navy,
      //                 foregroundColor: Colors.white,
      //                 elevation: 0,
      //                 shape: RoundedRectangleBorder(
      //                   borderRadius: BorderRadius.circular(14),
      //                 ),
      //               ),
      //               child: const Text(
      //                 'Stop Charging',
      //                 style: TextStyle(
      //                   fontSize: 15,
      //                   fontWeight: FontWeight.w700,
      //                 ),
      //               ),
      //             ),
      //           ),
      //         ),
      //       )
      //     : null,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Vehicle card and status badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: _cardDecoration(),
                child: Row(
                  children: [
                    Container(
                      width: 76,
                      height: 54,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        // color: const Color(0xFFF5F7FB),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Image.asset(
                        CommonImagePath.carskyblue,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Q4',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF101828),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                             SvgPicture.asset(CommonImagePath.car_navy,width: 12,height: 12,),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  widget.args.sessionId.isNotEmpty
                                      ? 'Connected'
                                      : 'Connecting vehicle...',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: muted,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    _statusBadge(
                      isPreparing
                          ? 'Preparing'
                          : isCharging
                              ? 'Charging'
                              : (status ?? 'Connected'),
                      isPreparing
                          ?  Colors.grey.shade300
                          : isCharging
                              ? const Color(0xFFDDF8E6)
                              : Colors.grey.shade300,
                      isPreparing
                          ? Colors.black87.withOpacity(0.5)
                          : isCharging
                              ?  CommonColors.darkgreen
                              : navy,
                              isPreparing
                          ? Colors.amber
                          : isCharging
                              ?  CommonColors.darkgreen
                              : navy
                             
                              
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // Main session card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: _cardDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isPreparing
                          ? 'Getting your charger ready'
                          : isCharging
                              ? 'Charging in progress'
                              : 'Charging session details',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF101828),
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      isPreparing
                          ? hasError
                              ? message
                              : 'Connecting to your charging station...'
                          : isCharging
                              ? "You can leave the app, we'll keep tracking"
                              : 'Your latest charging session information',
                      style: TextStyle(
                        fontSize: 11,
                        height: 1.4,
                        color: muted,
                        fontWeight: FontWeight.w200

                      ),
                    ),

                    if (isPreparing && hasError) ...[
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: isWaiting ? null : _waitForSessionId,
                          icon: const Icon(Icons.refresh_rounded),
                          label: const Text('Try Again'),
                        ),
                      ),
                    ],

                    const SizedBox(height: 22),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Units',
                                style: TextStyle(
                                  color: muted,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    isPreparing
                                        ? '0'
                                        : (unitConsumed ?? '0'),
                                    style: TextStyle(
                                      color: navy,
                                      fontSize: 42,
                                      height: 1,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(
                                      left: 4,
                                      bottom: 5,
                                    ),
                                    child: Text(
                                      'kWh',
                                      style: TextStyle(
                                        fontSize: 17,
                                        color: Color(0xFF667085),
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        _energyBars(
                          active: isCharging,
                          color: isCharging
                              ? green
                              : const Color(0xFFE8EBF1),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Battery (estimated)',
                          style: TextStyle(
                            color: muted,
                            fontSize: 10,
                          ),
                        ),
                        Text(
                          '${batteryPercentage ?? '0'}%',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF101828),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: LinearProgressIndicator(
                        value: ((double.tryParse(
                                      batteryPercentage ?? '0') ??
                                  0)
                              .clamp(0, 100)) /
                            100,
                        minHeight: 7,
                        backgroundColor: const Color(0xFFEAEDF2),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          green,
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    _sessionSteps(
                      isPreparing: isPreparing,
                      isCharging: isCharging,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Three summary cards
              Row(
                children: [
                  Expanded(
                    child: _summaryCard(
                      icon: Icons.currency_rupee_rounded,
                      value: '₹ ${cost ?? '0'}',
                      label: 'Amount',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _summaryCard(
                      icon: Icons.speed_rounded,
                      value: outputPower ?? '0 kWh',
                      label: 'Output Power',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _summaryCard(
                      icon: Icons.access_time_rounded,
                      value: duration,
                      label: 'Duration',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Station details
              Container(
                padding: const EdgeInsets.all(14),
                decoration: _cardDecoration(),
                child: Row(
                  children: [
                    Container(
  height: 38,
                  width: 38,
                  decoration: BoxDecoration(
                    color: CommonColors.lightblue,
                    borderRadius: BorderRadius.circular(14)
                  ),
                  padding: const EdgeInsets.all(9),
  alignment: Alignment.center,
  child: SvgPicture.asset(
    CommonImagePath.plugdark,
    color: CommonColors.blue,
    width: 20,
    height: 20,
    fit: BoxFit.contain,
  ),
),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Station Name:',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                              color: Color(0xFF101828),
                            ),
                          ),
                          const SizedBox(height: 1),
                          Text(
                            (stationName?.isNotEmpty == true)
                                ? "${stationName!} (Connector: ${ConnectorGunID ?? '--'})"
                                : 'Waiting for station details',
                            style: TextStyle(
                              color: muted,
                              fontSize: 12,
                            ),
                          ),
                          // const SizedBox(height: 3),
                          // Text(
                          //   'Connector ${ConnectorGunID ?? '--'}',
                          //   style: TextStyle(
                          //     color: muted,
                          //     fontSize: 12,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
         !isPreparing &&
              status != null &&
              currentStatus != 'completed'
          ?     GestureDetector(
                onTap: ()
                async {
                   final result = await stopSessionDialog(
                        context,
                        amount: cost,
                        units: unitConsumed,
                      );

                      if (result != true || !mounted) return;

                      final id = _sessionId;
                      if (id == null || id.isEmpty) return;

                      final response = await context
                          .read<ChargingProvider>()
                          .endUnifiedSession(
                            context: context,
                            sessionId: id,
                            endMeterReading: endMeterReading ?? '',
                          );

                      if (!mounted) return;

                      _durationTimer?.cancel();
                      _refreshTimer?.cancel();

                      if (await Vibration.hasVibrator() ?? false) {
                        Vibration.vibrate(
                          pattern: [0, 500, 200, 500],
                        );
                      }

                      showToast('Charging session stopped');
 print("Session ID ${id}");
                      Navigator.push(
                        routeGlobalKey.currentContext!,
                        MaterialPageRoute(
                          builder: (_) =>
                           DetailScreen(recID: id!, bookingType: id.contains("L")?"L":"P",),
                          //  ChargingHistoryScreen(
                          //   initialTabIndex:id.contains("L")?0: 1,
                          // ),
                        ),
                      );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                                    'Preview: session ended state',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                        fontFamily: 'Poppins',
                                      fontSize: 10,
                                      color: CommonColors.blue,
                                    ),
                                  ),
                                  Icon(Icons.arrow_forward,color: CommonColors.blue,size: 12,)
                    ],
                  ),
                ),
              ):Container()
            ],
          ),
        ),
      ),
    ),
  );
}

BoxDecoration _cardDecoration() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(22),
    boxShadow: [
      BoxShadow(
        color: const Color(0xFF142B70).withOpacity(0.06),
        blurRadius: 18,
        offset: const Offset(0, 5),
      ),
    ],
  );
}

Widget _statusBadge(
  String label,
  Color background,
  Color foreground,
  Color dot
) {
  return Container(
    padding: const EdgeInsets.symmetric(
      horizontal: 10,
      vertical: 7,
    ),
    decoration: BoxDecoration(
      color: background,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: dot,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: foreground,
          ),
        ),
      ],
    ),
  );
}

Widget _energyBars({
  required bool active,
  required Color color,
}) {
  const heights = [18.0, 29.0, 37.0, 25.0, 34.0, 21.0];

  return Row(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.end,
    children: heights.map((height) {
      return Container(
        width: 6,
        height: height,
        margin: const EdgeInsets.only(left: 4),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(5),
        ),
      );
    }).toList(),
  );
}

Widget _sessionSteps({
  required bool isPreparing,
  required bool isCharging,
}) {
  const green = Color(0xFF27C36A);
  const navy = Color(0xFF142B70);
  const grey = Color(0xFFE9EDF3);

  final int activeStep = isPreparing ? 1 : isCharging ? 3 : 2;

  Widget step(int number, String title) {
    final bool completed = number < activeStep;
    final bool active = number == activeStep;

    // Completed = green; active and pending = blue
    final Color circleColor = completed ? green : navy;

    final Color textColor = (active || completed)
        ? navy
        : Colors.black;

    return Expanded(
      child: Column(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: circleColor,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: completed
                ? const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 15,
                  )
                : Text(
                    '$number',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              fontWeight: active ? FontWeight.w700 : FontWeight.w500,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  return Row(
    children: [
      step(1, 'Connecting'),
      step(2, 'Authorizing'),
      step(3, 'Charging'),
    ],
  );
}

// Widget _sessionSteps({
//   required bool isPreparing,
//   required bool isCharging,
// }) {
//   const green = Color(0xFF27C36A);
//   const navy = Color(0xFF142B70);
//   const grey = Color(0xFFE9EDF3);

//   final int activeStep = isPreparing ? 1 : isCharging ? 3 : 2;

//   Widget step(int number, String title) {
//     final bool completed = number < activeStep;
//     final bool active = number == activeStep;

//     final Color circleColor = completed
//         ? green
//         : active
//             ? navy
//             : grey;

//     final Color textColor = 
//     active || completed
//         ? navy
//         : 
//         const Color(0xFF98A2B3);

//     return Expanded(
//       child: Column(
//         children: [
//           Container(
//             width: 23,
//             height: 23,
//             decoration: BoxDecoration(
//               color: circleColor,
//               shape: BoxShape.circle,
//             ),
//             child: Icon(
//               completed ? Icons.check_rounded :null,
//               color: Colors.white,
//               size: 15,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             title,
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: 10,
//               fontWeight: active ? FontWeight.w700 : FontWeight.w500,
//               color: textColor,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   return Row(
//     children: [
//       step(1, 'Connecting'),
//       step(2, 'Authorizing'),
//       step(3, 'Charging'),
//     ],
//   );
// }

Widget _summaryCard({
  required IconData icon,
  required String value,
  required String label,
}) {
  return Container(
    height: 90,
    padding: const EdgeInsets.symmetric(
      horizontal: 10,
      vertical: 12,
    ),
    decoration: _cardDecoration(),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: const Color(0xFF142B70),
          size: 18,
        ),
        const Spacer(),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: Color(0xFF101828),
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 10,
            color: Color(0xFF667085),
          ),
        ),
      ],
    ),
  );
}

void _navigateBack() {
  if (widget.args.isActive == true) {
    Navigator.push(
      routeGlobalKey.currentContext!,
      MaterialPageRoute(
        builder: (_) => ActiveSessionsScreen(
          selectedTabIndex: 0,
        ),
      ),
    );
  } else {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MainTab(
          isLoggedIn: GlobalLists.islLogin,
          currentIndex: 1,
        ),
      ),
    );
  }
}

//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<ChargingProvider>();
//     final data = provider.sessionDetails?.data;

//     return WillPopScope(
//       onWillPop: () async {
//         if (widget.args!.isActive!) {
//           Navigator.push(
//             routeGlobalKey.currentContext!,
//             MaterialPageRoute(
//               builder: (_) => ActiveSessionsScreen(
//                 selectedTabIndex: 0,
//               ),
//             ),
//           );
//         } else {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) => MainTab(
//                 isLoggedIn: GlobalLists.islLogin,
//                 currentIndex: 1,
//               ),
//             ),
//           );
//         }

       
//         return false; // prevent default pop
//       },
//       child: Scaffold(
//         backgroundColor: CommonColors.white,
//         appBar: CommonAppBar(
//           title: "Charging Session",
//           onBack: () {
//             if (widget.args!.isActive!) {
//               Navigator.push(
//                 routeGlobalKey.currentContext!,
//                 MaterialPageRoute(
//                   builder: (_) => ActiveSessionsScreen(
//                     selectedTabIndex: 0,
//                   ),
//                 ),
//               );
//             } else {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => MainTab(
//                     isLoggedIn: GlobalLists.islLogin,
//                     currentIndex: 1,
//                   ),
//                 ),
//               );
//             }
//           },
//         ),
//         bottomNavigationBar: _sessionId != ""  && status !=null? Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Row(
//             children: [
//               Expanded(
//                 child: ElevatedButton(
//                   onPressed: status == "Completed"
//                       ? null
//                       : () async {
//                           // print("Charging session ID ${data!.session!.recId!}");

//                           bool? result = await stopSessionDialog(context,
//                               amount: cost, units: unitConsumed);
//                           if (result == true) {
//                             // ✅ User clicked YES
//                             final response = await provider.endUnifiedSession(
//                                 context: context,
//                                 sessionId:
//                                     widget.args.sessionId!, // 🔑 station id
//                                 endMeterReading: endMeterReading!);

//                             setState(() async {
//                               _durationTimer?.cancel();
//                               if (await Vibration.hasVibrator() ?? false) {
//                                 Vibration.vibrate(pattern: [0, 500, 200, 500]);
//                               }
//                               showToast("charging session stopped");
//                               Navigator.push(
//                                 routeGlobalKey.currentContext!,
//                                 MaterialPageRoute(
//                                     builder: (context) => ChargingHistoryScreen(
//                                           initialTabIndex: 1,
//                                         )),
//                               );
                             
//                             });
//                           } else {
//                             // ❌ User clicked NO or closed dialog
//                             print("User cancelled");
//                           }
//                         },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: CommonColors.blue,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     padding: const EdgeInsets.symmetric(vertical: 14),
//                   ),
//                   child: Text(
//                     "Stop Charging",
//                     style: const TextStyle(color: CommonColors.white),
//                   ),
//                 ),
//               ),
// //              
//             ],
//           ),
//         ):null,
//         body: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               status == ""
//                   ? Container()
//                   : _sessionId != ""  && status !=null?Row(
//                       children: [
//                         Expanded(
//                           child: Center(
//                             child: Padding(
//                               padding: const EdgeInsets.only(left: 30),
//                               child: Text(
//                                 '${status}',
//                                 style: TextStyle(
//                                     color: CommonColors.blue, fontSize: 22),
//                               ),
//                             ),
//                           ),
//                         ),
//                         // SizedBox(
//                         //   width: 60,
//                         // ),
//                         Padding(
//                           padding: const EdgeInsets.only(right: 20),
//                           child: GestureDetector(
//                               onTap: () async {
//                                 print("REFRESH CLICKED");
//                                 final res = await context
//                                     .read<ChargingProvider>()
//                                     .fetchChargingSessionDetails(
//                                       context: context,
//                                       sessionId: widget.args.sessionId,
//                                     );
//                                 setState(() {
//                                   status = res!.data!.raw!.status == null
//                                       ? ""
//                                       : res!.data!.raw!.status;
//                                   cost = "${res.data!.cost!.toString()!}";
//                                    print("COST 3 ${cost}");
//                                   unitConsumed = res.data!.raw!.energyLimit ==
//                                           null
//                                       ? ""
//                                       : "${res.data!.raw!.energyLimit!.toString()} ";
//                                   outputPower =
//                                       "${res.data!.raw!.totalEnergyKwh} KW";

//                                   stationName = "${res.data!.locationName}";
//                                   //  ConnectorGunID="${res.data!.session!.connectorName}";
//                                   batteryPercentage = res!.data!.isActive == 1
//                                       ? res.data!.batteryStateOfCharge!
//                                           .currentSoC
//                                           .toString()
//                                       :res.data!.batteryStateOfCharge==null?"": res.data!.batteryStateOfCharge!.endSoC
//                                           .toString();
//                                   final isActive = res?.data?.isActive == 1;

//                                   batteryPercentage = isActive
//                                       ? res?.data?.batteryStateOfCharge
//                                               ?.currentSoC
//                                               ?.toString() ??
//                                           "0"
//                                       : res?.data?.batteryStateOfCharge?.endSoC
//                                               ?.toString() ??
//                                           "0";
//                                   print("AFTER 15 sec batteryStateOfCharge");
//                                   print(res
//                                       .data!.batteryStateOfCharge!.currentSoC
//                                       .toString());

//                                   endMeterReading =
//                                       res.data!.meterCurrent == null
//                                           ? ""
//                                           : res.data!.meterCurrent.toString();
//                                 });
//                               },
//                               child: provider.loading
//                                   ? CircularProgressIndicator(
//                                       color: CommonColors.blue,
//                                     )
//                                   : Icon(Icons.refresh)),
//                         ),
//                       ],
//                     ):Container(),
//                     _sessionId != ""  && status !=null
//                     // && status != null
//               ? Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
                   
//                     ChargerAnimation(
//                       status: status!,
//                     ),
//                   ],
//                 )
//               : 
              
// Column(
//   mainAxisAlignment: MainAxisAlignment.center,
//   crossAxisAlignment: CrossAxisAlignment.center,
//   children: [
//     Center(
//       child: Container(
//         width: 180,
//         height: 180,
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           color: const Color(0xFFE5F7ED),
//           boxShadow: [
//             BoxShadow(
//               color: const Color(0xFF16A05D).withOpacity(0.12),
//               blurRadius: 24,
//               spreadRadius: 3,
//             ),
//           ],
//         ),
//         child: Stack(
//           alignment: Alignment.center,
//           children: [
//             // Circular loading ring
//             if (isWaiting && !hasError)
//               const SizedBox(
//                 width: 174,
//                 height: 174,
//                 child: CircularProgressIndicator(
//                   strokeWidth: 5,
//                   backgroundColor: Color(0xFFC8E8D6),
//                   valueColor: AlwaysStoppedAnimation<Color>(
//                     Color(0xFF16A05D),
//                   ),
//                 ),
//               )
//             else
//               Container(
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   border: Border.all(
//                     color: const Color(0xFFC8E8D6),
//                     width: 5,
//                   ),
//                 ),
//               ),

//             // Car in the center
//             Padding(
//               padding: const EdgeInsets.all(18),
//               child: Image.asset(
//                 CommonImagePath.car,
//                 fit: BoxFit.contain,
//               ),
//             ),
//           ],
//         ),
//       ),
//     ),

//     const SizedBox(height: 24),

//     Text(
//       hasError
//           ? 'Session not confirmed'
//           : 'Getting your charger ready',
//       textAlign: TextAlign.center,
//       style: const TextStyle(
//         fontSize: 16,
//         fontWeight: FontWeight.bold,
//         color: Color(0xFF172B4D),
//       ),
//     ),

//     const SizedBox(height: 12),

//     Text(
//       message,
//       textAlign: TextAlign.center,
//       style: const TextStyle(
//         fontSize: 15,
//         height: 1.5,
//         color: Color(0xFF667085),
//       ),
//     ),

//     if (hasError) ...[
//       const SizedBox(height: 16),
//       SizedBox(
//         width: double.infinity,
//         child: ElevatedButton.icon(
//           onPressed: isWaiting ? null : _waitForSession,
//           icon: const Icon(Icons.refresh_rounded),
//           label: const Text('Try Again'),
//           style: ElevatedButton.styleFrom(
//             backgroundColor: const Color(0xFF16A05D),
//             foregroundColor: Colors.white,
//             padding: const EdgeInsets.symmetric(vertical: 15),
//           ),
//         ),
//       ),
//     ],
//   ],
// ),

             

//               SizedBox(
//                 height: 10,
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 20, bottom: 10),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         Text(
//                           "Station Name: ",
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 14,
//                           ),
//                         ),
//                         Text(
//                           "${stationName!.toUpperCase()}",
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontSize: 14,
//                           ),
//                         ),
//                       ],
//                     ),
//                     Text(
//                       "(Connector ${ConnectorGunID})",
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 12,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               _batteryProgress(),
//               _infoGrid(),

//             ],
//           ),
//         ),
//       ),
//     );
//   }

  Widget _batteryProgress() {
   
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
                          end: (batteryPercentage == null ||
                                  batteryPercentage == "null")
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
        _infoCard("Amount", "₹ ${"${cost}" ?? 0}", CommonImagePath.current),
       
        _infoCard(
            "Units ", "${unitConsumed ?? '--'}", CommonImagePath.unitconsumed),
        _infoCard(
            "Output Power", "${outputPower}", CommonImagePath.poweroutput),

        _infoCard("Duration", "${duration}", CommonImagePath.poweroutput),
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
                  style: TextStyle(color: Colors.white70, fontSize: 13)),

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

    if (widget.status == "ACTIVE" ||widget.status == "Active" ||widget.status == "Charging") {
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

            if (widget.status == "ACTIVE" ||widget.status == "Active" ||widget.status == "Charging" ) {
              _controller.repeat();
            } else {
              _controller.value = 1.0; // 👈 optional: end frame for Complete
              _controller.stop();
            }
          },
          width: 200,
          height: 180,
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
  final String? stationName;
  final String? ConnectorGunID;
  final bool? isActive; //1 for Active otherwise 0
  final String? authorizationReference;

  SessionChargingArgs(
      {required this.sessionId,
      required this.status,
      required this.cost,
      required this.unitConsumed,
      required this.outputPower,
      required this.batteryPercentage,
      required this.endMeterReading,
      required this.duration,
      required this.stationName,
      required this.ConnectorGunID,
      this.authorizationReference,
      this.isActive = false});
}
