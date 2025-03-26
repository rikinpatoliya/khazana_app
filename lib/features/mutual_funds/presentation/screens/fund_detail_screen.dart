import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:khazana_app/core/theme/app_theme.dart';
import 'package:khazana_app/features/mutual_funds/data/models/mutual_fund_model.dart';
import 'package:khazana_app/features/watchlist/presentation/bloc/watchlist_bloc.dart';
import 'package:khazana_app/features/watchlist/presentation/bloc/watchlist_event.dart';

class FundDetailScreen extends StatefulWidget {
  final MutualFundModel fund;

  const FundDetailScreen({super.key, required this.fund});

  @override
  State<FundDetailScreen> createState() => _FundDetailScreenState();
}

class _FundDetailScreenState extends State<FundDetailScreen> {
  String selectedTimeRange = 'All';
  final List<String> timeRanges = ['1M', '3M', '6M', '1Y', 'All'];

  bool isInWatchlist = false;
  double investmentAmount = 1.0; // Added missing variable declaration

  @override
  void initState() {
    super.initState();
    isInWatchlist = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        // title: Text(
        //   widget.fund.name,
        //   style: const TextStyle(color: Colors.white),
        // ),
        actions: [
          IconButton(
            icon: Icon(
              isInWatchlist ? Icons.bookmark : Icons.bookmark_border,
              color: isInWatchlist ? AppTheme.blueColor : Colors.white,
            ),
            onPressed: () {
              // Show dialog to select a watchlist
              _showAddToWatchlistDialog(context, widget.fund);
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
              const SizedBox(height: 16),
              _buildInvestmentSummary(),
              const SizedBox(height: 24),
              _buildNavChart(),
              const SizedBox(height: 16),
              _buildTimeRangeSelector(),
              const SizedBox(height: 24),
              _buildInvestmentCalculator(),
              const SizedBox(height: 24),
              _buildReturnComparison(),
              const SizedBox(height: 32),
              _buildActionButtons(),
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
          widget.fund.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              widget.fund.category,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade700),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '₹ ${widget.fund.nav.toStringAsFixed(2)}',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                border: Border.all(
                  color:
                      widget.fund.returns.oneYear >= 0
                          ? Colors.green
                          : Colors.red,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    widget.fund.returns.oneYear >= 0
                        ? Icons.arrow_upward
                        : Icons.arrow_downward,
                    color:
                        widget.fund.returns.oneYear >= 0
                            ? Colors.green
                            : Colors.red,
                    size: 12,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    widget.fund.returns.oneYear.abs().toStringAsFixed(1),
                    style: TextStyle(
                      color:
                          widget.fund.returns.oneYear >= 0
                              ? Colors.green
                              : Colors.red,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
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

  Widget _buildInvestmentSummary() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade700),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryItem(
              'Invested',
              '₹${widget.fund.investedAmount.toStringAsFixed(0)}k',
            ),
          ),
          Expanded(
            child: _buildSummaryItem(
              'Current Value',
              '₹${widget.fund.currentValue.toStringAsFixed(2)}k',
            ),
          ),
          Expanded(
            child: _buildSummaryItem(
              'Total Gain',
              '₹${widget.fund.totalGain.toStringAsFixed(2)}',
              percentageChange: widget.fund.totalChangePercent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(
    String label,
    String value, {
    double? percentageChange,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: Colors.grey.shade800, width: 1),
        ),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (percentageChange != null)
            Text(
              '${percentageChange.toStringAsFixed(1)}%',
              style: TextStyle(
                color: percentageChange >= 0 ? Colors.green : Colors.red,
                fontSize: 12,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNavChart() {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade800),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'NAV',
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                  ),
                ],
              ),
              Text(
                '23.6k (10k.2)',
                style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 1,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(color: Colors.transparent, strokeWidth: 1);
                  },
                ),
                titlesData: FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: _getChartData(),
                    isCurved: true,
                    color: Colors.white,
                    barWidth: 2,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.blue.withOpacity(0.1),
                    ),
                  ),
                ],
                minX: 0,
                maxX: widget.fund.navHistory.length.toDouble() - 1,
                minY:
                    widget.fund.navHistory
                        .map((e) => e.value)
                        .reduce((a, b) => a < b ? a : b) *
                    0.9,
                maxY:
                    widget.fund.navHistory
                        .map((e) => e.value)
                        .reduce((a, b) => a > b ? a : b) *
                    1.1,
                lineTouchData: LineTouchData(
                  enabled: true,
                  touchTooltipData: LineTouchTooltipData(
                    // tooltipBgColor: Colors.grey.shade800,
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((touchedSpot) {
                        final index = touchedSpot.x.toInt();
                        if (index >= 0 &&
                            index < widget.fund.navHistory.length) {
                          final item = widget.fund.navHistory[index];
                          return LineTooltipItem(
                            '${DateFormat('dd MMM yyyy').format(DateTime.parse(item.date))}\n₹${item.value.toStringAsFixed(2)}',
                            const TextStyle(color: Colors.white, fontSize: 12),
                          );
                        }
                        return null;
                      }).toList();
                    },
                  ),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '2022',
                style: TextStyle(color: Colors.grey.shade400, fontSize: 10),
              ),
              Text(
                '2023',
                style: TextStyle(color: Colors.grey.shade400, fontSize: 10),
              ),
              Text(
                '2024',
                style: TextStyle(color: Colors.grey.shade400, fontSize: 10),
              ),
              Text(
                '2025',
                style: TextStyle(color: Colors.grey.shade400, fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeRangeSelector() {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade700),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ...timeRanges.map(
            (range) => GestureDetector(
              onTap: () {
                setState(() => selectedTimeRange = range);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color:
                      selectedTimeRange == range
                          ? Colors.blue
                          : Colors.transparent,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  range,
                  style: TextStyle(
                    color:
                        selectedTimeRange == range ? Colors.white : Colors.grey,
                    fontSize: 12,
                    fontWeight:
                        selectedTimeRange == range
                            ? FontWeight.bold
                            : FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInvestmentCalculator() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade800),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'If you invested',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '1 Year',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                '₹ ${investmentAmount.toStringAsFixed(1)} L',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: Slider(
                  value: investmentAmount,
                  min: 0.1,
                  max: 10.0,
                  activeColor: Colors.blue,
                  inactiveColor: Colors.grey.shade800,
                  onChanged: (value) {
                    setState(() {
                      investmentAmount = value;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'This Fund\'s past returns',
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildReturnColumn('Similar A/C', 11.9, Colors.green),
              _buildReturnColumn('Category Avg.', 13.8, Colors.green),
              _buildReturnColumn('Direct Plan', 16.4, Colors.green),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReturnColumn(String label, double returnValue, Color color) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 100,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                width: 40,
                height:
                    returnValue * 5, // Scale the height based on return value
                color: color,
              ),
              Positioned(
                top: 0,
                child: Text(
                  '₹ ${(returnValue * 1000).toStringAsFixed(1)}',
                  style: TextStyle(color: color, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildReturnComparison() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade800),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Returns',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildReturnRow('1 Year', widget.fund.returns.oneYear),
          const SizedBox(height: 8),
          _buildReturnRow('3 Year', widget.fund.returns.threeYear),
          const SizedBox(height: 8),
          _buildReturnRow('5 Year', widget.fund.returns.fiveYear),
        ],
      ),
    );
  }

  Widget _buildReturnRow(String period, double returnValue) {
    final isPositive = returnValue >= 0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(period, style: TextStyle(color: Colors.grey.shade400)),
        Text(
          '${returnValue.toStringAsFixed(2)}%',
          style: TextStyle(
            color: isPositive ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('Sell', style: TextStyle(fontSize: 14)),
                SizedBox(width: 5),
                Icon(Icons.arrow_downward, size: 16),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('Invest More', style: TextStyle(fontSize: 14)),
                SizedBox(width: 5),
                Icon(Icons.arrow_upward, size: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Add this method to show watchlist selection dialog
void _showAddToWatchlistDialog(BuildContext context, MutualFundModel fund) {
  /*  showDialog(
    context: context,
    builder:
        (context) => BlocBuilder<WatchListBloc, WatchListState>(
          builder: (context, state) {
            if (state is WatchListLoadedState) {
              if (state.watchLists.isEmpty) {
                return AlertDialog(
                  title: const Text('No Watchlists'),
                  content: const Text(
                    'You don\'t have any watchlists yet. Create a watchlist first.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                );
              }

              return AlertDialog(
                title: const Text('Add to Watchlist'),
                content: SizedBox(
                  width: double.maxFinite,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.watchLists.length,
                    itemBuilder: (context, index) {
                      final watchlist = state.watchLists[index];
                      final isInThisWatchlist = watchlist.fundIds.contains(
                        fund.id,
                      );

                      return ListTile(
                        title: Text(watchlist.name),
                        trailing: Icon(
                          isInThisWatchlist
                              ? Icons.check_circle
                              : Icons.add_circle_outline,
                          color: AppTheme.blueColor,
                        ),
                        onTap: () {
                          if (isInThisWatchlist) {
                            // Remove from watchlist
                            context.read<WatchListBloc>().add(
                              WatchListRemoveFundEvent(watchlist.id, fund.id),
                            );
                          } else {
                            // Add to watchlist
                            context.read<WatchListBloc>().add(
                              WatchListAddFundEvent(watchlist.id, fund.id),
                            );
                          }

                          // setState(() {
                          //   isInWatchlist = !isInThisWatchlist;
                          // });

                          Navigator.pop(context);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                isInThisWatchlist
                                    ? '${fund.name} removed from ${watchlist.name}'
                                    : '${fund.name} added to ${watchlist.name}',
                              ),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ],
              );
            }

            return const AlertDialog(
              title: Text('Loading...'),
              content: Center(child: CircularProgressIndicator()),
            );
          },
        ),
  ); */
}
