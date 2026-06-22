import 'package:HyCharge/Bottomsheet/showVehicleBottomsheet.dart';
import 'package:HyCharge/Screens/MainTab.dart';
import 'package:HyCharge/Utils/CommonAppBar.dart';
import 'package:HyCharge/Utils/commoncolors.dart';
import 'package:HyCharge/Utils/commonimages.dart';
import 'package:HyCharge/Utils/sizeConfig.dart';
import 'package:HyCharge/model/VehicleModel.dart';
import 'package:HyCharge/widget/GlobalLists.dart';

import 'package:flutter/material.dart';

class VehicleSelectionScreen extends StatefulWidget {
  final bool isVehicleAdded;
  const VehicleSelectionScreen({super.key, required this.isVehicleAdded});

  @override
  State<VehicleSelectionScreen> createState() => _VehicleSelectionScreenState();
}

class _VehicleSelectionScreenState extends State<VehicleSelectionScreen>
    with SingleTickerProviderStateMixin {
  String selectedTab = "All";

  VehicleModel? selectedVehicle;

  late TabController _tabController;

  final List<String> brands = [
    "All",
    "BYD",
    "Kia",
    "Tata",
    "Hyundai",
    "MG",
    "Mahindra",
    "Toyota",
  ];
VehicleModel? selectedMyVehicle;
bool showMyVehicles = true;
  @override
  void initState() {
    super.initState();
showMyVehicles=widget.isVehicleAdded;
    _tabController = TabController(
      length: brands.length,
      vsync: this,
    );

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          selectedTab = brands[_tabController.index];
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  final List<VehicleModel> vehicles = [
    VehicleModel(
      id: 1,
      vehicleName: "Tata Nexon EV",
      brand: "Tata",
      image: CommonImagePath.vehicle1
    ),
    VehicleModel(
      id: 2,
      vehicleName: "Tata Xpress-T EV",
      brand: "Tata",
      image:  CommonImagePath.vehicle2
    ),
    VehicleModel(
      id: 3,
      vehicleName: "MG ZS EV",
      brand: "Hyundai",
      image:  CommonImagePath.vehicle3
    ),
    VehicleModel(
      id: 4,
      vehicleName: "Hyundai kona Electric",
      brand: "Hyundai",
      image: CommonImagePath.vehicle4
    ),
    VehicleModel(
      id: 5,
      vehicleName: "Seltos",
      brand: "Kia",
      image:  CommonImagePath.vehicle5
    ),
    VehicleModel(
      id: 6,
      vehicleName: "BYD",
      brand: "BYD",
      image: CommonImagePath.vehicle6
    ),
    VehicleModel(
      id: 7,
      vehicleName: "MG",
      brand: "MG",
      image:  CommonImagePath.vehicle7
    ),
    VehicleModel(
      id: 8,
      vehicleName: "Mahindra",
      brand: "Mahindra",
      image:  CommonImagePath.vehicle5
    ),
    VehicleModel(
      id: 9,
      vehicleName: "Toyota",
      brand: "Toyota",
      image: CommonImagePath.vehicle1
    ),
  ];
String searchText = '';
  List<VehicleModel> get filteredVehicles {
    if (selectedTab == "All") {
      return vehicles;
    }

    return vehicles.where((e) => e.brand == selectedTab).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CommonColors.neutral50,
      appBar: CommonAppBar(
        title: "Select Your Vehicle",
        onBack: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MainTab(isLoggedIn: GlobalLists.islLogin),
            ),
          );
        },
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showMyVehicles)
           Padding(
             padding: const EdgeInsets.only(left: 20,top: 12,bottom: 12),
             child: Text(
                  "My Vehicles",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
           ),

  Container(
    width: SizeConfig.blockSizeHorizontal *35,
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
        SizedBox(height: 10,),
        Text(
                selectedVehicle?.vehicleName ??
                    "Tata Nexon EV",
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
                    "MH04CB2522",
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade700,
                      fontWeight:
                          FontWeight.w500,
                    ),
                  ),
                ],
              ),
      ],
    ),
  ),

  
          Container(
  height: 43,
  // color: Colors.white,
  child: TabBar(
    controller: _tabController,
    isScrollable: true,
    indicatorColor:
    CommonColors.blue,
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
    labelPadding:
        const EdgeInsets.symmetric(horizontal: 0),
                tabs: brands
                  .map(
                    (e) => Tab(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 45),
                        child: Text(e),
                      ),
                    ),
                  )
                  .toList(),
    // tabs: brands.map((e) => Tab(text: e)).toList(),
  ),
),
         
          const SizedBox(height: 10),
         

Padding(
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
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: brands.map((brand) {
                final data = (brand == "All"
        ? vehicles
        : vehicles
            .where((e) => e.brand == brand)
            .toList())
    .where(
      (e) => e.vehicleName
          .toLowerCase()
          .contains(
            searchText.toLowerCase(),
          ),
    )
    .toList();
                // final data = brand == "All"
                //     ? vehicles
                //     : vehicles.where((e) => e.brand == brand).toList();

                return GridView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: data.length,
                  // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  //   crossAxisCount: 2,
                  //   crossAxisSpacing: 12,
                  //   mainAxisSpacing: 12,
                  //   childAspectRatio: 0.9,
                  // ),
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
                      isSelected: selectedVehicle?.id == vehicle.id,
                      onTap: () {
                        setState(() {
                          selectedVehicle = vehicle;
                        });
                      },
                    );
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
          padding:
              const EdgeInsets.only(bottom: 16, top: 8, left: 20, right: 20),
          child: _navigateButton()),
    );
  }

  Widget _navigateButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed:selectedVehicle == null? null:() {
          if (selectedVehicle != null) {
            showAddVehicleBottomSheet(context, selectedVehicle!);
          }
        },
       style: ElevatedButton.styleFrom(
  backgroundColor:CommonColors.blue,
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
}
class VehicleCard extends StatelessWidget {
  final VehicleModel vehicle;
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
          color:isSelected?const Color(0xFFEAF7F5): Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? CommonColors.blue
                : CommonColors.neutral200,
            width: isSelected ? 1 : 0.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Expanded(
                child: Image.asset(
                  vehicle.image,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                vehicle.vehicleName,
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
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(15),
//           border: Border.all(
//             color: isSelected ? CommonColors.blue : CommonColors.neutral200,
//             width: 0.2,
//           ),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.network(
//               vehicle.image,
//               height: 100,
//             ),
//             const SizedBox(height: 10),
//             Text(
//               vehicle.vehicleName,
//               style: const TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
