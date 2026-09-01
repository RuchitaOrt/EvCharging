import 'package:HyCharge/Provider/ActiveSessionProvider.dart';
import 'package:HyCharge/Provider/PaymentProvider.dart';
import 'package:HyCharge/Screens/BookingDetailsScreen.dart';
import 'package:HyCharge/Screens/MainTab.dart';
import 'package:HyCharge/Screens/SessionChargingScreen.dart';
import 'package:HyCharge/Utils/CommonAppBar.dart';
import 'package:HyCharge/Utils/LocationConvert.dart';
import 'package:HyCharge/Utils/commoncolors.dart';
import 'package:HyCharge/Utils/commonimages.dart';
import 'package:HyCharge/Utils/sizeConfig.dart';
import 'package:HyCharge/model/ActiveSessionResponse.dart';
import 'package:HyCharge/model/StartChargingSessionResponse.dart';
import 'package:HyCharge/model/UnifiedActiveSessionResponse.dart';
import 'package:HyCharge/widget/GlobalLists.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ChargingHistoryScreen extends StatefulWidget {
  const ChargingHistoryScreen({super.key});

  @override
  State<ChargingHistoryScreen> createState() => _ChargingHistoryScreenState();
}

class _ChargingHistoryScreenState extends State<ChargingHistoryScreen>
    with SingleTickerProviderStateMixin {
  late final ScrollController _scrollController;
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
 final provider = context.read<ActiveSessionProvider>();
    _scrollController = ScrollController()..addListener(_onScroll);
 provider.fetchActiveSessions(
          context,
          "",
        );
    // Initialize TabController first
    _tabController = TabController(
      length: 2,
      vsync: this,
    );

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        return;
      }

     

      provider.changeMainTab(_tabController.index);

      if (_tabController.index == 0) {
        provider.fetchActiveSessions(
          context,
          "",
        );
      } else {
        provider.fetchAUnifiedctiveSessions(
          context,
          "",
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final provider = context.read<ActiveSessionProvider>();

    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        provider.hasMore &&
        !provider.loadingMore) {
      provider.loadMore(context, "");
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MainTab(isLoggedIn: GlobalLists.islLogin),
          ),
        );

        return false; // ✅ now it's Future<bool>
      },
      child: Scaffold(
          appBar: CommonAppBar(
            title: "Charging History",
            onBack: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MainTab(isLoggedIn: GlobalLists.islLogin),
                ),
              );
            },
          ),
          backgroundColor: CommonColors.neutral50,
          body: Consumer<ActiveSessionProvider>(
            builder: (context, provider, _) {
              if (provider.loading) {
                return const Center(child: CircularProgressIndicator());
              }
              //  if (provider.sessions.isEmpty) {
              //           return  Center(child: Text("No charging history found"));
              //         }
            //  if( provider.selectedMainTab == 0){
            //   if (provider.totalSessions == "0") {
            //     return Center(child: Text("No charging history found"));
            //   }
            //  }
              return ListView(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                children: [
                  _summaryRow(),
                  const SizedBox(height: 20),
                  TabBar(
                    indicatorColor: CommonColors.blue,
                    controller: _tabController,
                    tabs:  [
                      Tab(child: Text("Charging Session",style: TextStyle(color: provider.selectedMainTab == 0?CommonColors.blue:CommonColors.blacklight ),),),
                      Tab(child: Text("Partner Session",style: TextStyle(color: provider.selectedMainTab == 1?CommonColors.blue:CommonColors.blacklight ),),)
                    ],
                  ),
                  const SizedBox(height: 20),
                  const FilterTabsWidget(),
                  const SizedBox(height: 20),
                  provider.selectedMainTab == 0
                      ? Column(
                          children: provider.sessions
                              .map((session) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  child: _historyCard(session)))
                              .toList(),
                        )
                      : Column(
                          children: provider.partnerSessions
                              .map((session) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  child: _partnerhistoryCard(session)))
                              .toList(),
                        )
                  //               provider.sessions.isEmpty
                  // ? Center(
                  //     child: Center(child: Text("No charging history found"))
                  //   )
                  // : Column(
                  //     children:
                  //      provider.sessions.map(
                  //       (session) => Padding(
                  //         padding: const EdgeInsets.only(bottom: 12, top: 12),
                  //         child: _historyCard(session),
                  //       ),
                  //     ).toList(),
                  //   ),

                  //               if (provider.loadingMore)
                  //                 const Padding(
                  //                   padding: EdgeInsets.symmetric(vertical: 16),
                  //                   child: Center(child: CircularProgressIndicator()),
                  //                 ),
                ],
              );
            },
          )),
    );
  }

  Widget _summaryRow() {
    return Consumer<ActiveSessionProvider>(
      builder: (context, provider, _) {
        // Calculate summary values

        final totalSessions = provider.totalSessions;
        final totalEnergy = provider.totalEnergy;
        //  provider.sessions.fold<double>(
        //   0,
        //   (sum, s) => sum + (double.tryParse(s!.energyTransmitted!) ?? 0),
        // );
        final totalSpent = provider.totalSpent;
        //  provider.sessions.fold<double>(
        //   0,
        //   (sum, s) => sum + (double.tryParse(s.chargingTotalFee) ?? 0),
        // );
        final durationString = provider.totalTime;
        // provider.sessions.fold<Duration>(
        //   Duration.zero,
        //   (sum, s) {
        //     // assuming s.duration is "hh:mm" or "h:mm"
        //     final parts = s.duration.split(':');
        //     final hours = int.tryParse(parts[0]) ?? 0;
        //     final minutes = int.tryParse(parts[1]) ?? 0;
        //     return sum + Duration(hours: hours, minutes: minutes);
        //   },
        // );

        // Format total duration as Hh Mm
        // final durationString =
        //     "${totalDuration.inHours}h ${totalDuration.inMinutes.remainder(60)}m";

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _summaryBox("$totalSessions", "Sessions"),
                _summaryBox("${totalEnergy} kW", "Total Energy"),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _summaryBox("₹ ${totalSpent}", "Total Spent"),
                _summaryBox(durationString, "Total Time"),
              ],
            ),
          ],
        );
      },
    );
  }

  // Widget _summaryRow() {
  //   return Column(
  //     children: [
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           _summaryBox("12", "Sessions"),
  //           _summaryBox("214 kW", "Total Energy"),
  //         ],
  //       ),
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           _summaryBox("₹ 5,428", "Total Spent"),
  //           _summaryBox("15h 42m", "Total Time"),
  //         ],
  //       ),
  //     ],
  //   );
  // }

  Widget _summaryBox(String value, String label) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Container(
        width: SizeConfig.blockSizeHorizontal * 40,
        decoration: BoxDecoration(
          color: CommonColors.white,
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(left: 8, right: 8, top: 10, bottom: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(value,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: CommonColors.blue)),
              const SizedBox(height: 4),
              Text(label, style: TextStyle(fontSize: 14, color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _partnerhistoryCard(Session data) {
   
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            data.status == "Active"
                ? null
                : Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BookingDetailsScreen(
                        recID: data.sessionId!,
                        bookingType: "P",
                      ),
                    ),
                  );
          },
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: CommonColors.white,
                  border: Border.all(color: CommonColors.neutral200),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      width: SizeConfig.blockSizeHorizontal * 90,
                      decoration: BoxDecoration(
                        color: CommonColors.neutral50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// LEFT SIDE (FIXED)
                                Expanded(
                                  // ✅ KEY FIX
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Station: ${data.locationName!.toUpperCase() ?? "Station"}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12),
                                      ),
                                      Text(
                                        "${data.locationCity}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12),
                                      ),

                                      const SizedBox(height: 4),
                                      // Row(
                                      //   crossAxisAlignment: CrossAxisAlignment.start,
                                      //   mainAxisAlignment: MainAxisAlignment.start,
                                      //   children: [
                                      //    Padding(
                                      //      padding: const EdgeInsets.only(top: 4),
                                      //      child: Image.asset( CommonImagePath.redpin,),
                                      //    ),
                                      //     const SizedBox(width: 4),

                                      //   ],
                                      // ),
                                    ],
                                  ),
                                ),

                                const SizedBox(width: 8),

                                /// RIGHT SIDE (AUTO WIDTH)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      formatTime("${data.startDateTime}"),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: CommonColors.black,
                                        fontSize: 12,
                                      ),
                                    ),
                                    // Text(
                                    //   data.status == "Active"
                                    //       ? formatonlyTimeIST(data.startDateTime!)
                                    //       : "${formatonlyTimeIST(data.startDateTime!)} - ${formatonlyTimeIST(data.endDateTime!)}",
                                    //   // data.status == "Active"
                                    //   //     ? formatonlyTime("${data.startTime}")
                                    //   //     : "${formatonlyTime("${data.startTime}")} - ${formatonlyTime("${data.endTime}")}",
                                    //   style: const TextStyle(
                                    //     fontWeight: FontWeight.w400,
                                    //     color: CommonColors.neutral500,
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
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Energy",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: CommonColors.neutral500,
                                      fontSize: 12)),
                              Text("${data.totalEnergyKwh} kW",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12)),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text("Duration",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: CommonColors.neutral500,
                                      fontSize: 12)),
                              Text(formatDuration("${data.durationMinutes}"),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12)),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text("Fee",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: CommonColors.neutral500,
                                      fontSize: 12)),
                              Text("₹${data.totalCost}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12)),
                            ],
                          ),
                        ),
                       
                      ],
                    ),

                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Start Battery",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: CommonColors.neutral500,
                                    fontSize: 12)),
                            Text(
                                // data.soCStart == null
                                //     ? "-"
                                //     : "${data.soCStart} %",
                                "",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 12)),
                          ],
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text("End Battery",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: CommonColors.neutral500,
                                      fontSize: 12)),
                              Text(
                                  // data.soCEnd == null
                                  //     ? "-"
                                  //     : "${data.soCEnd} %",
                                  "",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12)),
                            ],
                          ),
                        ),
                       
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    const SizedBox(height: 16),
                    data.status == "Active"
                        ? Container(
                            width: SizeConfig.blockSizeHorizontal * 90,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => SessionChargingScreen(
                                      args: SessionChargingArgs(
                                          sessionId: data.sessionId! ?? "",
                                          status: data.status ?? "",
                                          cost: data.totalCost?.toString() ??
                                              "0",
                                          unitConsumed: data.totalEnergyKwh
                                                  ?.toString() ??
                                              "0",
                                          outputPower: data.totalEnergyKwh
                                                  ?.toString() ??
                                          "0"
                                             ,
                                          batteryPercentage:
                                              "0",
                                          endMeterReading:
                                            
                                                  "0",
                                          duration:
                                              data.durationMinutes?.toString() ?? "0",
                                          stationName:
                                              data.locationName ?? "",
                                          ConnectorGunID:
                                              data.connectorId ?? ""),
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: CommonColors.white,
                                foregroundColor: CommonColors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(
                                    color: CommonColors.blue.withOpacity(0.4),
                                    width: 0.8,
                                  ),
                                ),
                              ),
                              child: const Text(
                                "View Session",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: CommonColors.blue,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          )
                        : Container(
                            width: SizeConfig.blockSizeHorizontal * 90,
                            child: ElevatedButton(
                              onPressed: () {
                                data.status == "Active"
                                    ? null
                                    : Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => BookingDetailsScreen(
                                            recID: data.sessionId!,
                                            bookingType: "P",
                                          ),
                                        ),
                                      );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: CommonColors.white,
                                foregroundColor: CommonColors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(
                                    color: CommonColors.blue.withOpacity(0.4),
                                    width: 0.8,
                                  ),
                                ),
                              ),
                              child: const Text(
                                //Download
                                "View Receipt",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: CommonColors.blue,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
              Positioned(
                top: -10,
                left: 16,
                child: _statusChip(data.status!, data.sessionId!),
              ),
            ],
          ),
        ),
      ],
    );
  }


  String formatDuration(String duration) {
    List<String> parts = duration.split(':');

    int h = 0, m = 0, s = 0;

    if (parts.isNotEmpty) {
      h = int.tryParse(parts[0]) ?? 0;
    }

    if (parts.length > 1) {
      m = int.tryParse(parts[1]) ?? 0;
    }

    if (parts.length > 2) {
      // keep only first 2 digits if too long
      String secPart = parts[2].replaceAll(RegExp(r'[^0-9]'), '');
      if (secPart.length > 2) {
        secPart = secPart.substring(0, 2);
      }
      s = int.tryParse(secPart) ?? 0;
    }

    // fix overflow
    m += s ~/ 60;
    s = s % 60;

    h += m ~/ 60;
    m = m % 60;

    return "${h.toString().padLeft(2, '0')}:"
        "${m.toString().padLeft(2, '0')}:"
        "${s.toString().padLeft(2, '0')}";
  }

  String formatTime(String dateTimeString) {
    final dateTime = DateTime.parse(dateTimeString);

    return DateFormat('EEE dd MMM yyyy').format(dateTime);
  }

  Widget _historyCard(ChargingSession data) {
    // print("API VALUE");
    // print(data.startTime!);
    // print(data.endTime!);
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            data.status == "Active"
                ? null
                : Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BookingDetailsScreen(
                        recID: data.recId!,
                        bookingType: "L",
                      ),
                    ),
                  );
          },
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: CommonColors.white,
                  border: Border.all(color: CommonColors.neutral200),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      width: SizeConfig.blockSizeHorizontal * 90,
                      decoration: BoxDecoration(
                        color: CommonColors.neutral50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// LEFT SIDE (FIXED)
                                Expanded(
                                  // ✅ KEY FIX
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Station: ${data.chargingStationName!.toUpperCase() ?? "Station"}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12),
                                      ),
                                      Text(
                                        "${data.chargingHubName}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12),
                                      ),

                                      const SizedBox(height: 4),
                                      // Row(
                                      //   crossAxisAlignment: CrossAxisAlignment.start,
                                      //   mainAxisAlignment: MainAxisAlignment.start,
                                      //   children: [
                                      //    Padding(
                                      //      padding: const EdgeInsets.only(top: 4),
                                      //      child: Image.asset( CommonImagePath.redpin,),
                                      //    ),
                                      //     const SizedBox(width: 4),

                                      //   ],
                                      // ),
                                    ],
                                  ),
                                ),

                                const SizedBox(width: 8),

                                /// RIGHT SIDE (AUTO WIDTH)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      formatTime("${data.createdOn}"),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: CommonColors.black,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      data.status == "Active"
                                          ? formatonlyTimeIST(data.startTime!)
                                          : "${formatonlyTimeIST(data.startTime!)} - ${formatonlyTimeIST(data.endTime!)}",
                                      // data.status == "Active"
                                      //     ? formatonlyTime("${data.startTime}")
                                      //     : "${formatonlyTime("${data.startTime}")} - ${formatonlyTime("${data.endTime}")}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: CommonColors.neutral500,
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
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Energy",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: CommonColors.neutral500,
                                      fontSize: 12)),
                              Text("${data.energyTransmitted} kW",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12)),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text("Duration",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: CommonColors.neutral500,
                                      fontSize: 12)),
                              Text(formatDuration("${data.duration}"),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12)),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text("Fee",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: CommonColors.neutral500,
                                      fontSize: 12)),
                              Text("₹${data.chargingTotalFee}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12)),
                            ],
                          ),
                        ),
                        // Expanded(
                        //   child: Column(
                        //     children: [
                        //       Text("Plug Type",
                        //           style: TextStyle(
                        //               fontWeight: FontWeight.w400,
                        //               color: CommonColors.neutral500,
                        //               fontSize: 12)),
                        //       Text("${data.chargingTariff}",
                        //           style: TextStyle(
                        //               fontWeight: FontWeight.w600, fontSize: 12)),
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Start Battery",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: CommonColors.neutral500,
                                    fontSize: 12)),
                            Text(
                                data.soCStart == null
                                    ? "-"
                                    : "${data.soCStart} %",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 12)),
                          ],
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text("End Battery",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: CommonColors.neutral500,
                                      fontSize: 12)),
                              Text(
                                  data.soCEnd == null
                                      ? "-"
                                      : "${data.soCEnd} %",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12)),
                            ],
                          ),
                        ),
                        // Expanded(
                        //   child: Column(
                        //     children: [
                        //       Text("Fee",
                        //           style: TextStyle(
                        //               fontWeight: FontWeight.w400,
                        //               color: CommonColors.neutral500,
                        //               fontSize: 12)),
                        //       Text("₹${data.chargingTotalFee}",
                        //           style: TextStyle(
                        //               fontWeight: FontWeight.w600, fontSize: 12)),
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    //  Column(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //    children: [
                    //      Text("Location",
                    //          style: TextStyle(
                    //              fontWeight: FontWeight.w400,
                    //              color: CommonColors.neutral500,
                    //              fontSize: 12)),
                    //     Text(
                    //            "${data.chargingHubName}",
                    //             maxLines: 2,
                    //             overflow: TextOverflow.ellipsis,
                    //             style: const TextStyle(
                    //               fontWeight: FontWeight.w600,
                    //               fontSize: 12,
                    //             ),
                    //           ),
                    //    ],
                    //  ),
                    const SizedBox(height: 16),
                    data.status == "Active"
                        ? Container(
                            width: SizeConfig.blockSizeHorizontal * 90,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => SessionChargingScreen(
                                      args: SessionChargingArgs(
                                          sessionId: data?.recId ?? "",
                                          status: data?.status ?? "",
                                          cost: data?.chargingTotalFee?.toString() ??
                                              "0",
                                          unitConsumed: data?.energyTransmitted
                                                  ?.toString() ??
                                              "0",
                                          outputPower: (data?.chargingGun
                                                          ?.powerOutput ==
                                                      null ||
                                                  data?.chargingGun?.powerOutput ==
                                                      "null")
                                              ? "0"
                                              : data!.chargingGun!.powerOutput
                                                  .toString(),
                                          batteryPercentage:
                                              data?.soCStart?.toString() ?? "0",
                                          endMeterReading:
                                              data?.endMeterReading?.toString() ??
                                                  "0",
                                          duration:
                                              data?.duration?.toString() ?? "0",
                                          stationName:
                                              data.chargingStationName ?? "",
                                          ConnectorGunID:
                                              data.chargingGun!.connectorId ?? ""),
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: CommonColors.white,
                                foregroundColor: CommonColors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(
                                    color: CommonColors.blue.withOpacity(0.4),
                                    width: 0.8,
                                  ),
                                ),
                              ),
                              child: const Text(
                                "View Session",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: CommonColors.blue,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          )
                        : Container(
                            width: SizeConfig.blockSizeHorizontal * 90,
                            child: ElevatedButton(
                              onPressed: () {
                                data.status == "Active"
                                    ? null
                                    : Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => BookingDetailsScreen(
                                            recID: data.recId!,
                                            bookingType: "L",
                                          ),
                                        ),
                                      );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: CommonColors.white,
                                foregroundColor: CommonColors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(
                                    color: CommonColors.blue.withOpacity(0.4),
                                    width: 0.8,
                                  ),
                                ),
                              ),
                              child: const Text(
                                //Download
                                "View Receipt",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: CommonColors.blue,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
              Positioned(
                top: -10,
                left: 16,
                child: _statusChip(data.status!, data.recId!),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String formatonlyTimeIST(DateTime time) {
    final utcTime = DateTime.utc(
      time.year,
      time.month,
      time.day,
      time.hour,
      time.minute,
      time.second,
      time.millisecond,
      time.microsecond,
    );

    final istTime = utcTime.add(const Duration(hours: 5, minutes: 30));

    return DateFormat("hh.mm a").format(istTime);
  }

  String formatonlyTime(String dateTimeString) {
    final dateTime = DateTime.parse(dateTimeString);
    return DateFormat('hh.mm a').format(dateTime);
  }

  DateTime convertToIST(DateTime time) {
    return time.toUtc().add(const Duration(hours: 5, minutes: 30));
  }

// String formatonlyTimeIST(DateTime time) {
//   final istTime = convertToIST(time);
//   return DateFormat("hh.mm a").format(istTime);
// }
// DateTime convertToIST(DateTime time) {
//   return time.toUtc().add(const Duration(hours: 5, minutes: 30));
// }
// String formatonlyTimeIST(DateTime time) {
//   final istTime = convertToIST(time);
//   return DateFormat("hh.mm a").format(istTime);
// }
  Widget _statusChip(
    String isActive,
    String recId,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isActive == "Completed"
            ? Colors.green.shade50
            : Colors.red.shade100,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive == "Completed" ? Colors.green : CommonColors.red,
          width: 0.8,
        ),
      ),
      child: Text(
        "${isActive} ",
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: isActive == "Completed" ? Colors.green : CommonColors.red,
        ),
      ),
    );
  }
}

class FilterTabsWidget extends StatefulWidget {
  const FilterTabsWidget({super.key});

  @override
  State<FilterTabsWidget> createState() => _FilterTabsWidgetState();
}

class _FilterTabsWidgetState extends State<FilterTabsWidget> {
  // Track selected tab index
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _tabButton("This month", Icons.calendar_month, 0),
          const SizedBox(width: 10),
          _tabButton("Last 7 Days", Icons.bolt, 1),
          const SizedBox(width: 10),
          _tabButton("All", Icons.apps, 2), // NEW
          SizedBox(width: 10),
          // _tabButton("Filter", Icons.filter, 2),
        ],
      ),
    );
  }

  Widget _tabButton(String title, IconData icon, int index) {
    final isSelected = selectedIndex == index;
    return GestureDetector(
      // onTap: () {
      //   setState(() {
      //     selectedIndex = index;
      //   });
      // },
      onTap: () {
        setState(() {
          selectedIndex = index;
        });

        final provider = context.read<ActiveSessionProvider>();

        if (index == 0) {
          provider.setFilter(SessionFilter.thisMonth);
        } else if (index == 1) {
          provider.setFilter(SessionFilter.last7Days);
        } else if (index == 2) {
          provider.setFilter(SessionFilter.all); // NEW
        }

        // Debug: print length after filtering
        Future.microtask(() {
          print("Filtered sessions: ${provider.sessions.length}");
        });
          Future.microtask(() {
          print("Filtered  Partner sessions: ${provider.partnerSessions.length}");
        });
      },

      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected
              ? CommonColors.blue.withOpacity(0.1)
              : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: isSelected
                  ? CommonColors.blue.withOpacity(0.6)
                  : Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? CommonColors.blue : Colors.black,
              size: 20,
            ),
            const SizedBox(width: 5),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? CommonColors.blue : Colors.black,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
