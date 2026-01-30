// import 'package:ev_charging_app/Screens/MainTab.dart';
// import 'package:ev_charging_app/Utils/commoncolors.dart';
// import 'package:ev_charging_app/Utils/commonimages.dart';
// import 'package:ev_charging_app/Utils/sizeConfig.dart';
// import 'package:ev_charging_app/widget/GlobalLists.dart';
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
//       "title": "Power Up, Stress-Free",
//       "subtitle":
//           "Find, navigate, and pay—all in one \napp. Start your journey.",
//     },
//     {
//       "image": CommonImagePath.onboard2,
//       "title": "See Real-Time Availability",
//       "subtitle":
//           "View real-time maps with \nconnector types, speed, and pricing.",
//     },
//     {
//       "image": CommonImagePath.onboard3,
//       "title": "Navigate & Pay in a Tap",
//       "subtitle":
//           "Get directions and start charging \nwith secure, tap-to-pay.",
//     },
//     {
//       "image": CommonImagePath.onboard4,
//       "title": "Ready to Go Electric?",
//       "subtitle": "Set up your profile for personalized \nstation recommendations.",
//     },
//   ];

//   void nextPage() {
//     if (currentIndex < onboardingData.length - 1) {
//       _controller.nextPage(
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.ease,
//       );
//     } else {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) =>  MainTab(isLoggedIn: GlobalLists.islLogin,)),
//       );
//     }
//   }

//   double get progress => (currentIndex + 1) / onboardingData.length;
// @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//             FocusManager.instance.primaryFocus?.unfocus();
//           });
      
     
    
//   }
//   @override
//   Widget build(BuildContext context) {
//     // Initialize SizeConfig for this device
//     SizeConfig().init(context);

//     return Scaffold(
//       backgroundColor: CommonColors.neutral50,
      
//       body: Column(
//         children: [
//           Expanded(
//             child: PageView.builder(
//               controller: _controller,
//               itemCount: onboardingData.length,
//               onPageChanged: (index) => setState(() => currentIndex = index),
//               itemBuilder: (context, index) {
//                 return Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(height: SizeConfig.safeBlockVertical * 8), // responsive
//                     Padding(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: SizeConfig.safeBlockHorizontal * 5,
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             onboardingData[index]["title"],
//                             style: TextStyle(
//                               fontSize: SizeConfig.safeBlockHorizontal * 6, // responsive
//                               fontWeight: FontWeight.bold,
//                               color: CommonColors.blue,
//                             ),
//                           ),
//                           SizedBox(height: SizeConfig.safeBlockVertical * 1.5),
//                           Text(
//                             onboardingData[index]["subtitle"],
//                             style: TextStyle(
//                               fontSize: SizeConfig.safeBlockHorizontal * 4.5, // responsive
//                               color: CommonColors.blue.withOpacity(0.8),
//                             ),
//                           ),
//                           SizedBox(height: SizeConfig.safeBlockVertical * 2),
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: SizeConfig.safeBlockVertical * 2),
//                     SvgPicture.asset(
//                       onboardingData[index]["image"],
//                       height: SizeConfig.safeBlockVertical * 57, // responsive image height
//                       width: double.infinity,
//                       fit: BoxFit.contain,
//                     ),
//                   ],
//                 );
//               },
//             ),
//           ),
//           SizedBox(height: SizeConfig.safeBlockVertical * 2),
//           Padding(
//             padding: EdgeInsets.symmetric(
//               horizontal: SizeConfig.safeBlockHorizontal * 5,
//             ),
//             child: Column(
//               children: [
//                 CustomDotIndicator(
//                   currentIndex: currentIndex,
//                   count: onboardingData.length,
//                 ),
//                 SizedBox(height: SizeConfig.safeBlockVertical * 0.1),
//                 Row(
//                   children: [
//                     GestureDetector(
//                       onTap: () 
//                       {
// Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) =>  MainTab(isLoggedIn: GlobalLists.islLogin)),
//       );
//                       },
//                       // => _controller.jumpToPage(onboardingData.length - 1),
//                       child: Text(
//                         "Skip",
//                         style: TextStyle(
//                           fontSize: SizeConfig.safeBlockHorizontal * 4,
//                           color: CommonColors.blue,
//                         ),
//                       ),
//                     ),
//                     Spacer(),
//                     Stack(
//                       alignment: Alignment.center,
//                       children: [
//                         SizedBox(
//                           width: SizeConfig.safeBlockHorizontal * 14,
//                           height: SizeConfig.safeBlockHorizontal * 14,
//                           child: TweenAnimationBuilder(
//                             tween: Tween<double>(begin: 0, end: progress),
//                             duration: const Duration(milliseconds: 400),
//                             builder: (context, value, child) {
//                               return CircularProgressIndicator(
//                                 value: value,
//                                 strokeWidth: SizeConfig.safeBlockHorizontal * 1,
//                                 color: CommonColors.blue,
//                                 backgroundColor: Colors.grey.shade300,
//                               );
//                             },
//                           ),
//                         ),
//                         ElevatedButton(
//                           onPressed: nextPage,
//                           style: ElevatedButton.styleFrom(
//                             shape: const CircleBorder(),
//                             padding: EdgeInsets.all(SizeConfig.safeBlockHorizontal * 3),
//                             backgroundColor: CommonColors.blue,
//                             elevation: 0,
//                           ),
//                           child: Icon(
//                             // currentIndex == onboardingData.length - 1
//                             //     ? Icons.check
//                             //     :
//                                  Icons.arrow_forward_ios_outlined,
//                             color: Colors.white,
//                             size: SizeConfig.safeBlockHorizontal * 6,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: SizeConfig.safeBlockVertical * 3),
//         ],
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
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: List.generate(
//         count,
//         (index) {
//           bool isActive = index == currentIndex;
//           return AnimatedContainer(
//             duration: const Duration(milliseconds: 250),
//             margin: EdgeInsets.symmetric(horizontal: SizeConfig.safeBlockHorizontal * 1),
//             width: isActive ? SizeConfig.safeBlockHorizontal * 4.5 : SizeConfig.safeBlockHorizontal * 2,
//             height: SizeConfig.safeBlockVertical * 1,
//             decoration: BoxDecoration(
//               color: isActive
//                   ? CommonColors.blue
//                   : CommonColors.blue.withOpacity(0.4),
//               borderRadius: BorderRadius.circular(SizeConfig.safeBlockHorizontal),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:ev_charging_app/Screens/MainTab.dart';
import 'package:ev_charging_app/Utils/commoncolors.dart';
import 'package:ev_charging_app/Utils/commonimages.dart';
import 'package:ev_charging_app/Utils/sizeConfig.dart';
import 'package:ev_charging_app/widget/GlobalLists.dart';
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
      "image": CommonImagePath.onboard1,
      "title": "Power Up, Stress-Free",
      "subtitle": "Find, navigate, and pay—all in one \napp. Start your journey.",
    },
    {
      "image": CommonImagePath.onboard2,
      "title": "See Real-Time Availability",
      "subtitle": "View real-time maps with \nconnector types, speed, and pricing.",
    },
    {
      "image": CommonImagePath.onboard3,
      "title": "Navigate & Pay in a Tap",
      "subtitle": "Get directions and start charging \nwith secure, tap-to-pay.",
    },
    {
      "image": CommonImagePath.onboard4,
      "title": "Ready to Go Electric?",
      "subtitle": "Set up your profile for personalized \nstation recommendations.",
    },
  ];

  double get progress => (currentIndex + 1) / onboardingData.length;

  void nextPage() {
    if (currentIndex < onboardingData.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => MainTab(isLoggedIn: GlobalLists.islLogin),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusManager.instance.primaryFocus?.unfocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: CommonColors.neutral50,
      body: SafeArea(
        child: Column(
          children: [
            /// -------------------- PAGES --------------------
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: onboardingData.length,
                onPageChanged: (index) =>
                    setState(() => currentIndex = index),
                itemBuilder: (context, index) {
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: SizeConfig.safeBlockVertical * 6),

                        /// ----------- TITLE + SUBTITLE -----------
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal:
                                SizeConfig.safeBlockHorizontal * 5,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                onboardingData[index]["title"],
                                style: TextStyle(
                                  fontSize:
                                      SizeConfig.safeBlockHorizontal * 6,
                                  fontWeight: FontWeight.bold,
                                  color: CommonColors.blue,
                                ),
                              ),
                              SizedBox(
                                  height:
                                      SizeConfig.safeBlockVertical * 1.5),
                              Text(
                                onboardingData[index]["subtitle"],
                                style: TextStyle(
                                  fontSize:
                                      SizeConfig.safeBlockHorizontal * 4.2,
                                  color: CommonColors.blue.withOpacity(0.8),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: SizeConfig.safeBlockVertical * 3),

                        /// ----------- IMAGE (RESPONSIVE) -----------
                     SizedBox(
  width: double.infinity,
  height: screenHeight * 0.45,
  child: FittedBox(
    fit: BoxFit.cover, // 🚀 forces edge-to-edge
    child: SvgPicture.asset(
      onboardingData[index]["image"],
    ),
  ),
),



                      ],
                    ),
                  );
                },
              ),
            ),

            /// -------------------- FOOTER --------------------
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.safeBlockHorizontal * 5,
                vertical: SizeConfig.safeBlockVertical * 2,
              ),
              child: Column(
                children: [
                  CustomDotIndicator(
                    currentIndex: currentIndex,
                    count: onboardingData.length,
                  ),
                  SizedBox(height: SizeConfig.safeBlockVertical * 1.5),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  MainTab(isLoggedIn: GlobalLists.islLogin),
                            ),
                          );
                        },
                        child: Text(
                          "Skip",
                          style: TextStyle(
                            fontSize:
                                SizeConfig.safeBlockHorizontal * 4,
                            color: CommonColors.blue,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width:
                                SizeConfig.safeBlockHorizontal * 14,
                            height:
                                SizeConfig.safeBlockHorizontal * 14,
                            child: TweenAnimationBuilder(
                              tween:
                                  Tween<double>(begin: 0, end: progress),
                              duration:
                                  const Duration(milliseconds: 400),
                              builder: (context, value, child) {
                                return CircularProgressIndicator(
                                  value: value,
                                  strokeWidth:
                                      SizeConfig.safeBlockHorizontal * 1,
                                  color: CommonColors.blue,
                                  backgroundColor:
                                      Colors.grey.shade300,
                                );
                              },
                            ),
                          ),
                          ElevatedButton(
                            onPressed: nextPage,
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              padding: EdgeInsets.all(
                                  SizeConfig.safeBlockHorizontal * 3),
                              backgroundColor: CommonColors.blue,
                              elevation: 0,
                            ),
                            child: Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: Colors.white,
                              size:
                                  SizeConfig.safeBlockHorizontal * 6,
                            ),
                          ),
                        ],
                      ),
                    ],
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
      children: List.generate(
        count,
        (index) {
          final isActive = index == currentIndex;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            margin: EdgeInsets.symmetric(
                horizontal: SizeConfig.safeBlockHorizontal * 1),
            width: isActive
                ? SizeConfig.safeBlockHorizontal * 4.5
                : SizeConfig.safeBlockHorizontal * 2,
            height: SizeConfig.safeBlockVertical * 1,
            decoration: BoxDecoration(
              color: isActive
                  ? CommonColors.blue
                  : CommonColors.blue.withOpacity(0.4),
              borderRadius:
                  BorderRadius.circular(SizeConfig.safeBlockHorizontal),
            ),
          );
        },
      ),
    );
  }
}
