import 'package:HyCharge/Provider/LoginProvider.dart';
import 'package:HyCharge/Screens/MainTab.dart';
import 'package:HyCharge/Screens/auth/ResetPassword_bottom_sheet.dart';
import 'package:HyCharge/Utils/CommonStyles.dart';
import 'package:HyCharge/Utils/ShowDialog.dart';
import 'package:HyCharge/Utils/commoncolors.dart';
import 'package:HyCharge/Utils/commonimages.dart';
import 'package:HyCharge/Utils/commonstrings.dart';
import 'package:HyCharge/main.dart';
import 'package:HyCharge/widget/GlobalLists.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VerifyOtpBottomSheet extends StatefulWidget {
  final String mobileNo;
  final String authToken;
 final  bool isForgetPassword;

  VerifyOtpBottomSheet(
      {super.key, required this.mobileNo, required this.authToken, required this.isForgetPassword});

  @override
  State<VerifyOtpBottomSheet> createState() => _VerifyOtpBottomSheetState();
}

class _VerifyOtpBottomSheetState extends State<VerifyOtpBottomSheet> {
  TextEditingController otpfielfController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      duration: const Duration(milliseconds: 100),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 👇 your existing widgets
              Consumer<LoginProvider>(
                builder: (context, loginProvider, _) {
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(30)),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(CommonImagePath.shield),
                          const SizedBox(height: 12),
                          Center(
                            child: Text(CommonStrings.strVerifyOTP,
                                style: CommonStyles.tsblackHeading),
                          ),
                          Center(
                            child: Text(
                                "${CommonStrings.strSendOTP} ${widget.mobileNo}",
                                style: CommonStyles.textFieldHint),
                          ),

                          const SizedBox(height: 15),
                          OtpBoxField(
                            controller: otpfielfController,
                          ),
                          const SizedBox(height: 15),
                          GestureDetector(
                            onTap: () async {
                              await loginProvider.resendOtp(
                                context: context,
                                phoneNumber: widget.mobileNo,
                                countryCode: "+91",
                              );
 showToast(
                                    loginProvider.resendOtpResponse!.message);
                              if (loginProvider.resendOtpResponse?.success ==
                                  true) {
                               
                                FocusManager.instance.primaryFocus?.unfocus();
                                Navigator.pop(context);
                                showVerifyOTPLoginSheet(
                                    context,
                                    widget.mobileNo,
                                    loginProvider.sendOtpResponse!.authId!,widget.isForgetPassword);
                              }
                            },
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Resend Otp",
                                      style: CommonStyles.tsbllueHeading,),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Icon(
                                    Icons.refresh,
                                    color: CommonColors.greyText,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          // Login Button / Loader
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: CommonColors.blue,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () async {
                                await loginProvider.verifyOtp(
                                  context: context,
                                  authId: widget.authToken,
                                  otpCode: otpfielfController.text,
                                  phoneNumber: widget.mobileNo,
                                  isReset: false
                                );

                                if (loginProvider.verifyOtpResponse?.success ==
                                    true) {
                                      if(widget.isForgetPassword)
                                      {

    showSetPasswordLoginSheet(
                                              context,
                                             widget.mobileNo,
                                              loginProvider
                                                  .sendOtpResponse!.authId!,true
                                            );
                                      }else{
 GlobalLists.islLogin = true;
                                   // Close bottom sheet
  Navigator.of(context, rootNavigator: true).pop();

  // Wait for sheet animation to finish
  Future.delayed(const Duration(milliseconds: 300), () {

    Navigator.of(routeGlobalKey.currentContext!)
        .pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => MainTab(isLoggedIn: true),
      ),
      (route) => false,
    );

  });
                                      }
                                 
                                  // Navigator.of(context, rootNavigator: true)
                                  //     .pop(); // close sheet

                                  // // Navigate to main tab
                                  // Navigator.pushReplacement(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //       builder: (_) => MainTab(
                                  //             isLoggedIn: true,
                                  //           )),
                                  // );
                                }
                              },
                              child: loginProvider.isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Text(
                                      "Login",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );

    
  }
   showSetPasswordLoginSheet(
      BuildContext context, String mobile, String authToken,bool isForgetPassword) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return WillPopScope(
          onWillPop: () async => false,
          child: ResetpasswordBottomSheet(
            mobileNo: mobile,
            authToken: authToken,
             isForgetPassword:isForgetPassword
          ),
        );
      },
    );
  }
  showVerifyOTPLoginSheet(
      BuildContext context, String mobile, String authToken,bool isForgetPassword) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return WillPopScope(
          onWillPop: () async => false,
          child: VerifyOtpBottomSheet(
            mobileNo: mobile,
            authToken: authToken,
            isForgetPassword: isForgetPassword,
            
          ),
        );
      },
    );
  }

}

class OtpBoxField extends StatefulWidget {
  final TextEditingController controller;
  final int length;

  const OtpBoxField({
    super.key,
    required this.controller,
    this.length = 6,
  });

  @override
  State<OtpBoxField> createState() => _OtpBoxFieldState();
}

class _OtpBoxFieldState extends State<OtpBoxField> {
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _focusNode.requestFocus(),
      child: Stack(
        children: [
          /// Hidden TextField (handles input)
          Opacity(
            opacity: 0,
            child: TextField(
              focusNode: _focusNode,
              controller: widget.controller,
              keyboardType: TextInputType.number,
              maxLength: widget.length,
              autofocus: false,
              enableSuggestions: false,
              autocorrect: false,
              onChanged: (_) => setState(() {}),
            ),
          ),

          /// Visible OTP boxes
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(widget.length, (index) {
                String text = '';
                if (index < widget.controller.text.length) {
                  text = widget.controller.text[index];
                }

                return Container(
                  width: 42,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _focusNode.hasFocus
                          ? CommonColors.blue
                          : Colors.grey.shade400,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    text,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }




  
}
