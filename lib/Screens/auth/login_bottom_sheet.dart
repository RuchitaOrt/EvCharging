import 'package:HyCharge/Provider/LoginProvider.dart';
import 'package:HyCharge/Request/LoginRequest.dart';
import 'package:HyCharge/Screens/MainTab.dart';
import 'package:HyCharge/Screens/Map/MapScreen.dart';
import 'package:HyCharge/Screens/RegistrationScreen.dart';
import 'package:HyCharge/Screens/ResetPasswordScreen.dart';
import 'package:HyCharge/Screens/auth/otp_bottom_sheet.dart';
import 'package:HyCharge/Services/pdf_viewer_screen.dart';
import 'package:HyCharge/Utils/CommonStyles.dart';
import 'package:HyCharge/Utils/ShowDialog.dart';
import 'package:HyCharge/Utils/ValidationHelper.dart';
import 'package:HyCharge/Utils/commoncolors.dart';
import 'package:HyCharge/Utils/commonimages.dart';
import 'package:HyCharge/Utils/commonstrings.dart';
import 'package:HyCharge/Utils/regex_helper.dart';
import 'package:HyCharge/Utils/sizeConfig.dart';
import 'package:HyCharge/widget/GlobalLists.dart';
import 'package:HyCharge/widget/custom_text_field_widget.dart';
import 'package:HyCharge/widget/or_divider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import 'package:provider/provider.dart';

class LoginSheetWidget extends StatefulWidget {
  final bool isLogin;

  const LoginSheetWidget({super.key, this.isLogin = false});

  @override
  State<LoginSheetWidget> createState() => _LoginSheetWidgetState();
}

class _LoginSheetWidgetState extends State<LoginSheetWidget> {
  final TextEditingController _phoneEmailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _rememberMe = false;
  bool isMobile = true;
  bool isGmail = false;

  void _toggleRememberMe(bool? value) {
    setState(() {
      _rememberMe = value ?? false;
    });
  }

  final BorderRadius borderRadius = const BorderRadius.all(Radius.circular(8));
  final BorderSide focusedBorder = const BorderSide(
    width: 1.0,
    color: CommonColors.blue,
  );
  final BorderSide enableBorder = BorderSide(
    width: 1.0,
    color: CommonColors.background,
  );

  TextEditingController passwordController = TextEditingController();

  TextEditingController phoneNameController = TextEditingController();
  bool isPasswordObscured = true;
  bool isMobileValid = false;

  void togglePasswordVisibility() {
    setState(() {
      isPasswordObscured = !isPasswordObscured;
    });
  }

  Future<void> _login() async {
    final emailOrPhone = _phoneEmailController.text.trim();
    final password = _passwordController.text.trim();
    if (!ValidationHelper.isNotEmpty(emailOrPhone)) {
      FocusScope.of(context).unfocus();
      showToast("Please enter email");
      return;
    }

    if (!ValidationHelper.isEmailValid(emailOrPhone)) {
      FocusScope.of(context).unfocus();
      showToast("Please enter a valid email address");
      return;
    }

    if (!ValidationHelper.isPasswordValid(password)) {
      FocusScope.of(context).unfocus();
      showToast("Password must be at least 6 characters");
      return;
    }

    if (!_rememberMe) {
      FocusScope.of(context).unfocus();
      showToast("Please accept Terms & Conditions");
      return;
    }

    final loginProvider = Provider.of<LoginProvider>(context, listen: false);

    loginProvider.setLoading(true);

    try {
      await loginProvider.login(
        context,
        LoginRequest(
          emailOrPhone: _phoneEmailController.text,
          password: _passwordController.text,
        ),
      );

      loginProvider.setLoading(false);

      if (loginProvider.loginResponse?.success ?? false) {
        GlobalLists.islLogin = true;
        Navigator.of(context, rootNavigator: true).pop(); // close sheet

        // Navigate to main tab
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => MainTab(
                    isLoggedIn: true,
                  )),
        );
      } else if (loginProvider.loginResponse?.success == false) {
        FocusScope.of(context).unfocus();
        showToast(loginProvider.loginResponse!.message);
      } else if (loginProvider.error != null) {
        FocusScope.of(context).unfocus();
        showToast(loginProvider.error.toString());
      } else {
        FocusScope.of(context).unfocus();
        showToast("Unknown error occurred");
      }
    } catch (e) {
      loginProvider.setLoading(false);
      FocusScope.of(context).unfocus();
      showToast("Something went wrong");
    }
  }

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
                          Image.asset(CommonImagePath.lock),
                          const SizedBox(height: 12),
                          Center(
                            child: Text(CommonStrings.strLogin,
                                style: CommonStyles.tsblackHeading),
                          ),
                          const SizedBox(height: 5),
                          isMobile
                              ? CustomTextFieldWidget(
                                  title: "",
                                  isMandatory: false,
                                  hintText: CommonStrings.strMobileNo,
                                  textEditingController: _phoneEmailController,
                                  textInputType: TextInputType.phone,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(10),
                                    FilteringTextInputFormatter.allow(
                                        RegExp(RegexHelper().numberOnlyRegex)),
                                  ],
                                  onChange: (value) {
                                    setState(() {
                                      isMobileValid = value.length == 10 &&
                                          ValidationHelper.isValidPhone(value);
                                    });
                                  },
                                )
                              : Container(),
                          // Email/Phone
                          isGmail
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomTextFieldWidget(
                                      title: "",
                                      isMandatory: false,
                                      hintText: CommonStrings.strEmailHint,
                                      textEditingController:
                                          _phoneEmailController,
                                      textInputType: TextInputType.emailAddress,
                                    ),
                                    const SizedBox(height: 10),

                                    // Password
                                    TextFormField(
                                      cursorColor: CommonColors.blue,
                                      style: CommonStyles.textFieldHeading,
                                      obscureText: isPasswordObscured,
                                      controller: _passwordController,
                                      decoration: InputDecoration(
                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              isPasswordObscured =
                                                  !isPasswordObscured;
                                            });
                                          },
                                          icon: Icon(
                                            isPasswordObscured
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                            color: isPasswordObscured
                                                ? CommonColors.hintGrey
                                                : CommonColors.blue,
                                          ),
                                        ),
                                        hintText: CommonStrings.strPasswordHint,
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 16),
                                        border: OutlineInputBorder(
                                            borderRadius: borderRadius,
                                            borderSide: enableBorder),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius: borderRadius,
                                            borderSide: focusedBorder),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius: borderRadius,
                                            borderSide: enableBorder),
                                        filled: true,
                                        fillColor: CommonColors.white,
                                        hintStyle: CommonStyles.textFieldHint,
                                        errorStyle: CommonStyles.textFieldHint,
                                      ),
                                    ),
                                  ],
                                )
                              : Container(),

                          // Remember/Terms
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Checkbox(
                                visualDensity: VisualDensity(horizontal: 0),
                                value: _rememberMe,
                                activeColor: CommonColors.blue,
                                onChanged: _toggleRememberMe,
                              ),
                               Expanded(
                                child:
                                //  Text(
                                //   "I agree to the terms and Conditions and Privacy Policy",
                                //   style: TextStyle(fontSize: 10),
                                // ),
                                 RichText(
                                   textAlign: TextAlign.start,
                                   text: TextSpan(
                                     children: [
                                       TextSpan(
                                         text: "I agree to the ",
                                         style: TextStyle(
                                             fontSize: 11,
                                             color: CommonColors.black,
                                             fontWeight: FontWeight.w400),
                                       ),
                                       WidgetSpan(
  child: GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const PdfViewerScreen(
            title: "Terms of Service",
            assetPath: "assets/pdfs/terms.pdf",
          ),
        ),
      );
    },
    child: Container(
     
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: CommonColors.skyBlue,
            width: 1,
          ),
        ),
      ),
      child: const Text(
        "Terms of Service ",
        style: TextStyle(
          fontSize: 11,
          color: CommonColors.skyBlue,
          fontWeight: FontWeight.w400,
        ),
      ),
    ),
  ),
),

                                       TextSpan(
                                         text: "and ",
                                         style: TextStyle(
                                             color: CommonColors.black,
                                             fontSize: 11,
                                             fontWeight: FontWeight.w400),
                                       ),
                                       WidgetSpan(
  child: GestureDetector(
    onTap: () {
       Navigator.push(
                                               context,
                                               MaterialPageRoute(
                                 builder: (_) => const PdfViewerScreen(
                                   title: "Privacy Policy ",
                                   assetPath: "assets/pdfs/privacy.pdf",
                                 ),
                                               ),
                                             );
    },
    child: Container(
     
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: CommonColors.skyBlue,
            width: 1,
          ),
        ),
      ),
      child: const Text(
        "Privacy Policy ",
        style: TextStyle(
          fontSize: 11,
          color: CommonColors.skyBlue,
          fontWeight: FontWeight.w400,
        ),
      ),
    ),
  ),
),
                            
                                     ],
                                   ),
                                 ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          // Sign Up Link
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegistrationScreen()),
                              );
                            },
                            child: RichText(
                              text: const TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Don't have an Account? ",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "Register",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 25),
isGmail?Container():GestureDetector(
  onTap: ()
  async {
      Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ResetPasswordScreen()),
                              );
   
  },
  child: Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Text(
                                           "Forgot Passsword ?",
                                            style: TextStyle(
                                                color: CommonColors.blue, fontSize: 14,fontWeight: FontWeight.bold),
                                          ),
    ],
  ),
),
  const SizedBox(height: 25),
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
                              onPressed: isGmail
                                  ? (loginProvider.isLoading ? null : _login)
                                  : (!isMobileValid
                                      ? null
                                      : () async {

    if (!ValidationHelper.isValidPhone(_phoneEmailController.text)) {
      FocusScope.of(context).unfocus();
      showToast("Enter valid 10 digit mobile no");
      return;
    }

    if (!_rememberMe) {
      FocusScope.of(context).unfocus();
      showToast("Please accept Terms & Conditions");
      return;
    }
                                          await loginProvider.sendOtp(
                                            context: context,
                                            phoneNumber:
                                                _phoneEmailController.text,
                                            countryCode: "+91",
                                          );
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                          // Navigator.pop(context);
                                           Navigator.of(context,
                                                    rootNavigator: true)
                                                .pop();
                                                FocusScope.of(context).unfocus();
                                          showToast(loginProvider
                                              .sendOtpResponse!.message);
                                          if (loginProvider
                                                  .sendOtpResponse?.success ==
                                              true) {
                                           
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .pop();

                                            showVerifyOTPLoginSheet(
                                              context,
                                              _phoneEmailController.text,
                                              loginProvider
                                                  .sendOtpResponse!.authId!,false
                                            );
                                          
                                          }else
                                          {
                                               Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegistrationScreen()),
                              );
                                          }
                                        }),
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
                                      isGmail ? "Login" : "Send otp",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          OrDivider(
                            text: "Or",
                          ),

                          const SizedBox(height: 10),
                          isMobile
                              ? GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isGmail = true;
                                      isMobile = false;
                                    });
                                  },
                                  child: Text(
                                    "Login with Password",
                                    style: TextStyle(
                                        color: CommonColors.blue, fontSize: 16),
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isGmail = false;
                                      isMobile = true;
                                    });
                                  },
                                  child: Text(
                                    "Login with OTP",
                                    style: TextStyle(
                                        color: CommonColors.blue, fontSize: 16),
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
             isForgetPassword:isForgetPassword
          ),
        );
      },
    );
  }
}
