import 'package:HyCharge/Screens/FAQScreen.dart';
import 'package:HyCharge/Screens/ReportScreen.dart';
import 'package:HyCharge/Utils/CommonAppBar.dart';
import 'package:HyCharge/Utils/commoncolors.dart';
import 'package:HyCharge/Utils/commonimages.dart';
import 'package:HyCharge/Utils/googleMap.dart';
import 'package:HyCharge/main.dart';
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
                  Text("Need help ?",
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
                  _supportTile(CommonImagePath.mail, "inquiry@hycharge.in", () {}),
                   _supportTile(CommonImagePath.call, "8655471696", () {}),
              // _supportTile(CommonImagePath.chatting, "Contact Live Chat", () {}),
              _supportTile(
CommonImagePath.alert,
                "Report an issue",
                () {
                   openContactPage();
                  // Navigator.push(
                  //   routeGlobalKey.currentContext!,
                  //   MaterialPageRoute(builder: (context) => ReportIssueScreen()),
                  // );
                },
              ),
              _supportTile(
               CommonImagePath.faq,
                "FAQs",
                () {
                //  https://hycharge.in/contact-us
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
