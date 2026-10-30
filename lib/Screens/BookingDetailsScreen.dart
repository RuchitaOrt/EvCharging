// import 'package:HyCharge/Provider/ChargingProvider.dart';
// import 'package:HyCharge/Utils/CommonAppBar.dart';
// import 'package:HyCharge/Utils/commoncolors.dart';
// import 'package:HyCharge/model/SessionDetailResponse.dart';
// import 'package:HyCharge/model/SessionIDDetailResponse.dart';
// import 'package:HyCharge/model/UnifiedSessionDetailResponse.dart';

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';

// class BookingDetailsScreen extends StatefulWidget {
//   final String recID;
//   final String bookingType;
//   const BookingDetailsScreen(
//       {super.key, required this.recID, required this.bookingType});

//   @override
//   State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
// }

// class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
//   @override
//   void initState() {
//     super.initState();
//     loadData();
//   }

//   SessionIDDetailResponse? response;

//   UnifiedSessionDetailResponse? Unifiedresponse;
//   bool isLoading = true;
//   late ScrollController _scrollController;
//   Future<void> loadData() async {
//     if (widget.bookingType == "L") {
//       final res = await context.read<ChargingProvider>().fetchSessionDetails(
//             context: context,
//             sessionId: widget.recID,
//           );

//       setState(() {
//         response = res;
//         isLoading = false;
//       });
//     } else {
//       final res =
//           await context.read<ChargingProvider>().fetchPartnerSessionDetails(
//                 context: context,
//                 sessionId: widget.recID,
//               );

//       setState(() {
//         Unifiedresponse = res;
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: CommonColors.white,
//       appBar: CommonAppBar(
//         title: "Booking Details",
//         onBack: () {
//           Navigator.pop(context);
//         },
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : (response == null && widget.bookingType == "L")
//               ? const Center(child: Text("No data found"))
//               : (Unifiedresponse == null && widget.bookingType == "P")
//                   ? const Center(child: Text("No data found"))
//                   : SingleChildScrollView(
//                       padding: const EdgeInsets.all(16),
//                       child: Column(
//                         children: [
//                           /// Amount Section
//                           Text(
//                             widget.bookingType == "L"
//                                 ? "₹ ${response!.data!.costDetails!.totalCost.toString()}"
//                                 :(Unifiedresponse!.data!.costDetails==null || Unifiedresponse!.data!.costDetails! =="null")? "₹ 0": "₹ ${Unifiedresponse!.data!.costDetails!.grandTotal!.toString()}",
//                             style: TextStyle(
//                               fontSize: 34,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             widget.bookingType == "L"
//                                 ? "${response!.data!.status}"
//                                 : "${Unifiedresponse!.data!.status}",
//                             style: TextStyle(
//                               color: Colors.green,
//                               fontSize: 14,
//                             ),
//                           ),
//                           const SizedBox(height: 8),

//                           /// Booking ID Card
//                           _buildBookingId(),

//                           const SizedBox(height: 16),

//                           /// Details Card
//                           _buildDetailsCard(),
//                         ],
//                       ),
//                     ),
//     );
//   }

//   Widget _buildBookingId() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
//       decoration: _cardDecoration(),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             "Booking ID",
//             style: TextStyle(color: Colors.grey),
//           ),
//           const SizedBox(width: 10),

//           /// Fix overflow here
//           Expanded(
//             child: Text(
//               widget.recID,
//               textAlign: TextAlign.right,
//               softWrap: true,
//               style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   String formatTime(String dateTimeString) {
//     final dateTime = DateTime.parse(dateTimeString);

//     return DateFormat('EEE dd MMM yyyy').format(dateTime);
//   }

//   String formatonlyTime(String dateTimeString) {
//     final dateTime = DateTime.parse(dateTimeString);
//     return DateFormat('hh.mm a').format(dateTime);
//   }
// // String formatonlyTimeIST(DateTime time) {
// //   final utcTime = DateTime.utc(
// //     time.year,
// //     time.month,
// //     time.day,
// //     time.hour,
// //     time.minute,
// //     time.second,
// //     time.millisecond,
// //     time.microsecond,
// //   );

// //   final istTime = utcTime.add(const Duration(hours: 5, minutes: 30));

// //   return DateFormat("hh.mm a").format(istTime);
// // }
// //   String formatonlyTimeIST(String? timeString) {
// //     if (timeString == null || timeString.isEmpty) return "";
// // print("timeStringtimeString ${timeString}");
// //     final parsed = DateTime.parse(timeString);

// //     final utcTime = DateTime.utc(
// //       parsed.year,
// //       parsed.month,
// //       parsed.day,
// //       parsed.hour,
// //       parsed.minute,
// //       parsed.second,
// //       parsed.millisecond,
// //       parsed.microsecond,
// //     );

// //     final istTime = utcTime.add(const Duration(hours: 5, minutes: 30));

// //     return DateFormat("hh.mm a").format(istTime);
// //   }

// String formatOnlyTimeIST(String? timeString) {
//   if (timeString == null || timeString.trim().isEmpty) {
//     return "";
//   }

//   try {
//     print("timeString: $timeString");

//     final parsed = DateTime.parse(timeString);

//     // If the API time is UTC, convert it to IST.
//     final istTime = parsed.toUtc().add(
//       const Duration(hours: 5, minutes: 30),
//     );

//     return DateFormat("hh.mm a").format(istTime);
//   } catch (e) {
//     print("Invalid date format: $timeString");
//     return "";
//   }
// }


//   Widget _buildDetailsCard() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: _cardDecoration(),
//       child: widget.bookingType == "L"
//           ? Column(
//               children: [
//                 _item(
//   "Date & time",
//   "${formatTime(response!.data!.session!.createdOn!.toString())}\n"
//   "${formatOnlyTimeIST(response!.data!.session!.startTime?.toString())} - "
//   "${formatOnlyTimeIST(response!.data!.session!.endTime?.toString())}",
// ),
//                 // _item("Date & time",
//                 //     "${formatTime(response!.data!.session!.createdOn!.toString())} \n${formatonlyTimeIST("${response!.data!.session!.startTime}")} - ${formatonlyTimeIST("${response!.data!.session!.endTime}")}"),
//                 //     _item("Address details",
//                 // (response!.data!.session!.chargingHub!.addressLine1==null)?"-":      "${response!.data!.session!.chargingHub!.addressLine1}"),
//                 _item("Charger type",
//                     "${response!.data!.chargerDetails!.chargerType}"),
//                 _item(
//                     "Price per unit", "${response!.data!.summary!.costPerKwh}"),
//                 //  _item("Connector details", "${response!.data!.session!.chargingHubName}"),
//                 //  _item("Energy Cost",  "₹ ${response!.data!.costDetails!.energyCost.toString()}"),
//                 _item("Total kW used",
//                  response!.data!.energyConsumption!.totalEnergy=="null"?"-":   "${response!.data!.energyConsumption!.totalEnergy}"),
//                 _item("Total charging time",
//               response!.data!.timing!.duration!.formattedDuration=="null"?"-":       "${response!.data!.timing!.duration!.formattedDuration}"),
//                 _item("Service charge",
//                     "₹ ${response!.data!.costDetails!.energyCost.toString()}"),
//                 // // _item("Discount", "₹0.0"),
//                 // // _item("Cashback", "0.0"),
//                 _item("SGST (9%)",
//                     "₹ ${response!.data!.costDetails!.sgst.toString()}"),
//                 _item("CGST (9%)",
//                     "₹ ${response!.data!.costDetails!.cgst.toString()}"),
//                 _item("Duration",
//                     "${response!.data!.timing!.duration!.formattedDuration.toString()}"),

//                 const Divider(height: 24),

//                 Row(
//                   children: [
//                     Text(
//                       "Total Amount",
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: Colors.green,
//                         fontSize: 16,
//                       ),
//                     ),
//                     Spacer(),
//                     Text(
//                       "₹ ${response!.data!.costDetails!.totalCost.toString()}",
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: Colors.green,
//                         fontSize: 16,
//                       ),
//                     ),
//                   ],
//                 )
//               ],
//             )
//           : Column(
//               children: [
//                 _item(
//   "Date & time",
//   "${formatTime(Unifiedresponse!.data!.startDateTime!.toString())}\n"
//   "${formatOnlyTimeIST(Unifiedresponse!.data!.startDateTime.toString())} - "
//   "${formatOnlyTimeIST(Unifiedresponse!.data!.endDateTime.toString())}",
// ),
//                 // _item("Date & time",
//                 //     "${formatTime(Unifiedresponse!.data!.startDateTime!.toString())} \n${formatonlyTimeIST("${Unifiedresponse!.data!.startDateTime}")} - ${formatonlyTimeIST("${Unifiedresponse!.data!.endDateTime}")}"),

//                 _item("Charger type", "-"),
//                 _item("Price per unit",
//                   Unifiedresponse!.data!.costDetails==null?"":  "${Unifiedresponse!.data!.costDetails!.platformFeePerKwh.toString()}"),
//                 // _item("Connector details", "${Unifiedresponse!.data!.location!.address}"),

//                 _item("Total kW used",
//             Unifiedresponse!.data!.totalEnergyKwh==null?"-"     :   "${Unifiedresponse!.data!.totalEnergyKwh.toString()}"),
//                 _item("Total charging time",
//              Unifiedresponse!.data!.timeLimit==null?"-":       "${Unifiedresponse!.data!.timeLimit.toString()}"),
//                 _item("Service charge",
//                   Unifiedresponse!.data!.costDetails==null?"":  "₹ ${Unifiedresponse!.data!.costDetails!.taxableValue.toString()}"),

//                 _item("SGST (9%)",
//                     Unifiedresponse!.data!.costDetails==null?"":    "₹ ${Unifiedresponse!.data!.costDetails!.sgstAmount.toString()}"),
//                 _item("CGST (9%)",
//                    Unifiedresponse!.data!.costDetails==null?"":     "₹ ${Unifiedresponse!.data!.costDetails!.cgstAmount.toString()}"),
//                 _item("Duration",
//                    Unifiedresponse!.data!.costDetails==null?"":     "${Unifiedresponse!.data!.durationMinutes!.toString()}"),

//                 const Divider(height: 24),

//                 Row(
//                   children: [
//                     Text(
//                       "Total Amount",
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: Colors.green,
//                         fontSize: 16,
//                       ),
//                     ),
//                     Spacer(),
//                     Text(
//                    Unifiedresponse!.data!.costDetails==null?"":       "₹ ${Unifiedresponse!.data!.costDetails!.grandTotal.toString()}",
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: Colors.green,
//                         fontSize: 16,
//                       ),
//                     ),
//                   ],
//                 )
//               ],
//             ),
//     );
//   }

//   Widget _item(String title, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             child: Text(
//               title,
//               style: const TextStyle(color: Colors.grey),
//             ),
//           ),
//           const SizedBox(width: 10),
//           Expanded(
//             child: Text(
//               value,
//               textAlign: TextAlign.right,
//               style: const TextStyle(fontWeight: FontWeight.w500),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   BoxDecoration _cardDecoration() {
//     return BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(12),
//       boxShadow: [
//         BoxShadow(
//           color: Colors.grey.shade200,
//           blurRadius: 6,
//           offset: const Offset(0, 2),
//         )
//       ],
//     );
//   }
// }

import 'package:HyCharge/Provider/ChargingProvider.dart';
import 'package:HyCharge/Utils/commoncolors.dart';
import 'package:HyCharge/model/SessionIDDetailResponse.dart';
import 'package:HyCharge/model/UnifiedSessionDetailResponse.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

const Color _navy = Color(0xFF142D78);
const Color _darkText = Color(0xFF101A35);
const Color _mutedText = Color(0xFF667085);
const Color _dividerColor = Color(0xFFDDE3ED);
const Color _pageBackground = Color(0xFFF4F6FA);
const Color _softBlue = Color(0xFFE8EEF9);
const Color _statusBackground = Color(0xFFD8F9E3);
const Color _statusText = Color(0xFF078443);

class BookingDetailsScreen extends StatefulWidget {
  final String recID;
  final String bookingType;

  const BookingDetailsScreen({
    super.key,
    required this.recID,
    required this.bookingType,
  });

  @override
  State<BookingDetailsScreen> createState() =>
      _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  SessionIDDetailResponse? response;
  UnifiedSessionDetailResponse? Unifiedresponse;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  // Existing API calls and booking-type conditions are preserved.
  Future<void> loadData() async {
    try {
      if (widget.bookingType == "L") {
        final res =
            await context.read<ChargingProvider>().fetchSessionDetails(
                  context: context,
                  sessionId: widget.recID,
                );

        if (!mounted) return;

        setState(() {
          response = res;
          isLoading = false;
        });
      } else {
        final res = await context
            .read<ChargingProvider>()
            .fetchPartnerSessionDetails(
              context: context,
              sessionId: widget.recID,
            );

        if (!mounted) return;

        setState(() {
          Unifiedresponse = res;
          isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasNoData = widget.bookingType == "L"
        ? response == null
        : Unifiedresponse == null;

    return Scaffold(
      backgroundColor: CommonColors.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: SafeArea(
          bottom: false,
          child: Container(
            color: _pageBackground,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: Row(
              children: [
                Material(
                  color: Colors.white,
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () => Navigator.pop(context),
                    child: const SizedBox(
                      height: 42,
                      width: 42,
                      child: Icon(
                        Icons.arrow_back,
                        color: _darkText,
                        size: 22,
                      ),
                    ),
                  ),
                ),
                const Expanded(
                  child: Text(
                    'Booking Details',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: _darkText,
                    ),
                  ),
                ),
                const SizedBox(width: 42),
              ],
            ),
          ),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: _navy),
            )
          : hasNoData
              ? const Center(
                  child: Text(
                    'No data found',
                    style: TextStyle(
                      fontSize: 14,
                      color: _mutedText,
                    ),
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildAmountCard(),
                      const SizedBox(height: 14),
                      _buildDetailsCard(),
                    ],
                  ),
                ),
    );
  }

  // Amount, status and booking ID card.
  Widget _buildAmountCard() {
    final amount = widget.bookingType == "L"
        ? '₹ ${response!.data!.costDetails!.totalCost}'
        : (Unifiedresponse!.data!.costDetails == null ||
                Unifiedresponse!.data!.costDetails == "null")
            ? '₹ 0'
            : '₹ ${Unifiedresponse!.data!.costDetails!.grandTotal}';

    final status = widget.bookingType == "L"
        ? '${response!.data!.status ?? "-"}'
        : '${Unifiedresponse!.data!.status ?? "-"}';

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
      decoration: _cardDecoration(radius: 26),
      child: Column(
        children: [
          Text(
            amount,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: _navy,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 10),

          // Status badge.
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 13,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              color: _statusBackground,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  color: _statusText,
                  size: 15,
                ),
                const SizedBox(width: 5),
                Text(
                  status,
                  style: const TextStyle(
                    color: _statusText,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Booking ID panel.
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: const Color(0xFFEEF0F5),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              
              children: [
                const Text(
                  'Booking ID',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                    fontSize: 12,
                    color: _mutedText,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                SelectableText(
                  widget.recID,
                  style: const TextStyle(
                    fontSize: 12,
                    color: _darkText,
                    fontWeight: FontWeight.w700,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Existing local and partner data bindings are retained.
  Widget _buildDetailsCard() {
    if (widget.bookingType == "L") {
      final data = response!.data!;

      return _detailsContainer(
        items: [
          _DetailItem(
            'Date & time',
            '${_formatDate(data.session!.createdOn?.toString())}\n'
                '${formatOnlyTimeIST(data.session!.startTime?.toString())}'
                ' - '
                '${formatOnlyTimeIST(data.session!.endTime?.toString())}',
            multiline: true,
          ),
          _DetailItem(
            'Charger type',
            '${data.chargerDetails!.chargerType ?? "-"}',
          ),
          _DetailItem(
            'Price per unit',
            '₹ ${data.summary!.costPerKwh ?? "-"}',
          ),
          _DetailItem(
            'Total kW used',
            data.energyConsumption!.totalEnergy == "null"
                ? '-'
                : '${data.energyConsumption!.totalEnergy ?? "-"}',
          ),
          _DetailItem(
            'Total charging time',
            data.timing!.duration!.formattedDuration == "null"
                ? '-'
                : '${data.timing!.duration!.formattedDuration ?? "-"}',
          ),
          _DetailItem(
            'Service charge',
            '₹ ${data.costDetails!.energyCost}',
          ),
          _DetailItem(
            'SGST (9%)',
            '₹ ${data.costDetails!.sgst}',
          ),
          _DetailItem(
            'CGST (9%)',
            '₹ ${data.costDetails!.cgst}',
          ),
          _DetailItem(
            'Duration',
            '${data.timing!.duration!.formattedDuration}',
          ),
        ],
        totalAmount: '₹ ${data.costDetails!.totalCost}',
      );
    }

    final data = Unifiedresponse!.data!;
    final costs = data.costDetails;

    return _detailsContainer(
      items: [
        _DetailItem(
          'Date & time',
          '${_formatDate(data.startDateTime?.toString())}\n'
              '${formatOnlyTimeIST(data.startDateTime?.toString())}'
              ' - '
              '${formatOnlyTimeIST(data.endDateTime?.toString())}',
          multiline: true,
        ),
        const _DetailItem('Charger type', '-'),
        _DetailItem(
          'Price per unit',
          costs == null ? '' : '${costs.platformFeePerKwh}',
        ),
        _DetailItem(
          'Total kW used',
          data.totalEnergyKwh == null
              ? '-'
              : '${data.totalEnergyKwh}',
        ),
        _DetailItem(
          'Total charging time',
          data.timeLimit == null ? '-' : '${data.timeLimit}',
        ),
        _DetailItem(
          'Service charge',
          costs == null ? '' : '₹ ${costs.taxableValue}',
        ),
        _DetailItem(
          'SGST (9%)',
          costs == null ? '' : '₹ ${costs.sgstAmount}',
        ),
        _DetailItem(
          'CGST (9%)',
          costs == null ? '' : '₹ ${costs.cgstAmount}',
        ),
        _DetailItem(
          'Duration',
          costs == null ? '' : '${data.durationMinutes}',
        ),
      ],
      totalAmount: costs == null ? '' : '₹ ${costs.grandTotal}',
    );
  }

  Widget _detailsContainer({
    required List<_DetailItem> items,
    required String totalAmount,
  }) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: _cardDecoration(radius: 26),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                for (int i = 0; i < items.length; i++) ...[
                  _detailRow(items[i]),
                  if (i != items.length - 1)
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: _dividerColor,
                    ),
                ],
              ],
            ),
          ),

          // Total amount footer.
          Container(
            width: double.infinity,
            color: _softBlue,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 17,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Text(
                    'Total Amount',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: _navy,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: Text(
                    totalAmount,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: _navy,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(_DetailItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: Text(
              item.title,
              style: const TextStyle(
                color: _mutedText,
                fontSize: 13,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 5,
            child: Text(
              item.value,
              textAlign: TextAlign.right,
              softWrap: true,
              style: const TextStyle(
                color: _navy,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String? dateTimeString) {
    if (dateTimeString == null || dateTimeString.trim().isEmpty) {
      return '-';
    }

    try {
      final dateTime = DateTime.parse(dateTimeString);
      return DateFormat('EEE dd MMM yyyy').format(dateTime);
    } catch (_) {
      return dateTimeString;
    }
  }

  String formatTime(String dateTimeString) {
    return _formatDate(dateTimeString);
  }

  String formatonlyTime(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString);
      return DateFormat('hh.mm a').format(dateTime);
    } catch (_) {
      return '';
    }
  }

  String formatOnlyTimeIST(String? timeString) {
    if (timeString == null || timeString.trim().isEmpty) {
      return '';
    }

    try {
      final parsed = DateTime.parse(timeString);

      // Preserve the existing UTC-to-IST conversion logic.
      final istTime = parsed.toUtc().add(
            const Duration(hours: 5, minutes: 30),
          );

      return DateFormat('hh.mm a').format(istTime);
    } catch (_) {
      return '';
    }
  }

  BoxDecoration _cardDecoration({double radius = 20}) {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(radius),
      boxShadow: [
        BoxShadow(
          color: const Color(0xFF142D78).withOpacity(0.07),
          blurRadius: 16,
          offset: const Offset(0, 5),
        ),
      ],
    );
  }
}

class _DetailItem {
  final String title;
  final String value;
  final bool multiline;

  const _DetailItem(
    this.title,
    this.value, {
    this.multiline = false,
  });
}

