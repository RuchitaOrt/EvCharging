// import 'package:HyCharge/Services/ChargingService.dart';
// import 'package:HyCharge/model/ActiveSessionResponse.dart';
// import 'package:HyCharge/model/StartChargingSessionResponse.dart';

// import 'package:flutter/material.dart';

// enum SessionFilter { thisMonth, last7Days, all,Debit,Credit }

// class ActiveSessionProvider extends ChangeNotifier {
//   final ChargingService _service = ChargingService();

//   bool _loading = false;
//   bool _loadingMore = false;
//   bool _hasMore = true;

//   int _page = 1;
//   final int _pageSize = 100; // ✅ LOAD 3 AT A TIME

//   final List<ChargingSession> _sessions = [];
//   List<ChargingSession> _filteredSessions = [];
// // final List<UnifiedSession> _sessions = [];
// //   List<UnifiedSession> _filteredSessions = [];
//   SessionFilter _currentFilter = SessionFilter.thisMonth;

//   bool get loading => _loading;
//   bool get loadingMore => _loadingMore;
//   bool get hasMore => _hasMore;
//   List<ChargingSession> get sessions => _filteredSessions;

//   String _totalSessions = "0";
//   String _totalEnergy = "0";
//   String _totalSpent = "0";
//   String _totalTime = "0";

//   String get totalSessions => _totalSessions;
//   String get totalEnergy => _totalEnergy;
//   String get totalSpent => _totalSpent;
//   String get totalTime => _totalTime;

//   /// ===============================
//   /// INITIAL LOAD
//   /// ===============================
//   Future<void> fetchActiveSessions(
//       BuildContext context, String status) async {
//     _loading = true;
//     _page = 1;
//     _hasMore = true;
//     _sessions.clear();
//     _filteredSessions.clear();
//     notifyListeners();

//     try {
//       final response = await _service.getActiveUNifiedSessions(
//         context,
//         page: _page,
//         pageSize: _pageSize,
//         status: status,
//       );
// print("object");
//       if (response.success! && response.data!.sessions != null) {
//         print("object1");
//         _totalSessions = response.data!.totalRecords.toString();
//         _totalEnergy ="0.0";
//             // response.sessions![0].energyDelivered.toString() ?? "0";
//         _totalSpent =="0.0";
//             // response.sessions![0].summary?.totalChargingTotalFee?.toString() ?? "0";
//         _totalTime ="0.0";
//             // response.data!.summary?.totalChargingTime!.formattedDuration! ?? "0";
// print("object2");
//         _sessions.addAll(response.sessions!);
//         _hasMore = response!.sessions!.length == _pageSize;
//         _applyFilter();
//       }
//     } catch (e) {
//       debugPrint("Fetch error: ${e.toString()}");
//     } finally {
//       _loading = false;
//       notifyListeners();
//     }
//   }

//   /// ===============================
//   /// LOAD MORE (SCROLL)
//   /// ===============================
//   Future<void> loadMore(BuildContext context, String status) async {
//     if (_loadingMore || !_hasMore) return;

//     _loadingMore = true;
//     _page++;
//     notifyListeners();

//     try {
//       final response = await _service.getActiveUNifiedSessions(
//         context,
//         page: _page,
//         pageSize: _pageSize,
//         status: status,
//       );

//       if (response.success! && response!.sessions != null) {
//         final newItems = response.sessions;
//         _sessions.addAll(newItems!);
//         _hasMore = newItems.length == _pageSize;
//         _applyFilter();
//       }
//     } catch (e) {
//       debugPrint("Load more error: $e");
//     } finally {
//       _loadingMore = false;
//       notifyListeners();
//     }
//   }

//   /// ===============================
//   /// FILTER
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
//         final date = DateTime.parse(s.startTime!.toString());
//         return date.year == now.year && date.month == now.month;
//       }).toList();
//     } else if (_currentFilter == SessionFilter.last7Days) {
//       final last7 = now.subtract(const Duration(days: 7));
//       _filteredSessions = _sessions.where((s) {
//         final date = DateTime.parse(s.startTime!.toString());
//         return date.isAfter(last7);
//       }).toList();
//     }
   
//   else {
//       _filteredSessions = List.from(_sessions);
//     }
//   }
// }
import 'package:HyCharge/Services/ChargingService.dart';
import 'package:HyCharge/model/ActiveSessionResponse.dart';
import 'package:HyCharge/model/StartChargingSessionResponse.dart';
import 'package:HyCharge/model/UnifiedActiveSessionResponse.dart' as uni;
import 'package:flutter/material.dart';

enum SessionFilter { thisMonth, last7Days, all,Debit,Credit }

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
  List<uni.Session> partnerSessions = [];
  List<uni.Session> _filteredUnifedSessions = [];
List<uni.Session> get unifiedSessions => _filteredUnifedSessions;

  String _totalSessions = "0";
  String _totalEnergy = "0";
  String _totalSpent = "0";
  String _totalTime = "0";

  String get totalSessions => _totalSessions;
  String get totalEnergy => _totalEnergy;
  String get totalSpent => _totalSpent;
  String get totalTime => _totalTime;
int _selectedMainTab = 0;

int get selectedMainTab => _selectedMainTab;

void changeMainTab(int index) {
  _selectedMainTab = index;
  notifyListeners();
}
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
            response.data!.summary?.totalChargingTime!.formattedDuration! ?? "0";

        _sessions.addAll(response.data!.sessions!);
        _hasMore = response.data!.sessions!.length == _pageSize;
        _applyFilter();
      }
    } catch (e) {
      debugPrint("Fetch error: $e");
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
 Future<void> fetchAUnifiedctiveSessions(
      BuildContext context, String status) async {
    _loading = true;
    _page = 1;
    _hasMore = true;
    partnerSessions.clear();
    _filteredUnifedSessions.clear();
    notifyListeners();

    try {
      final response = await _service.getActiveUNifiedSessions(
        context,
        page: _page,
        pageSize: _pageSize,
        status: status,
      );

      if (response.success! && response.data != null) {
        _totalSessions = response.data!.totalCount.toString();
        _totalEnergy =
            // response.data!.summary?.totalEnergyTransmitted?.toString() ??
             "0";
        _totalSpent =
            // response.data!.summary?.totalChargingTotalFee?.toString() ?? 
            "0";
        _totalTime =
            // response.data!.summary?.totalChargingTime!.formattedDuration! ??
             "0";

        partnerSessions.addAll(response!.data!.sessions!);
        _hasMore = response.data!.sessions!.length == _pageSize;
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
        _sessions.addAll(newItems!);
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


  Future<void> loadMoreUnifiedData(BuildContext context, String status) async {
    if (_loadingMore || !_hasMore) return;

    _loadingMore = true;
    _page++;
    notifyListeners();

    try {
      final response = await _service.getActiveUNifiedSessions(
        context,
        page: _page,
        pageSize: _pageSize,
        status: status,
      );

      if (response.success! && response.data != null) {
        final newItems = response.data!.sessions;
        partnerSessions.addAll(newItems!);
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
 void setFilter(SessionFilter filter){

_currentFilter = filter;


if(_selectedMainTab == 0){

  _applyFilter();

}else{

  _applyUnifiedFilter();

}


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
    }
   
  else {
      _filteredSessions = List.from(_sessions);
    }
  }

  void _applyUnifiedFilter() {
    final now = DateTime.now();

    if (_currentFilter == SessionFilter.thisMonth) {
      _filteredUnifedSessions = partnerSessions.where((s) {
        final date = DateTime.parse(s.startDateTime.toString());
        return date.year == now.year && date.month == now.month;
      }).toList();
    } else if (_currentFilter == SessionFilter.last7Days) {
      final last7 = now.subtract(const Duration(days: 7));
      _filteredUnifedSessions = partnerSessions.where((s) {
        final date = DateTime.parse(s.startDateTime!.toString());
        return date.isAfter(last7);
      }).toList();
    }
   
  else {
      _filteredSessions = List.from(_sessions);
    }
  }
}