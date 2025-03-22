import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khazana_app/core/constants/app_constants.dart';
import 'package:khazana_app/core/theme/app_theme.dart';
import 'package:khazana_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:khazana_app/features/mutual_funds/data/models/mutual_fund_model.dart';
import 'package:khazana_app/features/mutual_funds/presentation/bloc/mutual_fund_bloc.dart';
import 'package:khazana_app/features/mutual_funds/presentation/screens/fund_detail_screen.dart';
import 'package:khazana_app/features/watchlist/presentation/bloc/watchlist_bloc.dart';
import 'package:shimmer/shimmer.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  final List<String> _categories = [
    'All',
    'Large Cap',
    'Mid Cap',
    'Small Cap',
    'ELSS',
    'Flexi Cap',
    'Value',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // Load mutual funds and watchlists
    context.read<MutualFundBloc>().add(MutualFundLoadAllEvent());
    context.read<WatchlistBloc>().add(WatchlistLoadAllEvent());
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    if (query.isEmpty) {
      context.read<MutualFundBloc>().add(MutualFundLoadAllEvent());
    } else {
      context.read<MutualFundBloc>().add(MutualFundSearchEvent(query));
    }
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });
    
    if (category == 'All') {
      context.read<MutualFundBloc>().add(MutualFundLoadAllEvent());
    } else {
      context.read<MutualFundBloc>().add(MutualFundLoadByCategoryEvent(category));
    }
  }

  void _navigateToFundDetail(MutualFundModel fund) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FundDetailScreen(fund: fund),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Khazana'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(AuthSignOutEvent());
            },
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            labelColor: AppTheme.primaryColor,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppTheme.primaryColor,
            tabs: const [
              Tab(text: 'Fund Performance'),
              Tab(text: 'My Watchlist'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Fund Performance Tab
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search funds...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
                        ),
                        onChanged: _onSearch,
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        itemCount: _categories.length,
                        itemBuilder: (context, index) {
                          final category = _categories[index];
                          final isSelected = category == _selectedCategory;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ChoiceChip(
                              label: Text(category),
                              selected: isSelected,
                              onSelected: (selected) {
                                if (selected) {
                                  _onCategorySelected(category);
                                }
                              },
                              backgroundColor: Colors.grey[200],
                              selectedColor: AppTheme.primaryColor.withOpacity(0.2),
                              labelStyle: TextStyle(
                                color: isSelected ? AppTheme.primaryColor : Colors.black,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: BlocBuilder<MutualFundBloc, MutualFundState>(
                        builder: (context, state) {
                          if (state is MutualFundLoadingState) {
                            return _buildLoadingShimmer();
                          } else if (state is MutualFundLoadedState) {
                            final funds = state.funds;
                            if (funds.isEmpty) {
                              return const Center(
                                child: Text('No mutual funds found'),
                              );
                            }
                            return ListView.builder(
                              padding: const EdgeInsets.all(16.0),
                              itemCount: funds.length,
                              itemBuilder: (context, index) {
                                final fund = funds[index];
                                return _buildFundCard(fund);
                              },
                            );
                          } else if (state is MutualFundErrorState) {
                            return Center(
                              child: Text(
                                'Error: ${state.message}',
                                style: const TextStyle(color: Colors.red),
                              ),
                            );
                          } else {
                            return const Center(
                              child: Text('No data available'),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
                // My Watchlist Tab
                BlocBuilder<WatchlistBloc, WatchlistState>(
                  builder: (context, state) {
                    if (state is WatchlistLoadingState) {
                      return _buildLoadingShimmer();
                    } else if (state is WatchlistLoadedState) {
                      final watchlists = state.watchlists;
                      if (watchlists.isEmpty) {
                        return const Center(
                          child: Text('No watchlists found. Create one to get started!'),
                        );
                      }
                      return ListView.builder(
                        padding: const EdgeInsets.all(16.0),
                        itemCount: watchlists.length,
                        itemBuilder: (context, index) {
                          final watchlist = watchlists[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 16.0),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: ExpansionTile(
                              title: Text(
                                watchlist.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Text('${watchlist.funds.length} funds'),
                              children: watchlist.funds.map((fundId) {
                                // Find the fund details from the MutualFundBloc
                                final fundState = context.read<MutualFundBloc>().state;
                                if (fundState is MutualFundLoadedState) {
                                  final fund = fundState.funds.firstWhere(
                                    (f) => f.id == fundId,
                                    orElse: () => MutualFundModel(
                                      id: fundId,
                                      name: 'Unknown Fund',
                                      category: '',
                                      amc: '',
                                      currentNav: 0,
                                      oneYearReturn: 0,
                                      threeYearReturn: 0,
                                      fiveYearReturn: 0,
                                      riskLevel: 'Unknown',
                                      expenseRatio: 0,
                                      fundSize: 0,
                                      fundManager: '',
                                      navHistory: [],
                                    ),
                                  );
                                  return ListTile(
                                    title: Text(fund.name),
                                    subtitle: Text('${fund.category} • NAV: ₹${fund.currentNav.toStringAsFixed(2)}'),
                                    trailing: Text(
                                      '${fund.oneYearReturn.toStringAsFixed(2)}%',
                                      style: TextStyle(
                                        color: fund.oneYearReturn >= 0 ? Colors.green : Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    onTap: () => _navigateToFundDetail(fund),
                                  );
                                }
                                return ListTile(
                                  title: Text('Fund ID: $fundId'),
                                  subtitle: const Text('Loading fund details...'),
                                );
                              }).toList(),
                            ),
                          );
                        },
                      );
                    } else if (state is WatchlistErrorState) {
                      return Center(
                        child: Text(
                          'Error: ${state.message}',
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    } else {
                      return const Center(
                        child: Text('No data available'),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFundCard(MutualFundModel fund) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: InkWell(
        onTap: () => _navigateToFundDetail(fund),
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      fund.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Text(
                      fund.category,
                      style: TextStyle(
                        color: AppTheme.primaryColor,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Text(
                fund.amc,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'NAV',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '₹${fund.currentNav.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        '1Y Return',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '${fund.oneYearReturn.toStringAsFixed(2)}%',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: fund.oneYearReturn >= 0 ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildReturnItem('3Y', '${fund.threeYearReturn.toStringAsFixed(2)}%', fund.threeYearReturn >= 0),
                  _buildReturnItem('5Y', '${fund.fiveYearReturn.toStringAsFixed(2)}%', fund.fiveYearReturn >= 0),
                  _buildRiskItem(fund.riskLevel),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReturnItem(String label, String value, bool isPositive) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label Return',
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: isPositive ? Colors.green : Colors.red,
          ),
        ),
      ],
    );
  }

  Widget _buildRiskItem(String riskLevel) {
    Color riskColor;
    switch (riskLevel.toLowerCase()) {
      case 'low':
        riskColor = Colors.green;
        break;
      case 'moderate':
        riskColor = Colors.orange;
        break;
      case 'high':
        riskColor = Colors.red;
        break;
      default:
        riskColor = Colors.grey;
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Risk',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          decoration: BoxDecoration(
            color: riskColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Text(
            riskLevel,
            style: TextStyle(
              color: riskColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildLoadingShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Container(
              height: 180,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 20,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 8.0),
                  Container(
                    width: 150,
                    height: 16,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 80,
                        height: 40,
                        color: Colors.white,
                      ),
                      Container(
                        width: 80,
                        height: 40,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 60,
                        height: 30,
                        color: Colors.white,
                      ),
                      Container(
                        width: 60,
                        height: 30,
                        color: Colors.white,
                      ),
                      Container(
                        width: 60,
                        height: 30,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }