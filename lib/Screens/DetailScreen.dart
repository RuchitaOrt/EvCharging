
import 'package:HyCharge/Provider/ChargingProvider.dart';
import 'package:HyCharge/Screens/MainTab.dart';
import 'package:HyCharge/Utils/CommonAppBar.dart';
import 'package:HyCharge/Utils/commoncolors.dart';
import 'package:HyCharge/model/SessionIDDetailResponse.dart';
import 'package:HyCharge/model/UnifiedSessionDetailResponse.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DetailScreen extends StatefulWidget {
  final String recID;
  final String bookingType;
  final bool? isSessionVisible;

  const DetailScreen({
    super.key,
    required this.recID,
    required this.bookingType,
    this.isSessionVisible=false
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  SessionIDDetailResponse? response;
  UnifiedSessionDetailResponse? unifiedResponse;

  bool isLoading = true;
  String? errorMessage;

  static const Color navy = Color(0xFF142D70);
  static const Color background = Color(0xFFF4F7FB);
  static const Color green = Color(0xFF16A05D);
  static const Color textColor = Color(0xFF172B4D);
  static const Color secondaryText = Color(0xFF667085);

  @override
  void initState() {
    super.initState();
    loadData();
  }
Future<void> loadData() async {
  const int maxAttempts = 5;
  const Duration retryDelay = Duration(seconds: 10);

  if (mounted) {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
  }

  final sessionId = widget.recID.startsWith('L:')
      ? widget.recID.substring(2)
      : widget.recID;
      print("widget.recID ${widget.recID}");
final sessionIdaprtner= widget.recID.startsWith('P:')
      ? widget.recID.substring(2)
      : widget.recID;
 print("widget.recID ${sessionIdaprtner}");
  for (int attempt = 1; attempt <= maxAttempts; attempt++) {
    try {
      debugPrint(
        'Loading session details: attempt $attempt/$maxAttempts, '
        'bookingType: ${widget.bookingType}, sessionId: $sessionId',
      );

      if (widget.bookingType == "L") {
        // Preserve the original L booking API.
        final res = await context
            .read<ChargingProvider>()
            .fetchSessionDetails(
              context: context,
              sessionId: sessionId,
            );

        if (!mounted) return;

        if (res?.data != null) {
          setState(() {
            response = res;
            isLoading = false;
            errorMessage = null;
          });
          return;
        }
      } else {
        // Preserve the partner booking API.
        print("Comm");
        final res = await context
            .read<ChargingProvider>()
            .fetchPartnerSessionDetails(
              context: context,
              sessionId: sessionIdaprtner,
            );

        if (!mounted) return;

        if (res?.data != null) {
          setState(() {
            unifiedResponse = res;
            isLoading = false;
            errorMessage = null;
          });
          return;
        }
      }

      debugPrint('Attempt $attempt returned no session data.');
    } catch (e, stackTrace) {
      debugPrint('Attempt $attempt failed: $e');
      debugPrintStack(stackTrace: stackTrace);
    }

    if (attempt < maxAttempts) {
      await Future.delayed(retryDelay);
      if (!mounted) return;
    }
  }

  if (!mounted) return;

  setState(() {
    isLoading = false;
    errorMessage =
        'Charging details are not available yet. Please try again.';
  });
}
// Future<void> loadData() async {
//   try {
//     if (widget.bookingType == "L") {
//       // Keep the original API for L bookings
//       final res = await context
//           .read<ChargingProvider>()
//           .fetchSessionDetails(
//             context: context,
//             sessionId: widget.recID,
//           );

//       if (!mounted) return;

//       setState(() {
//         response = res;
//         isLoading = false;
//         errorMessage = null;
//       });
//     } else {
//       // Remove L: only for partner session API
//       final sessionId = widget.recID.startsWith('L:')
//           ? widget.recID.substring(2)
//           : widget.recID;

//       final res = await context
//           .read<ChargingProvider>()
//           .fetchPartnerSessionDetails(
//             context: context,
//             sessionId: sessionId,
//           );

//       if (!mounted) return;

//       setState(() {
//         unifiedResponse = res;
//         isLoading = false;
//         errorMessage = null;
//       });
//     }
//   } catch (e, stackTrace) {
//     debugPrint('Error loading charging details: $e');
//     debugPrintStack(stackTrace: stackTrace);

//     if (!mounted) return;

//     setState(() {
//       isLoading = false;
//       errorMessage = 'Unable to load charging details.';
//     });
//   }
// }
// Future<void> loadData() async {
//   const int maxAttempts = 5;
//   const Duration retryDelay = Duration(seconds: 10);

//   if (mounted) {
//     setState(() {
//       isLoading = true;
//       errorMessage = null;
//     });
//   }

//   for (int attempt = 1; attempt <= maxAttempts; attempt++) {
//     try {
//       final sessionId = widget.recID.startsWith('L:')
//     ? widget.recID.substring(2)
//     : widget.recID;

// final res = await context
//     .read<ChargingProvider>()
//     .fetchPartnerSessionDetails(
//       context: context,
//       sessionId: sessionId,
//     );
//       // final res = await context
//       //     .read<ChargingProvider>()
//       //     .fetchPartnerSessionDetails(
//       //       context: context,
//       //       sessionId: widget.recID,
//       //     );

//       if (!mounted) return;

//       if (res?.data != null) {
//         setState(() {
//           unifiedResponse = res;
//           response = null;
//           isLoading = false;
//           errorMessage = null;
//         });
//         return;
//       }
//     } catch (e) {
//       debugPrint('Session details attempt $attempt failed: $e');
//     }

//     debugPrint(
//       'Session details attempt $attempt/$maxAttempts '
//       'returned no data for ${widget.recID}',
//     );

//     if (attempt < maxAttempts) {
//       await Future.delayed(retryDelay);
//       if (!mounted) return;
//     }
//   }

//   if (!mounted) return;

//   setState(() {
//     isLoading = false;
//     errorMessage =
//         'Charging details are not available yet. Please try again.';
//   });
// }
  

  String safeValue(dynamic value, {String fallback = "-"}) {
    if (value == null) return fallback;

    final result = value.toString().trim();

    if (result.isEmpty || result.toLowerCase() == "null") {
      return fallback;
    }

    return result;
  }

  String formatDate(String? dateTimeString) {
    if (dateTimeString == null || dateTimeString.trim().isEmpty) {
      return "-";
    }

    try {
      final dateTime = DateTime.parse(dateTimeString);
      return DateFormat('dd MMM yyyy').format(dateTime);
    } catch (_) {
      return "-";
    }
  }

  String formatTimeIST(String? dateTimeString) {
    if (dateTimeString == null || dateTimeString.trim().isEmpty) {
      return "";
    }

    try {
      final parsed = DateTime.parse(dateTimeString);
      final istTime = parsed.toUtc().add(
            const Duration(hours: 5, minutes: 30),
          );

      return DateFormat('hh:mm a').format(istTime);
    } catch (_) {
      return "";
    }
  }

  String get totalAmount {
    if (widget.bookingType == "L") {
      return safeValue(
        response?.data?.costDetails?.totalCost,
        fallback: "0",
      );
    }

    return safeValue(
      unifiedResponse?.data?.totalCost,
      fallback: "0",
    );
  }

  String get sessionStatus {
    if (widget.bookingType == "L") {
      return safeValue(response?.data?.status, fallback: "Completed");
    }

    return safeValue(
      unifiedResponse?.data?.status,
      fallback: "Completed",
    );
  }

  String get stationName {
    if (widget.bookingType == "L") {
      return safeValue(
        response?.data?.session?.chargingHubName,
        fallback: "Charging Station",
      );
    }

    return safeValue(
      unifiedResponse?.data?.location?.name,
      fallback: "Charging Station",
    );
  }

  String get energyConsumed {
    if (widget.bookingType == "L") {
      return safeValue(
        response?.data?.energyConsumption?.totalEnergy,
      );
    }

    return safeValue(unifiedResponse?.data?.totalEnergyKwh);
  }

  String get chargingDuration {
    if (widget.bookingType == "L") {
      return safeValue(
        response?.data?.timing?.duration?.formattedDuration,
      );
    }

    return safeValue(unifiedResponse?.data?.durationMinutes);
  }

  String get chargerType {
    if (widget.bookingType == "L") {
      return safeValue(response?.data?.chargerDetails?.chargerType);
    }

    return "-";
  }

  String get pricePerUnit {
    if (widget.bookingType == "L") {
      return safeValue(response?.data?.summary?.costPerKwh);
    }

    return safeValue(
      unifiedResponse?.data?.costDetails?.platformFeePerKwh,
    );
  }

  String get serviceCharge {
    if (widget.bookingType == "L") {
      return safeValue(
        response?.data?.costDetails?.energyCost,
        fallback: "0",
      );
    }

    return safeValue(
      unifiedResponse?.data?.costDetails?.taxableValue,
      fallback: "0",
    );
  }

  String get sgst {
    if (widget.bookingType == "L") {
      return safeValue(
        response?.data?.costDetails?.sgst,
        fallback: "0",
      );
    }

    return safeValue(
      unifiedResponse?.data?.costDetails?.sgstAmount,
      fallback: "0",
    );
  }

  String get cgst {
    if (widget.bookingType == "L") {
      return safeValue(
        response?.data?.costDetails?.cgst,
        fallback: "0",
      );
    }

    return safeValue(
      unifiedResponse?.data?.costDetails?.cgstAmount,
      fallback: "0",
    );
  }

  String get startDateTime {
    if (widget.bookingType == "L") {
      return safeValue(
        response?.data?.session?.startTime,
        fallback: "",
      );
    }

    return safeValue(
      unifiedResponse?.data?.startDateTime,
      fallback: "",
    );
  }

  String get endDateTime {
    if (widget.bookingType == "L") {
      return safeValue(
        response?.data?.session?.endTime,
        fallback: "",
      );
    }

    return safeValue(
      unifiedResponse?.data?.endDateTime,
      fallback: "",
    );
  }

  String get sessionDate {
    if (widget.bookingType == "L") {
      return formatDate(
        response?.data?.session?.createdOn?.toString(),
      );
    }

    return formatDate(
      unifiedResponse?.data?.startDateTime?.toString(),
    );
  }

  String get sessionTimeRange {
    final start = formatTimeIST(startDateTime);
    final end = formatTimeIST(endDateTime);

    if (start.isEmpty && end.isEmpty) return "-";
    if (start.isEmpty) return end;
    if (end.isEmpty) return start;

    return "$start - $end";
  }

  bool get hasData {
    if (widget.bookingType == "L") {
      return response?.data != null;
    }

    return unifiedResponse?.data != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
    bottomNavigationBar: SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: _viewReceipt,
                icon: const Icon(
                  Icons.receipt_long_rounded,
                  size: 19,
                ),
                label: const Text(
                  "View Receipt",
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w900,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: navy,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            TextButton(
              onPressed: (){
 Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (_) => MainTab(isLoggedIn: true),
            ),
            (_) => false,
          );
              },
              child: const Text(
                "Back to Map",
                style: TextStyle(
                  color: navy,
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
      body: SafeArea(
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: navy,
                ),
              )
            : errorMessage != null
                ? _buildError()
                : !hasData
                    ? _buildNoData()
                    : _buildDetails(),
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 52,
              color: Colors.redAccent,
            ),
            const SizedBox(height: 16),
            Text(
              errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                color: secondaryText,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isLoading = true;
                  errorMessage = null;
                });
                loadData();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: navy,
                foregroundColor: Colors.white,
              ),
              child: const Text("Try Again"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoData() {
    return const Center(
      child: Text(
        "No charging details found.",
        style: TextStyle(
          fontSize: 15,
          color: secondaryText,
        ),
      ),
    );
  }

  Widget _buildDetails() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 10),

          // Success icon
          Center(
            child: Container(
              width: 84,
              height: 84,
              decoration: const BoxDecoration(
                color: Color(0xFFD8F8E2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                color: Color(0xFF008F4C),
                size: 48,
              ),
            ),
          ),

          const SizedBox(height: 22),

          // Completion title
          const Text(
            "Charging session ended",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor,
                fontFamily: 'Poppins',
              fontSize: 23,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),

          const SizedBox(height: 3),

          // Amount and station
          Text(
            "₹$totalAmount debited · $stationName",
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: secondaryText,
                fontFamily: 'Poppins',
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 26),

          // Main details card
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF172B4D).withOpacity(0.07),
                  blurRadius: 18,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                _summaryRow(
                  "Amount",
                  "₹ $totalAmount",
                  emphasize: true,
                ),
                _summaryRow(
                  "Units consumed",
                  energyConsumed,
                ),
                _summaryRow(
                  "Duration",
                  chargingDuration,
                ),
                _summaryRow(
                  "Station",
                  stationName,
                  isLast: true,
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // Additional information card
       widget.isSessionVisible!?   Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF172B4D).withOpacity(0.05),
                  blurRadius: 15,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Session information",
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 14),

                _detailRow("Booking ID", widget.recID),
                _detailRow("Status", sessionStatus),
                _detailRow("Date", sessionDate),
                _detailRow("Time", sessionTimeRange),
                _detailRow("Charger type", chargerType),
                _detailRow("Price per unit", pricePerUnit),
                _detailRow("Service charge", "₹ $serviceCharge"),
                _detailRow("SGST", "₹ $sgst"),
                _detailRow("CGST", "₹ $cgst"),

                const Divider(
                  height: 26,
                  color: Color(0xFFE7EAF0),
                ),

                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        "Total Amount",
                        style: TextStyle(
                          color: green,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Text(
                      "₹ $totalAmount",
                      style: const TextStyle(
                        color: green,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
          :Container(),

          widget.isSessionVisible! ?   const SizedBox(height: 28) :Container(),

          // View Receipt button
          
        ],
      ),
    );
  }

  Widget _summaryRow(
    String title,
    String value, {
    bool emphasize = false,
    bool isLast = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 17,
      ),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(
                bottom: BorderSide(
                  color: Color(0xFFE7EAF0),
                  width: 1,
                ),
              ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 12,
                  fontFamily: 'Poppins',
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          const SizedBox(width: 2),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight:
                    emphasize ? FontWeight.w800 : FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: Text(
              title,
              style: const TextStyle(
                color: secondaryText,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 6,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: textColor,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _viewReceipt() {
    // Connect your receipt screen or PDF generation here when available.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Receipt viewing is not connected yet.",
        ),
      ),
    );
  }
}
