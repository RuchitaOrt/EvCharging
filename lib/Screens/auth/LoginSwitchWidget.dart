import 'package:flutter/material.dart';

class LoginSwitchWidget extends StatefulWidget {
  const LoginSwitchWidget({super.key});

  @override
  State<LoginSwitchWidget> createState() => _LoginSwitchWidgetState();
}

class _LoginSwitchWidgetState extends State<LoginSwitchWidget> {
  bool isMobileSelected = true;

  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // drag handle
          Center(
            child: Container(
              height: 4,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),

          const SizedBox(height: 16),

          const Text(
            "Login",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

          // 🔁 Toggle
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                _buildToggleButton("Mobile", true),
                _buildToggleButton("Email", false),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // 📱 Mobile field
          if (isMobileSelected)
            TextField(
              controller: mobileController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: "Mobile Number",
                hintText: "Enter mobile number",
                border: OutlineInputBorder(),
              ),
            ),

          // 📧 Email field
          if (!isMobileSelected)
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: "Email Address",
                hintText: "Enter email",
                border: OutlineInputBorder(),
              ),
            ),

          const SizedBox(height: 24),

          // 🔘 Action Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {},
              child: Text(
                isMobileSelected ? "Send OTP" : "Continue",
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),

          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildToggleButton(String title, bool isMobile) {
    final bool isSelected = isMobileSelected == isMobile;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            isMobileSelected = isMobile;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
