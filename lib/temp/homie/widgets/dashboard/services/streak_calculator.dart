import 'package:flutter/foundation.dart';
import '../models/dashboard_stats.dart';
import '../models/recent_activity.dart';
import '../services/dashboard_service.dart';

/// Manages dashboard state and data loading
class DashboardController extends ChangeNotifier {
  DashboardStats? _stats;
  List<RecentActivity> _activities = [];
  int _streak = 0;
  bool _isLoading = true;
  String? _error;

  // Getters
  DashboardStats? get stats => _stats;
  List<RecentActivity> get activities => _activities;
  int get streak => _streak;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasData => _stats != null;

  /// Load all dashboard data
  Future<void> loadDashboardData() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Load all data in parallel
      final results = await Future.wait([
        DashboardService.getDashboardStats(),
        DashboardService.getRecentActivity(),
        DashboardService.getCurrentStreak(),
      ]);

      _stats = results[0] as DashboardStats;
      _activities = results[1] as List<RecentActivity>;
      _streak = results[2] as int;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load dashboard data: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Refresh dashboard data
  Future<void> refresh() async {
    await loadDashboardData();
  }

  /// Clear all data
  void clear() {
    _stats = null;
    _activities = [];
    _streak = 0;
    _isLoading = true;
    _error = null;
    notifyListeners();
  }
}
