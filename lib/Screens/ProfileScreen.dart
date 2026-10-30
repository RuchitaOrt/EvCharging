// import 'dart:io';

// import 'package:HyCharge/Provider/AuthProvider.dart';
// import 'package:HyCharge/Provider/DeleteAccountProvider.dart';
// import 'package:HyCharge/Provider/FileUploadProvider.dart';
// import 'package:HyCharge/Provider/ImageCacheProvider.dart';
// import 'package:HyCharge/Provider/ProfileProvider.dart';
// import 'package:HyCharge/Screens/ChargingEstimateScreen.dart';
// import 'package:HyCharge/Screens/ChargingHistoryScreen.dart';
// import 'package:HyCharge/Screens/EditProfileScreen.dart';
// import 'package:HyCharge/Screens/MainTab.dart';
// import 'package:HyCharge/Screens/Vehicle/MyVehicleScreen.dart';
// import 'package:HyCharge/Screens/NotificationScreen.dart';
// import 'package:HyCharge/Screens/ResetPassword.dart';
// import 'package:HyCharge/Screens/SupportScreen.dart';
// import 'package:HyCharge/Screens/Vehicle/ManageVehicleScreen.dart';
// import 'package:HyCharge/Utils/APIManager.dart';
// import 'package:HyCharge/Utils/CommonAppBar.dart';
// import 'package:HyCharge/Utils/ImageHelper.dart';
// import 'package:HyCharge/Utils/InternetConnection.dart';
// import 'package:HyCharge/Utils/ShowDialog.dart';
// import 'package:HyCharge/Utils/commoncolors.dart';
// import 'package:HyCharge/Utils/commonimages.dart';
// import 'package:HyCharge/main.dart';
// import 'package:HyCharge/model/UploadResponse.dart';
// import 'package:HyCharge/widget/GlobalLists.dart';
// import 'package:HyCharge/widget/LogoutConfirmationSheet.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   @override
//   void initState() {
//     super.initState();
//     // WidgetsBinding.instance.addPostFrameCallback((_) {
//     //   context.read<ProfileProvider>().loadProfile(context);
//     // });

//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       final profileProvider = context.read<ProfileProvider>();
//       await profileProvider.loadProfile(context);

//       final imageId = profileProvider.profile?.user?.profileImageID;
//       print(imageId);
//       context.read<ImageCacheProvider>().loadProfileImage(imageId);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<ProfileProvider>();

//     final user = provider.profile?.user;
//     return Scaffold(
//       backgroundColor: CommonColors.neutral50,
//       appBar: CommonAppBar(
//         title: "Profile",
//         onBack: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (context) =>
//                     MainTab(isLoggedIn: GlobalLists.islLogin)),
//           );
//         },
//       ),
//       body: provider.loading
//           ? Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
//               child: Column(children: [
//                 Container(
//                   padding:
//                       const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
//                   decoration: BoxDecoration(
//                       color: CommonColors.neutral50,
//                       borderRadius: BorderRadius.circular(12)),
//                   child: Column(children: [
//                     GestureDetector(
//                       onTap: () async {
//                         final File? file = await pickProfileImage(context);
//                         final uploadProvider = context.read<UploadProvider>();

//                         final UploadResponse? resultResponse =
//                             await uploadProvider.upload(file: file!,isDP: true);

//                         if (resultResponse?.success == true) {
//                           print("✅ Uploaded: ${resultResponse!.fileId}");
//                           final provider = context.read<ProfileProvider>();
//                           FocusScope.of(context).unfocus();
//  showToast("${resultResponse?.message}");
                         
//                              context.read<UploadProvider>().setImage(file);
                         
//                         } else {
//                           print("❌ Upload failed: ${resultResponse?.message}");
//                         }


//                       },
//                       child: Consumer<UploadProvider>(
//                         builder: (_, provider, __) {
//                           return Stack(
//                             clipBehavior: Clip.none,
//                             children: [
//                               Consumer2<UploadProvider, ImageCacheProvider>(
//                                 builder: (_, upload, cache, __) {
//                                   return ClipRRect(
//                                     borderRadius: BorderRadius.circular(60),
//                                     child: upload.selectedImage != null
//                                         ? Image.file(
//                                             upload.selectedImage!,
//                                             width: 120,
//                                             height: 120,
//                                             fit: BoxFit.cover,
//                                           )
//                                         : cache.image != null
//                                             ? Image.memory(
//                                                 cache.image!,
//                                                 width: 120,
//                                                 height: 120,
//                                                 fit: BoxFit.cover,
//                                                 errorBuilder: (context, error, stackTrace) {
//                 return Image.asset(
//                   CommonImagePath.profileIcon,
//                   width: 120,
//                   height: 120,
//                   fit: BoxFit.cover,
//                 );
//               },
//                                               )
//                                             : Image.asset(
//                                                 CommonImagePath.profileIcon,
//                                                 width: 120,
//                                                 height: 120,
//                                                 fit: BoxFit.cover,
//                                               ),
//                                   );
//                                 },
//                               ),
//                               Positioned(
//                                 bottom: -4,
//                                 right: -4,
//                                 child: Container(
//                                   width: 40,
//                                   height: 40,
//                                   decoration: BoxDecoration(
//                                     color: CommonColors.neutral50,
//                                     shape: BoxShape.circle,
//                                     border: Border.all(
//                                         color: Colors.white, width: 3),
//                                   ),
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(8),
//                                     child: Image.asset(CommonImagePath.edit),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           );
//                         },
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     Text("${user?.firstName ?? ''} ${user?.lastName ?? ''}",
//                         style: TextStyle(fontWeight: FontWeight.w600)),
//                     const SizedBox(height: 6),
//                     Text("${user?.email ?? ''} • ${user?.phoneNumber ?? ''}",
//                         style: TextStyle(color: Colors.black54)),
//                   ]),
//                 ),
//                 const SizedBox(height: 18),
//                 // list tiles
//                 Container(
//                   decoration: BoxDecoration(
//                       color: CommonColors.neutral50,
//                       borderRadius: BorderRadius.circular(12)),
//                   child: Column(children: [
//                     _profileTile(
//                       CommonImagePath.profileIcon,
//                       'Edit Profile',
//                       () async {
//                         final hasInternet = await hasInternetConnection();
//                         if (hasInternet) {
//                           Navigator.push(
//                             routeGlobalKey.currentContext!,
//                             MaterialPageRoute(
//                                 builder: (context) => EditProfileScreen(
//                                     user: provider.profile!.user!)),
//                           );
//                         } else {
//                           FocusScope.of(context).unfocus();
//                           showToast("No internet connection. Please check your network.");
//                           // infoNormalDialog(
//                           //   routeGlobalKey.currentContext!,
//                           //   message:
//                           //       "No internet connection. Please check your network.",
//                           // );
//                         }
//                       },
//                     ),
//                     _profileTile(
//                       CommonImagePath.edit,
//                       'Reset Password',
//                       () {
//                         Navigator.push(
//                           routeGlobalKey.currentContext!,
//                           MaterialPageRoute(
//                               builder: (context) => ResetPassword(
//                                     email: "${user?.email ?? ''}",
//                                     mobile: "${user?.phoneNumber ?? ''}",
//                                   )),
//                         );
//                       },
//                     ),
//                     _profileTile(
//                       CommonImagePath.chargingHistory,
//                       'Charging History',
//                       () {
//                         Navigator.push(
//                           routeGlobalKey.currentContext!,
//                           MaterialPageRoute(
//                               builder: (context) => ChargingHistoryScreen()),
//                         );
//                       },
//                     ),
//                     // _profileTile(
//                     //   CommonImagePath.paymentOption,
//                     //   'Payment Options',
//                     //   () {
//                     //     // Navigator.push(
//                     //     //   routeGlobalKey.currentContext!,
//                     //     //   MaterialPageRoute(builder: (context) => ChargingEstimateScreen()),
//                     //     // );
//                     //   },
//                     // ),
//                     _profileTile(
//                       CommonImagePath.vehicle,
//                       'Vehicle',
//                       () {
//                         Navigator.push(
//                           routeGlobalKey.currentContext!,
//                           MaterialPageRoute(
//                               builder: (context) => ManageVehicleScreen()),
//                         );
//                       },
//                     ),
//                     // _profileTile(
//                     //   CommonImagePath.notification,
//                     //   'Notification',
//                     //   () {
//                     //     Navigator.push(
//                     //       routeGlobalKey.currentContext!,
//                     //       MaterialPageRoute(
//                     //           builder: (context) => NotificationScreen()),
//                     //     );
//                     //   },
//                     // ),
//                     // _profileTile(
//                     //   CommonImagePath.share,
//                     //   'Share',
//                     //   () {
//                     //     // Navigator.push(
//                     //     //   routeGlobalKey.currentContext!,
//                     //     //   MaterialPageRoute(builder: (context) => EditProfileScreen()),
//                     //     // );
//                     //   },
//                     // ),
//                     _profileTile(
//                       CommonImagePath.setting,
//                       'Support',
//                       () {
//                         Navigator.push(
//                           routeGlobalKey.currentContext!,
//                           MaterialPageRoute(
//                               builder: (context) => SupportScreen()),
//                         );
//                       },
//                     ),
//                     // _profileTile(
//                     //   CommonImagePath.delete,
//                     //   'Delete Account',
//                     //   () {
//                     //     showModalBottomSheet(
//                     //       backgroundColor: CommonColors.white,
//                     //       context: context,
//                     //       shape: RoundedRectangleBorder(
//                     //         borderRadius:
//                     //             BorderRadius.vertical(top: Radius.circular(20)),
//                     //       ),
//                     //       isScrollControlled: true,
//                     //       builder: (_) => ConfirmationSheet(
//                     //         title: "Are you sure you want to Delete Account?",
//                     //         singleButton: "",
//                     //         imagePath: CommonImagePath.delete, // Your SVG/PNG
//                     //         isSingleButton: false,
//                     //         onBackToHome: () {},
//                     //         onCancel: () => Navigator.pop(context),
//                     //         onLogout: () async {
//                     //           print("LOGOUT CLICKED");
//                     //           context
//                     //               .read<DeleteAccountProvider>()
//                     //               .deleteAccount(context);
//                     //         },
//                     //         firstbutton: 'Cancel',
//                     //         secondButton: 'Delete',
//                     //         subHeading: '',
//                     //       ),
//                     //     );
//                     //   },
//                     // ),
//                     _profileTile(
//                       CommonImagePath.logout,
//                       'Log out',
//                       () {
//                         showModalBottomSheet(
//                           backgroundColor: CommonColors.white,
//                           context: context,
//                           shape: RoundedRectangleBorder(
//                             borderRadius:
//                                 BorderRadius.vertical(top: Radius.circular(20)),
//                           ),
//                           isScrollControlled: true,
//                           builder: (_) => ConfirmationSheet(
//                             singleButton: "",
//                             imagePath: CommonImagePath.logout, // Your SVG/PNG
//                             isSingleButton: false,
//                             onBackToHome: () {},
//                             onCancel: () => Navigator.pop(context),
//                             onLogout: () {
//                               // Navigator.pop(context);
//                               // // Handle logout logic
//                               print("LOGOUT CLICKED");
//                               context.read<AuthProvider>().logout(context);
//                             },
//                             firstbutton: 'Cancel',
//                             secondButton: 'Logout',
//                             subHeading: '',
//                           ),
//                         );
//                       },
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(bottom: 40),
//                       child: Center(
//                           child: Text(
//                        Platform.isIOS? "Version: 1.1.7": "Version: 1.2.9",
//                         style: const TextStyle(
//                           fontSize: 12,
//                           color: Colors.black87,
//                         ),
//                       )),
//                     )
//                   ]),
//                 )
//               ]),
//             ),
//     );
//   }

//   Widget _profileTile(String icon, String title, VoidCallback onTap) {
//     return InkWell(
//       onTap: onTap,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 12.0),
//         child: Row(
//           children: [
//             Image.asset(
//               icon,
//               width: 20,
//               height: 20,
//               color: CommonColors.black,
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Text(
//                 title,
//                 style: const TextStyle(
//                   fontSize: 16,
//                   color: Colors.black87,
//                 ),
//               ),
//             ),
//             const Icon(Icons.chevron_right, color: Colors.grey)
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';

import 'package:HyCharge/Provider/ActiveSessionProvider.dart';
import 'package:HyCharge/Provider/AuthProvider.dart';
import 'package:HyCharge/Provider/FileUploadProvider.dart';
import 'package:HyCharge/Provider/ImageCacheProvider.dart';
import 'package:HyCharge/Provider/ProfileProvider.dart';
import 'package:HyCharge/Screens/ChargingHistoryScreen.dart';
import 'package:HyCharge/Screens/EditProfileScreen.dart';
import 'package:HyCharge/Screens/MainTab.dart';
import 'package:HyCharge/Screens/ResetPassword.dart';
import 'package:HyCharge/Screens/SupportScreen.dart';
import 'package:HyCharge/Screens/Vehicle/ManageVehicleScreen.dart';
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
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  static const Color navy = Color(0xFF142D70);
  static const Color background = Color(0xFFF4F6FA);
  static const Color mutedText = Color(0xFF778198);
  static const Color dividerColor = Color(0xFFE9EDF4);
  static const Color iconBackground = Color(0xFFEDF2FC);

  late TabController _historyTabController;

  @override
  void initState() {
    super.initState();

    _historyTabController = TabController(
      length: 2,
      vsync: this,
    );

    _historyTabController.addListener(_onHistoryTabChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      final profileProvider = context.read<ProfileProvider>();

      await profileProvider.loadProfile(context);

      if (!mounted) return;

      final imageId = profileProvider.profile?.user?.profileImageID;
      context.read<ImageCacheProvider>().loadProfileImage(imageId);

      // Load Charging Session values initially.
      final sessionProvider = context.read<ActiveSessionProvider>();
      sessionProvider.changeMainTab(0);
      sessionProvider.fetchActiveSessions(context, "");
    });
  }

  void _onHistoryTabChanged() {
    if (_historyTabController.indexIsChanging) return;

    final selectedIndex = _historyTabController.index;
    final provider = context.read<ActiveSessionProvider>();

    if (provider.selectedMainTab == selectedIndex) return;

    provider.changeMainTab(selectedIndex);

    if (selectedIndex == 0) {
      provider.fetchActiveSessions(context, "");
    } else {
      provider.fetchAUnifiedctiveSessions(context, "");
    }
  }

  @override
  void dispose() {
    _historyTabController.removeListener(_onHistoryTabChanged);
    _historyTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>();
    final user = profileProvider.profile?.user;

    return Scaffold(
      backgroundColor: background,
      appBar: CommonAppBar(
        title: 'Profile',
        onBack: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MainTab(
                isLoggedIn: GlobalLists.islLogin,
              ),
            ),
          );
        },
      ),
      body: profileProvider.loading
          ? const Center(
              child: CircularProgressIndicator(color: navy),
            )
          : SafeArea(
              top: false,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // PROFILE HEADER CARD
                    _buildProfileCard(
                      firstName: user?.firstName ?? '',
                      lastName: user?.lastName ?? '',
                      phone: user?.phoneNumber ?? '',
                      email: user?.email ?? '',
                    ),

                    const SizedBox(height: 16),

                    // SUMMARY CARDS
                    // Connect actual statistics here when their existing
                    // data provider/API is available.
                    _buildChargingHistorySection(),
                    const SizedBox(height: 20),

                   

                    _buildMenuCard(
                      children: [
                        _buildMenuTile(
                          icon: CommonImagePath.edit_blue,
                          title: 'Edit Profile',
                          onTap: () async {
                            final hasInternet =
                                await hasInternetConnection();

                            if (!context.mounted) return;

                            if (hasInternet) {
                              final currentUser =
                                  context.read<ProfileProvider>().profile?.user;

                              if (currentUser == null) {
                                showToast('Profile information unavailable.');
                                return;
                              }

                              Navigator.push(
                                routeGlobalKey.currentContext!,
                                MaterialPageRoute(
                                  builder: (_) => EditProfileScreen(
                                    user: currentUser,
                                  ),
                                ),
                              );
                            } else {
                              FocusScope.of(context).unfocus();
                              showToast(
                                'No internet connection. Please check your network.',
                              );
                            }
                          },
                        ),

                        _buildMenuTile(
                          icon: CommonImagePath.car_navy,
                          title: 'Manage Vehicle',
                          onTap: () {
                            Navigator.push(
                              routeGlobalKey.currentContext!,
                              MaterialPageRoute(
                                builder: (_) => ManageVehicleScreen(),
                              ),
                            );
                          },
                        ),

                        _buildMenuTile(
                          icon: CommonImagePath.Charging_History,
                          title: 'Charging History',
                          onTap: () {
                            Navigator.push(
                              routeGlobalKey.currentContext!,
                              MaterialPageRoute(
                                builder: (_) => ChargingHistoryScreen(),
                              ),
                            );
                          },
                        ),
                         _buildMenuTile(
                          icon: CommonImagePath.set_key,
                          title: 'Set Password',
                          onTap: () {
                            Navigator.push(
                              routeGlobalKey.currentContext!,
                              MaterialPageRoute(
                                builder: (_) => ResetPassword(
                                  email: user?.email ?? '',
                                  mobile: user?.phoneNumber ?? '',
                                ),
                              ),
                            );
                          },
                        ),

                        _buildMenuTile(
                          icon:CommonImagePath.support,
                          title: 'Support',
                          onTap: () {
                            Navigator.push(
                              routeGlobalKey.currentContext!,
                              MaterialPageRoute(
                                builder: (_) => SupportScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),

                    // const SizedBox(height: 24),

                    // // PREFERENCES AND SUPPORT SECTION
                    // _buildSectionTitle('PREFERENCES & SUPPORT'),

                    // const SizedBox(height: 10),

                    
                    const SizedBox(height: 12),

                    // LOGOUT
                    _buildLogoutTile(),

                    const SizedBox(height: 12),

                    // APP VERSION
                    Center(
                      child: Column(
                        children: [
                         
                          Text(
                            Platform.isIOS
                                ? 'Version: 1.1.7'
                                : 'Version: 1.2.9',
                            style: const TextStyle(
                              fontSize: 12,
                              color: mutedText,
                            ),
                          ),
                        ],
                      ),
                    ),
                      const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
    );
  }
Widget _buildChargingHistorySection() {
  return Consumer<ActiveSessionProvider>(
    builder: (context, provider, _) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF152B55).withOpacity(0.04),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TabBar(
              controller: _historyTabController,
              indicator: const UnderlineTabIndicator(
                borderSide: BorderSide(
                  color: Color(0xFF142F7D),
                  width: 2.5,
                ),
              ),
              indicatorSize: TabBarIndicatorSize.label,
              indicatorPadding: const EdgeInsets.only(bottom: 0),
              dividerColor: Colors.transparent,
              labelColor: const Color(0xFF142F7D),
              unselectedLabelColor: const Color(0xFF687386),
              labelStyle: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              tabs: const [
                Tab(
                  height: 42,
                  text: 'Charging Session',
                ),
                Tab(
                  height: 42,
                  text: 'Partner Session',
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Statistics for the selected session tab.
            _summaryRow(),
          ],
        ),
      );
    },
  );
}
  // ---------------------------------------------------------------------------
  // PROFILE CARD
  // ---------------------------------------------------------------------------

  Widget _buildProfileCard({
    required String firstName,
    required String lastName,
    required String phone,
    required String email,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: navy,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: navy.withOpacity(0.12),
            blurRadius: 16,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Row(
        children: [
          Consumer2<UploadProvider, ImageCacheProvider>(
            builder: (context, upload, cache, child) {
              return Stack(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      // border: Border.all(
                      //   color: Colors.white.withOpacity(0.65),
                      //   width: 1.5,
                      // ),
                    ),
                    child: ClipOval(
                      child: upload.selectedImage != null
                          ? Image.file(
                              upload.selectedImage!,
                              width: 64,
                              height: 64,
                              fit: BoxFit.cover,
                            )
                          : cache.image != null
                              ? Image.memory(
                                  cache.image!,
                                  width: 64,
                                  height: 64,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) {
                                    return _defaultProfileImage();
                                  },
                                )
                              : _defaultProfileImage(),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 23,
                      height: 23,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: navy,
                          width: 1.5,
                        ),
                      ),
                      child: const Icon(
                        Icons.camera_alt_outlined,
                        color: navy,
                        size: 13,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$firstName $lastName'.trim().isEmpty
                      ? 'Welcome'
                      : '$firstName $lastName'.trim(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                     fontFamily: 'Poppins',
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
               
                Row(
                  children: [
                   
                    Expanded(
                      child: Text(
                        phone.isNotEmpty ? phone : email,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                           fontFamily: 'Poppins',
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
                if (phone.isNotEmpty && email.isNotEmpty) ...[
                  const SizedBox(height: 1),
                  Text(
                    email,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                       fontFamily: 'Poppins',
                      color: Colors.white,
                          fontSize: 10,
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(width: 8),

          ElevatedButton(
            onPressed: _openEditProfile,
            style: OutlinedButton.styleFrom(
              backgroundColor: CommonColors.lightBlue,
              foregroundColor: Colors.white,
              // side: BorderSide(
              //   color: Colors.white.withOpacity(0.45),
              // ),
              padding: const EdgeInsets.symmetric(
                horizontal: 11,
                vertical: 9,
              ),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child:  Row(
              mainAxisSize: MainAxisSize.min,
              children: [
               SvgPicture.asset(CommonImagePath.pencil_navy,color: CommonColors.white,width: 12,height: 14,),
                SizedBox(width: 4),
                Text(
                  'Edit',
                  style: TextStyle(
                     fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _defaultProfileImage() {
    return Image.asset(
      CommonImagePath.profileIcon,
      width: 64,
      height: 64,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) {
        return Container(
          color: iconBackground,
          child: const Icon(
            Icons.person_rounded,
            color: navy,
            size: 36,
          ),
        );
      },
    );
  }

  Future<void> _openEditProfile() async {
    final hasInternet = await hasInternetConnection();

    if (!mounted) return;

    if (!hasInternet) {
      FocusScope.of(context).unfocus();
      showToast(
        'No internet connection. Please check your network.',
      );
      return;
    }

    final user = context.read<ProfileProvider>().profile?.user;

    if (user == null) {
      showToast('Profile information unavailable.');
      return;
    }

    Navigator.push(
      routeGlobalKey.currentContext!,
      MaterialPageRoute(
        builder: (_) => EditProfileScreen(user: user),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // STATISTICS
  // ---------------------------------------------------------------------------

  // Widget _buildStatistics() {
  //   return Row(
  //     children: [
  //       Expanded(
  //         child: _buildStatCard(
  //           icon: Icons.ev_station_rounded,
  //           label: 'Sessions',
  //           value: '—',
  //         ),
  //       ),
  //       const SizedBox(width: 10),
  //       Expanded(
  //         child: _buildStatCard(
  //           icon: Icons.bolt_rounded,
  //           label: 'Energy',
  //           value: '— kWh',
  //         ),
  //       ),
  //       const SizedBox(width: 10),
  //       Expanded(
  //         child: _buildStatCard(
  //           icon: Icons.currency_rupee_rounded,
  //           label: 'Spent',
  //           value: '₹—',
  //         ),
  //       ),
  //     ],
  //   );
  // }
Widget _summaryRow() {
  return Consumer<ActiveSessionProvider>(
    builder: (context, provider, _) {
      final items = [
        (provider.totalSessions, "Sessions"),
        ("${provider.totalEnergy} kWh", "Energy"),
        ("₹ ${provider.totalSpent}", "Spent"),
        // (provider.totalTime, "Time"),
      ];

      return Container(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 4,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF152B55).withOpacity(0.04),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: List.generate(items.length, (index) {
            final item = items[index];

            return Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: index == 0
                      ? null
                      : const Border(
                          left: BorderSide(
                            color: Color(0xFFE4E8F0),
                          ),
                        ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        item.$1,
                        maxLines: 1,
                        style:  TextStyle(
                             fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: CommonColors.blue,
                        ),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      item.$2,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFF687386),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      );
    },
  );
}



  // ---------------------------------------------------------------------------
  // MENU CARD
  // ---------------------------------------------------------------------------

  Widget _buildMenuCard({
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: dividerColor),
        boxShadow: [
          BoxShadow(
            color: navy.withOpacity(0.035),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildMenuTile({
    required String icon,
    required String title,
    required VoidCallback onTap,
    bool showDivider = true,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 10,
              ),
              child: Row(
                children: [
                 Container(
  width: 42,
  height: 42,
  decoration: BoxDecoration(
    color: iconBackground,
    shape: BoxShape.circle,
  ),
  child: Center(
    child: SvgPicture.asset(
      icon,
      width: 16,
      height: 16,
      fit: BoxFit.contain,
    ),
  ),
),
                  const SizedBox(width: 13),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Color(0xFF172443),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: mutedText,
                    size: 23,
                  ),
                ],
              ),
            ),
            if (showDivider)
              const Padding(
                padding: EdgeInsets.only(left: 0),
                child: Divider(
                  height: 1,
                  thickness: 1,
                  color: dividerColor,
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // LOGOUT
  // ---------------------------------------------------------------------------

  Widget _buildLogoutTile() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _showLogoutConfirmation,
        borderRadius: BorderRadius.circular(17),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFFFEEEE),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: const Color(0xFFFFDEDE),
            ),
          ),
          child:  Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             SvgPicture.asset(CommonImagePath.logout_red,width: 16,height: 16,),
              SizedBox(width: 10),
              Text(
                'Log out',
                style: TextStyle(
                  color: Color(0xFFEF4444),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutConfirmation() {
    showModalBottomSheet(
      backgroundColor: CommonColors.white,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      isScrollControlled: true,
      builder: (_) => ConfirmationSheet(
        singleButton: '',
        imagePath: CommonImagePath.logout,
        isSingleButton: false,
        onBackToHome: () {},
        onCancel: () => Navigator.pop(context),
        onLogout: () {
          context.read<AuthProvider>().logout(context);
        },
        firstbutton: 'Cancel',
        secondButton: 'Logout',
        subHeading: '',
      ),
    );
  }
}
