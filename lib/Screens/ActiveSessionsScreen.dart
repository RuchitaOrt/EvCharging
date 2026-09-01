import 'package:HyCharge/Provider/ActiveSessionProvider.dart';
import 'package:HyCharge/Provider/ChargingProvider.dart';
import 'package:HyCharge/Screens/ChargingHistoryScreen.dart';
import 'package:HyCharge/Screens/MainTab.dart';
import 'package:HyCharge/Screens/SessionChargingScreen.dart';
import 'package:HyCharge/Utils/CommonAppBar.dart';
import 'package:HyCharge/Utils/ShowDialog.dart';
import 'package:HyCharge/Utils/commoncolors.dart';
import 'package:HyCharge/main.dart';
import 'package:HyCharge/model/StartChargingSessionResponse.dart';
import 'package:HyCharge/model/UnifiedActiveSessionResponse.dart';
import 'package:HyCharge/widget/GlobalLists.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ActiveSessionsScreen extends StatefulWidget {
  final int selectedTabIndex;
  const ActiveSessionsScreen({super.key, required this.selectedTabIndex});

  @override
  State<ActiveSessionsScreen> createState() => _ActiveSessionsScreenState();
}

class _ActiveSessionsScreenState extends State<ActiveSessionsScreen>
    with SingleTickerProviderStateMixin {
  late final ScrollController _scrollController;

  late TabController _tabController;

   int? selectedTab;
  @override
  void initState() {
    super.initState();
  selectedTab=widget.selectedTabIndex;
     print("selectedTab ${selectedTab}");

    _scrollController = ScrollController()..addListener(_onScroll);

    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: selectedTab!,
    );

    // Initial API
    Future.microtask(() {
    
            if (selectedTab == 0) {
        context.read<ActiveSessionProvider>().fetchActiveSessions(
            context,
            "Active",
          );
      } else {
         context.read<ActiveSessionProvider>().fetchAUnifiedctiveSessions(
            context,
            "Active",
          );
      }
    });

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        return;
      }

      final provider = context.read<ActiveSessionProvider>();

      selectedTab = _tabController.index;

      if (selectedTab == 0) {
        provider.fetchActiveSessions(context, "Active");
      } else {
        provider.fetchAUnifiedctiveSessions(context, "Active");
      }

      setState(() {});
    });
  }

  void _onScroll() {
    final provider = context.read<ActiveSessionProvider>();

    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !provider.loadingMore &&
        provider.hasMore) {
      if (selectedTab == 0) {
        provider.loadMore(context, "Active");
      } else {
        provider.loadMoreUnifiedData(context, "Active");
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tabController.dispose();

    super.dispose();
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
        backgroundColor: CommonColors.neutral50,
        appBar: CommonAppBar(
          title: "Active Charging Session",
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
             // if (provider.loading) {
            //   return const Center(child: CircularProgressIndicator());
            // }

            // if (provider.sessions.isEmpty) {
            //   return const Center(child: Text("No active sessions"));
            // }
            return Column(
              children: [
                TabBar(
                   indicatorColor: CommonColors.blue,
                  controller: _tabController,
                  tabs:  [
                    Tab(child: Text("Charging Session",style: TextStyle(color:selectedTab == 0?CommonColors.blue:CommonColors.blacklight ),),),
                      Tab(child: Text("Partner Session",style: TextStyle(color: selectedTab == 1?CommonColors.blue:CommonColors.blacklight ),),)
                  ],
                ),
               
                Expanded(
                    child:
                     selectedTab == 0
                        ?ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.all(12),
                            itemCount: provider.sessions.length +
                                (provider.loadingMore && provider.hasMore
                                    ? 1
                                    : 0),
                            itemBuilder: (context, index) {
                              if (index == provider.sessions.length) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }

                              final session = provider.sessions[index];

                              return _activeSessionCard(session);
                            },
                          )
                        : 
                         ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.all(12),
                            itemCount: provider.partnerSessions.length,
                            itemBuilder: (context, index) {
                              final session = provider.partnerSessions[index];

                              return _partnerSessionCard(session);
                            },
                          ))
              ],
            );
            // return ListView.builder(
            //   controller: _scrollController,
            //   padding: const EdgeInsets.all(12),
            //   itemCount: provider.sessions.length +
            //       (provider.loadingMore && provider.hasMore ? 1 : 0),
            //   itemBuilder: (context, index) {
            //     if (index == provider.sessions.length) {
            //       return const Padding(
            //         padding: EdgeInsets.all(16),
            //         child: Center(child: CircularProgressIndicator()),
            //       );
            //     }

            //     final session = provider.sessions[index];
            //     return _activeSessionCard(session);
            //   },
            // );
          },
        ),
      ),
    );
  }


  Widget _activeSessionCard(ChargingSession session) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SessionChargingScreen(
                args: SessionChargingArgs(
                    sessionId: session?.recId ?? "",
                    status: session?.status ?? "",
                    cost: session?.chargingTotalFee?.toString() ?? "0",
                    unitConsumed: session?.energyTransmitted?.toString() ?? "0",
                    outputPower: (session?.chargingGun?.powerOutput == null ||
                            session?.chargingGun?.powerOutput == "null")
                        ? "0"
                        : session!.chargingGun!.powerOutput.toString(),
                    batteryPercentage: session?.soCStart?.toString() ?? "0",
                    endMeterReading:
                        session?.endMeterReading?.toString() ?? "0",
                    duration: session?.duration?.toString() ?? "0",
                    stationName: session.chargingStationName ?? "",
                    ConnectorGunID: session.chargingGunId ?? "",
                    isActive: true),
              ),
            ),
          );
        },
        child: Card(
          color: CommonColors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 🔹 Header
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.green.shade400,
                              Colors.green.shade600,
                            ],
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.ev_station,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              session.chargingStationName!.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              session.chargingHubName!,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),

                      /// Status pill
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          session.status!,
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                /// 🔹 Info row
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _infoChip(
                        Icons.power,
                        "Connector",
                        "${session.connectorName}",
                      ),
                    ),
                    Expanded(
                      child: _infoChip(
                        Icons.timer,
                        "Duration",
                        session.duration!.split('.').first,
                      ),
                    ),
                    Expanded(
                      child: _infoChip(
                        Icons.power,
                        "Energy",
                        "${session.energyTransmitted}",
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () async {
                      bool? result = await stopSessionDialog(context);
                      if (result == true) {
                        final providerEndSession =
                            context.read<ChargingProvider>();
                        //                   // print("Charging session ID ${data!.session!.recId!}");
                        final response =
                            await providerEndSession.endUnifiedSession(
                                context: context,
                                sessionId: session.recId!, // 🔑 station id
                                endMeterReading:
                                    session.endMeterReading!.toString());

                        if (response!.success!) {
                          Navigator.push(
                            routeGlobalKey.currentContext!,
                            MaterialPageRoute(
                                builder: (context) => ChargingHistoryScreen()),
                          );
                          final provider =
                              context.read<ActiveSessionProvider>();

                          await provider.fetchActiveSessions(context, "Active");
                        }
                      } else {
                        // ❌ User clicked NO or closed dialog
                        print("User cancelled");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CommonColors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 6),
                    ),
                    child: Text(
                      "Stop Charging",
                      style: const TextStyle(color: CommonColors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _partnerSessionCard(Session session) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SessionChargingScreen(
                args: SessionChargingArgs(
                    sessionId: session?.sessionId ?? "",
                    status: session?.status ?? "",
                    cost: session?.totalCost?.toString() ?? "0",
                    unitConsumed: session?.totalEnergyKwh?.toString() ?? "0",
                    outputPower: (session?.totalEnergyKwh == null ||
                            session.totalEnergyKwh == "null")
                        ? "0"
                        : session!.totalEnergyKwh.toString(),
                    batteryPercentage: "0",
                    endMeterReading:
                         "0",
                    duration: session?.durationMinutes?.toString() ?? "0",
                    stationName: session.locationName ?? "",
                    ConnectorGunID: session.connectorId ?? "",
                    isActive: true),
              ),
            ),
          );
        },
        child: Card(
          color: CommonColors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 🔹 Header
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.green.shade400,
                              Colors.green.shade600,
                            ],
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.ev_station,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              session.locationName!.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              session.locationCity!,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),

                      /// Status pill
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          session.status!,
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                /// 🔹 Info row
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _infoChip(
                        Icons.power,
                        "Connector",
                        "${session.ocpiLocationId}",
                      ),
                    ),
                    Expanded(
                      child: _infoChip(
                        Icons.timer,
                        "Duration",
                        session.durationMinutes!.toString().split('.').first,
                      ),
                    ),
                    Expanded(
                      child: _infoChip(
                        Icons.power,
                        "Energy",
                        "${session.totalEnergyKwh}",
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () async {
                      bool? result = await stopSessionDialog(context);
                      if (result == true) {
                        final providerEndSession =
                            context.read<ChargingProvider>();
                        //                   // print("Charging session ID ${data!.session!.recId!}");
                        final response =
                            await providerEndSession.endUnifiedSession(
                                context: context,
                                sessionId: "P:${session.sessionId!}", // 🔑 station id
                                endMeterReading:"0");
                                    // session.endMeterReading!.toString());

                        if (response!.success!) {
                          Navigator.push(
                            routeGlobalKey.currentContext!,
                            MaterialPageRoute(
                                builder: (context) => ChargingHistoryScreen()),
                          );
                          final provider =
                              context.read<ActiveSessionProvider>();

                          await provider.fetchActiveSessions(context, "Active");
                        }
                      } else {
                        // ❌ User clicked NO or closed dialog
                        print("User cancelled");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CommonColors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 6),
                    ),
                    child: Text(
                      "Stop Charging",
                      style: const TextStyle(color: CommonColors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _infoChip(IconData icon, String maintext, String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          maintext,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          text,
          maxLines: 2, // 👈 IMPORTANT
          overflow: TextOverflow.ellipsis, // 👈 prevents overflow
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade800,
          ),
        ),
      ],
    );
  }
}
