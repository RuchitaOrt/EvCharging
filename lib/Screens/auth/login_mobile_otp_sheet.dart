import 'package:flutter/material.dart';
import 'package:HyCharge/Utils/commoncolors.dart';
import 'package:HyCharge/Utils/ShowDialog.dart';

class MobileOtpSheetWidget extends StatefulWidget {
  const MobileOtpSheetWidget({super.key});

  @override
  State<MobileOtpSheetWidget> createState() => _MobileOtpSheetWidgetState();
}

class _MobileOtpSheetWidgetState extends State<MobileOtpSheetWidget> {
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  bool otpSent = false;
  bool isLoading = false;

  void _sendOtp() async {
    if (_mobileController.text.length != 10) {
      showToast("Enter valid mobile number");
      return;
    }

    setState(() => otpSent = true);
    showToast("OTP sent");
  }

  void _verifyOtp() async {
    if (_otpController.text.length != 6) {
      showToast("Enter valid OTP");
      return;
    }

    // TODO: API integration later
    showToast("OTP verified");

    Navigator.pop(context); // close OTP sheet
    Navigator.pop(context); // close login sheet

    // Navigate to home
    // Navigator.pushReplacement(context,
    //   MaterialPageRoute(builder: (_) => MainTab(isLoggedIn: true)));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              otpSent ? "Enter OTP" : "Login with Mobile",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            if (!otpSent)
              TextField(
                controller: _mobileController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  hintText: "Mobile Number",
                ),
              ),

            if (otpSent)
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: const InputDecoration(
                  hintText: "OTP",
                  counterText: "",
                ),
              ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: CommonColors.blue,
                ),
                onPressed: otpSent ? _verifyOtp : _sendOtp,
                child: Text(otpSent ? "Verify OTP" : "Send OTP"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
