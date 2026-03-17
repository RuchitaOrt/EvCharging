import 'package:HyCharge/Provider/ChargingProvider.dart';
import 'package:HyCharge/Utils/CommonAppBar.dart';
import 'package:HyCharge/Utils/commoncolors.dart';
import 'package:HyCharge/model/SessionDetailResponse.dart';


import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class BookingDetailsScreen extends StatefulWidget {
  final String recID;
  const BookingDetailsScreen({super.key, required this.recID});

  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {

    @override
  void initState() {
    super.initState();
   loadData();
  }
SessionDetailResponse? response;
bool isLoading = true;

Future<void> loadData() async {
  final res = await context.read<ChargingProvider>()
      .fetchChargingSessionDetails(
        context: context,
        sessionId: widget.recID,
      );

  setState(() {
    response = res;
    isLoading = false;
  });
}
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
       backgroundColor: CommonColors.white,
        appBar: CommonAppBar(
          title: "Booking Details",
          onBack: () {
          Navigator.pop(context);
          },
        ),
      body: isLoading
        ? const Center(child: CircularProgressIndicator())
        : response == null
            ? const Center(child: Text("No data found"))
            :  SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// Amount Section
             Text(
              "₹ ${response!.data!.costDetails!.totalCost.toString()}",
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
             Text(
              "${response!.data!.status}",
              style: TextStyle(
                color: Colors.green,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            // TextButton(
            //   onPressed: () {},
            //   child:  Text("View invoice",style: TextStyle(color: CommonColors.blue,),),
            // ),

          
            /// Booking ID Card
            _buildBookingId(),

            const SizedBox(height: 16),

            /// Details Card
            _buildDetailsCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingId() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
    decoration: _cardDecoration(),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Booking ID",
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(width: 10),

        /// Fix overflow here
        Expanded(
          child: Text(
            widget.recID,
            textAlign: TextAlign.right,
            softWrap: true,
            style: const TextStyle(
              fontWeight: FontWeight.w400,
             fontSize: 12
            ),
          ),
        ),
      ],
    ),
  );
}
  String formatTime(String dateTimeString) {
  final dateTime = DateTime.parse(dateTimeString);

  return DateFormat('EEE dd MMM yyyy').format(dateTime);
}
  String formatonlyTime(String dateTimeString) {
  final dateTime = DateTime.parse(dateTimeString);
  return DateFormat('hh.mm a').format(dateTime);
}
// String formatonlyTimeIST(DateTime time) {
//   final utcTime = DateTime.utc(
//     time.year,
//     time.month,
//     time.day,
//     time.hour,
//     time.minute,
//     time.second,
//     time.millisecond,
//     time.microsecond,
//   );

//   final istTime = utcTime.add(const Duration(hours: 5, minutes: 30));

//   return DateFormat("hh.mm a").format(istTime);
// }
String formatonlyTimeIST(String? timeString) {
  if (timeString == null || timeString.isEmpty) return "";

  final parsed = DateTime.parse(timeString);

  final utcTime = DateTime.utc(
    parsed.year,
    parsed.month,
    parsed.day,
    parsed.hour,
    parsed.minute,
    parsed.second,
    parsed.millisecond,
    parsed.microsecond,
  );

  final istTime = utcTime.add(const Duration(hours: 5, minutes: 30));

  return DateFormat("hh.mm a").format(istTime);
}
  Widget _buildDetailsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          _item("Date & time", "${formatTime(response!.data!.session!.createdOn!.toString())} \n${formatonlyTimeIST("${response!.data!.session!.startTime}")} - ${formatonlyTimeIST("${response!.data!.session!.endTime}")}"),
      //     _item("Address details",
      // (response!.data!.session!.chargingHub!.addressLine1==null)?"-":      "${response!.data!.session!.chargingHub!.addressLine1}"),
          _item("Charger type", "${response!.data!.chargerDetails!.chargerType}"),
          _item("Price per unit", "${response!.data!.summary!.costPerKwh}"),
          _item("Connector details", "${response!.data!.session!.chargingHubName}"),
        //  _item("Energy Cost",  "₹ ${response!.data!.costDetails!.energyCost.toString()}"),
          _item("Total kW used", "${response!.data!.energyConsumption!.totalEnergy}"),
          _item("Total charging time", "${response!.data!.timing!.duration!.formattedDuration}"),
         _item("Service charge", "₹ ${response!.data!.costDetails!.energyCost.toString()}"),
          // // _item("Discount", "₹0.0"),
          // // _item("Cashback", "0.0"),
          _item("SGST (9%)",  "₹ ${response!.data!.costDetails!.sgst.toString()}"),
          _item("CGST (9%)", "₹ ${response!.data!.costDetails!.cgst.toString()}"),
         _item("Duration", "${response!.data!.timing!.duration!.formattedDuration.toString()}"),
          // _item("Charge coins credited", "55"),

          const Divider(height: 24),

          Row(
            children:  [
              Text(
                "Total Amount",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                  fontSize: 16,
                ),
              ),
              Spacer(),
              Text(
                "₹ ${response!.data!.costDetails!.totalCost.toString()}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                  fontSize: 16,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _item(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.shade200,
          blurRadius: 6,
          offset: const Offset(0, 2),
        )
      ],
    );
  }
}
