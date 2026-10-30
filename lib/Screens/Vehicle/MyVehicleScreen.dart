import 'package:HyCharge/Bottomsheet/showVehicleBottomsheet.dart';
import 'package:HyCharge/Provider/VehicleProvider.dart';
import 'package:HyCharge/Screens/MainTab.dart';
import 'package:HyCharge/Screens/Vehicle/ManageVehicleScreen.dart';
import 'package:HyCharge/Utils/CommonAppBar.dart';
import 'package:HyCharge/Utils/commoncolors.dart';
import 'package:HyCharge/Utils/commonimages.dart';
import 'package:HyCharge/Utils/sizeConfig.dart';
import 'package:HyCharge/main.dart';
import 'package:HyCharge/model/EvModelResponse.dart';
import 'package:HyCharge/model/VehicleModel.dart';
import 'package:HyCharge/widget/CommonButton.dart';
import 'package:HyCharge/widget/GlobalLists.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class VehicleSelectionScreen extends StatefulWidget {
  final bool isVehicleAdded;
  const VehicleSelectionScreen({super.key, required this.isVehicleAdded});

  @override
  State<VehicleSelectionScreen> createState() => _VehicleSelectionScreenState();
}

class _VehicleSelectionScreenState extends State<VehicleSelectionScreen>
    with SingleTickerProviderStateMixin {
  String selectedTab = "All";

  EvModelData? selectedVehicle;

  TabController? _tabController;


  bool showMyVehicles = true;
  void _createController(int length) {
    _tabController?.dispose();

    _tabController = TabController(
      length: length,
      vsync: this,
    );

    _tabController!.addListener(() {
      if (!_tabController!.indexIsChanging) {
        context.read<VehicleProvider>().changeTab(
            context.read<VehicleProvider>().tabs[_tabController!.index]);
      }
    });
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = context.read<VehicleProvider>();

      await provider.loadInitialData(context);

      if (!mounted) return;

      _createController(provider.tabs.length);

      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  

  String searchText = '';
  

  @override
  Widget build(BuildContext context) {
    // if (_tabController == null) {
    //   return const Center(
    //     child: CircularProgressIndicator(),
    //   );
    // }
    return Scaffold(
      backgroundColor: CommonColors.neutral50,
      appBar: CommonAppBar(
        title: "Select Your Vehicle",
        onBack: () {
         Navigator.push(
                          routeGlobalKey.currentContext!,
                          MaterialPageRoute(
                              builder: (context) => ManageVehicleScreen()),
                        );
        },
      ),
      body: 
      Consumer<VehicleProvider>(builder: (context, provider, c) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showMyVehicles && provider.userVehicles.isNotEmpty) ...[
  const Padding(
    padding: EdgeInsets.only(left: 20, top: 12, bottom: 10),
    child: Text(
      "My Vehicles",
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: Color(0xFF101B35),
      ),
    ),
  ),
  SizedBox(
    height: 135,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      itemCount: provider.userVehicles.length,
      separatorBuilder: (_, __) => const SizedBox(width: 12),
      itemBuilder: (context, index) {
        final vehicle = provider.userVehicles[index];
        final modelName =
            provider.getModelName(vehicle.carModelID);
        final isSelected =
            provider.selectedUserVehicleId == vehicle.recId;

        return GestureDetector(
          onTap: () {
            if (vehicle.recId != null) {
              provider.selectUserVehicle(vehicle.recId!);
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 145,
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF19C66A)
                    : const Color(0xFFE8ECF3),
                width: isSelected ? 1.2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF142344).withOpacity(0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 70,
                      width: double.infinity,
                      child: Image.asset(
                        CommonImagePath.carskyblue,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      modelName ?? "Vehicle",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF101B35),
                      ),
                    ),
                    const SizedBox(height: 1),
                    Row(
                      children: [
                       SvgPicture.asset(CommonImagePath.car_navy,width: 12,height: 12,),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            vehicle.carRegistrationNumber ?? "",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 10,
                              color: Color(0xFF68758A),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                if (isSelected)
                  const Positioned(
                    right: 0,
                    top: 0,
                    child: CircleAvatar(
                      radius: 10,
                      backgroundColor: Color(0xFF24C875),
                      child: Icon(
                        Icons.check,
                        size: 13,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    ),
  ),

  //          if (showMyVehicles && provider.userVehicles.isNotEmpty) ...[
  // const Padding(
  //   padding: EdgeInsets.only(left: 20, top: 12, bottom: 12),
  //   child: Text(
  //     "My Vehicles",
  //     style: TextStyle(
  //       fontSize: 14,
  //       fontWeight: FontWeight.w800,
  //     ),
  //   ),
  // ),

  // SizedBox(
  //   height: 150,
  //   child: ListView.separated(
  //     scrollDirection: Axis.horizontal,
  //     padding: const EdgeInsets.symmetric(horizontal: 16),
  //     itemCount: provider.userVehicles.length,
  //     separatorBuilder: (_, __) => const SizedBox(width: 12),
  //     itemBuilder: (context, index) {
  //       final vehicle = provider.userVehicles[index];

  //       final modelName = provider.getModelName(
  //         vehicle.carModelID,
  //       );

  //       final isSelected =
  //           provider.selectedUserVehicleId == vehicle.recId;

  //       return GestureDetector(
  //         onTap: () {
  //           provider.selectUserVehicle(vehicle.recId!);
  //         },
  //         child: Container(
  //           width: 145,
  //           padding: const EdgeInsets.all(10),
  //           decoration: BoxDecoration(
  //             color: isSelected
  //                 ? const Color(0xffE8FFF3)
  //                 : Colors.white,
  //             borderRadius: BorderRadius.circular(12),
  //             border: Border.all(
  //               color: isSelected
  //                   ? const Color(0xff53C98B)
  //                   : Colors.grey.shade300,
  //             ),
  //           ),
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               SizedBox(
  //                 height: 55,
  //                 child: Image.asset(
  //                   CommonImagePath.vehicle1,
  //                   fit: BoxFit.contain,
  //                 ),
  //               ),
  //               const SizedBox(height: 6),
  //               Text(
  //                 modelName,
  //                 maxLines: 1,
  //                 overflow: TextOverflow.ellipsis,
  //                 style: const TextStyle(
  //                   fontSize: 12,
  //                   fontWeight: FontWeight.w700,
  //                 ),
  //               ),
  //               const SizedBox(height: 5),
  //               Text(
  //                 vehicle.carRegistrationNumber ?? "",
  //                 maxLines: 1,
  //                 overflow: TextOverflow.ellipsis,
  //                 style: TextStyle(
  //                   fontSize: 11,
  //                   color: Colors.grey.shade700,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   ),
  // ),
],

//             if (showMyVehicles)
            
//            provider.userVehicles.length ==0?Container():   Padding(
//                 padding: const EdgeInsets.only(left: 20, top: 12, bottom: 12),
//                 child: Text(
//                   "My Vehicles",
//                   style: const TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w800,
//                   ),
//                 ),
//               ),
// provider.userVehicles.length ==0?Container():Padding(
//   padding: const EdgeInsets.only(bottom: 8),
//   child: SizedBox(
//     height: 150,
//     child: ListView.separated(
//             shrinkWrap: true,
//             scrollDirection: Axis.horizontal,
//             physics: const ScrollPhysics(),
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             itemCount: provider.userVehicles.length,
//             separatorBuilder: (_, __) => const SizedBox(height: 14),
//             itemBuilder: (context, index) {
//               final vehicle = provider.userVehicles[index];
          

    

//     final modelName = provider.getModelName(
//       vehicle.carModelID,
//     );
//               return  Container(
//                   width: SizeConfig.blockSizeHorizontal * 35,
//                   margin: const EdgeInsets.symmetric(
//                     horizontal: 8,
//                   ),
//                   padding: const EdgeInsets.all(10),
//                   decoration: BoxDecoration(
//                     color:provider.selectedUserVehicleId == vehicle.recId?  const Color(0xffE8FFF3):Colors.white,
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(
//                       color:provider.selectedUserVehicleId == vehicle.recId?   const Color(0xff53C98B)
//             : Colors.grey.shade300,
//                       width: 1,
//                     ),
//                   ),
//                   child: Column(
//                     children: [
//                       Container(
//                         width: 85,
//                         height: 65,
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(8),
//                           child: Image.asset(
//                             CommonImagePath.vehicle1,
//                             height: 120,
//                             fit: BoxFit.contain,
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       Text(
//                         modelName ?? "",
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                         style: const TextStyle(
//                           fontSize: 12,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const Icon(
//                             Icons.directions_car,
//                             size: 14,
//                             color: Colors.grey,
//                           ),
//                           const SizedBox(width: 4),
//                           Text(
//                             vehicle.carRegistrationNumber! ?? "",
//                             style: TextStyle(
//                               fontSize: 11,
//                               color: Colors.grey.shade700,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 );
//             },
//           ),
//   ),
// ),
           
if (_tabController == null)
  const Expanded(
    child: Center(child: CircularProgressIndicator()),
  )
else ...[
  const SizedBox(height: 14),

  Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Container(
      height: 38,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFEDF0F5),
        borderRadius: BorderRadius.circular(30),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          color: const Color(0xFF102B70),
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        labelColor: Colors.white,
        unselectedLabelColor: const Color(0xFF657084),
        labelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        labelPadding: const EdgeInsets.symmetric(horizontal: 22),
        tabs: provider.tabs.map((tab) {
          return Tab(text: tab);
        }).toList(),
      ),
    ),
  ),

  const SizedBox(height: 12),


 
],
    //       (_tabController == null) ?
    //    Padding(
    //      padding: const EdgeInsets.only(top: 30),
    //      child: Center(
    //       child: CircularProgressIndicator(),
    //            ),
    //    )
    // :   Container(
    //           height: 43,
    //           // color: Colors.white,
    //           child: TabBar(
    //             controller: _tabController,
    //             isScrollable: true,
    //             indicatorColor: CommonColors.blue,
    //             // const Color(0xffD88D73),
    //             indicatorWeight: 1.5,
    //             dividerColor: Colors.transparent,
    //             labelColor: Colors.black,
    //             unselectedLabelColor: CommonColors.neutral400,
    //             labelStyle: const TextStyle(
    //               fontSize: 14,
    //               fontWeight: FontWeight.w600,
    //             ),
    //             unselectedLabelStyle: const TextStyle(
    //               fontSize: 14,
    //               fontWeight: FontWeight.w400,
    //             ),
    //             labelPadding: const EdgeInsets.symmetric(horizontal: 0),
    //             tabs: provider.tabs
    //                 .map((e) => Tab(
    //                       child: Padding(
    //                         padding: const EdgeInsets.symmetric(horizontal: 45),
    //                         child: Text(e),
    //                       ),
    //                     ))
    //                 .toList(),
    //             // brands
    //             //   .map(
    //             //     (e) => Tab(
    //             //       child:
    //             // Padding(
    //             //         padding: const EdgeInsets.symmetric(horizontal: 45),
    //             //         child: Text(e),
    //             //       ),
    //             //     ),
    //             //   )
    //             //   .toList(),
    //             // tabs: brands.map((e) => Tab(text: e)).toList(),
    //           ),
    //         ),

            const SizedBox(height: 10),

     (_tabController == null) ?
       SizedBox()
    :         Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search for vehicle no",
                  hintStyle: TextStyle(
                    color: CommonColors.neutral400,
                    fontSize: 12,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    size: 20,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 0,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: CommonColors.neutral200,
                    ),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    searchText = value;
                  });
                },
              ),
            ),
       (_tabController == null) ?
       SizedBox()
    :          Expanded(
              child: Consumer<VehicleProvider>(
                builder: (context, provider, child) {
                  return TabBarView(
                    controller: _tabController,
                    children: provider.tabs.map((tab) {
                      List<EvModelData> data;

                      if (tab == "All") {
                        data = provider.evModels;
                      } else {
                        final manufacturer = provider.manufacturers.firstWhere(
                          (e) => e.manufacturerName == tab,
                        );

                        data = provider.getModelsByManufacturer(
                          manufacturer.recId ?? "",
                        );
                      }

                      /// Search Filter
                      data = data.where((e) {
                        return (e.modelName ?? "")
                            .toLowerCase()
                            .contains(searchText.toLowerCase());
                      }).toList();
return ListView.builder(
  padding: const EdgeInsets.all(16),
  itemCount: data.length,
  itemBuilder: (context, index) {
    final vehicle = data[index];

    return VehicleCard(
      vehicle: vehicle,
      isSelected: provider.selectedModelId == vehicle.recId,
      onTap: () {
        provider.selectModel(vehicle);
        // provider.selectVehicle(vehicle.recId ?? "");
        
      },
    );
  },
);
                      // return GridView.builder(
                      //   padding: const EdgeInsets.all(12),
                      //   itemCount: data.length,
                      //   gridDelegate:
                      //       const SliverGridDelegateWithFixedCrossAxisCount(
                      //     crossAxisCount: 2,
                      //     crossAxisSpacing: 14,
                      //     mainAxisSpacing: 14,
                      //     childAspectRatio: .85,
                      //   ),
                      //   itemBuilder: (context, index) {
                      //     final vehicle = data[index];

                      //     return VehicleCard(
                      //       vehicle: vehicle,
                      //       isSelected:
                      //           provider.selectedVehicleId == vehicle.recId,
                      //       onTap: () {
                      //         provider.selectModel(vehicle);
                      //         provider.selectVehicle(vehicle.recId ?? "");
                      //       },
                      //     );
                      //   },
                      // );
                    }).toList(),
                  );
                },
              ),
            ),
            //     Expanded(
            //       child: TabBarView(
            //         controller: _tabController,
            //         children: brands.map((brand) {
            //           final data = (brand == "All"
            //   ? vehicles
            //   : vehicles
            //       .where((e) => e.brand == brand)
            //       .toList())
            //     .where(
            // (e) => e.vehicleName
            //     .toLowerCase()
            //     .contains(
            //       searchText.toLowerCase(),
            //     ),
            //     )
            //     .toList();
            //           // final data = brand == "All"
            //           //     ? vehicles
            //           //     : vehicles.where((e) => e.brand == brand).toList();

            //           return GridView.builder(
            //             padding: const EdgeInsets.all(12),
            //             itemCount: data.length,
            //             // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            //             //   crossAxisCount: 2,
            //             //   crossAxisSpacing: 12,
            //             //   mainAxisSpacing: 12,
            //             //   childAspectRatio: 0.9,
            //             // ),
            //             gridDelegate:
            //     const SliverGridDelegateWithFixedCrossAxisCount(
            //   crossAxisCount: 2,
            //   crossAxisSpacing: 14,
            //   mainAxisSpacing: 14,
            //   childAspectRatio: .85,
            // ),
            //             itemBuilder: (context, index) {
            //               final vehicle = data[index];
            //               return VehicleCard(
            //                 vehicle: vehicle,
            //                 isSelected: selectedVehicle?.id == vehicle.id,
            //                 onTap: () {
            //                   setState(() {
            //                     selectedVehicle = vehicle;
            //                   });
            //                 },
            //               );
            //             },
            //           );
            //         }).toList(),
            //       ),
            //     ),
          ],
        );
      }),
      bottomNavigationBar: Container(
         decoration: const BoxDecoration(
    color: CommonColors.cardWhite,
    border: Border(
      top: BorderSide(color: Color(0xFFE1E5EB), width: 1), // outlineVariant divider
    ),
  ),
        child: Padding(
            padding:
                const EdgeInsets.only(bottom: 16, top: 8, left: 20, right: 20),
            child: _navigateButton()),
      ),
    );
  }

  Widget _navigateButton() {
    return Consumer<VehicleProvider>(
      builder: (context,provider,c) {
        return 
        // SizedBox(
        //   width: double.infinity,
        //   child: ElevatedButton(
        //     onPressed: provider.selectedModel == null
        //         ? null
        //         : () {
        //             if ( provider.selectedModel  != null) {
        //               print(provider.selectedModel);
        //               showAddVehicleBottomSheet(context, provider.selectedModel!);
        //             }
        //           },
        //     style: ElevatedButton.styleFrom(
        //       backgroundColor: CommonColors.blue,
        //       //  const Color(0xffD88D73),
        //       elevation: 0,
        //       padding: const EdgeInsets.symmetric(
        //         vertical: 14,
        //       ),
        //       shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(12),
        //       ),
        //     ),
        //     child: Text(
        //       "Add Vehicle",
        //       style: const TextStyle(color: CommonColors.white),
        //     ),
        //   ),
        // );

         CommonButton(
      title: 'Add Vehicle',
     backgroundColor:provider.selectedModel==null?CommonColors.hintGrey:CommonColors.blue,
      onPressed: provider.selectedModel == null
                ? null
                : () {
                    if ( provider.selectedModel  != null) {
                      print(provider.selectedModel);
                      showAddVehicleBottomSheet(context, provider.selectedModel!);
                    }
                  },
         );
      }
    );
  }
}
class VehicleCard extends StatelessWidget {
  final EvModelData vehicle;
  final bool isSelected;
  final VoidCallback onTap;

  const VehicleCard({
    super.key,
    required this.vehicle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected
                ?  CommonColors.blue
                : const Color(0xFFE8ECF3),
            width: isSelected ? 1.4 : 0.8,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF142344).withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
  width: 48,
  height: 48,
  decoration: BoxDecoration(
    color: const Color(0xFFEAF0FC),
    borderRadius: BorderRadius.circular(17),
  ),
  child: Padding(
    padding: const EdgeInsets.all(14),
    child: vehicle.carModelImage != null &&
            vehicle.carModelImage!.isNotEmpty
        ? Image.network(
            vehicle.carModelImage!,
            width: 28,
            height: 28,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => SvgPicture.asset(
  CommonImagePath.chargingGreen,
  color: CommonColors.blue,
  width: 10,
  height: 10,
  fit: BoxFit.contain,
)
          )
        : SvgPicture.asset(
  CommonImagePath.chargingGreen,
  color: CommonColors.blue,
  width: 10,
  height: 10,
  fit: BoxFit.contain,
)
  ),
),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    vehicle.modelName ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF101B35),
                    ),
                  ),
                 
                  Text(
                    vehicle.manufacturerName ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w200,
                      color: CommonColors.black
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF0FC),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                "233 kWh",
                style: TextStyle(
                  color: Color(0xFF102B70),
                  fontWeight: FontWeight.w700,
                  fontSize: 10,
                ),
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFF68758A),
              size: 23,
            ),
          ],
        ),
      ),
    );
  }
}
// class VehicleCard extends StatelessWidget {
//   final EvModelData vehicle;
//   final bool isSelected;
//   final VoidCallback onTap;

//   const VehicleCard({
//     super.key,
//     required this.vehicle,
//     required this.isSelected,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 200),
//         margin: const EdgeInsets.only(bottom: 14),
//         padding: const EdgeInsets.all(14),
//         decoration: BoxDecoration(
//           color: isSelected ? const Color(0xFFEAF7F5) : Colors.white,
//           borderRadius: BorderRadius.circular(18),
//           border: Border.all(
//             color: isSelected ? CommonColors.blue : CommonColors.neutral200,
//             width: isSelected ? 1.2 : .8,
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(.03),
//               blurRadius: 8,
//               offset: const Offset(0, 3),
//             )
//           ],
//         ),
//         child: Row(
//           children: [
//             /// Vehicle Image
//             Container(
//               width: 58,
//               height: 58,
//               decoration: BoxDecoration(
//                 color: const Color(0xffEEF3FF),
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(10),
//                 child: vehicle.carModelImage != null
//                     ? Image.network(
//                         vehicle.carModelImage!,
//                         fit: BoxFit.contain,
//                         errorBuilder: (_, __, ___) =>
//                            Icon(
//     Icons.bolt,
//     color: Color(0xFF3D6AF2),
//     size: 30,
//   ),
//                       )
//                     : Icon(
//     Icons.bolt,
//     color: Color(0xFF3D6AF2),
//     size: 30,
//   ),
//               ),
//             ),

//             const SizedBox(width: 14),

//             /// Vehicle Details
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     vehicle.modelName ?? "",
//                     style: const TextStyle(
//                       fontSize: 15,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     vehicle.manufacturerName ?? "",
//                     style: TextStyle(
//                       color: Colors.grey.shade600,
//                       fontSize: 12,
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             /// Battery
//             Container(
//               padding: const EdgeInsets.symmetric(
//                 horizontal: 14,
//                 vertical: 8,
//               ),
//               decoration: BoxDecoration(
//                 color: const Color(0xffEEF3FF),
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Text(
//                 "233 kWh",
//                 style: const TextStyle(
//                   color: CommonColors.blue,
//                   fontWeight: FontWeight.w700,
//                   fontSize: 11
//                 ),
//               ),
//             ),

//             const SizedBox(width: 12),

//             const Icon(
//               Icons.chevron_right,
//               color: Colors.grey,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// class VehicleCard extends StatelessWidget {
//   final EvModelData vehicle;
//   final bool isSelected;
//   final VoidCallback onTap;

//   const VehicleCard({
//     super.key,
//     required this.vehicle,
//     required this.isSelected,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 200),
//         decoration: BoxDecoration(
//           color: isSelected ? const Color(0xFFEAF7F5) : Colors.white,
//           borderRadius: BorderRadius.circular(14),
//           border: Border.all(
//             color: isSelected ? CommonColors.blue : CommonColors.neutral200,
//             width: isSelected ? 1 : .5,
//           ),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(12),
//           child: Column(
//             children: [
//               Expanded(
//                 child: vehicle.carModelImage != null
//                     ? Image.network(
//                         vehicle.carModelImage!,
//                         fit: BoxFit.contain,
//                         errorBuilder: (_, __, ___) {
//                           return Image.asset(
//                             CommonImagePath.vehicle1,
//                           );
//                         },
//                       )
//                     : Image.asset(
//                         CommonImagePath.vehicle1,
//                       ),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 vehicle.modelName ?? "",
//                 textAlign: TextAlign.center,
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//                 style: const TextStyle(
//                   fontSize: 13,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
