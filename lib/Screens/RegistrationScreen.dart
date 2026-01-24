import 'package:ev_charging_app/Provider/AuthProvider.dart';
import 'package:ev_charging_app/Request/RegisterRequest.dart';
import 'package:ev_charging_app/Screens/MainTab.dart';
import 'package:ev_charging_app/Utils/CommonStyles.dart';
import 'package:ev_charging_app/Utils/ShowDialog.dart';
import 'package:ev_charging_app/Utils/commoncolors.dart';
import 'package:ev_charging_app/Utils/commonimages.dart';
import 'package:ev_charging_app/Utils/commonstrings.dart';
import 'package:ev_charging_app/Utils/sizeConfig.dart';
import 'package:ev_charging_app/main.dart';
import 'package:ev_charging_app/widget/GlobalLists.dart';
import 'package:ev_charging_app/widget/custom_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegistrationScreen extends StatefulWidget {
  static const String route = "/login_screen";

  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
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
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();

  TextEditingController lastNameController = TextEditingController();
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
  Widget build(BuildContext context) {
    // SUCCESS

    return Consumer<AuthProvider>(builder: (context, authProvider, _) {
      // SUCCESS

      return Scaffold(
        backgroundColor: CommonColors.neutral50,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Scrollable content
              GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, top: 20),
                    child: Image.asset(CommonImagePath.back),
                  )),
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
                      Center(
                        child: Text(
                          CommonStrings.strRegistration,
                          style: CommonStyles.tsblackHeading,
                        ),
                      ),
                      SizedBox(height: SizeConfig.blockSizeVertical * 5),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextFieldWidget(
                              isMandatory: false,
                              title: CommonStrings.strfirstName,
                              hintText: CommonStrings.strfirstNameHint,
                              onChange: (val) {},
                              textEditingController: firstNameController,
                              autovalidateMode: AutovalidateMode.disabled,
                            ),
                          ),

                          SizedBox(width: 12), // spacing between fields

                          Expanded(
                            child: CustomTextFieldWidget(
                              isMandatory: false,
                              title: CommonStrings.strlastName,
                              hintText: CommonStrings.strlasttNameHint,
                              onChange: (val) {},
                              textEditingController:
                                  lastNameController, // ← fix incorrect controller
                              autovalidateMode: AutovalidateMode.disabled,
                            ),
                          ),
                        ],
                      ),
                      CustomTextFieldWidget(
                        isMandatory: false,
                        title: CommonStrings.strEmail,
                        hintText: CommonStrings.strEmailHint,
                        onChange: (val) {},
                        textEditingController: emailController,
                        autovalidateMode: AutovalidateMode.disabled,
                      ),
                      SizedBox(height: SizeConfig.blockSizeVertical * 2),
                      Text(
                        CommonStrings.strPassword,
                        style: CommonStyles.textFieldHeading,
                      ),
                      SizedBox(height: SizeConfig.blockSizeVertical * 1),
                      TextFormField(
                        cursorColor: CommonColors.blue,
                        style: CommonStyles.textFieldHeading,
                        obscureText: isPasswordObscured,
                        controller: passwordController,
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
                          hintText: CommonStrings.strPasswordHint,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 16.0),
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
                      SizedBox(height: SizeConfig.blockSizeVertical * 2),
                      Text(
                        CommonStrings.strconfirmpassword,
                        style: CommonStyles.textFieldHeading,
                      ),
                      SizedBox(height: SizeConfig.blockSizeVertical * 1),
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
                              vertical: 10.0, horizontal: 16.0),
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
                        // Login logic
final request = RegisterRequest(
  firstName: firstNameController.text.trim(),
  lastName: lastNameController.text.trim(),
  eMailID: emailController.text.trim(),
  phoneNumber: "9029635200",
  countryCode: "",
  password: passwordController.text.trim(),
  confirmPassword: confirmpasswordController.text.trim(),
  addressLine1: "",
  addressLine2: "",
  addressLine3: "",
  state: "",
  city: "",
  pinCode: "",
);

bool success = await context.read<AuthProvider>().register(context, request);

if (success) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    showToast("Registration Successful");
    Navigator.pushReplacement(
      routeGlobalKey.currentContext!,
      MaterialPageRoute(
        builder: (context) => MainTab(isLoggedIn: GlobalLists.islLogin),
      ),
    );
  });
}

                      },
                      child: authProvider.isLoading
                          ? CircularProgressIndicator(
                              color: CommonColors.white,
                            )
                          : Text(
                              "Create an account",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "By continuing, you agree to our ",
                        style: TextStyle(
                            fontSize: 14,
                            color: CommonColors.black,
                            fontWeight: FontWeight.w400),
                      ),
                      TextSpan(
                        text: "Terms of Service ",
                        style: TextStyle(
                            fontSize: 14,
                            decoration: TextDecoration.underline, // 👈 add this
                            decorationColor: CommonColors
                                .skyBlue, // optional (same color underline)
                            decorationThickness: 2,
                            color: CommonColors.skyBlue,
                            fontWeight: FontWeight.w400),
                      ),
                      TextSpan(
                        text: "and ",
                        style: TextStyle(
                            color: CommonColors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                      TextSpan(
                        text: "Privacy Policy ",
                        style: TextStyle(
                            fontSize: 14,
                            color: CommonColors.skyBlue,
                            decoration: TextDecoration.underline, // 👈 add this
                            decorationColor: CommonColors
                                .skyBlue, // optional (same color underline)
                            decorationThickness: 2,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
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
