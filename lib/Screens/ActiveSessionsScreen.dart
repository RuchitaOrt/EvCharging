import 'package:ev_charging_app/Provider/ActiveSessionProvider.dart';
import 'package:ev_charging_app/Provider/ChargingProvider.dart';
import 'package:ev_charging_app/Screens/SessionChargingScreen.dart';
import 'package:ev_charging_app/Utils/CommonAppBar.dart';
import 'package:ev_charging_app/Utils/commoncolors.dart';
import 'package:ev_charging_app/main.dart';
import 'package:ev_charging_app/model/ActiveSessionResponse.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ActiveSessionsScreen extends StatefulWidget {
  const ActiveSessionsScreen({super.key});

  @override
  State<ActiveSessionsScreen> createState() => _ActiveSessionsScreenState();
}

class _ActiveSessionsScreenState extends State<ActiveSessionsScreen> {
   late final ScrollController _scrollController;
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
        _scrollController = ScrollController()
      ..addListener(() {
        final provider = context.read<ActiveSessionProvider>();

        if (_scrollController.position.pixels >=
                _scrollController.position.maxScrollExtent - 200 &&
            !provider.loadingMore &&
            provider.hasMore) {
          provider.loadMore(context, "Active"); // 🔥 IMPORTANT
        }
      });

      context
          .read<ActiveSessionProvider>()
          .fetchActiveSessions(context, "Active");
    });
  }
 @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CommonColors.neutral50,
      appBar: CommonAppBar(
        title: "Active Charging Session",
      ),
      body: Consumer<ActiveSessionProvider>(
        builder: (context, provider, _) {
          if (provider.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.sessions.isEmpty) {
            return const Center(child: Text("No active sessions"));
          }

          return ListView.builder(
            controller: _scrollController, 
            padding: const EdgeInsets.all(12),
            itemCount: provider.sessions.length +
      (provider.loadingMore && provider.hasMore ? 1 : 0),
            itemBuilder: (context, index) {
               if (index == provider.sessions.length) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator()),
      );
    }

              final session = provider.sessions[index];
              return _activeSessionCard(session);
            },
          );
        },
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
                  sessionId: session.recId,
                  status: session!.status ?? "",
                  cost: session!.chargingTotalFee ?? "0",
                  unitConsumed: session!.chargingSpeed ?? "0",
                  outputPower: session!.energyTransmitted ?? "0",
                  batteryPercentage: session.soCStart.toString() ?? "0",
                  endMeterReading: session.endMeterReading ?? "0",
                ),
              ),
            ),
          );

          // Navigator.push(
          //                   routeGlobalKey.currentContext!,
          //                   MaterialPageRoute(
          //                     builder: (_) => SessionChargingScreen(
          //                       intitalResponse: response,
          //                     ),
          //                   ),
          //                 );
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
                              session.chargingStationName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              session.chargingHubName,
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
                          session.status,
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
                        "${session.duration}",
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

                const SizedBox(height: 16),
                //   Row(
                //     mainAxisAlignment: MainAxisAlignment.start,
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     _infoChip(
                //       Icons.power,
                //       "Charging Speed",
                //       "${session.chargingSpeed}",
                //     ),
                //     const SizedBox(width: 10),
                //     _infoChip(
                //       Icons.power,
                //       "Energy",
                //       "${session.energyTransmitted}",
                //     ),
                //   ],
                // ),

                /// 🔹 Stop button
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () async {
                      final providerEndSession =
                          context.read<ChargingProvider>();
                      //                   // print("Charging session ID ${data!.session!.recId!}");
                      final response = await providerEndSession.endSession(
                          context: context,
                          sessionId: session.recId, // 🔑 station id
                          endMeterReading: session.endMeterReading!);

                      if (response!.success!) {
                        final provider = context.read<ActiveSessionProvider>();

                        await provider.fetchActiveSessions(context, "Active");
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
