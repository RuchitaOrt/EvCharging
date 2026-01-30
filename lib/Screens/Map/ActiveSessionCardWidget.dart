import 'package:ev_charging_app/Provider/ActiveSessionProvider.dart';
import 'package:ev_charging_app/Utils/commoncolors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ActiveSessionCardWidget extends StatelessWidget {
  const ActiveSessionCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ActiveSessionProvider>(
      builder: (_, provider, __) {
        if (provider.loading || provider.sessions.isEmpty) {
          return const SizedBox();
        }

        return Container(
          height: 90,
          width: 80,
          decoration: BoxDecoration(
            color: CommonColors.blue,
            borderRadius: BorderRadius.circular(14),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.ev_station,
                  color: CommonColors.white,
                  size: 26,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Active\nSession',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  color: CommonColors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
