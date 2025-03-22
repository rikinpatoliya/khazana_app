import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khazana_app/core/theme/app_theme.dart';
import 'package:khazana_app/features/mutual_funds/data/models/mutual_fund_model.dart';
import 'package:khazana_app/features/mutual_funds/presentation/bloc/mutual_fund_bloc.dart';
import 'package:khazana_app/features/mutual_funds/presentation/screens/fund_detail_screen.dart';
import 'package:khazana_app/features/watchlist/presentation/bloc/watchlist_bloc.dart';
import 'package:shimmer/shimmer.dart';

class MutualFundListScreen extends StatefulWidget {
  const MutualFundListScreen({super.key});

  @override
  State<MutualFundListScreen> createState() => _MutualFundListScreenState();
}

class _MutualFundListScreenState extends State<MutualFundListScreen> {
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
    // Load mutual funds
    context.read<MutualFundBloc>().add(MutualFundLoadAllEvent());
  }

  @override
  void dispose() {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mutual Funds'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search Bar
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
          
          // Category Filter
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                    selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
                    labelStyle: TextStyle(
                      color: isSelected 
                          ? Theme.of(context).primaryColor 
                          : Colors.black,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Fund List
          Expanded(
            child: BlocBuilder<MutualFundBloc, MutualFundState>(
              builder: (context, state) {
                if (state is MutualFundLoadingState) {
                  return _buildLoadingShimmer();
                } else if (state is MutualFundLoadedState) {
                  return _buildFundList(state.funds);
                } else if (state is MutualFundErrorState) {
                  return Center(
                    child: Text(
                      'Error: ${state.message}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                } else {
                  return const Center(child: Text('No funds available'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 10,
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFundList(List<MutualFundModel> funds) {
    if (funds.isEmpty) {
      return const Center(child: Text('No funds found'));
    }
    
    return ListView.builder(
      itemCount: funds.length,
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, index) {
        final fund = funds[index];
        return _buildFundCard(fund);
      },
    );
  }

  Widget _buildFundCard(MutualFundModel fund) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FundDetailScreen(fund: fund),
            ),
          );
        },
        borderRadius: BorderRadius.circular(10.0),
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
                  IconButton(
                    icon: const Icon(Icons.bookmark_border),
                    onPressed: () {
                      // Show watchlist selection dialog
                      _showAddToWatchlistDialog(fund);
                    },
                    tooltip: 'Add to Watchlist',
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                fund.category,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'NAV',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Text(
                        '₹${fund.nav.toStringAsFixed(2)}',
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
                        '1Y Returns',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Text(
                        '${fund.returns.oneYear.toStringAsFixed(2)}%',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: fund.returns.oneYear >= 0 ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddToWatchlistDialog(MutualFundModel fund) {
    showDialog(
      context: context,
      builder: (context) {
        return BlocBuilder<WatchlistBloc, WatchlistState>(
          builder: (context, state) {
            if (state is WatchlistLoadingState) {
              return const AlertDialog(
                title: Text('Loading Watchlists...'),
                content: SizedBox(
                  height: 100,
                  child: Center(child: CircularProgressIndicator()),
                ),
              );
            } else if (state is WatchlistLoadedState) {
              final watchlists = state.watchlists;
              
              if (watchlists.isEmpty) {
                return AlertDialog(
                  title: const Text('No Watchlists'),
                  content: const Text('You don\'t have any watchlists yet. Create one first.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _showCreateWatchlistDialog(fund);
                      },
                      child: const Text('Create Watchlist'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
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
                    itemCount: watchlists.length,
                    itemBuilder: (context, index) {
                      final watchlist = watchlists[index];
                      final isInWatchlist = watchlist.fundIds.contains(fund.id);
                      
                      return ListTile(
                        title: Text(watchlist.name),
                        trailing: isInWatchlist
                            ? const Icon(Icons.check, color: Colors.green)
                            : null,
                        onTap: () {
                          if (!isInWatchlist) {
                            context.read<WatchlistBloc>().add(
                                  WatchlistAddFundEvent(
                                    watchlist.id,
                                    fund.id,
                                  ),
                                );
                          }
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _showCreateWatchlistDialog(fund);
                    },
                    child: const Text('Create New'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ],
              );
            } else {
              return AlertDialog(
                title: const Text('Error'),
                content: const Text('Failed to load watchlists'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  ),
                ],
              );
            }
          },
        );
      },
    );
  }

  void _showCreateWatchlistDialog(MutualFundModel? fund) {
    final TextEditingController nameController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create Watchlist'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Watchlist Name',
              hintText: 'Enter a name for your watchlist',
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final name = nameController.text.trim();
                if (name.isNotEmpty) {
                  context.read<WatchlistBloc>().add(WatchlistCreateEvent(name));
                  
                  // If a fund was provided, add it to the new watchlist
                  if (fund != null) {
                    // We need to listen for the creation event to complete
                    // This is a simplification - in a real app, you'd use a more robust approach
                    Future.delayed(const Duration(milliseconds: 500), () {
                      if (context.mounted) {
                        final state = context.read<WatchlistBloc>().state;
                        if (state is WatchlistDetailLoadedState) {
                          context.read<WatchlistBloc>().add(
                                WatchlistAddFundEvent(
                                  state.watchlist.id,
                                  fun