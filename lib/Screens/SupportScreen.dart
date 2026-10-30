// import 'package:HyCharge/Screens/FAQScreen.dart';
// import 'package:HyCharge/Screens/ReportScreen.dart';
// import 'package:HyCharge/Utils/CommonAppBar.dart';
// import 'package:HyCharge/Utils/commoncolors.dart';
// import 'package:HyCharge/Utils/commonimages.dart';
// import 'package:HyCharge/Utils/googleMap.dart';
// import 'package:HyCharge/main.dart';
// import 'package:flutter/material.dart';

// class SupportScreen extends StatelessWidget {
//   const SupportScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: CommonColors.neutral50,
//       appBar:
//       CommonAppBar(title: "Support",),
      
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 20),
//             Center(
//               child: Column(
//                 children:  [
//                  Image.asset(CommonImagePath.help),
//                   SizedBox(height: 10),
//                   Text("Need help ?",
//                       style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: CommonColors.blue)),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 30),
//             Container(
//                   margin: const EdgeInsets.only(bottom: 12),
//     padding: const EdgeInsets.all(8),
//     decoration: BoxDecoration(
//                 color: CommonColors.white,
//                 borderRadius: BorderRadius.all(Radius.circular(12)),
//               ),
//               child: Column(
//                 children: [
//                   _supportTile(CommonImagePath.mail, "inquiry@hycharge.in", () {}),
//                    _supportTile(CommonImagePath.call, "8655471696", () {}),
//               // _supportTile(CommonImagePath.chatting, "Contact Live Chat", () {}),
//               _supportTile(
// CommonImagePath.alert,
//                 "Report an issue",
//                 () {
//                    openContactPage();
//                   // Navigator.push(
//                   //   routeGlobalKey.currentContext!,
//                   //   MaterialPageRoute(builder: (context) => ReportIssueScreen()),
//                   // );
//                 },
//               ),
//               _supportTile(
//                CommonImagePath.faq,
//                 "FAQs",
//                 () {
//                 //  https://hycharge.in/contact-us
//                   Navigator.push(
//                     routeGlobalKey.currentContext!,
//                     MaterialPageRoute(builder: (context) => FAQScreen()),
//                   );
//                 },
//               ),
//                 ],
//               ),
//             ),
           
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _supportTile(String icon, String title, VoidCallback onTap) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         margin: const EdgeInsets.only(bottom: 12),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(12),
//           color: CommonColors.neutral50,
//         ),
//         child: Row(
//           children: [
//            Image.asset(icon),
//             const SizedBox(width: 16),
//             Expanded(
//                 child: Text(
//               title,
//               style: TextStyle(
//                   color: CommonColors.blue, fontWeight: FontWeight.w400),
//             ))
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:HyCharge/Screens/FAQScreen.dart';
import 'package:HyCharge/Screens/ReportScreen.dart';
import 'package:HyCharge/Utils/CommonAppBar.dart';
import 'package:HyCharge/Utils/commoncolors.dart';
import 'package:HyCharge/Utils/commonimages.dart';
import 'package:HyCharge/Utils/googleMap.dart';
import 'package:HyCharge/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CommonColors.neutral50,
      appBar: CommonAppBar(title: "Support"),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Help icon and heading
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8EEFC),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: SvgPicture.asset(
                        CommonImagePath.headphones,
                        width: 54,
                        height: 54,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      "Need help?",
                      style: TextStyle(
                          fontFamily: 'Poppins',
                        fontSize: 21,
                        fontWeight: FontWeight.w800,
                        color: CommonColors.black,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 26),

              // Support options card
              Container(
                decoration: BoxDecoration(
                  color: CommonColors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.045),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _supportTile(
                      CommonImagePath.mailBlue,
                      "inquiry@hycharge.in",
                      () {},
                      showDivider: true,
                    ),
                    _supportTile(
                      CommonImagePath.callwhite,
                      "8655471696",
                      () {},
                      showDivider: true,
                    ),
                    _supportTile(
                      CommonImagePath.alertBlue,
                      "Report an issue",
                      () {
                        openContactPage();
                      },
                      showDivider: true,
                    ),
                    _supportTile(
                      CommonImagePath.faqBlue,
                      "FAQs",
                      () {
                        Navigator.push(
                          routeGlobalKey.currentContext!,
                          MaterialPageRoute(
                            builder: (context) => FAQScreen(),
                          ),
                        );
                      },
                      showDivider: false,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _supportTile(
    String icon,
    String title,
    VoidCallback onTap, {
    required bool showDivider,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              child: Row(
                children: [
                  // Circular icon background
                  Container(
                    width: 36,
                    height: 36,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE8EEFC),
                      shape: BoxShape.circle,
                    ),
                    child: SvgPicture.asset(
                      icon,
                      width: 16,
                      color: CommonColors.blue,
                      height: 16,
                      fit: BoxFit.contain,
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Support title
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                        color: CommonColors.black,
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  Icon(
                    Icons.chevron_right_rounded,
                    size: 23,
                    color: CommonColors.blue.withOpacity(0.65),
                  ),
                ],
              ),
            ),

            if (showDivider)
              const Padding(
                padding: EdgeInsets.only(left: 16),
                child: Divider(
                  height: 1,
                  thickness: 0.8,
                  color: Color(0xFFE2E7F0),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
