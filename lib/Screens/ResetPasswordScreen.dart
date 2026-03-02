import 'package:HyCharge/Provider/LoginProvider.dart';
import 'package:HyCharge/Screens/MainTab.dart';
import 'package:HyCharge/Utils/CommonStyles.dart';
import 'package:HyCharge/Utils/ShowDialog.dart';
import 'package:HyCharge/Utils/ValidationHelper.dart';
import 'package:HyCharge/Utils/commoncolors.dart';
import 'package:HyCharge/Utils/commonimages.dart';
import 'package:HyCharge/Utils/commonstrings.dart';
import 'package:HyCharge/widget/GlobalLists.dart';
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
    return WillPopScope(
       onWillPop: () async {
      // Navigate to MainTab instead of popping
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>  MainTab(isLoggedIn: GlobalLists.islLogin)),
      );
      return false; // prevent default pop
    },
      child: Scaffold(
        backgroundColor: CommonColors.neutral50,
        appBar: AppBar(
          backgroundColor: CommonColors.neutral50,
          elevation: 0,
          leading: IconButton(
            icon: Image.asset(CommonImagePath.back),
            onPressed: () 
            {
                Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    MainTab(isLoggedIn: GlobalLists.islLogin),
                              ),
                            );
            }
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
                      // textInputType: const TextInputType.numberWithOptions(),
                      // inputFormatters: [
                      //   LengthLimitingTextInputFormatter(10),
                      //   FilteringTextInputFormatter.digitsOnly
                      // ],
                        textInputType: TextInputType.text,
      
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      //                       textInputType: TextInputType.text,
      
      // inputFormatters: [
      //   FilteringTextInputFormatter.digitsOnly,
      // ],
                      suffixIcon: GestureDetector(
                        onTap: isOtpEnabled
                            ? () async {
      
                                if (!ValidationHelper.isValidPhone(mobileController.text)) {
                                  FocusScope.of(context).unfocus();
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
      FocusScope.of(context).unfocus();
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
                                  FocusScope.of(context).unfocus();
                                  showToast(loginProvider.forgetPasswordResponse?.message ?? "");
                                   Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => MainTab(isLoggedIn: false),
              ),
              (_) => false,
            );
                                  // Navigator.pop(context);
                                } else {
                                  FocusScope.of(context).unfocus();
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
      ),
    );
  }
}
