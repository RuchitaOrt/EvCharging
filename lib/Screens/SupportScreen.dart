import 'package:ev_charging_app/Screens/FAQScreen.dart';
import 'package:ev_charging_app/Screens/ReportScreen.dart';
import 'package:ev_charging_app/Utils/CommonAppBar.dart';
import 'package:ev_charging_app/Utils/commoncolors.dart';
import 'package:ev_charging_app/Utils/commonimages.dart';
import 'package:ev_charging_app/main.dart';
import 'package:flutter/material.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CommonColors.neutral50,
      appBar:
      CommonAppBar(title: "Support",),
      
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Center(
              child: Column(
                children:  [
                 Image.asset(CommonImagePath.help),
                  SizedBox(height: 10),
                  Text("Need the help ?",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: CommonColors.blue)),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Container(
                  margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
                color: CommonColors.white,
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              child: Column(
                children: [
                  _supportTile(CommonImagePath.mail, "support@evcharge.in", () {}),
                   _supportTile(CommonImagePath.call, "1800-675-4628", () {}),
              _supportTile(CommonImagePath.chatting, "Contact Live Chat", () {}),
              _supportTile(
CommonImagePath.alert,
                "Report an issue",
                () {
                  Navigator.push(
                    routeGlobalKey.currentContext!,
                    MaterialPageRoute(builder: (context) => ReportIssueScreen()),
                  );
                },
              ),
              _supportTile(
               CommonImagePath.faq,
                "FAQs",
                () {
                  Navigator.push(
                    routeGlobalKey.currentContext!,
                    MaterialPageRoute(builder: (context) => FAQScreen()),
                  );
                },
              ),
                ],
              ),
            ),
           
          ],
        ),
      ),
    );
  }

  Widget _supportTile(String icon, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: CommonColors.neutral50,
        ),
        child: Row(
          children: [
           Image.asset(icon),
            const SizedBox(width: 16),
            Expanded(
                child: Text(
              title,
              style: TextStyle(
                  color: CommonColors.blue, fontWeight: FontWeight.w400),
            ))
          ],
        ),
      ),
    );
  }
}
