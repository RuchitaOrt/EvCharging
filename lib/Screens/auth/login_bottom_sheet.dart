import 'package:ev_charging_app/Provider/LoginProvider.dart';
import 'package:ev_charging_app/Request/LoginRequest.dart';
import 'package:ev_charging_app/Screens/MainTab.dart';
import 'package:ev_charging_app/Screens/Map/MapScreen.dart';
import 'package:ev_charging_app/Screens/RegistrationScreen.dart';
import 'package:ev_charging_app/Utils/CommonStyles.dart';
import 'package:ev_charging_app/Utils/ShowDialog.dart';
import 'package:ev_charging_app/Utils/ValidationHelper.dart';
import 'package:ev_charging_app/Utils/commoncolors.dart';
import 'package:ev_charging_app/Utils/commonimages.dart';
import 'package:ev_charging_app/Utils/commonstrings.dart';
import 'package:ev_charging_app/widget/GlobalLists.dart';
import 'package:ev_charging_app/widget/custom_text_field_widget.dart';
import 'package:flutter/material.dart';

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


  void _toggleRememberMe(bool? value) {
    setState(() {
      _rememberMe = value ?? false;
    });
  }

  final BorderRadius borderRadius = const BorderRadius.all(Radius.circular(8));
  final BorderSide focusedBorder = const BorderSide(width: 1.0,color: CommonColors.blue,);
  final BorderSide enableBorder = BorderSide(width: 1.0,
  color: CommonColors.background,);
 
 TextEditingController passwordController=TextEditingController();
  
  TextEditingController phoneNameController = TextEditingController();
    bool isPasswordObscured = true;

  void togglePasswordVisibility() {
    setState(() {
      isPasswordObscured = !isPasswordObscured;
    });
    
  }
  Future<void> _login() async {
 final emailOrPhone = _phoneEmailController.text.trim();
  final password = _passwordController.text.trim();
 if (!ValidationHelper.isNotEmpty(emailOrPhone)) {
    showToast("Please enter email");
    return;
  }

  if (!ValidationHelper.isEmailValid(emailOrPhone)) {
    showToast("Please enter a valid email address");
    return;
  }

  if (!ValidationHelper.isPasswordValid(password)) {
    showToast("Password must be at least 6 characters");
    return;
  }

  if (!_rememberMe) {
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
          MaterialPageRoute(builder: (_) => MainTab(isLoggedIn: true,)),
        );
      }else if(loginProvider.loginResponse?.success==false)
      {
 showToast(loginProvider.loginResponse!.message);
      } else if (loginProvider.error != null) {
        showToast(loginProvider.error.toString());
      } else {
        showToast("Unknown error occurred");
      }
    } catch (e) {
      loginProvider.setLoading(false);
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
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
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

                // Email/Phone
                CustomTextFieldWidget(
                  title: "",
                  isMandatory: false,
                  hintText: CommonStrings.strEmailHint,
                  textEditingController: _phoneEmailController,
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
                            onPressed: ()
                            {
                            setState(() {
                              isPasswordObscured = !isPasswordObscured;
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
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                          border: OutlineInputBorder(
                              borderRadius: borderRadius, borderSide: enableBorder),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: borderRadius, borderSide: focusedBorder),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: borderRadius, borderSide: enableBorder),
                          filled: true,
                          fillColor: CommonColors.white,
                          hintStyle: CommonStyles.textFieldHint,
                          errorStyle: CommonStyles.textFieldHint,
                        ),
                      ),

        
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
                    const Expanded(
                      child: Text(
                        "I agree to the terms and Conditions and Privacy Policy",
                        style: TextStyle(fontSize: 10),
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
                          text: "Sign Up",
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

                const SizedBox(height: 15),

                // Login Button / Loader
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CommonColors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: loginProvider.isLoading ? null : _login,
                    child: loginProvider.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
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
}
