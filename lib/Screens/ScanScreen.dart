import 'package:ev_charging_app/Screens/MainTab.dart';
import 'package:ev_charging_app/Screens/PaymentSuccessScreen.dart';
import 'package:ev_charging_app/Utils/CommonAppBar.dart';
import 'package:ev_charging_app/Utils/commoncolors.dart';
import 'package:ev_charging_app/Utils/commonimages.dart';
import 'package:ev_charging_app/Utils/sizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
   @override
  void initState() {
    super.initState();

    // Navigate to onboarding screen after 3 seconds
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PaymentSuccessScreen()),
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return WillPopScope(
     onWillPop: () async {
      // Navigate to MainTab instead of popping
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainTab()),
      );
      return false; // prevent default pop
    },
      child: Scaffold(
        backgroundColor: CommonColors.black,
      appBar: AppBar(
        title:  Padding(
                padding:  EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Scan",
                      overflow: TextOverflow.ellipsis,
                      style:  
                      GoogleFonts.poppins(
                  fontWeight: FontWeight.w600, // ExtraBold
                  color: CommonColors.white,
                  fontSize: 20,
                )
                
                      
                    ),
                  
                  ],
                ),
              ),
        backgroundColor: CommonColors.black,leading:  IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: CommonColors.white),
                onPressed:  () {
                  Navigator.pop(context);
                }
                
              ),),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
          
            Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                // QR container
                // Container(
                //   width: w * 0.7,
                //   height: w * 0.7,
                //   decoration: BoxDecoration(
                //     color: Colors.black,
                //     borderRadius: BorderRadius.circular(12),
                //     border: Border.all(color: Colors.white24),
                //   ),
                //   child: Stack(children: [
                //     // QR placeholder (image or widget)
                //     Center(
                //       child: Image.asset(CommonImagePath.qr, width: w * 0.45, height: w * 0.45, fit: BoxFit.contain),
                //     ),
                //     // green scan line
                //     Positioned(
                //       left: 0,
                //       right: 0,
                //       top: (w * 0.7) / 2 - 6,
                //       child: Container(
                //         height: 12,
                //         margin: const EdgeInsets.symmetric(horizontal: 12),
                //         decoration: BoxDecoration(
                //             gradient: LinearGradient(colors: [Colors.greenAccent, Colors.green.shade700]),
                //             borderRadius: BorderRadius.circular(6)),
                //       ),
                //     ),
                //   ]),
                // ),
                QrScannerBox(),
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
                  onPressed: () => Navigator.pushNamed(context, '/select'),
                  style: TextButton.styleFrom(
                    backgroundColor: CommonColors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Mock: Proceed (Select Vehicle)', style: TextStyle(color: Colors.white)),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

/// ------------------------
/// 2) Payment Success Screen
/// ------------------------
/// 
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

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
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
          // QR Image
          Center(
            child: Image.asset(
              CommonImagePath.qr,
              width: w * 0.45,
              height: w * 0.45,
              fit: BoxFit.contain,
            ),
          ),

          // Moving Scan Line
          AnimatedBuilder(
            animation: _animation,
            builder: (_, child) {
              double topPos = (_animation.value * (w * 0.7 - 12));
              return Positioned(
                left: 0,
                right: 0,
                top: topPos,
                child: child!,
              );
            },
            child: Container(
              height: 12,
              margin: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.greenAccent, Colors.green.shade700],
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
