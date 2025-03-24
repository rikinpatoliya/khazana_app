import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:khazana_app/core/theme/app_theme.dart';
import 'package:khazana_app/features/mutual_funds/data/models/mutual_fund_model.dart';

class FundDetailScreen extends StatefulWidget {
  final MutualFundModel fund;

  const FundDetailScreen({super.key, required this.fund});

  @override
  State<FundDetailScreen> createState() => _FundDetailScreenState();
}

class _FundDetailScreenState extends State<FundDetailScreen> {
  String selectedTimeRange = 'All';
  final List<String> timeRanges = ['1M', '3M', '6M', '1Y', 'All'];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.fund.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.star_border),
            onPressed: () {
              // TODO: Implement watchlist toggle
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFundHeader(),
              const SizedBox(height: 24),
              _buildNavChart(),
              const SizedBox(height: 24),
              _buildTimeRangeSelector(),
              const SizedBox(height: 24),
              _buildFundMetrics(),
              const SizedBox(height: 24),
              _buildFundDetails(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFundHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.fund.category,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Current NAV'),
                Text(
                  '₹${widget.fund.nav.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text('1Y Returns'),
                Text(
                  '${widget.fund.returns.oneYear.toStringAsFixed(2)}%',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color:
                        widget.fund.returns.oneYear >= 0
                            ? Colors.green
                            : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  List<FlSpot> _getChartData() {
    final sortedHistory = List<NavHistory>.from(
      widget.fund.navHistory,
    )..sort((a, b) => DateTime.parse(a.date).compareTo(DateTime.parse(b.date)));

    final now = DateTime.now();
    DateTime startDate;

    switch (selectedTimeRange) {
      case '1M':
        startDate = now.subtract(const Duration(days: 30));
        break;
      case '3M':
        startDate = now.subtract(const Duration(days: 90));
        break;
      case '6M':
        startDate = now.subtract(const Duration(days: 180));
        break;
      case '1Y':
        startDate = now.subtract(const Duration(days: 365));
        break;
      default: // 'All'
        return sortedHistory
            .asMap()
            .entries
            .map((e) => FlSpot(e.key.toDouble(), e.value.value))
            .toList();
    }

    final filteredHistory =
        sortedHistory
            .where((nav) => DateTime.parse(nav.date).isAfter(startDate))
            .toList();

    return filteredHistory
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value.value))
        .toList();
  }

  Widget _buildNavChart() {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: _getChartData(),
              isCurved: true,
              color: AppTheme.primaryColor,
              barWidth: 2,
              isStrokeCapRound: true,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: AppTheme.primaryColor.withOpacity(0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeRangeSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children:
          timeRanges
              .map(
                (range) => ChoiceChip(
                  label: Text(range),
                  selected: selectedTimeRange == range,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() => selectedTimeRange = range);
                      // TODO: Update chart data based on selected range
                    }
                  },
                ),
              )
              .toList(),
    );
  }

  Widget _buildFundMetrics() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Fund Metrics',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildMetricRow('Expense Ratio', '${widget.fund.expenseRatio}%'),
            const SizedBox(height: 8),
            _buildMetricRow('Fund Size', '₹${_formatAmount(widget.fund.aum)}'),
            const SizedBox(height: 8),
            // _buildMetricRow('Fund Manager', widget.fund.fundManager),
          ],
        ),
      ),
    );
  }

  Widget _buildFundDetails() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Returns',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildMetricRow('1 Year', '${widget.fund.returns.oneYear}%'),
            const SizedBox(height: 8),
            _buildMetricRow('3 Year', '${widget.fund.returns.threeYear}%'),
            const SizedBox(height: 8),
            _buildMetricRow('5 Year', '${widget.fund.returns.fiveYear}%'),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }

  String _formatAmount(num amount) {
    if (amount >= 10000000) {
      return '${(amount / 10000000).toStringAsFixed(2)} Cr';
    } else if (amount >= 100000) {
      return '${(amount / 100000).toStringAsFixed(2)} L';
    } else {
      return amount.toString();
    }
  }
}
