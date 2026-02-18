import 'package:HyCharge/Provider/LoginProvider.dart';
import 'package:HyCharge/Screens/MainTab.dart';
import 'package:HyCharge/Utils/CommonStyles.dart';
import 'package:HyCharge/Utils/ShowDialog.dart';
import 'package:HyCharge/Utils/commoncolors.dart';
import 'package:HyCharge/Utils/commonimages.dart';
import 'package:HyCharge/Utils/commonstrings.dart';
import 'package:HyCharge/Utils/sizeConfig.dart';
import 'package:HyCharge/main.dart';
import 'package:HyCharge/widget/GlobalLists.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResetpasswordBottomSheet extends StatefulWidget {
  final String mobileNo;
  final String authToken;
 final  bool isForgetPassword;

  ResetpasswordBottomSheet(
      {super.key, required this.mobileNo, required this.authToken, required this.isForgetPassword});

  @override
  State<ResetpasswordBottomSheet> createState() => _ResetpasswordBottomSheet();
}

class _ResetpasswordBottomSheet extends State<ResetpasswordBottomSheet> {
 final BorderRadius borderRadius = const BorderRadius.all(Radius.circular(8));
  final BorderSide focusedBorder = const BorderSide(
    width: 1.0,
    color: CommonColors.blue,
  );
  final BorderSide enableBorder = BorderSide(
    width: 1.0,
    color: CommonColors.background,
  );
TextEditingController oldpasswordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();
 TextEditingController newpasswordController = TextEditingController();

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
                            child: Text(CommonStrings.strResetPassword,
                                style: CommonStyles.tsblackHeading),
                          ),
                          SizedBox(height: SizeConfig.blockSizeVertical *8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            CommonStrings.strNewPassword,
                            style: CommonStyles.textFieldHeading,
                          ),
                        ],
                      ),
                      SizedBox(height: SizeConfig.blockSizeVertical * 2),
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
                      SizedBox(height: SizeConfig.blockSizeVertical * 4),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            CommonStrings.strconfirmpassword,
                            style: CommonStyles.textFieldHeading,
                          ),
                        ],
                      ),
                      SizedBox(height: SizeConfig.blockSizeVertical * 2),
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
                                      "Reset Password",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                            ),
                          ),
                           SizedBox(height: SizeConfig.blockSizeVertical * 1.5),
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
