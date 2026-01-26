// import 'package:ev_charging_app/Screens/MainTab.dart';
// import 'package:ev_charging_app/Screens/StationDetailsScreen.dart';
// import 'package:ev_charging_app/Utils/CommonAppBar.dart';
// import 'package:ev_charging_app/Utils/commoncolors.dart';
// import 'package:ev_charging_app/Utils/commonimages.dart';
// import 'package:ev_charging_app/Utils/sizeConfig.dart';
// import 'package:ev_charging_app/main.dart';
// import 'package:ev_charging_app/widget/GlobalLists.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:provider/provider.dart';
// import '../Provider/HubProvider.dart';

import 'package:ev_charging_app/Provider/charging_hub_provider.dart';
import 'package:ev_charging_app/Screens/MainTab.dart';
import 'package:ev_charging_app/Screens/StationDetailsScreen.dart';
import 'package:ev_charging_app/Utils/CommonAppBar.dart';
import 'package:ev_charging_app/Utils/commoncolors.dart';
import 'package:ev_charging_app/Utils/commonimages.dart';
import 'package:ev_charging_app/Utils/sizeConfig.dart';
import 'package:ev_charging_app/main.dart';
import 'package:ev_charging_app/widget/GlobalLists.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class ChargingStationsScreen extends StatefulWidget {
  const ChargingStationsScreen({super.key});

  @override
  State<ChargingStationsScreen> createState() => _ChargingStationsScreenState();
}

class _ChargingStationsScreenState extends State<ChargingStationsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final provider = context.read<ChargingHubProvider>();

    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !provider.loading) {
      provider.pageNumber++;
      provider.loadChargingHubs(context);
    }
  }

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // ---------------- Search Bar ----------------
  Widget _searchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 48,
      decoration: BoxDecoration(
        color: CommonColors.neutral50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: CommonColors.hintGrey,
          width: 0.3,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: CommonColors.hintGrey),
          SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Search Hub",
                hintStyle: TextStyle(color: CommonColors.hintGrey),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase().trim();
                });
              },
            ),
          ),
          if (_searchQuery.isNotEmpty)
            IconButton(
              icon: Icon(Icons.clear, size: 18, color: CommonColors.hintGrey),
              onPressed: () {
                setState(() {
                  _searchQuery = '';
                  _searchController.clear();
                });
              },
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CommonColors.neutral50,
      appBar: CommonAppBar(
        title: "Charging Stations",
        onBack: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MainTab(isLoggedIn: GlobalLists.islLogin),
            ),
          );
        },
      ),
      body: Consumer<ChargingHubProvider>(
        builder: (context, provider, _) {
          /// FIRST LOAD
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (provider.hubs.isEmpty && !provider.loading) {
              provider.pageNumber = 1;
              provider.loadChargingHubs(context);
            }
          });

          if (provider.loading && provider.hubs.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    SizedBox(
                      width: SizeConfig.blockSizeHorizontal * 73,
                      child: _searchBar(),
                    ),
                    SizedBox(width: 10),
                    Image.asset(CommonImagePath.filter, height: 40),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: provider.hubs.length + 1,
                  itemBuilder: (context, index) {
                    if (index == provider.hubs.length) {
                      return provider.loading
                          ? const Padding(
                              padding: EdgeInsets.all(16),
                              child: Center(child: CircularProgressIndicator()),
                            )
                          : const SizedBox(height: 80);
                    }

                    final hub = provider.hubs[index];
                    return _stationBottomCard(hub);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ---------------- Station Card ----------------

  Widget _stationBottomCard(dynamic hub) {
    final opening = hub.openingTime ?? 'N/A';
    final closing = hub.closingTime ?? 'N/A';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          routeGlobalKey.currentContext!,
          MaterialPageRoute(builder: (_) => StationDetailsScreen(hub: hub)),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Container(
          padding: const EdgeInsets.all(10),
          height: 160,
          decoration: BoxDecoration(
            color: CommonColors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TOP
              Container(
                decoration: BoxDecoration(
                  color: CommonColors.neutral50,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(4),
                child: Row(
                  children: [
                    Image.asset(CommonImagePath.frame, height: 50),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  hub.chargingHubName ?? 'Unnamed Station',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: CommonColors.primary,
                                  ),
                                ),
                              ),
                              const Icon(Icons.more_vert,
                                  color: CommonColors.blue),
                            ],
                          ),
                          Row(
                            children: [
                              _infoTag(
                                  CommonImagePath.redpin,
                                  hub.distanceKm != null
                                      ? "${hub.distanceKm} KM"
                                      : "N/A"),
                              const SizedBox(width: 4),
                              _infoTag(
                                  CommonImagePath.star,
                                  // hub.averageRating?.toString() ??
                                  "0"),
                              const SizedBox(width: 4),
                              _infoTag(
                                  CommonImagePath.clock, "$opening - $closing"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Amenities
              Text(
                hub.amenities ?? "4 Plugs • Wifi • Cafe • Restaurant",
                style: const TextStyle(
                    fontSize: 12, color: CommonColors.neutral500),
              ),

              const SizedBox(height: 14),

              // Pricing
              Row(
                children: [
                  _typeInfo("Type A", "₹${hub.typeATariff ?? '--'} / kWh"),
                  const SizedBox(width: 20),
                  Expanded(
                      child: _typeInfo(
                          "Type B", "₹${hub.typeBTariff ?? '--'} / kWh")),
                  SvgPicture.asset(CommonImagePath.direction),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoTag(String icon, String text) {
    return Row(
      children: [
        Image.asset(icon, height: 14),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _typeInfo(String type, String price) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(type,
            style:
                const TextStyle(fontSize: 14, color: CommonColors.neutral500)),
        const SizedBox(height: 2),
        Text(
          price,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: CommonColors.primary,
          ),
        ),
      ],
    );
  }
}

// class ChargingStationsScreen extends StatefulWidget {
//   const ChargingStationsScreen({super.key});

//   @override
//   State<ChargingStationsScreen> createState() => _ChargingStationsScreenState();
// }

// class _ChargingStationsScreenState extends State<ChargingStationsScreen> {
//   final TextEditingController _searchController = TextEditingController();
//   String _searchQuery = '';

//   // Add a ScrollController for pagination
//   final ScrollController _scrollController = ScrollController();

//   @override
//   void initState() {
//     super.initState();

//     // Setup scroll listener for pagination
//     _scrollController.addListener(_scrollListener);
//   }

//   @override
//   void dispose() {
//     _scrollController.removeListener(_scrollListener);
//     _scrollController.dispose();
//     _searchController.dispose();
//     super.dispose();
//   }

//   // Scroll listener for pagination
//   void _scrollListener() {
//     if (_searchQuery.isNotEmpty) return; // Don't paginate while searching

//     if (_scrollController.position.pixels >=
//         _scrollController.position.maxScrollExtent - 200) {
//       // Load more data when near bottom
//       _loadMoreData();
//     }
//   }

//   void _loadMoreData() {
//     final provider = Provider.of<HubProvider>(context, listen: false);
//     if (!provider.loading && provider.hasMore) {
//       provider.loadHubs(context,);
//     }
//   }

//   // ---------------- Search Bar ----------------
//   Widget _searchBar() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       height: 48,
//       decoration: BoxDecoration(
//         color: CommonColors.neutral50,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: CommonColors.hintGrey,
//           width: 0.3,
//         ),
//       ),
//       child: Row(
//         children: [
//           Icon(Icons.search, color: CommonColors.hintGrey),
//           SizedBox(width: 12),
//           Expanded(
//             child: TextField(
//               controller: _searchController,
//               decoration: InputDecoration(
//                 border: InputBorder.none,
//                 hintText: "Search Hub",
//                 hintStyle: TextStyle(color: CommonColors.hintGrey),
//               ),
//               onChanged: (value) {
//                 setState(() {
//                   _searchQuery = value.toLowerCase().trim();
//                 });
//               },
//             ),
//           ),
//           if (_searchQuery.isNotEmpty)
//             IconButton(
//               icon: Icon(Icons.clear, size: 18, color: CommonColors.hintGrey),
//               onPressed: () {
//                 setState(() {
//                   _searchQuery = '';
//                   _searchController.clear();
//                 });
//               },
//             ),
//         ],
//       ),
//     );
//   }

//   // Helper method to format time
//   String _formatTime(String? time) {
//     if (time == null || time.isEmpty) return "N/A";

//     try {
//       final parts = time.split(':');
//       if (parts.length >= 2) {
//         final hour = int.tryParse(parts[0]) ?? 0;
//         final minute = parts[1];
//         final period = hour >= 12 ? 'PM' : 'AM';
//         final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
//         return '$displayHour:$minute $period';
//       }
//       return time;
//     } catch (e) {
//       return time;
//     }
//   }

//   // Filter hubs based on search query
//   List<dynamic> _filterHubs(List<dynamic> allHubs, String query) {
//     if (query.isEmpty) return allHubs;

//     return allHubs.where((hub) {
//       final hubName = hub.chargingHubName?.toString().toLowerCase() ?? '';
//       return hubName.contains(query);
//     }).toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: CommonColors.neutral50,
//       appBar: CommonAppBar(
//         title: "Charging Hubs",
//         onBack: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => MainTab(isLoggedIn: GlobalLists.islLogin),
//             ),
//           );
//         },
//       ),
//       body: Consumer<HubProvider>(
//         builder: (context, provider, child) {
//           // Load data when screen is first built
//           WidgetsBinding.instance.addPostFrameCallback((_) {
//             if (provider.hubs.isEmpty && !provider.loading) {
//               provider.loadHubs(context, reset: true);
//             }
//           });

//           // Filter hubs based on search query
//           final filteredHubs = _filterHubs(provider.hubs, _searchQuery);

//           return Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               children: [
//                 // Search bar + Filter
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 10),
//                   child: Row(
//                     children: [
//                       SizedBox(
//                         width: SizeConfig.blockSizeHorizontal * 73,
//                         child: _searchBar(),
//                       ),
//                       SizedBox(width: 10),
//                       Image.asset(CommonImagePath.filter, height: 40),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 8),

//                 // Show search result count
//                 if (_searchQuery.isNotEmpty)
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 12),
//                     child: Row(
//                       children: [
//                         Text(
//                           '${filteredHubs.length} station${filteredHubs.length != 1 ? 's' : ''} found',
//                           style: TextStyle(
//                             fontSize: 12,
//                             color: CommonColors.neutral500,
//                           ),
//                         ),
//                         Spacer(),
//                         TextButton(
//                           onPressed: () {
//                             setState(() {
//                               _searchQuery = '';
//                               _searchController.clear();
//                             });
//                           },
//                           child: Text(
//                             'Clear search',
//                             style: TextStyle(
//                               fontSize: 12,
//                               color: CommonColors.primary,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                 // Main content area
//                 Expanded(
//                   child: _buildMainContent(context, provider, filteredHubs),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   // Helper method to build the main content
//   Widget _buildMainContent(BuildContext context, HubProvider provider, List<dynamic> filteredHubs) {
//     // Show loading
//     if (provider.loading && provider.hubs.isEmpty) {
//       return Center(
//         child: CircularProgressIndicator(),
//       );
//     }

//     // Show empty state - no stations at all
//     if (provider.hubs.isEmpty && !provider.loading) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'No charging stations found',
//               style: TextStyle(
//                 color: CommonColors.neutral500,
//                 fontSize: 16,
//               ),
//             ),
//             SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () {
//                 provider.loadHubs(context, reset: true);
//               },
//               child: Text('Retry'),
//             ),
//           ],
//         ),
//       );
//     }

//     // Show no search results
//     if (_searchQuery.isNotEmpty && filteredHubs.isEmpty) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.search_off,
//               size: 60,
//               color: CommonColors.neutral500,
//             ),
//             SizedBox(height: 16),
//             Text(
//               'No hub found for "$_searchQuery"',
//               style: TextStyle(
//                 color: CommonColors.neutral500,
//                 fontSize: 16,
//               ),
//             ),
//             SizedBox(height: 8),
//             Text(
//               'Try a different search',
//               style: TextStyle(
//                 color: CommonColors.neutral500,
//                 fontSize: 14,
//               ),
//             ),

//           ],
//         ),
//       );
//     }

//     // Show stations list with pagination
//     return RefreshIndicator(
//       onRefresh: () async {
//         await provider.loadHubs(context, reset: true);
//       },
//       child: NotificationListener<ScrollNotification>(
//         onNotification: (scrollNotification) {
//           // This handles overscroll scenarios
//           if (scrollNotification is ScrollEndNotification &&
//               _scrollController.position.extentAfter == 0) {
//             _loadMoreData();
//           }
//           return false;
//         },
//         child: ListView.builder(
//           controller: _scrollController,
//           itemCount: filteredHubs.length + (provider.hasMore ? 1 : 0),
//           itemBuilder: (context, index) {
//             // Show loading indicator at the bottom
//             if (index >= filteredHubs.length) {
//               return _buildLoadingIndicator(provider);
//             }

//             final hub = filteredHubs[index];
//             return _stationCard(hub);
//           },
//         ),
//       ),
//     );
//   }

//   // Loading indicator widget for pagination
//   Widget _buildLoadingIndicator(HubProvider provider) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Center(
//         child: provider.loading
//             ? CircularProgressIndicator()
//             : provider.hasMore
//             ? TextButton(
//           onPressed: _loadMoreData,
//           child: Text('Load More'),
//         )
//             : Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Text(
//             'No more stations',
//             style: TextStyle(
//               color: CommonColors.neutral500,
//               fontSize: 12,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // ---------------- Station Card ----------------
//   Widget _stationCard(dynamic hub) {
//     // Parse data from API
//     final openingTime = _formatTime(hub.openingTime);
//     final closingTime = _formatTime(hub.closingTime);
//     final hours = '$openingTime - $closingTime';

//     final distance = hub.distanceKm != null
//         ? '${hub.distanceKm} KM'
//         : 'N/A';

//     final rating = hub.averageRating?.toString() ?? '4.5';

//     final typeAPrice = hub.typeATariff?.isNotEmpty == true
//         ? '₹${hub.typeATariff} / kWh'
//         : '₹12.99 / kWh';

//     final typeBPrice = hub.typeBTariff?.isNotEmpty == true
//         ? '₹${hub.typeBTariff} / kWh'
//         : '₹12.99 / kWh';

//     // Parse amenities
//     final amenitiesStr = hub.amenities?.toString() ?? '';
//     final amenitiesList = amenitiesStr.isNotEmpty
//         ? amenitiesStr.split(',').map((a) => a.trim()).where((a) => a.isNotEmpty).toList()
//         : [];

//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           routeGlobalKey.currentContext!,
//           MaterialPageRoute(
//             builder: (context) => StationDetailsScreen(
//               /*  hubId: hub.recId,
//               hubName: hub.chargingHubName,*/
//             ),
//           ),
//         );
//       },
//       child: SizedBox(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Container(
//             padding: const EdgeInsets.all(8),
//             height: 1,
//             decoration: BoxDecoration(
//               color: CommonColors.white,
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // TOP ROW with Image, Title, More Menu
//                 Container(
//                   decoration: BoxDecoration(
//                     color: CommonColors.neutral50,
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   padding: const EdgeInsets.all(2),
//                   child: Row(
//                     children: [
//                       Container(
//                         width: 70,
//                         height: 70,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(8),
//                           color: CommonColors.neutral50,
//                           image: hub.chargingHubImage != null
//                               ? DecorationImage(
//                             image: NetworkImage(
//                               'https://your-api-base-url/images/${hub.chargingHubImage}',
//                             ),
//                             fit: BoxFit.cover,
//                           )
//                               : DecorationImage(
//                             image: AssetImage(CommonImagePath.frame),
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               children: [
//                                 Expanded(
//                                   child: Text(
//                                     hub.chargingHubName ?? 'Unnamed Station',
//                                     style: const TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w600,
//                                       color: CommonColors.primary,
//                                     ),
//                                   ),
//                                 ),
//                                 const Icon(Icons.more_vert,
//                                     color: CommonColors.blue),
//                               ],
//                             ),
//                             SizedBox(height: 4),
//                             Row(
//                               children: [
//                                 _infoTag(CommonImagePath.redpin, distance),
//                                 const SizedBox(width: 4),
//                                 _infoTag(CommonImagePath.star, rating),
//                                 const SizedBox(width: 4),
//                                 _infoTag(CommonImagePath.clock, hours),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 const SizedBox(height: 8),

//                 // FEATURES ROW - Show amenities from API
//                 if (amenitiesList.isNotEmpty && amenitiesList.length >= 4)
//                   Row(
//                     children: [
//                       for (int i = 0; i < 4 && i < amenitiesList.length; i++) ...[
//                         if (i > 0) const SizedBox(width: 6),
//                         Text(amenitiesList[i],
//                             style: TextStyle(fontSize: 12, color: CommonColors.neutral500)),
//                         if (i < 3 && i < amenitiesList.length - 1) ...[
//                           const SizedBox(width: 6),
//                           circularDot(CommonColors.blue, 5),
//                         ]
//                       ],
//                       // Show "more" indicator if there are more amenities
//                       if (amenitiesList.length > 4) ...[
//                         const SizedBox(width: 6),
//                         circularDot(CommonColors.blue, 5),
//                         const SizedBox(width: 4),
//                         Text("+${amenitiesList.length - 4} more",
//                             style: TextStyle(fontSize: 12, color: CommonColors.neutral500)),
//                       ]
//                     ],
//                   )
//                 else if (amenitiesList.isNotEmpty)
//                   Row(
//                     children: [
//                       for (int i = 0; i < amenitiesList.length; i++) ...[
//                         if (i > 0) const SizedBox(width: 6),
//                         Text(amenitiesList[i],
//                             style: TextStyle(fontSize: 12, color: CommonColors.neutral500)),
//                         if (i < amenitiesList.length - 1) ...[
//                           const SizedBox(width: 6),
//                           circularDot(CommonColors.blue, 5),
//                         ]
//                       ]
//                     ],
//                   )
//                 else
//                 // Default amenities if none from API
//                   Row(
//                     children: [
//                       Text("4 Plugs", style: TextStyle(fontSize: 12, color: CommonColors.neutral500)),
//                       const SizedBox(width: 6),
//                       circularDot(CommonColors.blue, 5),
//                       const SizedBox(width: 4),
//                       Text("Wifi", style: TextStyle(fontSize: 12, color: CommonColors.neutral500)),
//                       const SizedBox(width: 6),
//                       circularDot(CommonColors.blue, 5),
//                       const SizedBox(width: 4),
//                       Text("Cafe", style: TextStyle(fontSize: 12, color: CommonColors.neutral500)),
//                       const SizedBox(width: 6),
//                       circularDot(CommonColors.blue, 5),
//                       const SizedBox(width: 4),
//                       Text("Restaurant", style: TextStyle(fontSize: 12, color: CommonColors.neutral500)),
//                     ],
//                   ),

//                 const SizedBox(height: 6),

//                 // PRICING ROW
//                 Row(
//                   children: [
//                     _typeInfo("Type A", typeAPrice),
//                     const SizedBox(width: 20),
//                     Expanded(child: _typeInfo("Type B", typeBPrice)),
//                     SvgPicture.asset(CommonImagePath.direction),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // Helper methods
//   Widget _infoTag(String icon, String text) {
//     return Container(
//       padding: EdgeInsets.symmetric(vertical: 4, horizontal: 3),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(4),
//       ),
//       child: Row(
//         children: [
//           Image.asset(icon, height: 14),
//           SizedBox(width: 4),
//           Text(text, style: TextStyle(fontSize: 12)),
//         ],
//       ),
//     );
//   }

//   Widget _typeInfo(String type, String price) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(type,
//             style: TextStyle(fontSize: 14, color: CommonColors.neutral500)),
//         SizedBox(height: 2),
//         Text(price,
//             style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w600,
//                 color: CommonColors.primary)),
//       ],
//     );
//   }

//   void _openDirections(double lat, double lng) {
//     // TODO: Implement opening directions in Google Maps
//     print('Open directions to: $lat, $lng');
//   }
// }

// // Helper widget for circular dot
// Widget circularDot(Color color, double size) {
//   return Container(
//     width: size,
//     height: size,
//     decoration: BoxDecoration(
//       color: color,
//       shape: BoxShape.circle,
//     ),
//   );
// }
