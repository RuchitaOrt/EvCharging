import 'package:HyCharge/Screens/MainTab.dart';
import 'package:HyCharge/Utils/commoncolors.dart';
import 'package:HyCharge/Utils/commonimages.dart';
import 'package:HyCharge/Utils/sizeConfig.dart';
import 'package:HyCharge/widget/GlobalLists.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  MainTab(isLoggedIn: GlobalLists.islLogin)),
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: CommonColors.black,
        appBar: AppBar(
          title: Padding(
            padding: EdgeInsets.only(
                left: SizeConfig.blockSizeHorizontal * 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Scan",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: CommonColors.white,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          backgroundColor: CommonColors.black,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios,
                color: CommonColors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),

        ///  Responsive Body
        body: kIsWeb
            ? _webScanLayout(context)
            : _mobileScanLayout(context),
      ),
    );
  }

  /// ================= MOBILE () =================
  Widget _mobileScanLayout(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const QrScannerBox(),
              const SizedBox(height: 18),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 36.0),
                child: Text(
                  'Scan QR Code of the charger\n\nScan to continue. After scanning, you’ll be able to select your car model and plug type to begin charging.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () =>
                    Navigator.pushNamed(context, '/select'),
                style: TextButton.styleFrom(
                  backgroundColor: CommonColors.primary,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text(
                  'Mock: Proceed (Select Vehicle)',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// ================= WEB  LAYOUT =================
  Widget _webScanLayout(BuildContext context) {
    return Center(
      child: Container(
        width: 460,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white24),
          boxShadow: const [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 20,
              offset: Offset(0, 8),
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Scan Charger QR",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 24),

            const SizedBox(
              width: 260,
              height: 260,
              child: QrScannerBox(),
            ),

            const SizedBox(height: 24),

            const Text(
              "Scan the QR code printed on the charger to begin charging your vehicle.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70),
            ),

            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () =>
                    Navigator.pushNamed(context, '/select'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: CommonColors.primary,
                  padding:
                      const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  "Proceed",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ================= QR BOX  =================
class QrScannerBox extends StatefulWidget {
  const QrScannerBox({super.key});

  @override
  State<QrScannerBox> createState() => _QrScannerBoxState();
}

class _QrScannerBoxState extends State<QrScannerBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _animation =
        Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
          parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Container(
      width: w * 0.7,
      height: w * 0.7,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
      ),
      child: Stack(
        children: [
          Center(
            child: Image.asset(
              CommonImagePath.qr,
              width: w * 0.45,
              height: w * 0.45,
              fit: BoxFit.contain,
            ),
          ),
          AnimatedBuilder(
            animation: _animation,
            builder: (_, child) {
              double topPos =
                  (_animation.value * (w * 0.7 - 12));
              return Positioned(
                left: 0,
                right: 0,
                top: topPos,
                child: child!,
              );
            },
            child: Container(
              height: 12,
              margin:
                  const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.greenAccent,
                    Colors.green.shade700
                  ],
                ),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
