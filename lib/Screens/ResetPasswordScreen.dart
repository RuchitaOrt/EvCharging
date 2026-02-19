import 'package:HyCharge/Provider/LoginProvider.dart';
import 'package:HyCharge/Utils/CommonStyles.dart';
import 'package:HyCharge/Utils/ShowDialog.dart';
import 'package:HyCharge/Utils/ValidationHelper.dart';
import 'package:HyCharge/Utils/commoncolors.dart';
import 'package:HyCharge/Utils/commonimages.dart';
import 'package:HyCharge/Utils/commonstrings.dart';
import 'package:HyCharge/Utils/sizeConfig.dart';
import 'package:HyCharge/widget/custom_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';


// class ResetPasswordScreen extends StatefulWidget {
//   const ResetPasswordScreen({super.key});

//   @override
//   State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
// }

// class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
//   final BorderRadius borderRadius = const BorderRadius.all(Radius.circular(8));
//   final BorderSide focusedBorder =
//       const BorderSide(width: 1.0, color: CommonColors.blue);
//   final BorderSide enableBorder =
//       BorderSide(width: 1.0, color: CommonColors.background);

//   final TextEditingController mobileController = TextEditingController();
//   final TextEditingController otpController = TextEditingController();
//   final TextEditingController newpasswordController = TextEditingController();
//   final TextEditingController confirmpasswordController =
//       TextEditingController();

//   bool isPasswordObscured = true;
//   bool isConfirmPasswordObscured = true;
//   bool isOtpVerified = false;
//   bool isOtpEnabled = false;
//   bool isVerifyEnabled = false;
//   bool isPasswordEnabled = false;
//   bool isResetEnabled = false;

//   @override
//   void initState() {
//     super.initState();

//     mobileController.addListener(() {
//       setState(() {
//         isOtpEnabled = mobileController.text.length == 10;
//       });
//     });

//     otpController.addListener(() {
//       setState(() {
//         isVerifyEnabled = otpController.text.length == 6;
//       });
//     });

//     newpasswordController.addListener(_validatePasswordMatch);
//     confirmpasswordController.addListener(_validatePasswordMatch);
//   }

//   void _validatePasswordMatch() {
//     setState(() {
//       isResetEnabled = newpasswordController.text.isNotEmpty &&
//           confirmpasswordController.text.isNotEmpty &&
//           newpasswordController.text == confirmpasswordController.text &&
//           newpasswordController.text.length >= 6;
//     });
//   }

//   void togglePasswordVisibility() {
//     setState(() {
//       isPasswordObscured = !isPasswordObscured;
//     });
//   }

//   void toggleConfirmPasswordVisibility() {
//     setState(() {
//       isConfirmPasswordObscured = !isConfirmPasswordObscured;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: CommonColors.neutral50,
//       appBar: AppBar(
//         backgroundColor: CommonColors.neutral50,
//         elevation: 0,
//         leading: IconButton(
//           icon: Image.asset(CommonImagePath.back),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: Consumer<LoginProvider>(
//         builder: (context, loginProvider, _) {
//           return SingleChildScrollView(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Center(
//                   child: Text(
//                     CommonStrings.strSetPassword,
//                     style: CommonStyles.tsblackHeading,
//                   ),
//                 ),
//                 SizedBox(height: SizeConfig.safeBlockVertical * 5),

//                 /// MOBILE FIELD
//                 CustomTextFieldWidget(
//                   title: CommonStrings.strMobileNo,
//                   hintText: CommonStrings.strPhoneNumberHint,
//                   textEditingController: mobileController,
//                   textInputType: const TextInputType.numberWithOptions(),
//                   inputFormatters: [
//                     LengthLimitingTextInputFormatter(10),
//                     FilteringTextInputFormatter.digitsOnly
//                   ],
//                   suffixIcon: GestureDetector(
//                     onTap: isOtpEnabled
//                         ? () async {
//                             if (!ValidationHelper.isValidPhone(
//                                 mobileController.text)) {
//                               showToast("Enter valid 10 digit mobile no");
//                               return;
//                             }
//                             await loginProvider.sendOtp(
//                               context: context,
//                               phoneNumber: mobileController.text,
//                               countryCode: "+91",
//                             );
//                             FocusManager.instance.primaryFocus?.unfocus();
//                             showToast(
//                                 loginProvider.sendOtpResponse!.message);
//                           }
//                         : null,
//                     child: Text(
//                       "send OTP",
//                       style: TextStyle(
//                           color: isOtpEnabled
//                               ? CommonColors.blue
//                               : CommonColors.hintGrey,
//                           fontSize: 12),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: SizeConfig.blockSizeVertical * 2),

//                 /// OTP FIELD
//                 Text(
//                   "OTP",
//                   style: CommonStyles.textFieldHeading,
//                 ),
//                 SizedBox(height: SizeConfig.blockSizeVertical * 0.5),
//                 Padding(
//                   padding: const EdgeInsets.only(bottom: 20, top: 5),
//                   child: TextFormField(
//                     cursorColor: CommonColors.blue,
//                     style: CommonStyles.textFieldHeading,
//                     obscureText: false,
//                     controller: otpController,
//                     keyboardType: TextInputType.number,
//                     autovalidateMode: AutovalidateMode.disabled,
//                     decoration: InputDecoration(
//                       errorMaxLines: 3,
//                       suffixIcon: Padding(
//                         padding: const EdgeInsets.all(6.0),
//                         child: isOtpVerified
//                             ? const Icon(
//                                 Icons.check_circle,
//                                 color: Colors.green,
//                               )
//                             : SizedBox(
//                                 height: 36,
//                                 width: 80,
//                                 child: ElevatedButton(
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: isVerifyEnabled
//                                         ? CommonColors.blue
//                                         : CommonColors.hintGrey,
//                                     padding: const EdgeInsets.symmetric(
//                                         vertical: 8),
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                   ),
//                                   onPressed: isVerifyEnabled
//                                       ? () async {
//                                           await loginProvider.verifyOtp(
//                                             context: context,
//                                             authId: loginProvider
//                                                 .sendOtpResponse!.authId!,
//                                             otpCode: otpController.text,
//                                             phoneNumber: mobileController.text,
//                                             isReset: true
//                                           );
//                                           if (loginProvider
//                                                   .verifyOtpResponse?.success ==
//                                               true) {
//                                             setState(() {
//                                               isOtpVerified = true;
//                                               isPasswordEnabled = true;
//                                             });
//                                             // showToast(loginProvider
//                                             //     .verifyOtpResponse!.message);
//                                           } else {
//                                             showToast(loginProvider
//                                                 .verifyOtpResponse!.message);
//                                           }
//                                         }
//                                       : null,
//                                   child: const Text(
//                                     "Verify",
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                       ),
//                       hintText: "Enter OTP",
//                       contentPadding: const EdgeInsets.symmetric(
//                           vertical: 10.0, horizontal: 8.0),
//                       border: OutlineInputBorder(
//                           borderRadius: borderRadius, borderSide: enableBorder),
//                       focusedBorder: OutlineInputBorder(
//                           borderRadius: borderRadius, borderSide: focusedBorder),
//                       enabledBorder: OutlineInputBorder(
//                           borderRadius: borderRadius, borderSide: enableBorder),
//                       filled: true,
//                       fillColor: CommonColors.white,
//                       hintStyle: CommonStyles.textFieldHint,
//                       errorStyle: CommonStyles.textFieldHint,
//                       counterText: "",
//                     ),
//                   ),
//                 ),

//                 /// NEW PASSWORD FIELD
//                 Text(
//                   CommonStrings.strNewPassword,
//                   style: CommonStyles.textFieldHeading,
//                 ),
//                 SizedBox(height: SizeConfig.blockSizeVertical * 0.5),
//                 Padding(
//                   padding: const EdgeInsets.only(bottom: 20, top: 5),
//                   child: TextFormField(
//                     enabled: isPasswordEnabled,
//                     cursorColor: CommonColors.blue,
//                     style: CommonStyles.textFieldHeading,
//                     obscureText: isPasswordObscured,
//                     controller: newpasswordController,
//                     autovalidateMode: AutovalidateMode.disabled,
//                     decoration: InputDecoration(
//                       errorMaxLines: 3,
//                       suffixIcon: IconButton(
//                         onPressed: togglePasswordVisibility,
//                         icon: Icon(
//                           isPasswordObscured
//                               ? Icons.visibility_off
//                               : Icons.visibility,
//                           color: isPasswordObscured
//                               ? CommonColors.hintGrey
//                               : CommonColors.blue,
//                         ),
//                       ),
//                       hintText: CommonStrings.strnewPasswordHint,
//                       contentPadding: const EdgeInsets.symmetric(
//                           vertical: 10.0, horizontal: 8.0),
//                       border: OutlineInputBorder(
//                           borderRadius: borderRadius, borderSide: enableBorder),
//                       focusedBorder: OutlineInputBorder(
//                           borderRadius: borderRadius, borderSide: focusedBorder),
//                       enabledBorder: OutlineInputBorder(
//                           borderRadius: borderRadius, borderSide: enableBorder),
//                       filled: true,
//                       fillColor: CommonColors.white,
//                       hintStyle: CommonStyles.textFieldHint,
//                       errorStyle: CommonStyles.textFieldHint,
//                       counterText: "",
//                     ),
//                   ),
//                 ),

//                 /// CONFIRM PASSWORD FIELD
//                 Text(
//                   CommonStrings.strconfirmpassword,
//                   style: CommonStyles.textFieldHeading,
//                 ),
//                 SizedBox(height: SizeConfig.blockSizeVertical * 0.5),
//                 Padding(
//                   padding: const EdgeInsets.only(bottom: 20, top: 5),
//                   child: TextFormField(
//                     enabled: isPasswordEnabled,
//                     cursorColor: CommonColors.blue,
//                     style: CommonStyles.textFieldHeading,
//                     obscureText: isConfirmPasswordObscured,
//                     controller: confirmpasswordController,
//                     autovalidateMode: AutovalidateMode.disabled,
//                     decoration: InputDecoration(
//                       errorMaxLines: 3,
//                       suffixIcon: IconButton(
//                         onPressed: toggleConfirmPasswordVisibility,
//                         icon: Icon(
//                           isConfirmPasswordObscured
//                               ? Icons.visibility_off
//                               : Icons.visibility,
//                           color: isConfirmPasswordObscured
//                               ? CommonColors.hintGrey
//                               : CommonColors.blue,
//                         ),
//                       ),
//                       hintText: CommonStrings.strconfirmpassword,
//                       contentPadding: const EdgeInsets.symmetric(
//                           vertical: 10.0, horizontal: 8.0),
//                       border: OutlineInputBorder(
//                           borderRadius: borderRadius, borderSide: enableBorder),
//                       focusedBorder: OutlineInputBorder(
//                           borderRadius: borderRadius, borderSide: focusedBorder),
//                       enabledBorder: OutlineInputBorder(
//                           borderRadius: borderRadius, borderSide: enableBorder),
//                       filled: true,
//                       fillColor: CommonColors.white,
//                       hintStyle: CommonStyles.textFieldHint,
//                       errorStyle: CommonStyles.textFieldHint,
//                       counterText: "",
//                     ),
//                   ),
//                 ),

//                 /// RESET PASSWORD BUTTON
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: isResetEnabled
//                           ? CommonColors.blue
//                           : CommonColors.hintGrey,
//                       padding: const EdgeInsets.symmetric(vertical: 12),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     onPressed: isResetEnabled
//                         ? () async {
//                             // Call Reset API here
                           

// await loginProvider.forgetPassword(
//   context: context,
//   emailOrPhone: mobileController.text,
//   otpCode: otpController.text,
//   authId: loginProvider
//                                                 .sendOtpResponse!.authId!,
//   newPassword: newpasswordController.text,
//   confirmPassword: confirmpasswordController.text,
// );
// print(loginProvider.forgetPasswordResponse);
// if (loginProvider.forgetPasswordResponse?.success == true) {
//   showToast(loginProvider.forgetPasswordResponse?.message ?? "Password reset successful");
//   Navigator.pop(context);
// } else {
//   showToast(loginProvider.forgetPasswordResponse?.message ?? "Something went wrong");
// }

//                           }
//                         : null,
//                     child: const Text(
//                       "Reset Password",
//                       style: TextStyle(
//                           fontWeight: FontWeight.bold, color: Colors.white),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: SizeConfig.blockSizeVertical * 4),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:HyCharge/Provider/LoginProvider.dart';
import 'package:HyCharge/Utils/CommonStyles.dart';
import 'package:HyCharge/Utils/ShowDialog.dart';
import 'package:HyCharge/Utils/ValidationHelper.dart';
import 'package:HyCharge/Utils/commoncolors.dart';
import 'package:HyCharge/Utils/commonimages.dart';
import 'package:HyCharge/Utils/commonstrings.dart';
import 'package:HyCharge/widget/custom_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {

  final TextEditingController mobileController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController newpasswordController = TextEditingController();
  final TextEditingController confirmpasswordController = TextEditingController();

  bool isPasswordObscured = true;
  bool isConfirmPasswordObscured = true;
  bool isOtpVerified = false;
  bool isOtpEnabled = false;
  // bool isVerifyEnabled = false;
  bool isPasswordEnabled = false;
  bool isResetEnabled = false;

  @override
  void initState() {
    super.initState();

    mobileController.addListener(() {
      setState(() {
        isOtpEnabled = mobileController.text.length == 10;
      });
    });

    otpController.addListener(() {
      setState(() {
          otpController.text.length == 6;
      });
    });

    newpasswordController.addListener(_validatePasswordMatch);
    confirmpasswordController.addListener(_validatePasswordMatch);
  }

  void _validatePasswordMatch() {
    setState(() {
      isResetEnabled =
          newpasswordController.text.isNotEmpty &&
          confirmpasswordController.text.isNotEmpty &&
          newpasswordController.text == confirmpasswordController.text &&
          newpasswordController.text.length >= 6;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CommonColors.neutral50,
      appBar: AppBar(
        backgroundColor: CommonColors.neutral50,
        elevation: 0,
        leading: IconButton(
          icon: Image.asset(CommonImagePath.back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Consumer<LoginProvider>(
          builder: (context, loginProvider, _) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const SizedBox(height: 30),

                  Center(
                    child: Text(
                      CommonStrings.strSetPassword,
                      style: CommonStyles.tsblackHeading.copyWith(fontSize: 22),
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// MOBILE
                  CustomTextFieldWidget(
                    title: CommonStrings.strMobileNo,
                    hintText: CommonStrings.strPhoneNumberHint,
                    textEditingController: mobileController,
                    textInputType: const TextInputType.numberWithOptions(),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(10),
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    suffixIcon: GestureDetector(
                      onTap: isOtpEnabled
                          ? () async {

                              if (!ValidationHelper.isValidPhone(mobileController.text)) {
                                showToast("Enter valid mobile number");
                                return;
                              }

                              await loginProvider.sendOtp(
                                context: context,
                                phoneNumber: mobileController.text,
                                countryCode: "+91",
                              );

                              otpController.clear();

                              setState(() {
                                
                                isPasswordEnabled = false;
                                isResetEnabled = false;
                              });

                              showToast(loginProvider.sendOtpResponse?.message ?? "");
                            }
                          : null,
                      child: Text(
                        "Send OTP",
                        style: TextStyle(
                          color: isOtpEnabled
                              ? CommonColors.blue
                              : CommonColors.hintGrey,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  /// OTP (Same Height Now)
                  CustomTextFieldWidget(
                    title: "OTP",
                    hintText: "Enter OTP",
                    textEditingController: otpController,
                    textInputType: TextInputType.number,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(6),
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    // suffixIcon: isOtpVerified
                    //     ? const Icon(Icons.check_circle, color: Colors.green)
                    //     : GestureDetector(
                    //         onTap: isVerifyEnabled
                    //             ? () async {
                    //                 await loginProvider.verifyOtp(
                    //                   context: context,
                    //                   authId: loginProvider.sendOtpResponse!.authId!,
                    //                   otpCode: otpController.text,
                    //                   phoneNumber: mobileController.text,
                    //                   isReset: true,
                    //                 );

                    //                 if (loginProvider.verifyOtpResponse?.success == true) {
                    //                   setState(() {
                    //                     isOtpVerified = true;
                    //                     isPasswordEnabled = true;
                    //                   });
                    //                 } else {
                    //                   showToast(loginProvider.verifyOtpResponse?.message ?? "");
                    //                 }
                    //               }
                    //             : null,
                    //         child: Text(
                    //           "Verify",
                    //           style: TextStyle(
                    //             color: isVerifyEnabled
                    //                 ? CommonColors.blue
                    //                 : CommonColors.hintGrey,
                    //             fontSize: 12,
                    //           ),
                    //         ),
                    //       ),
                  ),

                  const SizedBox(height: 8),

                  /// NEW PASSWORD
                  CustomTextFieldWidget(
                    title: CommonStrings.strNewPassword,
                    hintText: CommonStrings.strnewPasswordHint,
                    textEditingController: newpasswordController,
                    obscureText: isPasswordEnabled ? isPasswordObscured : true,
                   
                    suffixIcon: IconButton(
                      icon: Icon(
                        isPasswordObscured
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: CommonColors.blue,
                      ),
                      onPressed: () {
                        setState(() {
                          isPasswordObscured = !isPasswordObscured;
                        });
                      },
                    ),
                  ),

                  const SizedBox(height: 8),

                  /// CONFIRM PASSWORD
                  CustomTextFieldWidget(
                    title: CommonStrings.strconfirmpassword,
                    hintText: CommonStrings.strconfirmpassword,
                    textEditingController: confirmpasswordController,
                    obscureText: isPasswordEnabled ? isConfirmPasswordObscured : true,
                  
                    suffixIcon: IconButton(
                      icon: Icon(
                        isConfirmPasswordObscured
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: CommonColors.blue,
                      ),
                      onPressed: () {
                        setState(() {
                          isConfirmPasswordObscured =
                              !isConfirmPasswordObscured;
                        });
                      },
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// RESET BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isResetEnabled
                            ? CommonColors.blue
                            : CommonColors.hintGrey,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                      onPressed: isResetEnabled
                          ? () async {
                              await loginProvider.forgetPassword(
                                context: context,
                                emailOrPhone: mobileController.text,
                                otpCode: otpController.text,
                                authId: loginProvider.sendOtpResponse!.authId!,
                                newPassword: newpasswordController.text,
                                confirmPassword: confirmpasswordController.text,
                              );

                              if (loginProvider.forgetPasswordResponse?.success == true) {
                                showToast(loginProvider.forgetPasswordResponse?.message ?? "");
                                Navigator.pop(context);
                              } else {
                                showToast(loginProvider.forgetPasswordResponse?.message ?? "");
                              }
                            }
                          : null,
                      child: const Text(
                        "Reset Password",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
