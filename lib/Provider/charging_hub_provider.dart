
// import 'package:HyCharge/Services/charging_hub_service.dart';
// import 'package:HyCharge/model/UnifiedComprehensiveResponse.dart';

// import 'package:flutter/material.dart';



// class ChargingHubProvider extends ChangeNotifier {
//   final ChargingHubService _service = ChargingHubService();

//   bool loading = false;
//   String? message;
//   List<Location> hubs = [];
 
// bool loadingMore = false;  // Pagination loading
//    bool hasMore = true;

//   int pageNumber = 1;
//   int pageSize = 6;//100
  
// Future<void> loadChargingHubs(BuildContext context) async {
//   if ((loading || loadingMore) || !hasMore) return;

//   final bool firstPage = pageNumber == 1;

//   if (firstPage) {
//     loading = true;
//   } else {
//     loadingMore = true;
//   }

//   notifyListeners();

//   try {
//     final res = await _service.getChargingHubs(
//       context,
//       pageNumber: pageNumber,
//       pageSize: pageSize,
//     );

//     if (res.success) {
//       final newHubs = res.locations ?? [];

//       if (firstPage) {
//         hubs.clear();
//       }

//       hubs.addAll(newHubs);

//       print("Page : $pageNumber");
//       print("Received : ${newHubs.length}");
//       print("Total : ${hubs.length}");

//       if (newHubs.length < pageSize) {
//         hasMore = false;
//       }

//       _applySearch();
//     }
//   } catch (e) {
//     debugPrint(e.toString());
//   }

//   loading = false;
//   loadingMore = false;

//   notifyListeners();
// }

// //   Future<void> loadChargingHubs(BuildContext context) async {
// //     loading = true;
// //     notifyListeners();

// //     try {
// //       final res = await _service.getChargingHubs(
// //       context,
// //         pageNumber: pageNumber,
// //         pageSize: pageSize,
// //       );

// //       if (res.success) {
// //         hubs = res.hubs;
// //       }
// //  _applySearch(); 
// //       message = res.message;
// //     } catch (e) {
// //       message = "Failed to load charging hubs";
// //       debugPrint("❌ Charging hub error: $e");
// //     }
// //     loading = false;
// //     notifyListeners();
// //   }
//   void searchHub(String query) {
//   _searchQuery = query.toLowerCase().trim();
//   _applySearch();
// }
// void resetPagination() {
//   pageNumber = 1;
//   hasMore = true;
//   hubs.clear();
//   filteredHubs.clear();
//   loading = false;
//   loadingMore = false;
// }

// void clearSearch() {
//   _searchQuery = '';
//   filteredHubs = List.from(hubs);
//   notifyListeners();
// }

// void _applySearch() {
//   if (_searchQuery.isEmpty) {
//     filteredHubs = List.from(hubs);
//   } else {
//     filteredHubs = hubs.where((hub) {
//       final name = hub.name?.toLowerCase() ?? '';
//       final amenities = '';
//       return name.contains(_searchQuery) ||
//           amenities.contains(_searchQuery);
//     }).toList();
//   }
//   notifyListeners();
// }

//   List<dynamic> filteredHubs = [];
//  bool get isSearching => _searchQuery.isNotEmpty;
//   String _searchQuery = '';
//   /// 🔍 SEARCH
//   void searchHubs(String query) {
//     if (query.isEmpty) {
//       filteredHubs = hubs;
//     } else {
//       filteredHubs = hubs.where((hub) {
//         final name = hub.name?.toLowerCase() ?? '';
//         return name.contains(query.toLowerCase());
//       }).toList();
//     }
//     notifyListeners();
//   }
// }
import 'package:flutter/material.dart';
import 'package:HyCharge/Services/charging_hub_service.dart';
import 'package:HyCharge/model/UnifiedComprehensiveResponse.dart';

class ChargingHubProvider extends ChangeNotifier {
  final ChargingHubService _service = ChargingHubService();

  bool loading = false;
  bool loadingMore = false;
  bool hasMore = true;

  String? message;

  int pageNumber = 1;
  final int pageSize = 50;

  List<Location> hubs = [];

  String _searchQuery = '';

List<Location> _filteredHubs = [];

List<Location> get filteredHubs => _filteredHubs;
  Future<void> loadChargingHubs(BuildContext context) async {
    if (loading || loadingMore || !hasMore) return;

    final bool firstPage = pageNumber == 1;

    if (firstPage) {
      loading = true;
    } else {
      loadingMore = true;
    }

    notifyListeners();

    try {
      final response = await _service.getChargingHubs(
        context,
        pageNumber: pageNumber,
        pageSize: pageSize,
      );

      if (response.success) {
        final List<Location> newData = response.locations ?? [];

        if (firstPage) {
          hubs.clear();
        }

        hubs.addAll(newData);

        print("Page : $pageNumber");
        print("Received : ${newData.length}");
        print("Total : ${hubs.length}");

        /// LAST PAGE
      if (response.page! >= response.totalPages!) {
          hasMore = false;
        } else {
          pageNumber++; // increment ONLY when next page exists
        }

        _applySearch();
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    loading = false;
    loadingMore = false;

    notifyListeners();
  }

  void resetPagination() {
    pageNumber = 1;
    hasMore = true;

    loading = false;
    loadingMore = false;

    hubs.clear();
    filteredHubs.clear();
  }

  void searchHub(String query) {
    _searchQuery = query.toLowerCase();
    _applySearch();
  }

  void clearSearch() {
    _searchQuery = '';
    _filteredHubs = List.from(hubs);
    notifyListeners();
  }

  void _applySearch() {
    if (_searchQuery.isEmpty) {
      _filteredHubs = List.from(hubs);
    } else {
      _filteredHubs = hubs.where((hub) {
        return (hub.name ?? '')
            .toLowerCase()
            .contains(_searchQuery);
      }).toList();
    }

    notifyListeners();
  }
}