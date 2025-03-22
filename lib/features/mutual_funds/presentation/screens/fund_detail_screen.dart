import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:intl/intl.dart';
import 'package:khazana_app/core/theme/app_theme.dart';
import 'package:khazana_app/features/mutual_funds/data/models/mutual_fund_model.dart';
import 'package:khazana_app/features/watchlist/presentation/bloc/watchlist_bloc.dart';

class FundDetailScreen extends StatefulWidget {
  final MutualFundModel fund;

  const FundDetailScreen({super.key, required this.fund});

  @override
  State<FundDetailScreen> createState() => _FundDetailScreenState();
}

class _FundDetailScreenState extends State<FundDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedTimeRange = '1Y';
  final List<String> _timeRanges = ['1M', '3M', '6M', '1Y', 'All'];
  
  // For heatmap
  late Map<DateTime, int> _heatmapDatasets;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _generateHeatmapData();
  }
  
  void _generateHeatmapData() {
    // Generate heatmap data based on NAV history
    _heatmapDatasets = {};
    
    // Convert NAV values to heatmap intensity (0-9 scale)
    final navValues = widget.fund.navHistory.map((e) => e.value).toList();
    final minNav = navValues.reduce((a, b) => a < b ? a : b);
    final maxNav = navValues.reduce((a, b) => a > b ? a : b);
    final navRange = maxNav - minNav;
    
    for (var navData in widget.fund.navHistory) {
      final date = DateTime.parse(navData.date);
      // Convert NAV to intensity level (0-9)
      int intensity = 0;