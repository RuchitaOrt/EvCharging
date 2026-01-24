import 'package:flutter/material.dart';

class VerifyOtpBottomSheet extends StatelessWidget {
  const VerifyOtpBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: const Center(
        child: Text("OTP Verification"),
      ),
    );
  }
}
