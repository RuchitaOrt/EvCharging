
import 'package:HyCharge/Screens/MainTab.dart';
import 'package:HyCharge/widget/GlobalLists.dart';
import 'package:flutter/material.dart';


// Replace these imports with the actual login screen in your project.

import 'package:HyCharge/Utils/commoncolors.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationPermissionScreen extends StatefulWidget {
  static const String route = '/location_permission';

  const LocationPermissionScreen({super.key});

  @override
  State<LocationPermissionScreen> createState() =>
      _LocationPermissionScreenState();
}

class _LocationPermissionScreenState
    extends State<LocationPermissionScreen> {
  bool _isRequesting = false;

  void _goToLogin() {
    if (!mounted) return;

   Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
              MainTab(isLoggedIn: GlobalLists.islLogin),
        ),
      );
  }

  Future<void> _allowLocation() async {
    if (_isRequesting) return;

    setState(() => _isRequesting = true);

    try {
      // Request foreground location permission.
      await Permission.locationWhenInUse.request();
    } finally {
      if (mounted) {
        setState(() => _isRequesting = false);
        _goToLogin();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CommonColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(flex: 3),

              Container(
                width: 82,
                height: 82,
                decoration: BoxDecoration(
                  color: CommonColors.secondaryContainer,
                  borderRadius: BorderRadius.circular(26),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.my_location_rounded,
                  size: 38,
                  color: CommonColors.primary,
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'Find chargers near you',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: CommonColors.onSurface,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Allow location so we can show nearby '
                'stations and distances.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: CommonColors.onSurfaceVariant,
                ),
              ),

              const Spacer(flex: 4),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isRequesting ? null : _allowLocation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CommonColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: _isRequesting
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Allow location',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 8),

              TextButton(
                onPressed: _goToLogin,
                child: const Text(
                  'Not now',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: CommonColors.onSurfaceVariant,
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
