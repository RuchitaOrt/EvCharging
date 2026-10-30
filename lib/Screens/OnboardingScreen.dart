
// // import 'package:HyCharge/Screens/MainTab.dart';
// // import 'package:HyCharge/Utils/AuthStorage.dart';
// // import 'package:HyCharge/Utils/commoncolors.dart';
// // import 'package:HyCharge/Utils/commonimages.dart';
// // import 'package:HyCharge/Utils/sizeConfig.dart';
// // import 'package:HyCharge/widget/GlobalLists.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_svg/flutter_svg.dart';

// // class OnboardingScreen extends StatefulWidget {
// //   static const String route = "/onboarding_screen";

// //   const OnboardingScreen({super.key});

// //   @override
// //   State<OnboardingScreen> createState() => _OnboardingScreenState();
// // }

// // class _OnboardingScreenState extends State<OnboardingScreen> {
// //   final PageController _controller = PageController();
// //   int currentIndex = 0;

// //   final List<Map<String, dynamic>> onboardingData = [
// //     {
// //       "image": CommonImagePath.onboard1,
// //       "title": "Power Up, Stress-Free",
// //       "subtitle": "Find, navigate, and pay—all in one \napp. Start your journey.",
// //     },
// //     {
// //       "image": CommonImagePath.onboard2,
// //       "title": "See Real-Time Availability",
// //       "subtitle": "View real-time maps with \nconnector types, speed, and pricing.",
// //     },
// //     {
// //       "image": CommonImagePath.onboard3,
// //       "title": "Navigate & Pay in a Tap",
// //       "subtitle": "Get directions and start charging \nwith secure, tap-to-pay.",
// //     },
// //     {
// //       "image": CommonImagePath.onboard4,
// //       "title": "Ready to Go Electric?",
// //       "subtitle": "Set up your profile for personalized \nstation recommendations.",
// //     },
// //   ];

// //   double get progress => (currentIndex + 1) / onboardingData.length;

// //   Future<void> nextPage() async {
// //     if (currentIndex < onboardingData.length - 1) {
// //       _controller.nextPage(
// //         duration: const Duration(milliseconds: 300),
// //         curve: Curves.ease,
// //       );
// //     } else {
// //            await AuthStorage.setFirstTimeDone();
// //       Navigator.pushReplacement(
// //         context,
// //         MaterialPageRoute(
// //           builder: (_) => MainTab(isLoggedIn: GlobalLists.islLogin),
// //         ),
// //       );
// //     }
// //   }

// //   @override
// //   void initState() {
// //     super.initState();
// //     WidgetsBinding.instance.addPostFrameCallback((_) {
// //       FocusManager.instance.primaryFocus?.unfocus();
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     SizeConfig().init(context);
// //     final screenHeight = MediaQuery.of(context).size.height;

// //     return Scaffold(
// //       backgroundColor: CommonColors.neutral50,
// //       body: SafeArea(
// //         child: Column(
// //           children: [
// //             /// -------------------- PAGES --------------------
// //             Expanded(
// //               child: PageView.builder(
// //                 controller: _controller,
// //                 itemCount: onboardingData.length,
// //                 onPageChanged: (index) =>
// //                     setState(() => currentIndex = index),
// //                 itemBuilder: (context, index) {
// //                   return SingleChildScrollView(
// //                     physics: const BouncingScrollPhysics(),
// //                     child: Column(
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       children: [
// //                         SizedBox(height: SizeConfig.safeBlockVertical * 6),

// //                         /// ----------- TITLE + SUBTITLE -----------
// //                         Padding(
// //                           padding: EdgeInsets.symmetric(
// //                             horizontal:
// //                                 SizeConfig.safeBlockHorizontal * 5,
// //                           ),
// //                           child: Column(
// //                             crossAxisAlignment: CrossAxisAlignment.start,
// //                             children: [
// //                               Text(
// //                                 onboardingData[index]["title"],
// //                                 style: TextStyle(
// //                                   fontSize:
// //                                       SizeConfig.safeBlockHorizontal * 6,
// //                                   fontWeight: FontWeight.bold,
// //                                   color: CommonColors.blue,
// //                                 ),
// //                               ),
// //                               SizedBox(
// //                                   height:
// //                                       SizeConfig.safeBlockVertical * 1.5),
// //                               Text(
// //                                 onboardingData[index]["subtitle"],
// //                                 style: TextStyle(
// //                                   fontSize:
// //                                       SizeConfig.safeBlockHorizontal * 4.2,
// //                                   color: CommonColors.blue.withOpacity(0.8),
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                         ),

// //                         SizedBox(height: SizeConfig.safeBlockVertical * 4),

// //                         /// ----------- IMAGE (RESPONSIVE) -----------
// //                      SizedBox(
// //   width: double.infinity,
// //   height: screenHeight * 0.45,
// //   child: FittedBox(
// //     fit: BoxFit.cover, // 🚀 forces edge-to-edge
// //     child: SvgPicture.asset(
// //       onboardingData[index]["image"],
// //     ),
// //   ),
// // ),



// //                       ],
// //                     ),
// //                   );
// //                 },
// //               ),
// //             ),

// //             /// -------------------- FOOTER --------------------
// //             Padding(
// //               padding: EdgeInsets.symmetric(
// //                 horizontal: SizeConfig.safeBlockHorizontal * 5,
// //                 vertical: SizeConfig.safeBlockVertical * 2,
// //               ),
// //               child: Column(
// //                 children: [
// //                   CustomDotIndicator(
// //                     currentIndex: currentIndex,
// //                     count: onboardingData.length,
// //                   ),
// //                   SizedBox(height: SizeConfig.safeBlockVertical * 1.5),
// //                   Row(
// //                     children: [
// //                       GestureDetector(
// //                         onTap: () async {
// //                           await AuthStorage.setFirstTimeDone();
// //                           Navigator.pushReplacement(
// //                             context,
// //                             MaterialPageRoute(
// //                               builder: (_) =>
// //                                   MainTab(isLoggedIn: GlobalLists.islLogin),
// //                             ),
// //                           );
// //                         },
// //                         child: Text(
// //                           "Skip",
// //                           style: TextStyle(
// //                             fontSize:
// //                                 SizeConfig.safeBlockHorizontal * 4,
// //                             color: CommonColors.blue,
// //                           ),
// //                         ),
// //                       ),
// //                       const Spacer(),
// //                       Stack(
// //                         alignment: Alignment.center,
// //                         children: [
// //                           SizedBox(
// //                             width:
// //                                 SizeConfig.safeBlockHorizontal * 14,
// //                             height:
// //                                 SizeConfig.safeBlockHorizontal * 14,
// //                             child: TweenAnimationBuilder(
// //                               tween:
// //                                   Tween<double>(begin: 0, end: progress),
// //                               duration:
// //                                   const Duration(milliseconds: 400),
// //                               builder: (context, value, child) {
// //                                 return CircularProgressIndicator(
// //                                   value: value,
// //                                   strokeWidth:
// //                                       SizeConfig.safeBlockHorizontal * 1,
// //                                   color: CommonColors.blue,
// //                                   backgroundColor:
// //                                       Colors.grey.shade300,
// //                                 );
// //                               },
// //                             ),
// //                           ),
// //                           ElevatedButton(
// //                             onPressed: nextPage,
// //                             style: ElevatedButton.styleFrom(
// //                               shape: const CircleBorder(),
// //                               padding: EdgeInsets.all(
// //                                   SizeConfig.safeBlockHorizontal * 3),
// //                               backgroundColor: CommonColors.blue,
// //                               elevation: 0,
// //                             ),
// //                             child: Icon(
// //                               Icons.arrow_forward_ios_outlined,
// //                               color: Colors.white,
// //                               size:
// //                                   SizeConfig.safeBlockHorizontal * 6,
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     ],
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class CustomDotIndicator extends StatelessWidget {
// //   final int currentIndex;
// //   final int count;

// //   const CustomDotIndicator({
// //     super.key,
// //     required this.currentIndex,
// //     required this.count,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     return Row(
// //       children: List.generate(
// //         count,
// //         (index) {
// //           final isActive = index == currentIndex;
// //           return AnimatedContainer(
// //             duration: const Duration(milliseconds: 250),
// //             margin: EdgeInsets.symmetric(
// //                 horizontal: SizeConfig.safeBlockHorizontal * 1),
// //             width: isActive
// //                 ? SizeConfig.safeBlockHorizontal * 4.5
// //                 : SizeConfig.safeBlockHorizontal * 2,
// //             height: SizeConfig.safeBlockVertical * 1,
// //             decoration: BoxDecoration(
// //               color: isActive
// //                   ? CommonColors.blue
// //                   : CommonColors.blue.withOpacity(0.4),
// //               borderRadius:
// //                   BorderRadius.circular(SizeConfig.safeBlockHorizontal),
// //             ),
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }

// import 'package:HyCharge/Screens/MainTab.dart';
// import 'package:HyCharge/Utils/AuthStorage.dart';
// import 'package:HyCharge/Utils/commoncolors.dart';
// import 'package:HyCharge/Utils/commonimages.dart';
// import 'package:HyCharge/Utils/sizeConfig.dart';
// import 'package:HyCharge/widget/GlobalLists.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';

// class OnboardingScreen extends StatefulWidget {
//   static const String route = "/onboarding_screen";

//   const OnboardingScreen({super.key});

//   @override
//   State<OnboardingScreen> createState() => _OnboardingScreenState();
// }

// class _OnboardingScreenState extends State<OnboardingScreen> {
//   final PageController _controller = PageController();
//   int currentIndex = 0;

//   final List<Map<String, dynamic>> onboardingData = [
//     {
//       "image": CommonImagePath.onboard1,
//       "title": "Find chargers near you",
//       "subtitle":
//           "See HyCharge and partner stations on the map with live availability.",
//     },
//     {
//       "image": CommonImagePath.onboard2,
//       "title": "Plug in and pay from your wallet",
//       "subtitle":
//           "Choose amount, units or time and start charging in a few taps.",
//     },
//     {
//       "image": CommonImagePath.onboard3,
//       "title": "Track every session",
//       "subtitle":
//           "Energy, cost and receipts for every charge, all in one place.",
//     },
//     // {
//     //   "image": CommonImagePath.onboard4,
//     //   "title": "Ready to Go Electric?",
//     //   "subtitle":
//     //       "Set up your profile for personalized station recommendations.",
//     // },
//   ];

//   double get progress =>
//       (currentIndex + 1) / onboardingData.length;

//   Future<void> nextPage() async {
//     if (currentIndex < onboardingData.length - 1) {
//       _controller.nextPage(
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeInOut,
//       );
//     } else {
//       await AuthStorage.setFirstTimeDone();

//       if (!mounted) return;

//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (_) =>
//               MainTab(isLoggedIn: GlobalLists.islLogin),
//         ),
//       );
//     }
//   }

//   Future<void> skipOnboarding() async {
//     await AuthStorage.setFirstTimeDone();

//     if (!mounted) return;

//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//         builder: (_) =>
//             MainTab(isLoggedIn: GlobalLists.islLogin),
//       ),
//     );
//   }

//   @override
//   void initState() {
//     super.initState();

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       FocusManager.instance.primaryFocus?.unfocus();
//     });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     SizeConfig().init(context);

//     final size = MediaQuery.of(context).size;
//     final horizontalPadding =
//         SizeConfig.safeBlockHorizontal * 6;

//     return Scaffold(
//       backgroundColor: CommonColors.background,
//       body: SafeArea(
//         child: Column(
//           children: [
//             // Pages
//             Expanded(
//               child: PageView.builder(
//                 controller: _controller,
//                 itemCount: onboardingData.length,
//                 onPageChanged: (index) {
//                   setState(() => currentIndex = index);
//                 },
//                 itemBuilder: (context, index) {
//                   final item = onboardingData[index];

//                   return Padding(
//                     padding: EdgeInsets.symmetric(
//                       horizontal: horizontalPadding,
//                     ),
//                     child: Column(
//                       children: [
//                         SizedBox(
//                           height:
//                               SizeConfig.safeBlockVertical * 3,
//                         ),

//                         // Skip action
//                         Align(
//                           alignment: Alignment.centerRight,
//                           child: TextButton(
//                             onPressed: skipOnboarding,
//                             style: TextButton.styleFrom(
//                               foregroundColor:
//                                   CommonColors.onSurfaceVariant,
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 12,
//                                 vertical: 8,
//                               ),
//                               minimumSize: Size.zero,
//                               tapTargetSize:
//                                   MaterialTapTargetSize.shrinkWrap,
//                             ),
//                             child: const Text(
//                               'Skip',
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           ),
//                         ),

//                         SizedBox(
//                           height:
//                               SizeConfig.safeBlockVertical * 2,
//                         ),

//                         // Illustration
//                         Expanded(
//                           flex: 6,
//                           child: Center(
//                             child: Container(
//                               width: size.width * 0.64,
//                               constraints: BoxConstraints(
//                                 maxWidth: 300,
//                                 maxHeight: size.height * 0.38,
//                               ),
//                               decoration: BoxDecoration(
//                                 color:
//                                     CommonColors.secondaryContainer,
//                                 borderRadius:
//                                     BorderRadius.circular(36),
//                               ),
//                               padding: const EdgeInsets.all(18),
//                               child: SvgPicture.asset(
//                                 item['image'] as String,
//                                 fit: BoxFit.contain,
//                               ),
//                             ),
//                           ),
//                         ),

//                         SizedBox(
//                           height:
//                               SizeConfig.safeBlockVertical * 2.5,
//                         ),

//                         // Title and description
//                         Expanded(
//                           flex: 3,
//                           child: Align(
//                             alignment: Alignment.topCenter,
//                             child: Column(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Text(
//                                   item['title'] as String,
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                     fontSize:
//                                         SizeConfig.safeBlockHorizontal *
//                                             6,
//                                     height: 1.2,
//                                     fontWeight: FontWeight.w800,
//                                     color: CommonColors.onSurface,
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   height:
//                                       SizeConfig.safeBlockVertical *
//                                           1.5,
//                                 ),
//                                 Text(
//                                   item['subtitle'] as String,
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                     fontSize:
//                                         SizeConfig.safeBlockHorizontal *
//                                             4,
//                                     height: 1.5,
//                                     color: CommonColors
//                                         .onSurfaceVariant,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),

//             // Footer
//             Padding(
//               padding: EdgeInsets.fromLTRB(
//                 horizontalPadding,
//                 12,
//                 horizontalPadding,
//                 SizeConfig.safeBlockVertical * 2.5,
//               ),
//               child: Column(
//                 children: [
//                   CustomDotIndicator(
//                     currentIndex: currentIndex,
//                     count: onboardingData.length,
//                   ),

//                   SizedBox(
//                     height: SizeConfig.safeBlockVertical * 3,
//                   ),

//                   SizedBox(
//                     width: double.infinity,
//                     height: 58,
//                     child: ElevatedButton(
//                       onPressed: nextPage,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: CommonColors.primary,
//                         foregroundColor: CommonColors.onPrimary,
//                         elevation: 0,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                       ),
//                       child: Text(
//                         currentIndex == onboardingData.length - 1
//                             ? 'Get Started'
//                             : 'Next',
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class CustomDotIndicator extends StatelessWidget {
//   final int currentIndex;
//   final int count;

//   const CustomDotIndicator({
//     super.key,
//     required this.currentIndex,
//     required this.count,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: List.generate(count, (index) {
//         final isActive = index == currentIndex;

//         return AnimatedContainer(
//           duration: const Duration(milliseconds: 250),
//           curve: Curves.easeInOut,
//           margin: const EdgeInsets.symmetric(horizontal: 4),
//           width: isActive ? 24 : 8,
//           height: 8,
//           decoration: BoxDecoration(
//             color: isActive
//                 ? CommonColors.primary
//                 : CommonColors.outline,
//             borderRadius: BorderRadius.circular(20),
//           ),
//         );
//       }),
//     );
//   }
// }

import 'package:HyCharge/Screens/LocationPermission.dart';
import 'package:HyCharge/Screens/MainTab.dart';
import 'package:HyCharge/Utils/AuthStorage.dart';
import 'package:HyCharge/Utils/commoncolors.dart';
import 'package:HyCharge/Utils/commonimages.dart';
import 'package:HyCharge/Utils/sizeConfig.dart';
import 'package:HyCharge/widget/GlobalLists.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardingScreen extends StatefulWidget {
  static const String route = "/onboarding_screen";

  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int currentIndex = 0;

  final List<Map<String, dynamic>> onboardingData = [
    {
      "image": CommonImagePath.location,
      "title": "Find chargers near you",
      "subtitle":
          "See HyCharge and partner stations on the map with live availability.",
    },
    {
      "image": CommonImagePath.chargerwhite,
      "title": "Plug in and pay from your wallet",
      "subtitle":
          "Choose amount, units or time and start charging in a few taps.",
    },
    {
      "image": CommonImagePath.track,
      "title": "Track every session",
      "subtitle":
          "Energy, cost and receipts for every charge, all in one place.",
    },
  ];

  double get progress =>
      (currentIndex + 1) / onboardingData.length;

  Future<void> nextPage() async {
    if (currentIndex < onboardingData.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      await AuthStorage.setFirstTimeDone();

      if (!mounted) return;
 Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const LocationPermissionScreen(),
      ),
    );
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //     builder: (_) =>
      //         MainTab(isLoggedIn: GlobalLists.islLogin),
      //   ),
      // );
    }
  }

  Future<void> skipOnboarding() async {
    await AuthStorage.setFirstTimeDone();

    if (!mounted) return;
 Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const LocationPermissionScreen(),
      ),
    );
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(
    //     builder: (_) =>
    //         MainTab(isLoggedIn: GlobalLists.islLogin),
    //   ),
    // );
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusManager.instance.primaryFocus?.unfocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    final horizontalPadding =
        SizeConfig.safeBlockHorizontal * 6;

    return Scaffold(
      backgroundColor: CommonColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Onboarding pages
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: onboardingData.length,
                onPageChanged: (index) {
                  setState(() => currentIndex = index);
                },
                itemBuilder: (context, index) {
                  final item = onboardingData[index];

                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height:
                              SizeConfig.safeBlockVertical * 2,
                        ),

                        // Skip
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: skipOnboarding,
                            style: TextButton.styleFrom(
                              foregroundColor:
                                  CommonColors.onSurfaceVariant,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              minimumSize: Size.zero,
                              tapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text(
                              'Skip',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        // Illustration area
                        Expanded(
                          flex: 6,
                          child: Center(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: OnboardingIllustration(
                                iconAsset: item['image'] as String,
                              ),
                            ),
                          ),
                        ),

                        // Title and subtitle
                        Expanded(
                          flex: 3,
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 2,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    item['title'] as String,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize:
                                          SizeConfig.safeBlockHorizontal *
                                              5.8,
                                      height: 1.2,
                                      fontWeight: FontWeight.w800,
                                      color: CommonColors.onSurface,
                                    ),
                                  ),
                                  SizedBox(
                                    height:
                                        SizeConfig.safeBlockVertical *
                                            1.3,
                                  ),
                                  Text(
                                    item['subtitle'] as String,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize:
                                          SizeConfig.safeBlockHorizontal *
                                              3.9,
                                      height: 1.45,
                                      fontWeight: FontWeight.w400,
                                      color:
                                          CommonColors.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Bottom controls
            Padding(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                8,
                horizontalPadding,
                SizeConfig.safeBlockVertical * 2.5,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Three-page indicator
                  CustomDotIndicator(
                    currentIndex: currentIndex,
                    count: onboardingData.length,
                  ),

                  SizedBox(
                    height: SizeConfig.safeBlockVertical * 3,
                  ),

                  // Full-width Next button
                  SizedBox(
                    width: double.infinity,
                    height: 58,
                    child: ElevatedButton(
                      onPressed: nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CommonColors.primary,
                        foregroundColor: CommonColors.onPrimary,
                        elevation: 0,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        currentIndex == onboardingData.length - 1
                            ? 'Get Started'
                            : 'Next',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Illustration matching the reference screenshots
class OnboardingIllustration extends StatelessWidget {
  final String iconAsset;

  const OnboardingIllustration({
    super.key,
    required this.iconAsset,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 270,
      height: 270,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Light-blue rounded panel
          Container(
            width: 226,
            height: 226,
            decoration: BoxDecoration(
              color: CommonColors.secondaryContainer,
              borderRadius: BorderRadius.circular(36),
            ),
          ),

          // Navy square containing the main icon
          Container(
            width: 98,
            height: 98,
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: CommonColors.primary,
              borderRadius: BorderRadius.circular(27),
            ),
            child: SvgPicture.asset(
              iconAsset,
              fit: BoxFit.contain,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
          ),

          // White circular charging badge
          Positioned(
            top: 45,
            right: 6,
            child: Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: CommonColors.surface,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: SvgPicture.asset(
                CommonImagePath.chargingGreen,
                width: 23,
                height: 23,
                fit: BoxFit.contain,
              ),
            ),
          ),

          // Floating charging price
          Positioned(
            left: 12,
            bottom: 48,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 13,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: CommonColors.surface,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Text(
                '₹16/kW',
                style: TextStyle(
                  color: CommonColors.onSurface,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Page indicators
class CustomDotIndicator extends StatelessWidget {
  final int currentIndex;
  final int count;

  const CustomDotIndicator({
    super.key,
    required this.currentIndex,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == currentIndex;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: isActive ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive
                ? CommonColors.primary
                : CommonColors.outline,
            borderRadius: BorderRadius.circular(20),
          ),
        );
      }),
    );
  }
}
