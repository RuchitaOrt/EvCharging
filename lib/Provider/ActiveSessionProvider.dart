import 'package:ev_charging_app/Services/ChargingService.dart';
import 'package:ev_charging_app/model/ActiveSessionResponse.dart';
import 'package:flutter/material.dart';
// enum SessionFilter { thisMonth, last7Days, all }
// class ActiveSessionProvider extends ChangeNotifier {
//   final ChargingService _service = ChargingService();

//   bool _loading = false;
//   bool _loadingMore = false;
//   bool _hasMore = true;

//   int _page = 1;
//   final int _pageSize = 10;

//   /// 🔴 ORIGINAL list (DO NOT TOUCH)
//   final List<ChargingSession> _sessions = [];

//   /// 🟢 NEW: filtered list
//   List<ChargingSession> _filteredSessions = [];

//   /// 🟢 NEW: current filter (default = this month)
//   SessionFilter _currentFilter = SessionFilter.thisMonth;

//   bool get loading => _loading;
//   bool get loadingMore => _loadingMore;
//   bool get hasMore => _hasMore;

//   /// ⚠️ IMPORTANT:
//   /// Screens will read THIS instead of _sessions
//   List<ChargingSession> get sessions => _filteredSessions;
//  String _totalSessions = "0"; // ✅ total sessions variable

 
//   // ✅ getter for total sessions
//   String get totalSessions => _totalSessions;

//   // ✅ setter for total sessions
//   set totalSessions(String value) {
//     _totalSessions = value;
//     notifyListeners();
//   }

//    String _totalEnergy = "0"; // ✅ total sessions variable

 
//   // ✅ getter for total sessions
//   String get totalEnergy => _totalEnergy;

//   // ✅ setter for total sessions
//   set totalEnergy(String value) {
//     _totalEnergy = value;
//     notifyListeners();
//   }

//    String _totalSpent = "0"; // ✅ total sessions variable

 
//   // ✅ getter for total sessions
//   String get totalSpent => _totalSpent;

//   // ✅ setter for total sessions
//   set totalSpent(String value) {
//     _totalSpent = value;
//     notifyListeners();
//   }
//   String _totalTime = "0"; // ✅ total sessions variable

 
//   // ✅ getter for total sessions
//   String get totalTime => _totalTime;

//   // ✅ setter for total sessions
//   set totalTime(String value) {
//     _totalTime = value;
//     notifyListeners();
//   }
  
// Future<ActiveSessionResponse?> fetchActiveSessions(
//   BuildContext context,
//   String status,
// ) async {
//   _loading = true;
//   _page = 1;
//   _hasMore = true;
//   _sessions.clear();
//   _filteredSessions.clear();
//   notifyListeners();

//   ActiveSessionResponse? response;

//   try {
//     response = await _service.getActiveSessions(
//       context,
//       page: _page,
//       pageSize: _pageSize,
//       status: status,
//     );

//     if (response.success && response.data != null) {
//       totalSessions = response.data!.totalRecords.toString();
//       totalEnergy=response!.data!.summary!.totalEnergyTransmitted!.toString();
// totalSpent=response!.data!.summary!.totalChargingTotalFee.toString();
// totalTime=response!.data!.summary!.totalChargingTime.formattedDuration.toString();

//       _sessions.addAll(response.data!.sessions);
//       _hasMore = response.data!.sessions.length == _pageSize;
//       _applyFilter();
//     }
//   } catch (e) {
//     debugPrint("Pagination error: $e");
//   } finally {
//     _loading = false;
//     notifyListeners();
//   }

//   return response; // ✅ RETURN HERE
// }

//   /// ===============================
//   /// PAGINATION (UNCHANGED FLOW)
//   /// ===============================
//   Future<void> loadMore(BuildContext context, String status) async {
//     if (_loadingMore || !_hasMore) return;

//     _loadingMore = true;
//     _page++;
//     notifyListeners();

//     try {
//       final response = await _service.getActiveSessions(
//         context,
//         page: _page,
//         pageSize: _pageSize,
//         status: status,
//       );

//       if (response.success && response.data != null) {
//         final newItems = response.data!.sessions;
//         _sessions.addAll(newItems);
//         _hasMore = newItems.length == _pageSize;
//         _applyFilter(); // 👈 ONLY ADDITION
//       }
//     } catch (e) {
//       debugPrint("Load more error: $e");
//     } finally {
//       _loadingMore = false;
//       notifyListeners();
//     }
//   }

//   /// ===============================
//   /// FILTER LOGIC (NEW)
//   /// ===============================
//   void setFilter(SessionFilter filter) {
//     _currentFilter = filter;
//     _applyFilter();
//     notifyListeners();
//   }

//   void _applyFilter() {
//     final now = DateTime.now();

//     if (_currentFilter == SessionFilter.thisMonth) {
//       _filteredSessions = _sessions.where((s) {
//         final date = DateTime.parse(s!.createdOn!.toString());
//         return date.year == now.year && date.month == now.month;
//       }).toList();
//     } else if (_currentFilter == SessionFilter.last7Days) {
//       final last7 = now.subtract(const Duration(days: 7));
//       _filteredSessions = _sessions.where((s) {
//         final date = DateTime.parse(s.createdOn!.toString());
//         return date.isAfter(last7);
//       }).toList();
//     } else {
//       _filteredSessions = List.from(_sessions);
//     }
//   }
// }

enum SessionFilter { thisMonth, last7Days, all }

class ActiveSessionProvider extends ChangeNotifier {
  final ChargingService _service = ChargingService();

  bool _loading = false;
  bool _loadingMore = false;
  bool _hasMore = true;

  int _page = 1;
  final int _pageSize = 100; // ✅ LOAD 3 AT A TIME

  final List<ChargingSession> _sessions = [];
  List<ChargingSession> _filteredSessions = [];

  SessionFilter _currentFilter = SessionFilter.thisMonth;

  bool get loading => _loading;
  bool get loadingMore => _loadingMore;
  bool get hasMore => _hasMore;
  List<ChargingSession> get sessions => _filteredSessions;

  String _totalSessions = "0";
  String _totalEnergy = "0";
  String _totalSpent = "0";
  String _totalTime = "0";

  String get totalSessions => _totalSessions;
  String get totalEnergy => _totalEnergy;
  String get totalSpent => _totalSpent;
  String get totalTime => _totalTime;

  /// ===============================
  /// INITIAL LOAD
  /// ===============================
  Future<void> fetchActiveSessions(
      BuildContext context, String status) async {
    _loading = true;
    _page = 1;
    _hasMore = true;
    _sessions.clear();
    _filteredSessions.clear();
    notifyListeners();

    try {
      final response = await _service.getActiveSessions(
        context,
        page: _page,
        pageSize: _pageSize,
        status: status,
      );

      if (response.success && response.data != null) {
        _totalSessions = response.data!.totalRecords.toString();
        _totalEnergy =
            response.data!.summary?.totalEnergyTransmitted?.toString() ?? "0";
        _totalSpent =
            response.data!.summary?.totalChargingTotalFee?.toString() ?? "0";
        _totalTime =
            response.data!.summary?.totalChargingTime.formattedDuration ?? "0";

        _sessions.addAll(response.data!.sessions);
        _hasMore = response.data!.sessions.length == _pageSize;
        _applyFilter();
      }
    } catch (e) {
      debugPrint("Fetch error: $e");
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  /// ===============================
  /// LOAD MORE (SCROLL)
  /// ===============================
  Future<void> loadMore(BuildContext context, String status) async {
    if (_loadingMore || !_hasMore) return;

    _loadingMore = true;
    _page++;
    notifyListeners();

    try {
      final response = await _service.getActiveSessions(
        context,
        page: _page,
        pageSize: _pageSize,
        status: status,
      );

      if (response.success && response.data != null) {
        final newItems = response.data!.sessions;
        _sessions.addAll(newItems);
        _hasMore = newItems.length == _pageSize;
        _applyFilter();
      }
    } catch (e) {
      debugPrint("Load more error: $e");
    } finally {
      _loadingMore = false;
      notifyListeners();
    }
  }

  /// ===============================
  /// FILTER
  /// ===============================
  void setFilter(SessionFilter filter) {
    _currentFilter = filter;
    _applyFilter();
    notifyListeners();
  }

  void _applyFilter() {
    final now = DateTime.now();

    if (_currentFilter == SessionFilter.thisMonth) {
      _filteredSessions = _sessions.where((s) {
        final date = DateTime.parse(s.createdOn!.toString());
        return date.year == now.year && date.month == now.month;
      }).toList();
    } else if (_currentFilter == SessionFilter.last7Days) {
      final last7 = now.subtract(const Duration(days: 7));
      _filteredSessions = _sessions.where((s) {
        final date = DateTime.parse(s.createdOn!.toString());
        return date.isAfter(last7);
      }).toList();
    } else {
      _filteredSessions = List.from(_sessions);
    }
  }
}
