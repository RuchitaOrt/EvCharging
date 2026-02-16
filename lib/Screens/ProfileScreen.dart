
import 'dart:io';
// import 'dart:nativewrappers/_internal/vm/lib/developer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:HyCharge/Provider/AuthProvider.dart';
import 'package:HyCharge/Provider/DeleteAccountProvider.dart';
import 'package:HyCharge/Provider/FileUploadProvider.dart';
import 'package:HyCharge/Provider/ImageCacheProvider.dart';
import 'package:HyCharge/Provider/ProfileProvider.dart';

import 'package:HyCharge/Screens/ChargingHistoryScreen.dart';
import 'package:HyCharge/Screens/EditProfileScreen.dart';
import 'package:HyCharge/Screens/MainTab.dart';
import 'package:HyCharge/Screens/MyVehicleScreen.dart';
import 'package:HyCharge/Screens/NotificationScreen.dart';
import 'package:HyCharge/Screens/ResetPassword.dart';
import 'package:HyCharge/Screens/SupportScreen.dart';

import 'package:HyCharge/Utils/CommonAppBar.dart';
import 'package:HyCharge/Utils/ImageHelper.dart';
import 'package:HyCharge/Utils/ShowDialog.dart';
import 'package:HyCharge/Utils/commoncolors.dart';
import 'package:HyCharge/Utils/commonimages.dart';

import 'package:HyCharge/main.dart';
import 'package:HyCharge/model/UploadResponse.dart';
import 'package:HyCharge/widget/GlobalLists.dart';
import 'package:HyCharge/widget/LogoutConfirmationSheet.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final profileProvider = context.read<ProfileProvider>();
      await profileProvider.loadProfile(context);

      final imageId = profileProvider.profile?.user?.profileImageID;
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
              builder: (_) => MainTab(isLoggedIn: GlobalLists.islLogin),
            ),
          );
        },
      ),
      body: provider.loading
          ? const Center(child: CircularProgressIndicator())
          : LayoutBuilder(
              builder: (context, constraints) {
                final isWeb = kIsWeb;
                final isDesktop = constraints.maxWidth > 900;

                return Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth:
                          isWeb && isDesktop ? 1200 : double.infinity,
                    ),
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: isWeb ? 24 : 8,
                        vertical: isWeb ? 24 : 0,
                      ),
                      child: Column(
                        children: [
                          _buildProfileHeader(user),
                          const SizedBox(height: 18),
                          _buildProfileOptions(provider, user),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  // ================= PROFILE HEADER =================

  Widget _buildProfileHeader(user) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      decoration: BoxDecoration(
        color: CommonColors.neutral50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () async {
              final File? file = await pickProfileImage(context);
              if (file == null) return;

              final uploadProvider = context.read<UploadProvider>();
              final UploadResponse? response =
                  await uploadProvider.upload(file: file);

              if (response?.success == true) {
                final provider = context.read<ProfileProvider>();

                final success = await provider.updateProfile(
                  context,
                  body: {
                    "firstName": user?.firstName ?? '',
                    "lastName": user?.lastName ?? '',
                    "eMailID": user?.email ?? '',
                    "phoneNumber": user?.phoneNumber ?? '',
                    "countryCode": "+91",
                    "addressLine1": user?.addressLine1 ?? '',
                    "profileImageID": response!.fileId,
                  },
                );

                if (success) {
                  uploadProvider.setImage(file);
                  showToast(provider.message.toString());
                }
              }
            },
            child: Consumer2<UploadProvider, ImageCacheProvider>(
              builder: (_, upload, cache, __) {
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ClipRRect(
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
                                )
                              : Image.asset(
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
                          color: CommonColors.neutral50,
                          shape: BoxShape.circle,
                          border:
                              Border.all(color: Colors.white, width: 3),
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
          Text(
            "${user?.firstName ?? ''} ${user?.lastName ?? ''}",
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          Text(
            "${user?.email ?? ''} • ${user?.phoneNumber ?? ''}",
            style: const TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }

  // ================= OPTIONS =================

  Widget _buildProfileOptions(ProfileProvider provider, user) {
    return Container(
      decoration: BoxDecoration(
        color: CommonColors.neutral50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _profileTile(CommonImagePath.profileIcon, 'Edit Profile', () {
            print('provider.profile!.use${provider.profile!.user!}');
            Navigator.push(
              routeGlobalKey.currentContext!,
              MaterialPageRoute(
                builder: (_) =>
                    EditProfileScreen(user: provider.profile!.user!),
              ),
            );
          }),
          _profileTile(CommonImagePath.edit, 'Reset Password', () {
            Navigator.push(
              routeGlobalKey.currentContext!,
              MaterialPageRoute(
                builder: (_) => ResetPassword(
                  email: user?.email ?? '',
                  mobile: user?.phoneNumber ?? '',
                ),
              ),
            );
          }),
          _profileTile(
              CommonImagePath.chargingHistory, 'Charging History', () {
            Navigator.push(
              routeGlobalKey.currentContext!,
              MaterialPageRoute(
                  builder: (_) => ChargingHistoryScreen()),
            );
          }),
          _profileTile(CommonImagePath.vehicle, 'Vehicle Information',
              () {
            Navigator.push(
              routeGlobalKey.currentContext!,
              MaterialPageRoute(builder: (_) => MyVehicleScreen()),
            );
          }),
          _profileTile(CommonImagePath.notification, 'Notification',
              () {
            Navigator.push(
              routeGlobalKey.currentContext!,
              MaterialPageRoute(builder: (_) => NotificationScreen()),
            );
          }),
          _profileTile(CommonImagePath.setting, 'Settings', () {
            Navigator.push(
              routeGlobalKey.currentContext!,
              MaterialPageRoute(builder: (_) => SupportScreen()),
            );
          }),
          _profileTile(CommonImagePath.delete, 'Delete Account', () {
            showModalBottomSheet(
              context: context,
              backgroundColor: CommonColors.white,
              shape: const RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (_) => ConfirmationSheet(
                title: "Are you sure you want to Delete Account?",
                imagePath: CommonImagePath.delete,
                isSingleButton: false,
                firstbutton: 'Cancel',
                secondButton: 'Delete',
                onCancel: () => Navigator.pop(context),
                onLogout: () {
                  context
                      .read<DeleteAccountProvider>()
                      .deleteAccount(context);
                }, subHeading: '', onBackToHome: () {  }, singleButton: '',
              ),
            );
          }),
          _profileTile(CommonImagePath.logout, 'Log out', () {
            showModalBottomSheet(
              context: context,
              backgroundColor: CommonColors.white,
              shape: const RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (_) => ConfirmationSheet(
                imagePath: CommonImagePath.logout,
                isSingleButton: false,
                firstbutton: 'Cancel',
                secondButton: 'Logout',
                onCancel: () => Navigator.pop(context),
                onLogout: () {
                  context.read<AuthProvider>().logout(context);
                }, subHeading: '', onBackToHome: () {  }, singleButton: '',
              ),
            );
          }),
          const SizedBox(height: 40),
          const Text(
            "Version: 1.0.0",
            style: TextStyle(fontSize: 12, color: Colors.black87),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ================= TILE =================

  Widget _profileTile(String icon, String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Image.asset(icon, width: 20, height: 20, color: CommonColors.black),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
