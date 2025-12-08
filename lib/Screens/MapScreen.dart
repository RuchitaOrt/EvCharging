import 'package:ev_charging_app/Screens/MainTab.dart';
import 'package:ev_charging_app/Screens/RegistrationScreen.dart';
import 'package:ev_charging_app/Utils/CommonStyles.dart';
import 'package:ev_charging_app/Utils/commoncolors.dart';
import 'package:ev_charging_app/Utils/commonimages.dart';
import 'package:ev_charging_app/Utils/commonstrings.dart';
import 'package:ev_charging_app/Utils/regex_helper.dart';
import 'package:ev_charging_app/Utils/sizeConfig.dart';
import 'package:ev_charging_app/main.dart';
import 'package:ev_charging_app/widget/GlobalLists.dart';
import 'package:ev_charging_app/widget/custom_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;

  final LatLng center = const LatLng(17.4444, 78.3772);

  Set<Marker> markers = {
    Marker(
      markerId: MarkerId("station1"),
      position: LatLng(17.4444, 78.3772),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    ),
    Marker(
      markerId: MarkerId("station2"),
      position: LatLng(17.4500, 78.3800),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
    )
  };
  TextEditingController phoneNameController = TextEditingController();

  bool _rememberMe = false;

  void toggleRememberMe(bool? value) {
    setState(() {
      _rememberMe = value ?? false;
    });
  }

  @override
  void initState() {
    super.initState();
    if (!GlobalLists.islLogin) {
      Future.delayed(Duration(milliseconds: 300), () {
        showLoginSheet(context);
      });
    }
  }

  void showLoginSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true, // ★ NEW
      backgroundColor: Colors.transparent,
      builder: (context) {
        bool _localRememberMe = _rememberMe;

        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom, // ★ NEW
              ),
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(CommonImagePath.lock),
                    SizedBox(height: 12),
                    Center(
                      child: Text(CommonStrings.strLogin,
                          style: CommonStyles.tsblackHeading),
                    ),
                    SizedBox(height: 20),

                    // TextField
                    CustomTextFieldWidget(
                      isMandatory: false,
                      title: "",
                      hintText: CommonStrings.strPhoneNumber,
                      onChange: (val) {},
                      textEditingController: phoneNameController,
                      // maxCharacterLength: 10,
                       inputFormatters: [
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(10),
  ],
                      textInputType: const TextInputType.numberWithOptions(
                        signed: false,
                        decimal: false,
                      ),
                    ),

                    // Checkbox
                    Row(
                      children: [
                        Checkbox(
                          value: _localRememberMe,
                          onChanged: (value) {
                            setModalState(() {
                              _localRememberMe = value ?? false;
                              _rememberMe = _localRememberMe;
                            });
                          },
                        ),
                        Expanded(
                          child: Text(
                            "I agree to the terms and Condition and Privacy Policy",
                            style: TextStyle(fontSize: 10),
                            maxLines: 3,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 10),

                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          routeGlobalKey.currentContext!,
                          MaterialPageRoute(
                              builder: (context) => RegistrationScreen()),
                        );
                      },
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Don't have an Account? ",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: CommonColors.black,
                                  fontWeight: FontWeight.w400),
                            ),
                            TextSpan(
                              text: "Sign Up",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: CommonColors.black,
                                  fontWeight: FontWeight.w800),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 15),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CommonColors.blue,
                          padding: EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          showVerifyOtpSheet(context);
                        },
                        child: Text("Login",
                            style:
                                TextStyle(color: Colors.white, fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

// void showLoginSheet(BuildContext context) {

//   showModalBottomSheet(
//     context: context,
//     isDismissible: false,
//     enableDrag: false,
//     backgroundColor: Colors.transparent,
//     builder: (context) {

//       return Container(
//         padding: EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Image.asset(CommonImagePath.lock),
//             SizedBox(height: 12),
//            Center(
//                     child: Text(
//                       CommonStrings.strLogin,
//                       style: CommonStyles.tsblackHeading,
//                     ),
//                   ),
//             SizedBox(height: 20),

//             CustomTextFieldWidget(
//         isMandatory: false,
//         title: "",
//         hintText: CommonStrings.strPhoneNumber,
//         onChange: (val) {},
//         textEditingController: phoneNameController, // ← fix incorrect controller
//         autovalidateMode: AutovalidateMode.disabled,
//       ),
//  Row(
//                     mainAxisSize: MainAxisSize.min,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Checkbox(

//                         value: _rememberMe,
//                            onChanged: (value) {
//         setState(() {
//           _rememberMe = value ?? false;
//         });
//       },
//                           visualDensity: VisualDensity(horizontal: -4, vertical: -4),
//                         activeColor: CommonColors.blue,
//                         side: BorderSide(color: CommonColors.blue,),
//                         checkColor: CommonColors.white,

//                         materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                       ),
//                        SizedBox(width: SizeConfig.blockSizeHorizontal * 1),
//                       Container(
//                         width: SizeConfig.blockSizeHorizontal*80,
//                         child: const Text("I agree the terms and Condition and Privacy Policy "
//                         ,
//                         style: TextStyle(overflow: TextOverflow.ellipsis,fontSize: 10),maxLines: 3,

//                         )),
//                     ],
//                   ),
//             SizedBox(height: 10),
//   GestureDetector(
//     onTap: ()
//     {
//         Navigator.pushReplacement(
//                       routeGlobalKey.currentContext!,
//                       MaterialPageRoute(builder: (context) =>  RegistrationScreen()),
//                     );
//     },
//     child: RichText(
//                                   text: TextSpan(
//                                     children: [
//                                       TextSpan(
//                                         text: "Don't have an Account? ",
//                                         style: TextStyle(
//                                           fontSize: 14,
//                                     color: CommonColors.black,
//                                               fontWeight: FontWeight.w400
//                                            ),
//                                       ),
//                                        TextSpan(

//                                         text: "Sign Up",
//                                         style: TextStyle(
//                                             fontSize: 14,
//                                             color: CommonColors.black,
//                                             fontWeight: FontWeight.w800),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//   ),SizedBox(height: 15,),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: CommonColors.blue,
//                   padding: EdgeInsets.symmetric(vertical: 10),
//                       shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(10), // 🔥 Add border radius here
//     ),

//                 ),
//                 onPressed: () {
//                   // simulate successful login
//                   Navigator.pop(context); // close sheet
//                   showVerifyOtpSheet(context);
//                 },
//                 child: Text("Login", style: TextStyle(color: Colors.white, fontSize: 16)),
//               ),
//             )
//           ],
//         ),
//       );
//     },
//   );
// }
  void showVerifyOtpSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: CommonColors.white,
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return VerifyOtpBottomSheet();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          /// MAP
          GoogleMap(
            initialCameraPosition: CameraPosition(target: center, zoom: 13),
            onMapCreated: (controller) async {
              mapController = controller;

              String style = await DefaultAssetBundle.of(context)
                  .loadString('assets/map_styles/dark_map.json');

              mapController!.setMapStyle(style);
            },
            markers: markers,
            zoomControlsEnabled: false,
          ),

          /// SEARCH BAR
          Positioned(
            top: 60,
            left: 20,
            right: 20,
            child: _searchBar(),
          ),

          /// FILTER BUTTONS
          Positioned(
            top: 130,
            left: 20,
            right: 0,
            child: _filterButtons(),
          ),
          Positioned(
            top: 190,
            left: 0,
            right: 20,
            child: Align(
              alignment: Alignment.centerRight,
              child: discount("10 %"),
            ),
          ),

          /// BOTTOM STATION CARD
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 160,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                scrollDirection: Axis.horizontal,
                itemCount: 5, // number of stations
                itemBuilder: (context, index) => _stationBottomCard(),
                separatorBuilder: (_, __) => const SizedBox(width: 12),
              ),
            ),
          )
        ],
      ),
    );
  }
Widget _searchBar() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    height: 50,
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xff212121),
          Color(0xff212121),
          Color(0xff303030),
          Color(0xff303030),
          Color(0xff303030),
        ],
      ),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: Colors.white24,
        width: 0.3,
      ),
      boxShadow: [
        BoxShadow(color: Colors.black12, blurRadius: 8),
      ],
    ),
    child: Row(
      children: [
        const Icon(Icons.search, color: Colors.white70, size: 22),
        const SizedBox(width: 12),

        /// --- TEXTFIELD ---
        Expanded(
          child: TextField(
            style: const TextStyle(color: Colors.white,fontSize: 14),
            cursorColor: Colors.white70,

            decoration: const InputDecoration(
              hintText: "Search nearby charging station",
              hintStyle: TextStyle(color: Colors.white54),
              border: InputBorder.none,
              isCollapsed: true,
            ),

            // optional:
            onChanged: (value) {
              // search logic
            },
            onTap: () {
              // open search screen
            },
          ),
        ),
      ],
    ),
  );
}

  // Widget _searchBar() {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 16),
  //     height: 50,
  //     decoration: BoxDecoration(
  //       gradient: const LinearGradient(
  //         begin: Alignment.topCenter,
  //         end: Alignment.bottomCenter,
  //         colors: [
  //           Color(0xff212121),
  //           Color(0xff212121),
  //           Color(0xff303030),
  //           Color(0xff303030),
  //           Color(0xff303030),

  //           // Color(0xff757575),
  //           //  Color(0xff757575),
  //           //       Color(0xff757575),
  //           // Color(0xff757575), // Teal/Green
  //         ],
  //       ),
  //       borderRadius: BorderRadius.circular(12),
  //       border: Border.all(
  //         color: Colors.white24, // choose your color here
  //         width: 0.3,
  //       ),
  //       boxShadow: [
  //         BoxShadow(color: Colors.black12, blurRadius: 8),
  //       ],
  //     ),
  //     child: Row(
  //       children: [
  //         Icon(
  //           Icons.search,
  //           color: CommonColors.white,
  //         ),
  //         SizedBox(width: 12),
  //         Expanded(
  //             child: Text(
  //           "Search nearby charging station",
  //           style: TextStyle(color: CommonColors.white),
  //         )),
  //       ],
  //     ),
  //   );
  // }

  Widget _filterButtons() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _filterChip("CCS"),
          const SizedBox(width: 10),
          _filterChip("CHAdeMO"),
          const SizedBox(width: 10),
          _filterChip("Type 2"),
          const SizedBox(width: 10),
          _filterChip("CCS"),
          const SizedBox(width: 10),
          _filterChip("CHAdeMO"),
          const SizedBox(width: 10),
          _filterChip("Type 2"),
        ],
      ),
    );
  }

  Widget _filterChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xff212121),
            Color(0xff424242),
            Color(0xff757575),
          ],
        ),
        border: Border.all(
          color: Colors.white24, // choose your color here
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            CommonImagePath.charger,
            width: 18,
            height: 18,
            color: Colors.white,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget discount(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      decoration: BoxDecoration(
        color: CommonColors.cream,
        borderRadius: BorderRadius.circular(16),
      ),
      constraints: const BoxConstraints(
        minWidth: 40,
        maxWidth: 60, // prevents stretching
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            CommonImagePath.info,
            width: 18,
            height: 18,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: CommonColors.brownRed,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _stationBottomCard() {
    return SizedBox(
      width: 338, // required for horizontal list
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ——— Top Header ———
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  CommonImagePath.frame,
                  fit: BoxFit.cover,
                  height: SizeConfig.blockSizeVertical * 8,
                ),
                SizedBox(width: SizeConfig.blockSizeHorizontal * 2),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Hitech EV",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Icon(Icons.more_vert, color: CommonColors.blue),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          _infoTag(CommonImagePath.redpin, "4.8 KM"),
                          SizedBox(width: 4),
                          _infoTag(CommonImagePath.star, "4.5"),
                          SizedBox(width: 4),
                          _infoTag(CommonImagePath.clock, "9.00AM - 12.00PM"),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ——— Bottom Row ———
            Row(
              children: [
                _typeInfo("Type 1", "₹12.99 / kWh"),
                SizedBox(width: SizeConfig.blockSizeHorizontal * 2),
                _typeInfo("Type 2", "₹12.99 / kWh"),
                SizedBox(width: SizeConfig.blockSizeHorizontal * 2),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CommonColors.white,
                      foregroundColor: CommonColors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: CommonColors.blue.withOpacity(0.4),
                          width: 0.8,
                        ),
                      ),
                    ),
                    child: const Text(
                      "Get Directions",
                      style: TextStyle(
                          fontSize: 12,
                          color: CommonColors.blue,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _infoTag(String icon, String text) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 3),
      decoration: BoxDecoration(
        color: CommonColors.neutral200,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Image.asset(icon, height: 14),
          SizedBox(width: 4),
          Text(text, style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _typeInfo(String type, String price) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(type,
            style: TextStyle(fontSize: 12, color: CommonColors.neutral500)),
        Text(price,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: CommonColors.primary)),
      ],
    );
  }
}

class VerifyOtpBottomSheet extends StatefulWidget {
  @override
  _VerifyOtpBottomSheetState createState() => _VerifyOtpBottomSheetState();
}

class _VerifyOtpBottomSheetState extends State<VerifyOtpBottomSheet> {
  final List<TextEditingController> otpControllers =
      List.generate(4, (index) => TextEditingController());

  bool validateOtp() {
    for (var controller in otpControllers) {
      if (controller.text.isEmpty) {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(CommonImagePath.shield),
            Center(
              child: Text(
                "Verify the OTP",
                style: CommonStyles.tsblackHeading,
              ),
            ),
            SizedBox(height: 4),
            Text(
              "Enter the otp sent to 90......78",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
            ),
            SizedBox(height: 10),
            Text(
              "Change Mobile Number?",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 20),
            Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: List.generate(4, (index) {
    return Container(
      width: 50,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: TextField(
        controller: otpControllers[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(1), // 👉 allow only 1 digit
        ],
        decoration: InputDecoration(
          counter: SizedBox.shrink(), // 👉 hide counter completely
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: CommonColors.hintGrey,
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: CommonColors.blue,
              width: 2,
            ),
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < 3) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );
  }),
)
,
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Resend OTP",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
                Icon(
                  Icons.refresh,
                  color: CommonColors.greyText,
                ),
              ],
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: CommonColors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(10), // 🔥 Add border radius here
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10),
                ),
                onPressed: () {
                  if (!validateOtp()) {
                    // Show popup
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text("Invalid OTP"),
                        content: Text("Please enter all 4 digits."),
                        actions: [
                          TextButton(
                            child: Text(
                              "OK",
                              style: TextStyle(color: CommonColors.blue),
                            ),
                            onPressed: () => Navigator.pop(context),
                          )
                        ],
                      ),
                    );
                  } else {
                    // All OTP filled
                    // You can now verify OTP or login
                    Navigator.pop(context); // Close sheet
                    setState(() {
                      GlobalLists.islLogin = true;
                    });
                  }
                },
                child: Text("Login",
                    style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
