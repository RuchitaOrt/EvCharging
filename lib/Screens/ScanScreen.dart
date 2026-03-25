import 'dart:io';

import 'package:HyCharge/Screens/ChargingEstimateScreen.dart';
import 'package:HyCharge/main.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:HyCharge/Utils/ShowDialog.dart'; // for showToast

class ScanScreen extends StatefulWidget {
  const ScanScreen({Key? key}) : super(key: key);

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final MobileScannerController controller = MobileScannerController();
  bool isScanned = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> handleScan(String code) async {
    debugPrint("Scanned: $code");
    showToast(code);

    // 🔥 UPI Payment QR
    if (code.startsWith("upi://")) {
      final upiData = code;

      // Convert generic UPI URL to app-specific schemes
      final gpayAppUrl = upiData.replaceFirst('upi://', 'gpay://');
      final phonePeAppUrl = upiData.replaceFirst('upi://', 'phonepe://');
      final paytmAppUrl = upiData.replaceFirst('upi://', 'paytmmp://');

      try {
        if (await canLaunchUrl(Uri.parse(gpayAppUrl))) {
          await launchUrl(Uri.parse(gpayAppUrl), mode: LaunchMode.externalApplication);
        } else if (await canLaunchUrl(Uri.parse(phonePeAppUrl))) {
          await launchUrl(Uri.parse(phonePeAppUrl), mode: LaunchMode.externalApplication);
        } else if (await canLaunchUrl(Uri.parse(paytmAppUrl))) {
          await launchUrl(Uri.parse(paytmAppUrl), mode: LaunchMode.externalApplication);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("No UPI app found. Install Google Pay, PhonePe, or Paytm."),
            ),
          );
        }
      } catch (e) {
        debugPrint("Error launching UPI: $e");
      }
    }

    // 🌐 Normal Link
    else if ((code.startsWith("http://") || code.startsWith("https://")) && Platform.isAndroid) {
      final uri = Uri.parse(code);
      try {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } catch (e) {
        debugPrint("Error launching URL: $e");
      }
    }
else if (code.startsWith("http://") || code.startsWith("https://")) {
  final uri = Uri.parse(code);

  debugPrint("Handling deep link internally: $uri");

  if (uri.pathSegments.length >= 2 && uri.pathSegments[0] == "c") {
    final chargerId = uri.pathSegments[1];

    Navigator.pop(context); // close scanner

    // 🔥 Navigate directly
    routeGlobalKey.currentState?.push(
      MaterialPageRoute(
        builder: (_) => ChargingEstimateScreen(
          chargerID: chargerId,
          isAPPLINK: "1",
        ),
      ),
    );
  } else {
    // fallback → open browser
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
    // 🚗 Station ID or Plain Text
    else {
      Navigator.pop(context, code);
    }

    // Reset scanner after short delay so user can scan again
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          isScanned = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan Charger QR"),
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on),
            onPressed: () => controller.toggleTorch(),
          ),
        ],
      ),
      body: 
      MobileScanner(
        controller: controller,
        // allowDuplicates: false,
        onDetect: (capture) async {
          if (isScanned) return;

          final barcodes = capture.barcodes;

          for (final barcode in barcodes) {
            final String? code = barcode.rawValue;
            if (code != null) {
              isScanned = true;
               controller.stop(); 
              await handleScan(code);
              break;
            }
          }
        },
      ),
    );
  }
}

