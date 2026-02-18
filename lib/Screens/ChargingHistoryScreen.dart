import 'package:HyCharge/Provider/ActiveSessionProvider.dart';
import 'package:HyCharge/Provider/PaymentProvider.dart';
import 'package:HyCharge/Utils/CommonAppBar.dart';
import 'package:HyCharge/Utils/commoncolors.dart';
import 'package:HyCharge/Utils/commonimages.dart';
import 'package:HyCharge/Utils/sizeConfig.dart';
import 'package:HyCharge/model/ActiveSessionResponse.dart';
import 'package:HyCharge/model/StartChargingSessionResponse.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ChargingHistoryScreen extends StatefulWidget {
  const ChargingHistoryScreen({super.key});

  @override
  State<ChargingHistoryScreen> createState() => _ChargingHistoryScreenState();
}

class _ChargingHistoryScreenState extends State<ChargingHistoryScreen> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()..addListener(_onScroll);

    Future.microtask(() {
      context
          .read<ActiveSessionProvider>()
          .fetchActiveSessions(context, "");


          
    });
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
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CommonAppBar(
          title: "Charging History",
        ),
        backgroundColor: CommonColors.neutral50,
        body: Consumer<ActiveSessionProvider>(
          builder: (context, provider, _) {
            if (provider.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.sessions.isEmpty) {
              return const Center(child: Text("No charging history found"));
            }
            return ListView(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              children: [
                _summaryRow(),
                const SizedBox(height: 20),
                const FilterTabsWidget(),
                const SizedBox(height: 20),
                ...provider.sessions.map(
                  (session) => Padding(
                    padding: const EdgeInsets.only(bottom: 12,top: 12),
                    child: _historyCard(session),
                  ),
                ),
                if (provider.loadingMore)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: CircularProgressIndicator()),
                  ),
              ],
            );
          },
        ));
  }
Widget _summaryRow() {
  return Consumer<ActiveSessionProvider>(
    builder: (context, provider, _) {
      // Calculate summary values
     


      final totalSessions = provider.totalSessions;
      final totalEnergy =provider.totalEnergy;
      //  provider.sessions.fold<double>(
      //   0,
      //   (sum, s) => sum + (double.tryParse(s!.energyTransmitted!) ?? 0),
      // );
      final totalSpent =provider.totalSpent;
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
          padding: const EdgeInsets.only(left: 8,right: 8,top: 10,bottom: 10),
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

//   Widget _filterTabs() {
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: Row(
//         children: [
//           _tabButton("This month", Icons.calendar_month, selected: true),
//           const SizedBox(width: 10),
//           _tabButton("Last 7 Days", Icons.bolt),
//           const SizedBox(width: 10),
//           _tabButton("All", Icons.list, 2), // NEW
// SizedBox(width: 10),
//           _tabButton("Filter", Icons.filter),
//         ],
//       ),
//     );
//   }

  // Widget _tabButton(String text, IconData icon, {bool selected = false}) {
  //   return Container(
  //     padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  //     decoration: BoxDecoration(
  //       color: selected ? CommonColors.blue.withOpacity(0.1) : Colors.white,
  //       borderRadius: BorderRadius.circular(12),
  //       border: Border.all(
  //           color: selected
  //               ? CommonColors.blue.withOpacity(0.6)
  //               : Colors.grey.shade300),
  //     ),
  //     child: Row(
  //       children: [
  //         Icon(
  //           icon,
  //           color: selected ? CommonColors.blue : Colors.black,
  //           size: 20,
  //         ),
  //         Text(
  //           text,
  //           style: TextStyle(
  //               color: selected ? CommonColors.blue : Colors.black,
  //               fontWeight: FontWeight.w500),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  String formatTime(String dateTimeString) {
    final dateTime = DateTime.parse(dateTimeString);

    return DateFormat('EEE ddMMM yyyy').format(dateTime);
  }

  Widget _historyCard(ChargingSession data) {
    return Column(
      children: [
        Stack(
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
                  SizedBox(height: 8,),
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
            Expanded( // ✅ KEY FIX
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                
                children: [
                  Text(
                    "Station: ${data.chargingStationName}",
                    style: const TextStyle(fontWeight: FontWeight.w600,fontSize: 12),
                  ),
                   Text(
                    "${data.chargingHubName}",
                    style: const TextStyle(fontWeight: FontWeight.w600,fontSize: 12),
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
                      ? formatonlyTime("${data.startTime}")
                      : "${formatonlyTime("${data.startTime}")} - ${formatonlyTime("${data.endTime}")}",
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
                                    fontWeight: FontWeight.w600, fontSize: 12)),
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
                            Text("${data.duration}",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 12)),
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
                                    fontWeight: FontWeight.w600, fontSize: 12)),
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
                            
                            
                            data.soCStart==null?"-":"${data.soCStart} %",
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
                              
                             data.soCEnd==null?"-": "${data.soCEnd} %",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 12)),
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
                  Container(
                    width: SizeConfig.blockSizeHorizontal * 90,
                    child: ElevatedButton(
                      onPressed: () {},
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
                        "Download Receipt",
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
        child: _statusChip(data.status!,data.recId!),
      ),
          ],
        ),
      ],
    );
  }
  String formatonlyTime(String dateTimeString) {
  final dateTime = DateTime.parse(dateTimeString);
  return DateFormat('hh.mm a').format(dateTime);
}
Widget _statusChip(String isActive,String recId,) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    decoration: BoxDecoration(
      color: isActive=="Completed"
          ? Colors.green.shade50
          : Colors.red.shade100,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color:  isActive=="Completed" ? Colors.green : CommonColors.red,
        width: 0.8,
      ),
    ),
    child: Text(
      "${isActive} " ,
      style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color:  isActive=="Completed" ? Colors.green : CommonColors.red,
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
              color: isSelected ? CommonColors.blue : Colors.black,size: 20,
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
