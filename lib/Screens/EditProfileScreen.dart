import 'dart:io';

import 'package:HyCharge/Provider/FileUploadProvider.dart';
import 'package:HyCharge/Provider/ImageCacheProvider.dart';
import 'package:HyCharge/Provider/ProfileProvider.dart';
import 'package:HyCharge/Utils/CommonAppBar.dart';
import 'package:HyCharge/Utils/ImageHelper.dart';
import 'package:HyCharge/Utils/ShowDialog.dart';
import 'package:HyCharge/Utils/commoncolors.dart';
import 'package:HyCharge/Utils/commonimages.dart';
import 'package:HyCharge/Utils/extentions.dart';
import 'package:HyCharge/model/ProfileResponse.dart';
import 'package:HyCharge/model/UploadResponse.dart';
import 'package:HyCharge/widget/CommonButton.dart';
import 'package:HyCharge/widget/custom_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  final UserProfile? user;
  const EditProfileScreen({super.key,  this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController addressController;

  @override
  void initState() {
    super.initState();
if(widget.user!=null)
{
 firstNameController =
        TextEditingController(text: widget.user!.firstName ?? "");
    lastNameController =
        TextEditingController(text: widget.user!.lastName ?? "");
    emailController =
        TextEditingController(text: widget.user!.email ?? "");
    phoneController =
        TextEditingController(text: widget.user!.phoneNumber ?? "");
    addressController = TextEditingController(
      text:
          "${widget.user!.addressLine1 ?? ''} "
         
    );
}
   
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CommonColors.neutral50,
      appBar: CommonAppBar(title: "Edit Profile"),
      bottomNavigationBar: Container(
  decoration: const BoxDecoration(
    color: CommonColors.cardWhite,
    border: Border(
      top: BorderSide(color: Color(0xFFE1E5EB), width: 1), // outlineVariant divider
    ),
  ),
  padding: const EdgeInsets.only(left: 24, right: 24, top: 12, bottom: 12),
  child: _updateButton(context),
),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _profileImage(),
            // const SizedBox(height: 10),

            // _inputField("First Name",true, firstNameController,),
            // 16.0.heightBox,

            // _inputField("Last Name",true, lastNameController),
              const SizedBox(height: 20),
            Row(
  children: [
    Expanded(
      child: _inputField(
        "First Name",
        true,
        firstNameController,
      ),
    ),
    const SizedBox(width: 12),
    Expanded(
      child: _inputField(
        "Last Name",
        true,
        lastNameController,
      ),
    ),
  ],
),
16.0.heightBox,
            //  16.0.heightBox,
           
            _inputField("Email",true, emailController),
             16.0.heightBox,
          

            _inputField("Address",false, addressController, maxLines: 3),
             16.0.heightBox,
            
            _inputField("Phone Number", true,phoneController),
           
 const SizedBox(height: 10),

         
          ],
        ),
      ),
    );
  }

  // 🔹 Profile Image UI
  Widget _profileImage() {
    return    GestureDetector(
                      onTap: () async {
                        final File? file = await pickProfileImage(context);
                        final uploadProvider = context.read<UploadProvider>();

                        final UploadResponse? resultResponse =
                            await uploadProvider.upload(file: file!,isDP: true);

                        if (resultResponse?.success == true) {
                          print("✅ Uploaded: ${resultResponse!.fileId}");
                          final provider = context.read<ProfileProvider>();
                          FocusScope.of(context).unfocus();
 showToast("${resultResponse?.message}");
                         
                             context.read<UploadProvider>().setImage(file);
                         
                        } else {
                          print("❌ Upload failed: ${resultResponse?.message}");
                        }


                      },
                      child: Consumer<UploadProvider>(
                        builder: (_, provider, __) {
                          return Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Consumer2<UploadProvider, ImageCacheProvider>(
                                builder: (_, upload, cache, __) {
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(60),
                                    child: upload.selectedImage != null
                                        ? Image.file(
                                            upload.selectedImage!,
                                            width: 120,
                                            height: 120,
                                            fit: BoxFit.cover,
                                          )
                                        : cache.image != null
                                            ? Image.memory(
                                                cache.image!,
                                                width: 120,
                                                height: 120,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  CommonImagePath.profileIcon,
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                );
              },
                                              )
                                            : Image.asset(
                                                CommonImagePath.profileIcon,
                                                width: 120,
                                                height: 120,
                                                fit: BoxFit.cover,
                                              ),
                                  );
                                },
                              ),
                              Positioned(
                                bottom: -4,
                                right: -4,
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: CommonColors.neutral50,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.white, width: 3),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Image.asset(CommonImagePath.edit),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    );
    // Stack(
    //   clipBehavior: Clip.none,
    //   children: [
    //     ClipRRect(
    //       borderRadius: BorderRadius.circular(60),
    //       child: Image.asset(
    //         CommonImagePath.profileImage,
    //         width: 120,
    //         height: 120,
    //         fit: BoxFit.cover,
    //       ),
    //     ),
    //     Positioned(
    //       bottom: -4,
    //       right: -4,
    //       child: Container(
    //         width: 40,
    //         height: 40,
    //         decoration: BoxDecoration(
    //           color: CommonColors.neutral200,
    //           shape: BoxShape.circle,
    //           border: Border.all(color: Colors.white, width: 3),
    //         ),
    //         child: Image.asset(CommonImagePath.edit),
    //       ),
    //     ),
    //   ],
    // );
  }

  // 🔹 TextField
  Widget _inputField(
    String label,
    bool isMandatory,
    TextEditingController controller, {
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       
        CustomTextFieldWidget(
          fillColor: CommonColors.white,
          textFieldLines: maxLines,
         
                        isMandatory: isMandatory,
                        title:label,
                        hintText: "",
                        onChange: (val) {},
                        textEditingController: controller,
                        autovalidateMode: AutovalidateMode.disabled,
                      ),
      ],
    );
  }
Widget _updateButton(BuildContext context) {
  return 
   CommonButton(
      title: "Update",
     
       onPressed: () async {
          final provider = context.read<ProfileProvider>();

          final success = await provider.updateProfile(
            context,
            body: {
              "firstName": firstNameController.text.trim(),
              "lastName": lastNameController.text.trim(),
              "eMailID": emailController.text.trim(),
              "phoneNumber": phoneController.text.trim(),
              "countryCode": "+91",
              "addressLine1": addressController.text.trim(),
                        "addressLine2": "",
                                  "addressLine3": "",
            },
          );

          if (success) {
            FocusScope.of(context).unfocus();
            showToast("${provider.message}");
            // ScaffoldMessenger.of(context).showSnackBar(
            //   const SnackBar(content: Text("Profile updated successfully")),
            // );
            Navigator.pop(context);
          }
        },
    );
  // SizedBox(
  //   height: 56,
  //   width: double.infinity,
  //   child: FilledButton(
  //     style: FilledButton.styleFrom(
  //       backgroundColor: const Color(0xFF0F2669),        // primary navy
  //       foregroundColor: Colors.white,                   // primary-foreground
  //       elevation: 0,
  //       padding: EdgeInsets.zero,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(16),       // radius 16
  //       ),
  //       textStyle: const TextStyle(
  //         fontSize: 15,
  //         fontWeight: FontWeight.w600,
  //         fontFamily: 'Poppins',
  //       ),
  //     ),
  //     onPressed: () async {
  //         final provider = context.read<ProfileProvider>();

  //         final success = await provider.updateProfile(
  //           context,
  //           body: {
  //             "firstName": firstNameController.text.trim(),
  //             "lastName": lastNameController.text.trim(),
  //             "eMailID": emailController.text.trim(),
  //             "phoneNumber": phoneController.text.trim(),
  //             "countryCode": "+91",
  //             "addressLine1": addressController.text.trim(),
  //                       "addressLine2": "",
  //                                 "addressLine3": "",
  //           },
  //         );

  //         if (success) {
  //           FocusScope.of(context).unfocus();
  //           showToast("${provider.message}");
  //           // ScaffoldMessenger.of(context).showSnackBar(
  //           //   const SnackBar(content: Text("Profile updated successfully")),
  //           // );
  //           Navigator.pop(context);
  //         }
  //       },
  //     child: const Text('Update'),
  //   ),
  // );
}

  // 🔹 Update Button
  // Widget _updateButton(BuildContext context) {
  //   return SizedBox(
  //     width: double.infinity,
  //     child: ElevatedButton(
  //       style: ElevatedButton.styleFrom(
  //         backgroundColor: CommonColors.blue,
  //         padding: const EdgeInsets.symmetric(vertical: 14),
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(8),
  //         ),
  //       ),
  //       onPressed: () async {
  //         final provider = context.read<ProfileProvider>();

  //         final success = await provider.updateProfile(
  //           context,
  //           body: {
  //             "firstName": firstNameController.text.trim(),
  //             "lastName": lastNameController.text.trim(),
  //             "eMailID": emailController.text.trim(),
  //             "phoneNumber": phoneController.text.trim(),
  //             "countryCode": "+91",
  //             "addressLine1": addressController.text.trim(),
  //                       "addressLine2": "",
  //                                 "addressLine3": "",
  //           },
  //         );

  //         if (success) {
  //           FocusScope.of(context).unfocus();
  //           showToast("${provider.message}");
  //           // ScaffoldMessenger.of(context).showSnackBar(
  //           //   const SnackBar(content: Text("Profile updated successfully")),
  //           // );
  //           Navigator.pop(context);
  //         }
  //       },
  //       child: const Text(
  //         "Update",
  //         style: TextStyle(
  //           fontSize: 16,
  //           color: Colors.white,
  //           fontWeight: FontWeight.bold,
  //         ),
  //       ),
  //     ),
  //   );
  // }
}


