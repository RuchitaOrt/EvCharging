import 'package:ev_charging_app/Services/ChargingService.dart';
import 'package:ev_charging_app/model/ActiveSessionResponse.dart';
import 'package:flutter/material.dart';
enum SessionFilter { thisMonth, last7Days, all }
class ActiveSessionProvider extends ChangeNotifier {
  final ChargingService _service = ChargingService();

  bool _loading = false;
  bool _loadingMore = false;
  bool _hasMore = true;

  int _page = 1;
  final int _pageSize = 10;

  /// 🔴 ORIGINAL list (DO NOT TOUCH)
  final List<Session> _sessions = [];

  /// 🟢 NEW: filtered list
  List<Session> _filteredSessions = [];

  /// 🟢 NEW: current filter (default = this month)
  SessionFilter _currentFilter = SessionFilter.thisMonth;

  bool get loading => _loading;
  bool get loadingMore => _loadingMore;
  bool get hasMore => _hasMore;

  /// ⚠️ IMPORTANT:
  /// Screens will read THIS instead of _sessions
  List<Session> get sessions => _filteredSessions;
 String _totalSessions = "0"; // ✅ total sessions variable

 
  // ✅ getter for total sessions
  String get totalSessions => _totalSessions;

  // ✅ setter for total sessions
  set totalSessions(String value) {
    _totalSessions = value;
    notifyListeners();
  }
  /// ===============================
  /// INITIAL LOAD (UNCHANGED FLOW)
  /// ===============================
  Future<void> fetchActiveSessions(BuildContext context, String status) async {
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
        totalSessions=response!.data!.totalRecords.toString();
        _sessions.addAll(response.data!.sessions);
        _hasMore = response.data!.sessions.length == _pageSize;
        _applyFilter(); // 👈 ONLY ADDITION
      }
    } catch (e) {
      debugPrint("Pagination error: $e");
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  /// ===============================
  /// PAGINATION (UNCHANGED FLOW)
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
        _applyFilter(); // 👈 ONLY ADDITION
      }
    } catch (e) {
      debugPrint("Load more error: $e");
    } finally {
      _loadingMore = false;
      notifyListeners();
    }
  }

  /// ===============================
  /// FILTER LOGIC (NEW)
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
        final date = DateTime.parse(s.createdOn!);
        return date.year == now.year && date.month == now.month;
      }).toList();
    } else if (_currentFilter == SessionFilter.last7Days) {
      final last7 = now.subtract(const Duration(days: 7));
      _filteredSessions = _sessions.where((s) {
        final date = DateTime.parse(s.createdOn!);
        return date.isAfter(last7);
      }).toList();
    } else {
      _filteredSessions = List.from(_sessions);
    }
  }
}

// // class ActiveSessionProvider extends ChangeNotifier {
// //   final ChargingService _service = ChargingService();

// //   bool _loading = false;
 
// //  List<Session> _sessions = [];

// //   bool get loading => _loading;
// //   List<Session> get sessions => _sessions;

// //   /// ✅ Pass context from widget
// //   Future<void> fetchActiveSessions(BuildContext context,String status) async {
// //     _loading = true;
// //     notifyListeners();
// // print("ACTIVE");
// //     try {
// //       final response = await _service.getActiveSessions(
// //         context, // pass it here
// //         page: 1,
// //         pageSize: 50,
// //         status: status
// //       );

// //       if (response.success && response.data != null) {
// //         _sessions = response!.data!.sessions;
// //         print("ACTIVE ${_sessions.length}");
// //       } else {
// //         _sessions = [];
// //       }
// //     } catch (e) {
// //       debugPrint('Error fetching active sessions: $e');
// //       _sessions = [];
// //     } finally {
// //       _loading = false;
// //       notifyListeners();
// //     }
// //   }
// // }
// class ActiveSessionProvider extends ChangeNotifier {
//   final ChargingService _service = ChargingService();

//   bool _loading = false;
//   bool _loadingMore = false;
//   bool _hasMore = true;

//   int _page = 1;
//   final int _pageSize = 10;

//   List<Session> _sessions = [];

//   bool get loading => _loading;
//   bool get loadingMore => _loadingMore;
//   bool get hasMore => _hasMore;
//   List<Session> get sessions => _sessions;

//   /// Initial load / refresh
//   Future<void> fetchActiveSessions(BuildContext context, String status) async {
//     _loading = true;
//     _page = 1;
//     _hasMore = true;
//     _sessions.clear();
//     notifyListeners();

//     try {
//       final response = await _service.getActiveSessions(
//         context,
//         page: _page,
//         pageSize: _pageSize,
//         status: status,
//       );

//       if (response.success && response.data != null) {
//         _sessions = response.data!.sessions;
//         _hasMore = _sessions.length == _pageSize;
//       }
//     } catch (e) {
//       debugPrint("Pagination error: $e");
//     } finally {
//       _loading = false;
//       notifyListeners();
//     }
//   }

//   /// Load next page
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
//       }
//     } catch (e) {
//       print("Load more error: $e");
//     } finally {
//       _loadingMore = false;
//       notifyListeners();
//     }
//   }
// }
