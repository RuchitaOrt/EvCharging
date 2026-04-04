import 'dart:io';

import 'package:HyCharge/Provider/AuthProvider.dart';
import 'package:HyCharge/Provider/DeleteAccountProvider.dart';
import 'package:HyCharge/Provider/FileUploadProvider.dart';
import 'package:HyCharge/Provider/ImageCacheProvider.dart';
import 'package:HyCharge/Provider/ProfileProvider.dart';
import 'package:HyCharge/Screens/ChargingEstimateScreen.dart';
import 'package:HyCharge/Screens/ChargingHistoryScreen.dart';
import 'package:HyCharge/Screens/EditProfileScreen.dart';
import 'package:HyCharge/Screens/MainTab.dart';
import 'package:HyCharge/Screens/MyVehicleScreen.dart';
import 'package:HyCharge/Screens/NotificationScreen.dart';
import 'package:HyCharge/Screens/ResetPassword.dart';
import 'package:HyCharge/Screens/SupportScreen.dart';
import 'package:HyCharge/Utils/APIManager.dart';
import 'package:HyCharge/Utils/CommonAppBar.dart';
import 'package:HyCharge/Utils/ImageHelper.dart';
import 'package:HyCharge/Utils/InternetConnection.dart';
import 'package:HyCharge/Utils/ShowDialog.dart';
import 'package:HyCharge/Utils/commoncolors.dart';
import 'package:HyCharge/Utils/commonimages.dart';
import 'package:HyCharge/main.dart';
import 'package:HyCharge/model/UploadResponse.dart';
import 'package:HyCharge/widget/GlobalLists.dart';
import 'package:HyCharge/widget/LogoutConfirmationSheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   context.read<ProfileProvider>().loadProfile(context);
    // });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final profileProvider = context.read<ProfileProvider>();
      await profileProvider.loadProfile(context);

      final imageId = profileProvider.profile?.user?.profileImageID;
      print(imageId);
      context.read<ImageCacheProvider>().loadProfileImage(imageId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProfileProvider>();

    final user = provider.profile?.user;
    return Scaffold(
      backgroundColor: CommonColors.neutral50,
      appBar: CommonAppBar(
        title: "Profile",
        onBack: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    MainTab(isLoggedIn: GlobalLists.islLogin)),
          );
        },
      ),
      body: provider.loading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
              child: Column(children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                  decoration: BoxDecoration(
                      color: CommonColors.neutral50,
                      borderRadius: BorderRadius.circular(12)),
                  child: Column(children: [
                    GestureDetector(
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
                    ),
                    const SizedBox(height: 10),
                    Text("${user?.firstName ?? ''} ${user?.lastName ?? ''}",
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    Text("${user?.email ?? ''} • ${user?.phoneNumber ?? ''}",
                        style: TextStyle(color: Colors.black54)),
                  ]),
                ),
                const SizedBox(height: 18),
                // list tiles
                Container(
                  decoration: BoxDecoration(
                      color: CommonColors.neutral50,
                      borderRadius: BorderRadius.circular(12)),
                  child: Column(children: [
                    _profileTile(
                      CommonImagePath.profileIcon,
                      'Edit Profile',
                      () async {
                        final hasInternet = await hasInternetConnection();
                        if (hasInternet) {
                          Navigator.push(
                            routeGlobalKey.currentContext!,
                            MaterialPageRoute(
                                builder: (context) => EditProfileScreen(
                                    user: provider.profile!.user!)),
                          );
                        } else {
                          FocusScope.of(context).unfocus();
                          showToast("No internet connection. Please check your network.");
                          // infoNormalDialog(
                          //   routeGlobalKey.currentContext!,
                          //   message:
                          //       "No internet connection. Please check your network.",
                          // );
                        }
                      },
                    ),
                    _profileTile(
                      CommonImagePath.edit,
                      'Reset Password',
                      () {
                        Navigator.push(
                          routeGlobalKey.currentContext!,
                          MaterialPageRoute(
                              builder: (context) => ResetPassword(
                                    email: "${user?.email ?? ''}",
                                    mobile: "${user?.phoneNumber ?? ''}",
                                  )),
                        );
                      },
                    ),
                    _profileTile(
                      CommonImagePath.chargingHistory,
                      'Charging History',
                      () {
                        Navigator.push(
                          routeGlobalKey.currentContext!,
                          MaterialPageRoute(
                              builder: (context) => ChargingHistoryScreen()),
                        );
                      },
                    ),
                    // _profileTile(
                    //   CommonImagePath.paymentOption,
                    //   'Payment Options',
                    //   () {
                    //     // Navigator.push(
                    //     //   routeGlobalKey.currentContext!,
                    //     //   MaterialPageRoute(builder: (context) => ChargingEstimateScreen()),
                    //     // );
                    //   },
                    // ),
                    // _profileTile(
                    //   CommonImagePath.vehicle,
                    //   'Vehicle Information',
                    //   () {
                    //     Navigator.push(
                    //       routeGlobalKey.currentContext!,
                    //       MaterialPageRoute(
                    //           builder: (context) => MyVehicleScreen()),
                    //     );
                    //   },
                    // ),
                    // _profileTile(
                    //   CommonImagePath.notification,
                    //   'Notification',
                    //   () {
                    //     Navigator.push(
                    //       routeGlobalKey.currentContext!,
                    //       MaterialPageRoute(
                    //           builder: (context) => NotificationScreen()),
                    //     );
                    //   },
                    // ),
                    // _profileTile(
                    //   CommonImagePath.share,
                    //   'Share',
                    //   () {
                    //     // Navigator.push(
                    //     //   routeGlobalKey.currentContext!,
                    //     //   MaterialPageRoute(builder: (context) => EditProfileScreen()),
                    //     // );
                    //   },
                    // ),
                    _profileTile(
                      CommonImagePath.setting,
                      'Support',
                      () {
                        Navigator.push(
                          routeGlobalKey.currentContext!,
                          MaterialPageRoute(
                              builder: (context) => SupportScreen()),
                        );
                      },
                    ),
                    // _profileTile(
                    //   CommonImagePath.delete,
                    //   'Delete Account',
                    //   () {
                    //     showModalBottomSheet(
                    //       backgroundColor: CommonColors.white,
                    //       context: context,
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius:
                    //             BorderRadius.vertical(top: Radius.circular(20)),
                    //       ),
                    //       isScrollControlled: true,
                    //       builder: (_) => ConfirmationSheet(
                    //         title: "Are you sure you want to Delete Account?",
                    //         singleButton: "",
                    //         imagePath: CommonImagePath.delete, // Your SVG/PNG
                    //         isSingleButton: false,
                    //         onBackToHome: () {},
                    //         onCancel: () => Navigator.pop(context),
                    //         onLogout: () async {
                    //           print("LOGOUT CLICKED");
                    //           context
                    //               .read<DeleteAccountProvider>()
                    //               .deleteAccount(context);
                    //         },
                    //         firstbutton: 'Cancel',
                    //         secondButton: 'Delete',
                    //         subHeading: '',
                    //       ),
                    //     );
                    //   },
                    // ),
                    _profileTile(
                      CommonImagePath.logout,
                      'Log out',
                      () {
                        showModalBottomSheet(
                          backgroundColor: CommonColors.white,
                          context: context,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          isScrollControlled: true,
                          builder: (_) => ConfirmationSheet(
                            singleButton: "",
                            imagePath: CommonImagePath.logout, // Your SVG/PNG
                            isSingleButton: false,
                            onBackToHome: () {},
                            onCancel: () => Navigator.pop(context),
                            onLogout: () {
                              // Navigator.pop(context);
                              // // Handle logout logic
                              print("LOGOUT CLICKED");
                              context.read<AuthProvider>().logout(context);
                            },
                            firstbutton: 'Cancel',
                            secondButton: 'Logout',
                            subHeading: '',
                          ),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 40),
                      child: Center(
                          child: Text(
                       Platform.isIOS? "Version: 1.1.7": "Version: 1.2.2",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black87,
                        ),
                      )),
                    )
                  ]),
                )
              ]),
            ),
    );
  }

  Widget _profileTile(String icon, String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            Image.asset(
              icon,
              width: 20,
              height: 20,
              color: CommonColors.black,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey)
          ],
        ),
      ),
    );
  }
}
