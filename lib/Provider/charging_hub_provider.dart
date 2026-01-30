
import 'package:ev_charging_app/Services/charging_hub_service.dart';
import 'package:ev_charging_app/model/ChargingcomprehensiveHubResponse.dart';
import 'package:flutter/material.dart';



class ChargingHubProvider extends ChangeNotifier {
  final ChargingHubService _service = ChargingHubService();

  bool loading = false;
  String? message;
  List<ChargingHub> hubs = [];

  int pageNumber = 1;
  int pageSize = 100;

  Future<void> loadChargingHubs(BuildContext context) async {
    loading = true;
    notifyListeners();

    try {
      final res = await _service.getChargingHubs(
      context,
        pageNumber: pageNumber,
        pageSize: pageSize,
      );

      if (res.success) {
        hubs = res.hubs;
      }
 _applySearch(); 
      message = res.message;
    } catch (e) {
      message = "Failed to load charging hubs";
      debugPrint("❌ Charging hub error: $e");
    }
    loading = false;
    notifyListeners();
  }
  void searchHub(String query) {
  _searchQuery = query.toLowerCase().trim();
  _applySearch();
}

void clearSearch() {
  _searchQuery = '';
  filteredHubs = List.from(hubs);
  notifyListeners();
}

void _applySearch() {
  if (_searchQuery.isEmpty) {
    filteredHubs = List.from(hubs);
  } else {
    filteredHubs = hubs.where((hub) {
      final name = hub.chargingHubName?.toLowerCase() ?? '';
      final amenities = hub.amenities?.toLowerCase() ?? '';
      return name.contains(_searchQuery) ||
          amenities.contains(_searchQuery);
    }).toList();
  }
  notifyListeners();
}

  List<dynamic> filteredHubs = [];
 bool get isSearching => _searchQuery.isNotEmpty;
  String _searchQuery = '';
  /// 🔍 SEARCH
  void searchHubs(String query) {
    if (query.isEmpty) {
      filteredHubs = hubs;
    } else {
      filteredHubs = hubs.where((hub) {
        final name = hub.chargingHubName?.toLowerCase() ?? '';
        return name.contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }
}
