import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khazana_app/core/theme/app_theme.dart';
import 'package:khazana_app/features/mutual_funds/data/models/mutual_fund_model.dart';
import 'package:khazana_app/features/mutual_funds/presentation/bloc/mutual_fund_bloc.dart';
import 'package:khazana_app/features/watchlist/data/models/watchlist_model.dart';
import 'package:khazana_app/features/watchlist/presentation/bloc/watchlist_bloc.dart';

class AddFundsToWatchlistScreen extends StatefulWidget {
  final WatchListModel watchlist;

  const AddFundsToWatchlistScreen({super.key, required this.watchlist});

  @override
  State<AddFundsToWatchlistScreen> createState() =>
      _AddFundsToWatchlistScreenState();
}

class _AddFundsToWatchlistScreenState extends State<AddFundsToWatchlistScreen>
    with SingleTickerProviderStateMixin {
  String _searchQuery = '';
  String _selectedCategory = 'MF';
  final List<String> _categories = ['#', 'MF', 'IPO', 'Events', 'Brands'];
  final TextEditingController _searchController = TextEditingController();
  bool _showClearButton = false;

  @override
  void initState() {
    super.initState();
    context.read<MutualFundBloc>().add(MutualFundLoadAllEvent());
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
        _showClearButton = _searchController.text.isNotEmpty;
      });
      context.read<MutualFundBloc>().add(
        MutualFundSearchEvent(_searchController.text),
      );
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: _buildSearchBar(),
        titleSpacing: 0,
        actions: [
          if (_showClearButton)
            TextButton(
              onPressed: () {
                _searchController.clear();
              },
              child: const Text(
                'Clear',
                style: TextStyle(color: AppTheme.blueColor),
              ),
            ),
        ],
      ),
      body: Column(
        children: [_buildCategoryFilter(), Expanded(child: _buildFundsList())],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search eg: infy bse, nifty fut',
          prefixIcon: const Icon(Icons.search, size: 20),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
          contentPadding: const EdgeInsets.symmetric(vertical: 0.0),
          filled: true,
          fillColor: Colors.white,
          isDense: true,
        ),
        style: const TextStyle(fontSize: 14),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children:
                    _categories.map((category) {
                      final isSelected = _selectedCategory == category;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedCategory = category;
                          });
                          if (category != '#') {
                            context.read<MutualFundBloc>().add(
                              MutualFundLoadByCategoryEvent(category),
                            );
                          } else {
                            context.read<MutualFundBloc>().add(
                              MutualFundLoadAllEvent(),
                            );
                          }
                        },
                        child: Container(
                          width: 80,
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          decoration: BoxDecoration(
                            border:
                                isSelected
                                    ? const Border(
                                      bottom: BorderSide(
                                        color: AppTheme.blueColor,
                                        width: 2.0,
                                      ),
                                    )
                                    : null,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            category,
                            style: TextStyle(
                              color:
                                  isSelected
                                      ? AppTheme.blueColor
                                      : Colors.black87,
                              fontWeight:
                                  isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFundsList() {
    return BlocBuilder<MutualFundBloc, MutualFundState>(
      builder: (context, state) {
        if (state is MutualFundLoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is MutualFundLoadedState) {
          // Filter out funds that are already in the watchlist
          final availableFunds =
              state.funds
                  .where((fund) => !widget.watchlist.fundIds.contains(fund.id))
                  .toList();

          // Apply category filter if not 'All'
          final filteredFunds =
              _selectedCategory == 'All'
                  ? availableFunds
                  : availableFunds
                      .where((fund) => fund.category == _selectedCategory)
                      .toList();

          // Apply search filter if search query is not empty
          final searchFilteredFunds =
              _searchQuery.isEmpty
                  ? filteredFunds
                  : filteredFunds
                      .where(
                        (fund) => fund.name.toLowerCase().contains(
                          _searchQuery.toLowerCase(),
                        ),
                      )
                      .toList();

          if (searchFilteredFunds.isEmpty) {
            return const Center(
              child: Text('No mutual funds available to add'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: searchFilteredFunds.length,
            itemBuilder: (context, index) {
              return _buildFundCard(searchFilteredFunds[index]);
            },
          );
        } else if (state is MutualFundErrorState) {
          return Center(
            child: Text(
              'Error: ${state.message}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildFundCard(MutualFundModel fund) {
    // Determine if the fund is already in the watchlist
    final bool isInWatchlist = widget.watchlist.fundIds.contains(fund.id);

    // Randomly assign NSE or BSE for demonstration purposes
    // In a real app, this would come from the fund data
    final String exchange = fund.id.hashCode % 2 == 0 ? 'NSE' : 'BSE';
    final Color exchangeColor =
        exchange == 'NSE' ? Colors.pink[100]! : Colors.blue[100]!;

    return Container(
      margin: const EdgeInsets.only(bottom: 1.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!, width: 1.0),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 8.0,
        ),
        leading: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          decoration: BoxDecoration(
            color: exchangeColor,
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Text(
            exchange,
            style: TextStyle(
              fontSize: 12,
              color: exchange == 'NSE' ? Colors.pink[900] : Colors.blue[900],
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              fund.name.toUpperCase(),
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            Text(
              fund.amc.toUpperCase(),
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(
            isInWatchlist ? Icons.check_circle : Icons.add_circle_outline,
            color: AppTheme.blueColor,
          ),
          onPressed: () {
            _addFundToWatchlist(fund);
          },
        ),
      ),
    );
  }

  void _addFundToWatchlist(MutualFundModel fund) {
    // Check if the fund is already in the watchlist
    final bool isInWatchlist = widget.watchlist.fundIds.contains(fund.id);

    if (isInWatchlist) {
      // Remove from watchlist
      context.read<WatchListBloc>().add(
        WatchListRemoveFundEvent(widget.watchlist.id, fund.id),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${fund.name} removed from watchlist'),
          duration: const Duration(seconds: 2),
        ),
      );
    } else {
      // Add to watchlist
      context.read<WatchListBloc>().add(
        WatchListAddFundEvent(widget.watchlist.id, fund.id),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${fund.name} added to watchlist'),
          duration: const Duration(seconds: 2),
        ),
      );
    }

    // Force rebuild to update the UI
    setState(() {});
  }
}
