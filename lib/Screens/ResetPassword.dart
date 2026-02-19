import 'package:HyCharge/Provider/AuthProvider.dart';
import 'package:HyCharge/Screens/MainTab.dart';
import 'package:HyCharge/Utils/APIManager.dart';
import 'package:HyCharge/Utils/AuthStorage.dart';
import 'package:HyCharge/Utils/CommonAppBar.dart';
import 'package:HyCharge/Utils/CommonStyles.dart';
import 'package:HyCharge/Utils/ShowDialog.dart';
import 'package:HyCharge/Utils/commoncolors.dart';
import 'package:HyCharge/Utils/commonstrings.dart';
import 'package:HyCharge/Utils/regex_helper.dart';
import 'package:HyCharge/Utils/sizeConfig.dart';
import 'package:HyCharge/widget/GlobalLists.dart';
import 'package:HyCharge/widget/custom_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResetPassword extends StatefulWidget {
 final String email;
  final String mobile;
  static const String route = "/login_screen";

  const ResetPassword({super.key, required this.email, required this.mobile});

  @override
  State<ResetPassword> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPassword> {
  final BorderRadius borderRadius = const BorderRadius.all(Radius.circular(8));
  final BorderSide focusedBorder = const BorderSide(
    width: 1.0,
    color: CommonColors.blue,
  );
  final BorderSide enableBorder = BorderSide(
    width: 1.0,
    color: CommonColors.background,
  );
  TextEditingController firstNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController newpasswordController = TextEditingController();
  TextEditingController oldpasswordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();

  TextEditingController lastNameController = TextEditingController();
  bool isoldPasswordObscured = true;

  void toggleoldPasswordVisibility() {
    setState(() {
      isoldPasswordObscured = !isoldPasswordObscured;
    });
  }

  bool isPasswordObscured = true;

  void togglePasswordVisibility() {
    setState(() {
      isPasswordObscured = !isPasswordObscured;
    });
  }

  bool isConfirmPasswordObscured = true;

  void toggleConfirmPasswordVisibility() {
    setState(() {
      isConfirmPasswordObscured = !isConfirmPasswordObscured;
    });
  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    mobileController.text=widget.mobile;
    emailController.text=widget.email;
  }
  @override
  Widget build(BuildContext context) {
    // SUCCESS

    return Consumer<AuthProvider>(builder: (context, authProvider, _) {
      // SUCCESS

      return Scaffold(
        backgroundColor: CommonColors.neutral50,
        resizeToAvoidBottomInset: true,
          appBar: CommonAppBar(title: "Reset Password"),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Scrollable content
              // GestureDetector(
              //     onTap: () {
              //       Navigator.pop(context);
              //     },
              //     child: Padding(
              //       padding: const EdgeInsets.only(left: 16, top: 20),
              //       child: Image.asset(CommonImagePath.back),
              //     )),
              
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: SizeConfig.blockSizeVertical * 5),
                      // Center(
                      //   child: Text(
                      //     CommonStrings.strResetPassword,
                      //     style: CommonStyles.tsblackHeading,
                      //   ),
                      // ),
                      //SizedBox(height: SizeConfig.blockSizeVertical * 5),
                      CustomTextFieldWidget(
                        title: CommonStrings.strMobileNo,
                        isMandatory: false,
                        hintText: CommonStrings.strPhoneNumberHint,
                        textEditingController: mobileController,
                        textInputType: const TextInputType.numberWithOptions(
                          signed: false,
                          decimal: false,
                        ),
                        isFieldDisabled: true,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(10),
                          FilteringTextInputFormatter.allow(
                              RegExp(RegexHelper().numberOnlyRegex)),
                        ],
                      ),
                      CustomTextFieldWidget(
                        isMandatory: false,
                        title: CommonStrings.strEmail,
                        hintText: CommonStrings.strEmailHint,
                        onChange: (val) {},
                        textEditingController: emailController,
                          isFieldDisabled: true,
                        autovalidateMode: AutovalidateMode.disabled,
                      ),
                      SizedBox(height:8),
                      Text(
                        CommonStrings.strOldPassword,
                        style: CommonStyles.textFieldHeading,
                      ),
                      SizedBox(height:6),
                      TextFormField(
                        cursorColor: CommonColors.blue,
                        style: CommonStyles.textFieldHeading,
                        obscureText: isoldPasswordObscured,
                        controller: oldpasswordController,
                        autovalidateMode: AutovalidateMode.disabled,
                        decoration: InputDecoration(
                          errorMaxLines: 3,
                          suffixIcon: IconButton(
                            onPressed: toggleoldPasswordVisibility,
                            icon: Icon(
                              isoldPasswordObscured
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: isoldPasswordObscured
                                  ? CommonColors.hintGrey
                                  : CommonColors.blue,
                            ),
                          ),
                          hintText: CommonStrings.strOldPasswordHint,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 8.0),
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
                          counterText: "",
                        ),
                      ),
                      SizedBox(height:15),
                      Text(
                        CommonStrings.strNewPassword,
                        style: CommonStyles.textFieldHeading,
                      ),
                      SizedBox(height:6),
                      TextFormField(
                        cursorColor: CommonColors.blue,
                        style: CommonStyles.textFieldHeading,
                        obscureText: isPasswordObscured,
                        controller: newpasswordController,
                        autovalidateMode: AutovalidateMode.disabled,
                        decoration: InputDecoration(
                          errorMaxLines: 3,
                          suffixIcon: IconButton(
                            onPressed: togglePasswordVisibility,
                            icon: Icon(
                              isPasswordObscured
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: isPasswordObscured
                                  ? CommonColors.hintGrey
                                  : CommonColors.blue,
                            ),
                          ),
                          hintText: CommonStrings.strnewPasswordHint,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 8.0),
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
                          counterText: "",
                        ),
                      ),
                      SizedBox(height:15),
                      Text(
                        CommonStrings.strconfirmpassword,
                        style: CommonStyles.textFieldHeading,
                      ),
                    SizedBox(height:6),
                      TextFormField(
                        cursorColor: CommonColors.blue,
                        style: CommonStyles.textFieldHeading,
                        obscureText: isConfirmPasswordObscured,
                        controller: confirmpasswordController,
                        autovalidateMode: AutovalidateMode.disabled,
                        decoration: InputDecoration(
                          errorMaxLines: 3,
                          suffixIcon: IconButton(
                            onPressed: toggleConfirmPasswordVisibility,
                            icon: Icon(
                              isConfirmPasswordObscured
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: isConfirmPasswordObscured
                                  ? CommonColors.hintGrey
                                  : CommonColors.blue,
                            ),
                          ),
                          hintText: CommonStrings.strconfirmpassword,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 8.0),
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
                          counterText: "",
                        ),
                      ),
                      SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
                    ],
                  ),
                ),
              ),

              // Login button pinned at bottom
              Padding(
                padding: const EdgeInsets.only(
                    left: 16, right: 16, bottom: 12), // no insets here
                child: SafeArea(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CommonColors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () async {
                        final provider = context.read<AuthProvider>();

                        final response = await provider.resetPassword(
                          context,
                          emailOrPhone: emailController.text,
                          oldPassword: oldpasswordController.text,
                          newPassword: newpasswordController.text,
                          confirmPassword: confirmpasswordController.text,
                        );

                        if (response!.success!) {
                          // Clear cookies + force login
                          await APIManager.clearCookies();
                          showToast(provider.response!.message!);
 await AuthStorage.clearAuthData();

        GlobalLists.islLogin = false;

        await Future.delayed(const Duration(milliseconds: 100));

        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (_) => MainTab(isLoggedIn: false),
            ),
            (_) => false,
          );
        }
                        
                        } else {
                          showToast(provider.response!.message!);
                        }
                      },
                      child: authProvider.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: CommonColors.white,
                              ),
                            )
                          : Text(
                              "Reset Password",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
