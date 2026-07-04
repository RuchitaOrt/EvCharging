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
import 'package:HyCharge/widget/GlobalLists.dart';

import 'package:flutter/material.dart';
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

  void _initTabController(int length) {
    _tabController!.dispose();

    _tabController = TabController(
      length: length,
      vsync: this,
    );

    _tabController!.addListener(() {
      if (!_tabController!.indexIsChanging) {
        context.read<VehicleProvider>().changeTab(
              context.read<VehicleProvider>().tabs[_tabController!.index],
            );
      }
    });
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
      body: Consumer<VehicleProvider>(builder: (context, provider, c) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showMyVehicles)
            
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 12, bottom: 12),
                child: Text(
                  "My Vehicles",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
SizedBox(
  height: 150,
  child: ListView.separated(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          physics: const ScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: provider.userVehicles.length,
          separatorBuilder: (_, __) => const SizedBox(height: 14),
          itemBuilder: (context, index) {
            final vehicle = provider.userVehicles[index];
        
            return  Container(
                width: SizeConfig.blockSizeHorizontal * 35,
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF7F5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: CommonColors.blue,
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 85,
                      height: 65,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          CommonImagePath.vehicle1,
                          height: 120,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      vehicle.evManufacturerID ?? "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.directions_car,
                          size: 14,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          vehicle.carRegistrationNumber! ?? "",
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
          },
        ),
),
           

          (_tabController == null) ?
       Padding(
         padding: const EdgeInsets.only(top: 30),
         child: Center(
          child: CircularProgressIndicator(),
               ),
       )
    :   Container(
              height: 43,
              // color: Colors.white,
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                indicatorColor: CommonColors.blue,
                // const Color(0xffD88D73),
                indicatorWeight: 1.5,
                dividerColor: Colors.transparent,
                labelColor: Colors.black,
                unselectedLabelColor: CommonColors.neutral400,
                labelStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                labelPadding: const EdgeInsets.symmetric(horizontal: 0),
                tabs: provider.tabs
                    .map((e) => Tab(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 45),
                            child: Text(e),
                          ),
                        ))
                    .toList(),
                // brands
                //   .map(
                //     (e) => Tab(
                //       child:
                // Padding(
                //         padding: const EdgeInsets.symmetric(horizontal: 45),
                //         child: Text(e),
                //       ),
                //     ),
                //   )
                //   .toList(),
                // tabs: brands.map((e) => Tab(text: e)).toList(),
              ),
            ),

            const SizedBox(height: 10),

     (_tabController == null) ?
       SizedBox()
    :         Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
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
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
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

                      return GridView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: data.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                          childAspectRatio: .85,
                        ),
                        itemBuilder: (context, index) {
                          final vehicle = data[index];

                          return VehicleCard(
                            vehicle: vehicle,
                            isSelected:
                                provider.selectedVehicleId == vehicle.recId,
                            onTap: () {
                              provider.selectModel(vehicle);
                              provider.selectVehicle(vehicle.recId ?? "");
                            },
                          );
                        },
                      );
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
      bottomNavigationBar: Padding(
          padding:
              const EdgeInsets.only(bottom: 16, top: 8, left: 20, right: 20),
          child: _navigateButton()),
    );
  }

  Widget _navigateButton() {
    return Consumer<VehicleProvider>(
      builder: (context,provider,c) {
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: provider.selectedVehicleId == null
                ? null
                : () {
                    if (provider.selectedVehicleId != null) {
                      print(provider.selectedModel);
                      showAddVehicleBottomSheet(context, provider.selectedModel!);
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: CommonColors.blue,
              //  const Color(0xffD88D73),
              elevation: 0,
              padding: const EdgeInsets.symmetric(
                vertical: 14,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              "Add Vehicle",
              style: const TextStyle(color: CommonColors.white),
            ),
          ),
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
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEAF7F5) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? CommonColors.blue : CommonColors.neutral200,
            width: isSelected ? 1 : .5,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Expanded(
                child: vehicle.carModelImage != null
                    ? Image.network(
                        vehicle.carModelImage!,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) {
                          return Image.asset(
                            CommonImagePath.vehicle1,
                          );
                        },
                      )
                    : Image.asset(
                        CommonImagePath.vehicle1,
                      ),
              ),
              const SizedBox(height: 8),
              Text(
                vehicle.modelName ?? "",
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// class VehicleCard extends StatelessWidget {
//   final VehicleModel vehicle;
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
//           color:isSelected?const Color(0xFFEAF7F5): Colors.white,
//           borderRadius: BorderRadius.circular(14),
//           border: Border.all(
//             color: isSelected
//                 ? CommonColors.blue
//                 : CommonColors.neutral200,
//             width: isSelected ? 1 : 0.5,
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(.04),
//               blurRadius: 8,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(12),
//           child: Column(
//             children: [
//               Expanded(
//                 child: Image.asset(
//                   vehicle.image,
//                   fit: BoxFit.contain,
//                 ),
//               ),

//               const SizedBox(height: 8),

//               Text(
//                 vehicle.vehicleName,
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
