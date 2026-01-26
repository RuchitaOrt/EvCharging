import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationPermissionManager {
  static final LocationPermissionManager instance =
  LocationPermissionManager._internal();

  LocationPermissionManager._internal();

  bool _dialogVisible = false;

  /// Call this method before using location
  Future<bool> ensureLocationReady(BuildContext context) async {
    // Permission check
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        _showPermissionDialog(context);
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showPermissionDialog(context, openSettings: true);
      return false;
    }

    // GPS service check
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showGpsDialog(context);
      return false;
    }

    return true;
  }

  void _showPermissionDialog(
      BuildContext context, {
        bool openSettings = false,
      }) {
    if (_dialogVisible) return;
    _dialogVisible = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: const Text('Location Permission Required'),
            content: const Text(
              'Location permission is required for driver tracking.',
            ),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  _dialogVisible = false;

                  if (openSettings) {
                    await Geolocator.openAppSettings();
                  } else {
                    await Geolocator.requestPermission();
                  }
                },
                child: const Text('ENABLE'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showGpsDialog(BuildContext context) {
    if (_dialogVisible) return;
    _dialogVisible = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: const Text('Location Services Off'),
            content: const Text(
              'Please enable GPS to continue driver tracking.',
            ),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  _dialogVisible = false;
                  await Geolocator.openLocationSettings();
                },
                child: const Text('TURN ON GPS'),
              ),
            ],
          ),
        );
      },
    );
  }
}
