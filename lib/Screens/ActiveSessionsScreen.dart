import 'package:ev_charging_app/Provider/ActiveSessionProvider.dart';
import 'package:ev_charging_app/Provider/ChargingProvider.dart';
import 'package:ev_charging_app/Utils/CommonAppBar.dart';
import 'package:ev_charging_app/Utils/commoncolors.dart';
import 'package:ev_charging_app/model/ActiveSessionResponse.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ActiveSessionsScreen extends StatefulWidget {
  const ActiveSessionsScreen({super.key});

  @override
  State<ActiveSessionsScreen> createState() => _ActiveSessionsScreenState();
}

class _ActiveSessionsScreenState extends State<ActiveSessionsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<ActiveSessionProvider>().fetchActiveSessions(context,"Active");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CommonColors.white,
      appBar: CommonAppBar(
        title: "Charging Session",
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
            padding: const EdgeInsets.all(12),
            itemCount: provider.sessions.length,
            itemBuilder: (context, index) {
              final session = provider.sessions[index];
              return _activeSessionCard(session);
            },
          );
        },
      ),
    );
  }

Widget _activeSessionCard(Session session) {
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
    child: Card(
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
            Row(
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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

            const SizedBox(height: 14),

            /// 🔹 Info row
            Row(
              children: [
                _infoChip(
                  Icons.power,
                  "Connector ${session.chargingGunId}",
                ),
                const SizedBox(width: 10),
                if (session.duration != null)
                  _infoChip(
                    Icons.timer,
                    session.duration!,
                  ),
              ],
            ),

            const SizedBox(height: 16),

            /// 🔹 Stop button
            SizedBox(
              width: double.infinity,
              height: 40,
              child: ElevatedButton(
                onPressed: () async {
                   final providerEndSession = context.read<ChargingProvider>();
//                   // print("Charging session ID ${data!.session!.recId!}");
                  final response = await providerEndSession.endSession(
                      context: context,
                      sessionId:session.recId, // 🔑 station id
                      endMeterReading: session.endMeterReading!);


                  if (response!.success!) {
                    final provider = context.read<ActiveSessionProvider>();
                    
                   await provider.fetchActiveSessions(context,"Active");
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
  );
}
Widget _infoChip(IconData icon, String text) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey.shade700),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade800,
          ),
        ),
      ],
    ),
  );
}

}
