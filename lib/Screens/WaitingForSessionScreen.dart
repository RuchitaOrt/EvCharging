
import 'package:HyCharge/Utils/commonimages.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import 'package:HyCharge/Provider/ChargingProvider.dart';
import 'package:HyCharge/Screens/SessionChargingScreen.dart';

class WaitingForSessionScreen extends StatefulWidget {
  final String authorizationReference;
  final String connectorId;

  const WaitingForSessionScreen({
    super.key,
    required this.authorizationReference,
    required this.connectorId,
  });

  @override
  State<WaitingForSessionScreen> createState() =>
      _WaitingForSessionScreenState();
}

class _WaitingForSessionScreenState
    extends State<WaitingForSessionScreen> {
  String message = 'Waiting for charger confirmation...';

  bool hasError = false;
  bool isWaiting = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _waitForSession();
    });
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
        authorizationReference:
            widget.authorizationReference,
      );

      if (!mounted) return;

      final sessionId = result?.data?.sessionId;

      if (sessionId != null && sessionId.isNotEmpty) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => SessionChargingScreen(
              args: SessionChargingArgs(
                sessionId: sessionId,
                status: 'Active',
                cost: '0',
                unitConsumed: '0',
                outputPower: '0',
                batteryPercentage: '0',
                endMeterReading: '0',
                duration: '00:00:00',
                stationName: '',
                ConnectorGunID: widget.connectorId,
                isActive: true,
              ),
            ),
          ),
        );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Car illustration in a clean circular container.
                Container(
                  width: 380,
                  height: 380,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5F7ED),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.10),
                        blurRadius: 24,
                        spreadRadius: 3,
                      ),
                    ],
                  ),
                  child:  Image.asset(CommonImagePath.car)
                ),

                const SizedBox(height: 20),

                // Existing charger animation.
                // Lottie.asset(
                //   'assets/lottie/animationCharger.json',
                //   width: 210,
                //   height: 170,
                //   repeat: true,
                // ),

                const SizedBox(height: 16),

                Text(
                  hasError
                      ? 'Session not confirmed'
                      : 'Getting your charger ready',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF172B4D),
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    color: Color(0xFF667085),
                  ),
                ),

                const SizedBox(height: 28),

                if (isWaiting && !hasError) ...[
                  const SizedBox(
                    width: 230,
                    child: LinearProgressIndicator(
                      minHeight: 5,
                      backgroundColor: Color(0xFFDDE5E1),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF16A05D),
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.bolt_rounded,
                        color: Color(0xFF16A05D),
                        size: 20,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Connecting to charger...',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF16A05D),
                        ),
                      ),
                    ],
                  ),
                ],

                if (hasError)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed:
                          isWaiting ? null : _waitForSession,
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Try Again'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFF16A05D),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),

                const SizedBox(height: 32),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFFE7EBF0),
                    ),
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        color: Color(0xFF16A05D),
                        size: 23,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Please keep the charging connector '
                          'plugged into your vehicle while we '
                          'confirm your session.',
                          style: TextStyle(
                            fontSize: 13,
                            height: 1.5,
                            color: Color(0xFF667085),
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
      ),
    );
  }
}
