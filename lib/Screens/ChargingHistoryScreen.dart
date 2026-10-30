import 'package:HyCharge/Provider/ActiveSessionProvider.dart';
import 'package:HyCharge/Screens/BookingDetailsScreen.dart';
import 'package:HyCharge/Screens/MainTab.dart';
import 'package:HyCharge/Screens/SessionChargingScreen.dart';
import 'package:HyCharge/Utils/CommonAppBar.dart';
import 'package:HyCharge/Utils/commoncolors.dart';
import 'package:HyCharge/Utils/commonimages.dart';

import 'package:HyCharge/model/StartChargingSessionResponse.dart';
import 'package:HyCharge/model/UnifiedActiveSessionResponse.dart';
import 'package:HyCharge/widget/GlobalLists.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ChargingHistoryScreen extends StatefulWidget {
  final int initialTabIndex;
  const ChargingHistoryScreen({super.key,this.initialTabIndex = 0,});

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

  // Open the requested tab and update Provider state.
  _tabController = TabController(
    length: 2,
    vsync: this,
    initialIndex: widget.initialTabIndex,
  );

  // Set the provider tab before calling the API.
  provider.changeMainTab(widget.initialTabIndex);

  // Call the API for the initially selected tab only.
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (!mounted) return;

    if (widget.initialTabIndex == 0) {
      provider.fetchActiveSessions(context, "");
    } else {
      provider.fetchAUnifiedctiveSessions(context, "");
    }
  });

  // Fetch the corresponding API when the user switches tabs.
  _tabController.addListener(() {
    if (_tabController.indexIsChanging) return;

    final selectedIndex = _tabController.index;

    if (provider.selectedMainTab == selectedIndex) return;

    provider.changeMainTab(selectedIndex);

    if (selectedIndex == 0) {
      provider.fetchActiveSessions(context, "");
    } else {
      provider.fetchAUnifiedctiveSessions(context, "");
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
  if (!_scrollController.hasClients) return;

  final provider = context.read<ActiveSessionProvider>();

  if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200 &&
      provider.selectedMainTab == 1 &&
      provider.hasMore &&
      !provider.loadingMore) {
    provider.loadMoreUnifiedData(context, "");
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
      return false;
    },
    child: Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
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
      body: Consumer<ActiveSessionProvider>(
        builder: (context, provider, _) {
          if (provider.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView(
            controller: _scrollController,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            children: [
              _summaryRow(),
              const SizedBox(height: 16),

              // Session tabs
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE9EDF4),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    color: const Color(0xFF142F7D),
                    borderRadius: BorderRadius.circular(26),
                  ),
                  dividerColor: Colors.transparent,
                  labelColor: Colors.white,
                  unselectedLabelColor: const Color(0xFF687386),
                  labelStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  tabs: const [
                    Tab(
                      height: 42,
                      text: "Charging Session",
                    ),
                    Tab(
                      height: 42,
                      text: "Partner Session",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),
              const FilterTabsWidget(),
              const SizedBox(height: 12),

              if (provider.selectedMainTab == 0)
                if (provider.sessions.isEmpty)
                  _emptyHistory()
                else
                  ...provider.sessions.map(
                    (session) => 
                    // Padding(
                    //   padding: const EdgeInsets.only(bottom: 12),
                      // child: 
                      _historyCard(session),
                    // ),
                  )
              else if (provider.partnerSessions.isEmpty)
                _emptyHistory()
              else
                ...provider.partnerSessions.map(
                  (session) => _partnerhistoryCard(session),
                ),

              if (provider.selectedMainTab == 1 &&
                  provider.loadingMore)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          );
        },
      ),
    ),
  );
}

Widget _emptyHistory() {
  return Container(
    margin: const EdgeInsets.only(top: 24),
    padding: const EdgeInsets.all(28),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
    ),
    child: const Column(
      children: [
        Icon(
          Icons.ev_station_rounded,
          size: 42,
          color: Color(0xFF8B97AA),
        ),
        SizedBox(height: 12),
        Text(
          "No charging history found",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF27344D),
          ),
        ),
      ],
    ),
  );
}

Widget _summaryRow() {
  return Consumer<ActiveSessionProvider>(
    builder: (context, provider, _) {
      final items = [
        (provider.totalSessions, "Sessions"),
        ("${provider.totalEnergy} kWh", "Energy"),
        ("₹ ${provider.totalSpent}", "Spent"),
        (provider.totalTime, "Time"),
      ];

      return Container(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 4,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF152B55).withOpacity(0.04),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: List.generate(items.length, (index) {
            final item = items[index];

            return Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: index == 0
                      ? null
                      : const Border(
                          left: BorderSide(
                            color: Color(0xFFE4E8F0),
                          ),
                        ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        item.$1,
                        maxLines: 1,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF142F7D),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      item.$2,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFF687386),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      );
    },
  );
}

Widget _invoiceButton({
  required String sessionId,
}) {
  return Consumer<ActiveSessionProvider>(
    builder: (context, provider, _) {
      return FutureBuilder<bool>(
        future: provider.isInvoiceDownloaded(sessionId),
        builder: (context, snapshot) {
          final isDownloaded = snapshot.data ?? false;

          return Expanded(
            child: ElevatedButton(
              onPressed: () async {
                if (isDownloaded) {
                  await provider.openInvoice(sessionId);
                } else {
                  final success = await provider.downloadInvoice(
                    context,
                    sessionId,
                  );

                  if (success && mounted) {
                    setState(() {});
                  }
                }
              },
               style: OutlinedButton.styleFrom(
                              backgroundColor: const Color(0xFFEAF0FF),
                              foregroundColor: CommonColors.blue,
                              minimumSize: const Size(0, 38),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 8,
                              ),
                              // side: BorderSide(
                              //   color: CommonColors.blue.withOpacity(0.25),
                              // ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
              child: snapshot.connectionState == ConnectionState.waiting
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       Icon(
                             isDownloaded?Icons.remove_red_eye_sharp:     Icons.download,
                                  size: 15,
                                ),
                                SizedBox(width: 2),
                      Center(
                        child: Text(
                            isDownloaded ? "View Download" : "Download",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 12,
                              color: CommonColors.blue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                      ),
                    ],
                  ),
            ),
          );
        },
      );
    },
  );
}


Widget _partnerhistoryCard(Session data) {
  final String sessionId = data.sessionId ?? "";
  final bool isExpanded = _expandedSessionId == sessionId;

  return Container(
    // margin: const EdgeInsets.only(bottom: 8),
    decoration: BoxDecoration(
      color: CommonColors.white,
      border: Border.all(color: CommonColors.neutral200),
      // borderRadius: BorderRadius.circular(14),
    ),
    child: Column(
      children: [
        // Compact, always-visible header
        InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {
            setState(() {
              _expandedSessionId =
                  isExpanded ? null : sessionId;
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            child: Row(
              children: [
                Container(
                  height: 38,
                  width: 38,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF0FF),
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(9),
                  child: Image.asset(
                    CommonImagePath.borderGreen,color: CommonColors.blue,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(width: 10),

                // Station and summary
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (data.locationName ?? "Station").toUpperCase(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: CommonColors.black,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        "${formatTime("${data.startDateTime}")} • "
                        "${data.totalEnergyKwh ?? 0} kW",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          color: CommonColors.neutral500,
                        ),
                      ),
                      Text(
                        data.totalCost == null
                            ? "₹-"
                            : "₹${data.totalCost}",
                        style: const TextStyle(
                          fontSize: 11,
                          color: CommonColors.neutral500,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 5),
                _statusChip(data.status ?? "", sessionId),
                const SizedBox(width: 4),
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: CommonColors.neutral500,
                  size: 22,
                ),
              ],
            ),
          ),
        ),

        // Expandable session details

AnimatedSize(
  duration: const Duration(milliseconds: 220),
  curve: Curves.easeInOut,
  child: isExpanded
      ? Column(
          children: [
            Divider(
              height: 1,
              color: CommonColors.neutral200,
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: CommonColors.neutral50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _historyInfo(
                            "Duration",
                            formatDuration(
                              "${data.durationMinutes}",
                            ),
                          ),
                        ),
                        Expanded(
                          child: _historyInfo(
                            "Start Battery",
                            data.soCStart == null
                                ? "-"
                                : "${data.soCStart}%",
                          ),
                        ),
                        Expanded(
                          child: _historyInfo(
                            "End Battery",
                            data.soCEnd == null
                                ? "-"
                                : "${data.soCEnd}%",
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),
Row(children: [
    Text(
                                "${data.locationCity} Time .",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: CommonColors.neutral500,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                data.startDateTime == null ||
                                        data.endDateTime == null
                                    ? "-"
                                    : "${formatOnlyTimeIST(data.startDateTime!.toString())} - "
                                        "${formatOnlyTimeIST(data.endDateTime!.toString())}",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: CommonColors.black,
                                ),
                              ),
],),
                  // Session time panel
                  // Container(
                  //   width: double.infinity,
                  //   padding: const EdgeInsets.symmetric(
                  //     horizontal: 12,
                  //     vertical: 12,
                  //   ),
                  //   decoration: BoxDecoration(
                  //     color: CommonColors.neutral50,
                  //     borderRadius: BorderRadius.circular(12),
                  //   ),
                  //   child: Row(
                  //     children: [
                  //       Icon(
                  //         Icons.access_time_rounded,
                  //         size: 18,
                  //         color: CommonColors.neutral500,
                  //       ),
                  //       const SizedBox(width: 8),
                  //       Expanded(
                  //         child: Column(
                  //           crossAxisAlignment:
                  //               CrossAxisAlignment.start,
                  //           children: [
                  //             const Text(
                  //               "Charging Time",
                  //               style: TextStyle(
                  //                 fontSize: 11,
                  //                 color: CommonColors.neutral500,
                  //               ),
                  //             ),
                  //             const SizedBox(height: 4),
                  //             Text(
                  //               data.startDateTime == null ||
                  //                       data.endDateTime == null
                  //                   ? "-"
                  //                   : "${formatOnlyTimeIST(data.startDateTime!.toString())} - "
                  //                       "${formatOnlyTimeIST(data.endDateTime!.toString())}",
                  //               maxLines: 2,
                  //               overflow: TextOverflow.ellipsis,
                  //               style: const TextStyle(
                  //                 fontSize: 12,
                  //                 fontWeight: FontWeight.w600,
                  //                 color: CommonColors.black,
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),

                  const SizedBox(height: 16),

                  // Active session: preserve existing navigation
                  if (data.status == "Active")
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SessionChargingScreen(
                                args: SessionChargingArgs(
                                  sessionId: data.sessionId ?? "",
                                  status: data.status ?? "",
                                  cost: data.totalCost?.toString() ?? "0",
                                  unitConsumed:
                                      data.totalEnergyKwh?.toString() ?? "0",
                                  outputPower:
                                      data.totalEnergyKwh?.toString() ?? "0",
                                  batteryPercentage: "0",
                                  endMeterReading: "0",
                                  duration:
                                      data.durationMinutes?.toString() ?? "0",
                                  stationName: data.locationName ?? "",
                                  ConnectorGunID: data.connectorId ?? "",
                                ),
                              ),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: CommonColors.blue,
                          minimumSize: const Size(double.infinity, 42),
                          side: BorderSide(
                            color: CommonColors.blue.withOpacity(0.4),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          "View Session",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )
                  else
                    Row(
                      children: [
                        // View Receipt: same rounded button design + icon
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BookingDetailsScreen(
                                    recID: data.sessionId!,
                                    bookingType: "P",
                                  ),
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              backgroundColor: CommonColors.white,
                              foregroundColor: CommonColors.blue,
                              minimumSize: const Size(0, 42),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 8,
                              ),
                              side: BorderSide(
                                color: CommonColors.blue.withOpacity(0.2),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.receipt_long_outlined,
                                  size: 16,
                                ),
                                SizedBox(width: 6),
                                Flexible(
                                  child: Text(
                                    "View Receipt",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Keep your existing invoice action and rounded style
                        Expanded(
                          child: _invoiceButton(
                            sessionId: data.sessionId!,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        )
      : const SizedBox.shrink(),
),

     
      ],
    ),
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
String formatOnlyTimeIST(String? timeString) {
  if (timeString == null || timeString.trim().isEmpty) {
    return "";
  }

  try {
    final parsed = DateTime.parse(timeString);

    // API timestamp is UTC, so convert it to IST.
    final istTime = DateTime.utc(
      parsed.year,
      parsed.month,
      parsed.day,
      parsed.hour,
      parsed.minute,
      parsed.second,
      parsed.millisecond,
      parsed.microsecond,
    ).add(const Duration(hours: 5, minutes: 30));

    return DateFormat("hh:mm a").format(istTime);
  } catch (e) {
    return "";
  }
}
String? _expandedSessionId;
Widget _historyCard(ChargingSession data) {
  final String sessionId = data.recId ?? "";
  final bool isExpanded = _expandedSessionId == sessionId;

  return Container(
    margin: const EdgeInsets.only(bottom: 8),
    decoration: BoxDecoration(
      color: CommonColors.white,
      border: Border.all(color: CommonColors.neutral200),
      borderRadius: BorderRadius.circular(14),
    ),
    child: Column(
      children: [
        // Always-visible compact header
        InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {
            setState(() {
              _expandedSessionId =
                  isExpanded ? null : sessionId;
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            child: Row(
              children: [
                // Charging icon
                Container(
                  height: 38,
                  width: 38,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF0FF),
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(CommonImagePath.borderGreen,color: CommonColors.blue,),
                ),
                const SizedBox(width: 10),

                // Station name and date
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (data.chargingStationName ?? "Station")
                            .toUpperCase(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: CommonColors.black,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        "${formatTime("${data.createdOn}")} • "
                        "${data.energyTransmitted ?? 0} kW",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          color: CommonColors.neutral500,
                        ),
                      ),
                      Text(
                        "₹${data.chargingTotalFee ?? 0}",
                        style: const TextStyle(
                          fontSize: 11,
                          color: CommonColors.neutral500,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 6),

                // Status
                _statusChip(
                  data.status ?? "",
                  sessionId,
                ),

                const SizedBox(width: 4),

                // Expand/collapse arrow
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: CommonColors.neutral500,
                  size: 22,
                ),
              ],
            ),
          ),
        ),

        // Expanded details
        // Expanded details
AnimatedSize(
  duration: const Duration(milliseconds: 220),
  curve: Curves.easeInOut,
  child: isExpanded
      ? Column(
          children: [
            Divider(
              height: 1,
              color: CommonColors.neutral200,
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Energy, Duration and Fee
                  // Row(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     Expanded(
                  //       child: _historyInfo(
                  //         "Energy",
                  //         "${data.energyTransmitted ?? 0} kW",
                  //       ),
                  //     ),
                  //     Expanded(
                  //       child: _historyInfo(
                  //         "Duration",
                  //         formatDuration("${data.duration}"),
                  //       ),
                  //     ),
                  //     Expanded(
                  //       child: _historyInfo(
                  //         "Fee",
                  //         "₹${data.chargingTotalFee ?? 0}",
                  //       ),
                  //     ),
                  //   ],
                  // ),

                  const SizedBox(height: 12),

                  // Grey rounded information panel
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: CommonColors.neutral50,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _historyInfo(
                            "Duration",
                            formatDuration("${data.duration}"),
                          ),
                        ),
                        Expanded(
                          child: _historyInfo(
                            "Start Battery",
                            data.soCStart == null
                                ? "-"
                                : "${data.soCStart} %",
                          ),
                        ),
                        Expanded(
                          child: _historyInfo(
                            "End Battery",
                            data.soCEnd == null
                                ? "-"
                                : "${data.soCEnd} %",
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),
Row(
  children: [
     
      Text(
        ". Time ",
        style: const TextStyle(
          fontWeight: FontWeight.w400,
          color: CommonColors.neutral500,
          fontSize: 11,
        ),
      ),
    Text(
           data.startTime == null || data.endTime == null
                            ? "-"
                            : "${formatOnlyTimeIST(data.startTime!.toString())} - "
                                "${formatOnlyTimeIST(data.endTime!.toString())}",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: CommonColors.black,
            ),
          ),
  ],
),
                
                  const SizedBox(height: 12),

                  // Existing View Session action for active sessions
                  if (data.status == "Active")
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SessionChargingScreen(
                                args: SessionChargingArgs(
                                  sessionId: data.recId ?? "",
                                  status: data.status ?? "",
                                  cost: data.chargingTotalFee?.toString() ?? "0",
                                  unitConsumed:
                                      data.energyTransmitted?.toString() ?? "0",
                                  outputPower:
                                      data.chargingGun?.powerOutput == null ||
                                              data.chargingGun?.powerOutput ==
                                                  "null"
                                          ? "0"
                                          : data.chargingGun!.powerOutput
                                              .toString(),
                                  batteryPercentage:
                                      data.soCStart?.toString() ?? "0",
                                  endMeterReading:
                                      data.endMeterReading?.toString() ?? "0",
                                  duration: data.duration?.toString() ?? "0",
                                  stationName: data.chargingStationName ?? "",
                                  ConnectorGunID:
                                      data.chargingGun?.connectorId ?? "",
                                ),
                              ),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: CommonColors.blue,
                          minimumSize: const Size(double.infinity, 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: BorderSide(
                            color: CommonColors.blue.withOpacity(0.4),
                          ),
                        ),
                        child: const Text(
                          "View Session",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )
                  else
                    Row(
                      children: [
                        // View Receipt
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BookingDetailsScreen(
                                    recID: data.recId!,
                                    bookingType: "L",
                                  ),
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              backgroundColor: CommonColors.white,
                              foregroundColor: CommonColors.blue,
                              minimumSize: const Size(0, 40),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 8,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              side: BorderSide(
                                color: CommonColors.blue.withOpacity(0.2),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.receipt_long_outlined,
                                  size: 15,
                                ),
                                SizedBox(width: 6),
                                Flexible(
                                  child: Text(
                                    "View Receipt",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(width: 8),

                        Expanded(
                          child: _invoiceButton(
                            sessionId: data.recId!,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        )
      : const SizedBox.shrink(),
),
     
      ],
    ),
  );
}
Widget _historyInfo(String title, String value) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w400,
          color: CommonColors.neutral500,
          fontSize: 11,
        ),
      ),
      const SizedBox(height: 3),
      Text(
        value,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
          color: CommonColors.black,
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

// }

Widget _statusChip(String isActive, String recId) {
  final isCompleted =
      isActive.toLowerCase() == "completed";

  final statusColor = isCompleted
      ? const Color(0xFF16844A)
      : const Color(0xFFE5484D);

  return Container(
    padding: const EdgeInsets.symmetric(
      horizontal: 10,
      vertical: 5,
    ),
    decoration: BoxDecoration(
      color: isCompleted
          ? const Color(0xFFE8F7EE)
          : const Color(0xFFFFEEEE),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      isActive.toUpperCase(),
      style: TextStyle(
        fontSize: 9,
        letterSpacing: 0.2,
        fontWeight: FontWeight.w800,
        color: statusColor,
      ),
    ),
  );
}

  
}

class FilterTabsWidget extends StatefulWidget {
  const FilterTabsWidget({super.key});

  @override
  State<FilterTabsWidget> createState() =>
      _FilterTabsWidgetState();
}

class _FilterTabsWidgetState extends State<FilterTabsWidget> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    const labels = ["This month", "Last 7 Days", "All"];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(labels.length, (index) {
          final selected = selectedIndex == index;

          return Padding(
            padding: EdgeInsets.only(
              right: index == labels.length - 1 ? 0 : 8,
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(22),
              onTap: () {
                setState(() => selectedIndex = index);

                final provider =
                    context.read<ActiveSessionProvider>();

                if (index == 0) {
                  provider.setFilter(SessionFilter.thisMonth);
                } else if (index == 1) {
                  provider.setFilter(SessionFilter.last7Days);
                } else {
                  provider.setFilter(SessionFilter.all);
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0xFFEAF0FF)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: selected
                        ? const Color(0xFF193A8A)
                        : const Color(0xFFD9DFE9),
                  ),
                ),
                child: Text(
                  labels[index],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: selected
                        ? FontWeight.w600
                        : FontWeight.w500,
                    color: selected
                        ? const Color(0xFF193A8A)
                        : const Color(0xFF687386),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
