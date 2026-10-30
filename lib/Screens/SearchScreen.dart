import 'package:HyCharge/Provider/charging_hub_provider.dart';
import 'package:HyCharge/Screens/Controller/map_controller.dart';
import 'package:HyCharge/Screens/StationDetailsScreen.dart';
import 'package:HyCharge/Utils/LocationConvert.dart';
import 'package:HyCharge/Utils/commonimages.dart';
import 'package:HyCharge/Utils/commonstrings.dart';
import 'package:HyCharge/Utils/commoncolors.dart';
import 'package:HyCharge/Utils/iconresizer.dart';
import 'package:HyCharge/model/UnifiedComprehensiveResponse.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchScreen extends StatefulWidget {
  final ValueChanged<Location>? onStationTap;

  const SearchScreen({
    super.key,
    this.onStationTap,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController =
      TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  final List<Location> _recentSearches = [];

  static const Color navy = Color(0xFF142F7D);
  static const Color pageBackground = Color(0xFFF4F6FA);
  static const Color muted = Color(0xFF687386);
  static const Color borderColor = Color(0xFFE6EAF1);
  static const Color titleColor = Color(0xFF15213A);
  static const Color availableBackground = Color(0xFFD7F9DE);
  static const Color availableText = Color(0xFF008D45);
static const String _recentSearchIdsKey = 'recent_charging_station_ids';

Future<void> _loadRecentSearchIds() async {
  final prefs = await SharedPreferences.getInstance();

  _savedRecentIds = prefs.getStringList(_recentSearchIdsKey) ?? [];
  _recentIdsLoaded = true;

  if (!mounted) return;

  _restoreRecentSearches(
    context.read<ChargingHubProvider>(),
  );
}

Future<void> _saveRecentSearches() async {
  final prefs = await SharedPreferences.getInstance();

  await prefs.setStringList(
    _recentSearchIdsKey,
    _recentSearches
        .map((station) => station.id.toString())
        .toList(),
  );
}

void _restoreRecentSearches(ChargingHubProvider provider) {
  if (!_recentIdsLoaded ||
      _restoringRecentSearches ||
      provider.hubs.isEmpty) {
    return;
  }

  _restoringRecentSearches = true;

  final restored = <Location>[];

  for (final savedId in _savedRecentIds) {
    for (final station in provider.hubs) {
      if (station.id.toString() == savedId) {
        restored.add(station);
        break;
      }
    }

    if (restored.length == 2) break;
  }

  if (mounted) {
    setState(() {
      _recentSearches
        ..clear()
        ..addAll(restored);
    });
  }

  _restoringRecentSearches = false;
}

List<String> _savedRecentIds = [];
bool _recentIdsLoaded = false;
bool _restoringRecentSearches = false;
  @override
  void initState() {
    super.initState();
 _fetchCurrentLocation();
  _loadRecentSearchIds();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final provider = context.read<ChargingHubProvider>();

      if (provider.hubs.isEmpty && !provider.loading) {
        provider.resetPagination();
        provider.loadChargingHubs(context);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  String _stationName(Location station) {
    return station.name?.trim().isNotEmpty == true
        ? station.name!.trim()
        : 'Charging Station';
  }

  String _stationLocation(Location station) {
    try {
      final value = station.city;
      if (value != null && value.toString().trim().isNotEmpty) {
        return value.toString().trim();
      }
    } catch (_) {}

    return 'Nearby location';
  }

  void _search(String value) {
    context.read<ChargingHubProvider>().searchHub(value);
    setState(() {});
  }

  void _clearSearch() {
    _searchController.clear();
    context.read<ChargingHubProvider>().clearSearch();
    _searchFocusNode.unfocus();
    setState(() {});
  }

 void _selectRecent(Location station) {
  _searchController.text = _stationName(station);

  _searchController.selection = TextSelection.collapsed(
    offset: _searchController.text.length,
  );

  _search(_searchController.text);

  _selectStation(station);
}

Future<void> _selectStation(Location station) async {
  setState(() {
    _recentSearches.removeWhere(
      (item) => item.id == station.id,
    );

    _recentSearches.insert(0, station);

    if (_recentSearches.length > 2) {
      _recentSearches.removeLast();
    }
  });

  await _saveRecentSearches();

  _searchFocusNode.unfocus();

  widget.onStationTap?.call(station);

  final location =
      LocationConvert.getLatLngFromUnifiedHub(station);

  if (location == null) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Station location coordinates are unavailable.',
        ),
      ),
    );
    return;
  }

  final activeMarkerIcon = await getResizedMarker(
    'assets/images/targetMarker.png',
    width: 125,
  );

  if (!mounted) return;

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => StationDetailsScreen(
        nearbyHubs:
            context.read<ChargingHubProvider>().filteredHubs,
        hub: station,
        marker: Marker(
          markerId: MarkerId(station.id.toString()),
          position: location,
          icon: activeMarkerIcon ??
              BitmapDescriptor.defaultMarker,
        ),
        location: location,
      ),
    ),
  );
}

   Position? _currentPosition;
    void _fetchCurrentLocation() async {
    Position? position = await MapController().getCurrentPosition();
    if (position != null) {
      setState(() {
        _currentPosition = position;
      });
      // print(
      //     "Current Location: ${_currentPosition!.latitude}, ${_currentPosition!.longitude}");
    }
  }
    static LatLng? getLatLngFromUnifiedHubs(dynamic hub) {
    if (hub.latitude == null ||
        hub.longitude == null ||
        hub.latitude!.isEmpty ||
        hub.longitude!.isEmpty) {
      return null;
    }
    return convertToLatLng(hub.latitude!, hub.longitude!);
  }
    static LatLng convertToLatLng(String lat, String lng) {
    final double latitude = parseCoordinate(lat);
    final double longitude = parseCoordinate(lng);

    return LatLng(latitude, longitude);
  }
  static double parseCoordinate(String value) {
  value = value.trim();

  // ✅ Case 1: Already a plain decimal number
  final direct = double.tryParse(value);
  if (direct != null) {
    return direct;
  }

  // ✅ Case 2: Has direction (N, S, E, W) like "19.25 N"
  value = value.replaceAll("°", "").trim();
  final parts = value.split(RegExp(r'\s+'));

  if (parts.length != 2) {
    throw FormatException("Invalid coordinate format: $value");
  }

  double coordinate = double.parse(parts[0]);
  String direction = parts[1].toUpperCase();

  if (direction == "S" || direction == "W") {
    coordinate = -coordinate;
  }

  return coordinate;
}
double? _distanceForHub(Location hub) {
  final current = _currentPosition;
  final location = LocationConvert.getLatLngFromUnifiedHub(hub);

  if (current == null || location == null) return null;

  return Geolocator.distanceBetween(
        current.latitude,
        current.longitude,
        location.latitude,
        location.longitude,
      ) /
      1000;
}

 double distance=0.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBackground,
      appBar: AppBar(
        backgroundColor: pageBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        toolbarHeight: 66,
        leadingWidth: 48,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Center(
            child: Material(
              color: Colors.white,
              shape: const CircleBorder(),
              elevation: 2,
              shadowColor: navy.withOpacity(0.07),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () => Navigator.pop(context),
                child: const SizedBox(
                  width: 38,
                  height: 38,
                  child: Icon(
                    Icons.arrow_back_rounded,
                    color: navy,
                    size: 21,
                  ),
                ),
              ),
            ),
          ),
        ),
        titleSpacing: 5,
        title: Container(
          height: 43,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: navy, width: 1.5),
            borderRadius: BorderRadius.circular(26),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.search_rounded,
                color: navy,
                size: 21,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  onChanged: _search,
                  textInputAction: TextInputAction.search,
                  style: const TextStyle(
                    color: titleColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Search nearby charging station',
                    hintStyle: TextStyle(
                      color: Color(0xFF8993A5),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
              if (_searchController.text.isNotEmpty)
                GestureDetector(
                  onTap: _clearSearch,
                  child: const Icon(
                    Icons.close_rounded,
                    color: muted,
                    size: 19,
                  ),
                ),
            ],
          ),
        ),
      ),
      body: Consumer<ChargingHubProvider>(
        builder: (context, provider, _) {

        
          final hubs = provider.filteredHubs;
          if (_recentIdsLoaded && _recentSearches.isEmpty) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (mounted) {
      _restoreRecentSearches(provider);
    }
  });
}
final query = _searchController.text.trim();
//           final query = _searchController.text.trim();
//  final distance = _distanceForHub(hubs);
          if (provider.loading && provider.hubs.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: navy),
            );
          }

          return NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification.metrics.pixels >=
                      notification.metrics.maxScrollExtent - 200 &&
                  provider.hasMore &&
                  !provider.loadingMore &&
                  !provider.loading &&
                  query.isEmpty) {
                provider.loadChargingHubs(context);
              }

              return false;
            },
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 7, 16, 24),
              children: [
                if (_recentSearches.isNotEmpty) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'RECENT',
                        style: TextStyle(
                          color: muted,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.45,
                        ),
                      ),
                      GestureDetector(
                       onTap: () async {
  setState(() {
    _recentSearches.clear();
    _savedRecentIds.clear();
  });

  final prefs = await SharedPreferences.getInstance();
  await prefs.remove(_recentSearchIdsKey);
},
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 5,
                          ),
                          child: Text(
                            'Clear',
                            style: TextStyle(
                              color: navy,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 7),
                  Wrap(
                    spacing: 7,
                    runSpacing: 7,
                    children: _recentSearches.map((station) {
                      return Material(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        elevation: 2,
                        shadowColor: navy.withOpacity(0.06),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(22),
                         onTap: () => _selectRecent(station),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.access_time_rounded,
                                  size: 13,
                                  color: muted,
                                ),
                                const SizedBox(width: 5),
                               Text(
  _stationName(station),
  style: const TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: titleColor,
  ),
),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 23),
                ],
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      query.isEmpty ? 'NEARBY HUBS' : 'SEARCH RESULTS',
                      style: const TextStyle(
                        color: muted,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.45,
                      ),
                    ),
                    Text(
                      '${hubs.length} found',
                      style: const TextStyle(
                        color: muted,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 9),
                if (hubs.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 30,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: navy.withOpacity(0.04),
                          blurRadius: 12,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 58,
                          height: 58,
                          decoration: const BoxDecoration(
                            color: Color(0xFFEAF0FF),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.ev_station_rounded,
                            size: 29,
                            color: navy,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          query.isEmpty
                              ? 'No charging stations found'
                              : 'No search results found',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: titleColor,
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          'Try searching with another station name.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11,
                            color: muted,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(21),
                      boxShadow: [
                        BoxShadow(
                          color: navy.withOpacity(0.055),
                          blurRadius: 13,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(21),
                      child: ListView.separated(
                        itemCount: hubs.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        separatorBuilder: (_, __) => const Divider(
                          height: 1,
                          thickness: 0.8,
                          indent: 0,
                          endIndent: 0,
                          color: borderColor,
                        ),
                        itemBuilder: (context, index) {
                          final station = hubs[index];
final distance = _distanceForHub(station);
                          return GestureDetector(
                            onTap: () => _selectStation(station),
                            child: Material(
                              color: Colors.white,
                              child: InkWell(
                                onTap: () => _selectStation(station),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 11,
                                    vertical: 10,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // _stationThumbnail(),
                                       ClipRRect(
                                            borderRadius: BorderRadius.circular(16),
                                            child: Image.asset(
                                              CommonImagePath.stationImage,
                                              width: 50,
                                              height: 48,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              _stationName(station),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 11.5,
                                                fontWeight: FontWeight.w800,
                                                color: titleColor,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                Text(
                                                  _stationLocation(station),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w400,
                                                    color: muted,
                                                  ),
                                                ),
                                                Text(
                                            distance == null
                                  ? ' • 0.0'
                                  : ' • ${distance.toStringAsFixed(1)} km',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w400,
                                                color: muted,
                                              ),
                                            ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 7),
                                      _filter24hourChip(station),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                if (provider.loadingMore)
                  const Padding(
                    padding: EdgeInsets.all(18),
                    child: Center(
                      child: CircularProgressIndicator(color: navy),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _stationThumbnail() {
    return Container(
      width: 43,
      height: 43,
      decoration: BoxDecoration(
        color: const Color(0xFFEAF0FF),
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFFE3E8F0),
          width: 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: const Icon(
        Icons.ev_station_rounded,
        color: navy,
        size: 23,
      ),
    );
  }

  Widget _filter24hourChip(dynamic hub) {
    final restricted = hub.id == CommonStrings.strDummyRecID ||
        hub.id == CommonStrings.strDummyRecID1;

    if (restricted) {
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 5,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFFCE8E8),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text(
          'Restricted',
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w600,
            color: CommonColors.brownRed,
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: availableBackground,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            CommonImagePath.clock_green,
            width: 12,
            height: 12,
          ),
          const SizedBox(width: 4),
          const Text(
            '24 hrs Available',
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: CommonColors.darkgreen,
            ),
          ),
        ],
      ),
    );
  }
}
