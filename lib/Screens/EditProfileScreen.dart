import 'package:ev_charging_app/Provider/ProfileProvider.dart';
import 'package:ev_charging_app/Utils/CommonAppBar.dart';
import 'package:ev_charging_app/Utils/ShowDialog.dart';
import 'package:ev_charging_app/Utils/commoncolors.dart';
import 'package:ev_charging_app/Utils/commonimages.dart';
import 'package:ev_charging_app/model/ProfileResponse.dart';
import 'package:ev_charging_app/widget/custom_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  final UserProfile user;
  const EditProfileScreen({super.key, required this.user});

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

    firstNameController =
        TextEditingController(text: widget.user.firstName ?? "");
    lastNameController =
        TextEditingController(text: widget.user.lastName ?? "");
    emailController =
        TextEditingController(text: widget.user.email ?? "");
    phoneController =
        TextEditingController(text: widget.user.phoneNumber ?? "");
    addressController = TextEditingController(
      text:
          "${widget.user.addressLine1 ?? ''} "
          "${widget.user.addressLine2 ?? ''} "
          "${widget.user.addressLine3 ?? ''}",
    );
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _profileImage(),
            const SizedBox(height: 10),

            _inputField("First Name", firstNameController),
            

            _inputField("Last Name", lastNameController),
           
            _inputField("Email", emailController),
          

            _inputField("Address *", addressController, maxLines: 3),
            
            _inputField("Phone Number", phoneController),
           
 const SizedBox(height: 10),

            _updateButton(context),
          ],
        ),
      ),
    );
  }

  // 🔹 Profile Image UI
  Widget _profileImage() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(60),
          child: Image.asset(
            CommonImagePath.profileImage,
            width: 120,
            height: 120,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          bottom: -4,
          right: -4,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: CommonColors.neutral200,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
            ),
            child: Image.asset(CommonImagePath.edit),
          ),
        ),
      ],
    );
  }

  // 🔹 TextField
  Widget _inputField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        // const SizedBox(height: 8),
        // TextField(
        //   controller: controller,
        //   maxLines: maxLines,
        //   decoration: InputDecoration(
        //     filled: true,
        //     fillColor: CommonColors.neutral50,
        //     contentPadding: const EdgeInsets.all(12),
        //     border: OutlineInputBorder(
        //       borderRadius: BorderRadius.circular(10),
        //     ),
        //   ),
        // ),

        CustomTextFieldWidget(
          textFieldLines: maxLines,
          fillColor:  CommonColors.neutral50,
                        isMandatory: false,
                        title:label,
                        hintText: "",
                        onChange: (val) {},
                        textEditingController: controller,
                        autovalidateMode: AutovalidateMode.disabled,
                      ),
      ],
    );
  }

  // 🔹 Update Button
  Widget _updateButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: CommonColors.blue,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
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
            },
          );

          if (success) {
            showToast("Profile updated successfully");
            // ScaffoldMessenger.of(context).showSnackBar(
            //   const SnackBar(content: Text("Profile updated successfully")),
            // );
            Navigator.pop(context);
          }
        },
        child: const Text(
          "Update",
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}


// class EditProfileScreen extends StatelessWidget {
//   final UserProfile user;
//   const EditProfileScreen({super.key, required this.user});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//      backgroundColor: CommonColors.neutral50,
      
//     appBar:
//       CommonAppBar(title: "Edit Profile",),
      
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             // Profile Image + Edit Icon
//           Stack(
//   clipBehavior: Clip.none, // allows edit button to overflow
//   children: [
//     // Profile Image
//     ClipRRect(
//       borderRadius: BorderRadius.circular(60), // make circular
//       child: Image.asset(
//         CommonImagePath.profileImage,
//         width: 120,
//         height: 120,
//         fit: BoxFit.cover,
//       ),
//     ),

//     // Edit Icon bottom-right
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
//         child: Image.asset(CommonImagePath.edit)
//       ),
//     ),
//   ],
// ),
//             const SizedBox(height: 30),

//             _inputField("Full Name", "${user.firstName ?? ''} ${user.lastName ?? ''}"),
//             const SizedBox(height: 20),

//             _inputField("Address *","${user.addressLine1 ?? ''} ${user.addressLine2 ?? ''} ${user.addressLine3 ?? ''}"),
//             const SizedBox(height: 20),

//             _inputField("Phone Number", "${user.phoneNumber ?? ''}"),
//             SizedBox(height: 30,),
//                  Align(
//                   alignment: Alignment.bottomCenter,
//                    child: Padding(
//                          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12), // no insets here
//                          child: SafeArea(
//                            child: SizedBox(
//                              width: double.infinity,
//                              child: ElevatedButton(
//                                style: ElevatedButton.styleFrom(
//                                  backgroundColor:  CommonColors.blue,
//                                  padding: const EdgeInsets.symmetric(vertical: 12),
//                                  shape: RoundedRectangleBorder(
//                                    borderRadius: BorderRadius.circular(8),
//                                  ),
//                                ),
//                                onPressed: () async {
//                                  // Login logic
                                  
//                                    final provider = context.read<ProfileProvider>();

// final success = await provider.updateProfile(
//   context,
//   body: {
//     "firstName": firstNameController.text,
//     "lastName": lastNameController.text,
//     "eMailID": emailController.text,
//     "phoneNumber": phoneController.text,
//     "countryCode": "+91",
//     "addressLine1": address1.text,
//     "city": city.text,
//     "pinCode": pincode.text,
//   },
// );

// if (success) {
//   ScaffoldMessenger.of(context).showSnackBar(
//     const SnackBar(content: Text("Profile updated successfully")),
//   );
//   Navigator.pop(context);
// }

                   
//                                },
//                                child: Text(
//                                  "Update",
//                                  style: TextStyle(fontSize: 16, color: Colors.white,fontWeight: FontWeight.bold),
//                                ),
//                              ),
//                            ),
//                          ),
//                          ),
//                  ),
//           ],
//         ),
//       ),
//     );
//   }
//   Widget _inputField(String label, String value) {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
//       const SizedBox(height: 8),
//    TextField(
    
//   maxLines: label == "Address *" ? 3 : 1,
//   decoration: InputDecoration(
//     filled: true,
//     fillColor: CommonColors.neutral50,
//     contentPadding: const EdgeInsets.all(12),

//     enabledBorder: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(10),
//       borderSide: BorderSide(
//         color: Colors.grey.withOpacity(0.25), // very light border
//         width: 1,
//       ),
//     ),

//     focusedBorder: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(10),
//       borderSide: BorderSide(
//         color: Colors.grey.withOpacity(0.50), // slightly stronger on focus
//         width: 1,
//       ),
//     ),

//     border: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(10),
//       borderSide: BorderSide(
//         color: Colors.grey.withOpacity(0.25),
//         width: 1,
//       ),
//     ),
//   ),
//   controller: TextEditingController(text: value),
// )

//     ],
//   );
// }
// }
