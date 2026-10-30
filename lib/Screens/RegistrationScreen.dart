import 'package:HyCharge/Provider/AuthProvider.dart';
import 'package:HyCharge/Request/RegisterRequest.dart';
import 'package:HyCharge/Screens/MainTab.dart';
import 'package:HyCharge/Screens/Vehicle/MyVehicleScreen.dart';
import 'package:HyCharge/Screens/auth/login_bottom_sheet.dart';
import 'package:HyCharge/Services/pdf_viewer_screen.dart';
import 'package:HyCharge/Utils/CommonStyles.dart';
import 'package:HyCharge/Utils/ShowDialog.dart';
import 'package:HyCharge/Utils/commoncolors.dart';
import 'package:HyCharge/Utils/commonimages.dart';
import 'package:HyCharge/Utils/commonstrings.dart';
import 'package:HyCharge/Utils/extentions.dart';
import 'package:HyCharge/Utils/regex_helper.dart';
import 'package:HyCharge/Utils/sizeConfig.dart';
import 'package:HyCharge/main.dart';
import 'package:HyCharge/widget/CommonButton.dart';
import 'package:HyCharge/widget/GlobalLists.dart';
import 'package:HyCharge/widget/custom_text_field_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  TextEditingController mobileController = TextEditingController();
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
final normalBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
    borderSide: const BorderSide(
      color: Color(0xFFDCE2EC),
      width: 1,
    ),
  );

  final focusedInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(16),
    borderSide: BorderSide(
      color: CommonColors.blue,
      width: 1.4,
    ),
  );

    return Consumer<AuthProvider>(builder: (context, authProvider, _) {
      // SUCCESS

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
          resizeToAvoidBottomInset: true,
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Scrollable content
                GestureDetector(
                    onTap: () {
                      //      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              MainTab(isLoggedIn: GlobalLists.islLogin),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16, top: 20),
                      child: SvgPicture.asset(CommonImagePath.back),
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
                        // Center(
                        //   child: Text(
                        //     CommonStrings.strRegistration,
                        //     style: CommonStyles.tsblackHeading,
                        //   ),
                        // ),
                        Padding(
    padding: const EdgeInsets.only(top: 12, bottom: 20),
    child: const Text( CommonStrings.strRegistration,textAlign: TextAlign.center, style: LoginText.title),
  ),
                        SizedBox(height: 20),
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
                        16.0.heightBox,
                        CustomTextFieldWidget(
                          title: CommonStrings.strMobileNo,
                          isMandatory: false,
                          hintText: CommonStrings.strPhoneNumberHint,
                          textEditingController: mobileController,
                          textInputType: TextInputType.text,
        
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          // textInputType: const TextInputType.numberWithOptions(
                          //   signed: false,
                          //   decimal: false,
                          // ),
                          // inputFormatters: [
                          //   LengthLimitingTextInputFormatter(10),
                          //   FilteringTextInputFormatter.allow(
                          //       RegExp(RegexHelper().numberOnlyRegex)),
                          // ],
                        ),
                        16.0.heightBox,
                        CustomTextFieldWidget(
                          isMandatory: false,
                          title: CommonStrings.strEmail,
                          hintText: CommonStrings.strEmailHint,
                          onChange: (val) {},
                          textEditingController: emailController,
                          autovalidateMode: AutovalidateMode.disabled,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Text(
                            CommonStrings.strPassword,
                            style: CommonStyles.textFieldHeading,
                          ),
                        ),
                       8.0.heightBox,
                        // TextFormField(
                        //   cursorColor: CommonColors.blue,
                        //   style: CommonStyles.textFieldHeading,
                        //   obscureText: isPasswordObscured,
                        //   controller: passwordController,
                        //   autovalidateMode: AutovalidateMode.disabled,
                        //   decoration: InputDecoration(
                        //     errorMaxLines: 3,
                        //     suffixIcon: IconButton(
                        //       onPressed: togglePasswordVisibility,
                        //       icon: Icon(
                        //         isPasswordObscured
                        //             ? Icons.visibility_off
                        //             : Icons.visibility,
                        //         color: isPasswordObscured
                        //             ? CommonColors.hintGrey
                        //             : CommonColors.blue,
                        //       ),
                        //     ),
                        //     hintText: CommonStrings.strPasswordHint,
                        //     contentPadding: const EdgeInsets.symmetric(
                        //         vertical: 10.0, horizontal: 8.0),
                        //     border: OutlineInputBorder(
                        //         borderRadius: borderRadius,
                        //         borderSide: enableBorder),
                        //     focusedBorder: OutlineInputBorder(
                        //         borderRadius: borderRadius,
                        //         borderSide: focusedBorder),
                        //     enabledBorder: OutlineInputBorder(
                        //         borderRadius: borderRadius,
                        //         borderSide: enableBorder),
                        //     filled: true,
                        //     fillColor: CommonColors.white,
                        //     hintStyle: CommonStyles.textFieldHint,
                        //     errorStyle: CommonStyles.textFieldHint,
                        //     counterText: "",
                        //   ),
                        // ),
                         TextFormField(
                    
                    obscureText: isPasswordObscured,
                    controller: passwordController,
                    cursorColor: CommonColors.blue,
                    style: CommonStyles.textFieldHeading,
                    decoration: InputDecoration(
                      hintText: CommonStrings.strPasswordHint,
                      hintStyle: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF939BAD),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 16,
                      ),
                    
                      border: normalBorder,
                      enabledBorder: normalBorder,
                      focusedBorder: focusedInputBorder,
                      filled: true,
                      fillColor: Colors.white,
                     
                      errorStyle: CommonStyles.textFieldHint,
                        suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isPasswordObscured =
                                !isPasswordObscured;
                          });
                        },
                        icon: Icon(
                          isPasswordObscured
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: isPasswordObscured
                              ? CommonColors.hintGrey
                              : CommonColors.blue,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                        16.0.heightBox,
                        Text(
                          CommonStrings.strconfirmpassword,
                          style: CommonStyles.textFieldHeading,
                        ),
                         8.0.heightBox,
                        
TextFormField(
  obscureText: isConfirmPasswordObscured,
  controller: confirmpasswordController,
  cursorColor: CommonColors.blue,
  style: CommonStyles.textFieldHeading,
  autovalidateMode: AutovalidateMode.disabled,
  decoration: InputDecoration(
    hintText: CommonStrings.strconfirmpassword,
    hintStyle: const TextStyle(
      fontSize: 13,
      color: Color(0xFF939BAD),
    ),
    contentPadding: const EdgeInsets.symmetric(
      vertical: 16,
      horizontal: 16,
    ),
    border: normalBorder,
    enabledBorder: normalBorder,
    focusedBorder: focusedInputBorder,
    filled: true,
    fillColor: Colors.white,
    errorStyle: CommonStyles.textFieldHint,
    errorMaxLines: 3,
    counterText: '',
    suffixIcon: IconButton(
      onPressed: toggleConfirmPasswordVisibility,
      icon: Icon(
        isConfirmPasswordObscured
            ? Icons.visibility_off_outlined
            : Icons.visibility_outlined,
        color: isConfirmPasswordObscured
            ? CommonColors.hintGrey
            : CommonColors.blue,
        size: 20,
      ),
    ),
  ),
),

                        // TextFormField(
                          
                        //   cursorColor: CommonColors.blue,
                        //   style: CommonStyles.textFieldHeading,
                        //   obscureText: isConfirmPasswordObscured,
                        //   controller: confirmpasswordController,
                        //   autovalidateMode: AutovalidateMode.disabled,
                        //   decoration: InputDecoration(
                        //     errorMaxLines: 3,
                        //     suffixIcon: IconButton(
                        //       onPressed: toggleConfirmPasswordVisibility,
                        //       icon: Icon(
                        //         isConfirmPasswordObscured
                        //             ? Icons.visibility_off
                        //             : Icons.visibility,
                        //         color: isConfirmPasswordObscured
                        //             ? CommonColors.hintGrey
                        //             : CommonColors.blue,
                        //       ),
                        //     ),
                        //     hintText: CommonStrings.strconfirmpassword,
                        //     contentPadding: const EdgeInsets.symmetric(
                        //         vertical: 10.0, horizontal: 8.0),
                        //     border: OutlineInputBorder(
                        //         borderRadius: borderRadius,
                        //         borderSide: enableBorder),
                        //     focusedBorder: OutlineInputBorder(
                        //         borderRadius: borderRadius,
                        //         borderSide: focusedBorder),
                        //     enabledBorder: OutlineInputBorder(
                        //         borderRadius: borderRadius,
                        //         borderSide: enableBorder),
                        //     filled: true,
                        //     fillColor: CommonColors.white,
                        //     hintStyle: CommonStyles.textFieldHint,
                        //     errorStyle: CommonStyles.textFieldHint,
                        //     counterText: "",
                        //   ),
                        // ),
                        SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
                      ],
                    ),
                  ),
                ),
        
                // Login button pinned at bottom
                Padding(
  padding: const EdgeInsets.only(
    left: 16,
    right: 16,
    bottom: 12,
  ),
  child: SafeArea(
    child: CommonButton(
      title: "Create an account",
      isLoading: authProvider.isLoading,
      onPressed: () async {
        FocusManager.instance.primaryFocus?.unfocus();
 // Login logic
                          final request = RegisterRequest(
                            firstName: firstNameController.text.trim(),
                            lastName: lastNameController.text.trim(),
                            eMailID: emailController.text.trim(),
                            phoneNumber: mobileController.text,
                            countryCode: "",
                            password: passwordController.text.trim(),
                            confirmPassword:
                                confirmpasswordController.text.trim(),
                            addressLine1: "",
                            addressLine2: "",
                            addressLine3: "",
                            state: "",
                            city: "",
                            pinCode: "",
                          );
                          final provider = context.read<AuthProvider>();
        
                          bool success =
                              await provider.register(context, request);
        // bool success = await context.read<AuthProvider>().register(context, request);
        
                          if (success) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              FocusScope.of(context).unfocus();
                              showToast("${provider.message}");
                              Navigator.pushReplacement(
                                routeGlobalKey.currentContext!,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      MainTab(isLoggedIn: GlobalLists.islLogin),
                                ),
                              );
                            });
                          }
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //     builder: (_) => VehicleSelectionScreen(
        //       isVehicleAdded: false,
        //     ),
        //   ),
        // );
      },
    ),
  ),
),
  //               Padding(
  //                 padding: const EdgeInsets.only(
  //                     left: 16, right: 16, bottom: 12), // no insets here
  //                 child: SafeArea(
  //                   child: SizedBox(
                      
  //                 height: 50,
  //                     width: double.infinity,
  //                     child: ElevatedButton(
  //                       style: ElevatedButton.styleFrom(
  //                     backgroundColor: const Color(0xFF142D78),
  //                     foregroundColor: Colors.white,
  //                     elevation: 0,
  //                     padding: const EdgeInsets.symmetric(
  //                       vertical: 10,
  //                     ),
  //                     shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(20),
  //                     ),
  //                   ),
  //                       // style: ElevatedButton.styleFrom(
  //                       //   backgroundColor: CommonColors.blue,
  //                       //   padding: const EdgeInsets.symmetric(vertical: 12),
  //                       //   shape: RoundedRectangleBorder(
  //                       //     borderRadius: BorderRadius.circular(8),
  //                       //   ),
  //                       // ),
  //                       onPressed: () async {
  //                         FocusManager.instance.primaryFocus?.unfocus();
  //        Navigator.pushReplacement(
  //   context,
  //   MaterialPageRoute(
  //     builder: (_) => 
  //    VehicleSelectionScreen(isVehicleAdded: false,)
  //     //  MainTab(isLoggedIn: loggedIn),
  //   ),
  // );
                          
  //                       },
  //                       child: authProvider.isLoading
  //                           ? const SizedBox(
  //                               height: 20,
  //                               width: 20,
  //                               child: CircularProgressIndicator(
  //                                 strokeWidth: 2.5,
  //                                 color: CommonColors.white,
  //                               ),
  //                             )
  //                           : Text(
  //                               "Create an account",
  //                               style: TextStyle(
  //                                   fontSize: 16,
  //                                   color: Colors.white,
  //                                   fontWeight: FontWeight.bold),
  //                             ),
  //                     ),
  //                   ),
  //                 ),
  //               ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "By continuing, you agree to our ",
                          style: TextStyle(
                              fontSize: 12,
                              height: 1.5,
                              color: CommonColors.greyText,
                              fontWeight: FontWeight.w400,
                            ),
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
                                          color: CommonColors.blue,
                                          width: 1,
                                        ),
                                      ),
                                    ),
                              child: const Text(
                                "Terms of Service ",
                               style: LoginText.input,
                              ),
                            ),
                          ),
                        ),
                        TextSpan(
                          text: "and ",
                         style: TextStyle(
                              fontSize: 12,
                              height: 1.5,
                              color: CommonColors.greyText,
                              fontWeight: FontWeight.w400,
                            ),
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
                                          color: CommonColors.blue,
                                          width: 1,
                                        ),
                                      ),
                                    ),
                              child: const Text(
                                "Privacy Policy ",
                               style: LoginText.input,
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
          ),
        ),
      );
    });
  }
}
