import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:khazana_app/core/theme/app_theme.dart';
import 'package:khazana_app/core/utils/progress_dialog.dart';
import 'package:khazana_app/core/utils/ui_state.dart';
import 'package:khazana_app/features/mutual_funds/data/models/mutual_fund_model.dart';
import 'package:khazana_app/features/mutual_funds/presentation/bloc/mutual_fund_bloc.dart';
import 'package:khazana_app/features/watchlist/data/models/watchlist_model.dart';
import 'package:khazana_app/features/watchlist/presentation/bloc/watchlist_bloc.dart';
import 'package:khazana_app/features/watchlist/presentation/bloc/watchlist_event.dart';
import 'package:khazana_app/features/watchlist/presentation/bloc/watchlist_state.dart';

class AddFundsToWatchListScreen extends StatefulWidget {
  const AddFundsToWatchListScreen({super.key, this.watchList});

  final WatchListModel? watchList;
  @override
  State<AddFundsToWatchListScreen> createState() =>
      _AddFundsToWatchListScreenState();
}

class _AddFundsToWatchListScreenState extends State<AddFundsToWatchListScreen>
    with SingleTickerProviderStateMixin {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  WatchListModel? _selectedWatchlist;

  @override
  void initState() {
    super.initState();
    context.read<MutualFundBloc>().add(MutualFundLoadAllEvent());

    // Get the current state of the WatchListBloc to find the selected watchlist
    // final watchlistState = context.read<WatchListBloc>().state;
    // if (watchlistState.watchListDetailUiState is Success<WatchListModel>) {
    //   _selectedWatchlist = (watchlistState as Success<WatchListModel>).data;
    //   _selectedWatchlistId =
    //       (watchlistState as Success<WatchListModel>).data?.id;
    // } else {
    //   //   // If no watchlist is selected, get all watchlists and select the first one
    //   context.read<WatchListBloc>().add(WatchListLoadAllEvent());
    // }

    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
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
          // if (_showClearButton)
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
      body: _buildFundsList(),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Search funds...',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        filled: true,
        fillColor: AppTheme.darkCardColor,
      ),
      onChanged: (value) {
        setState(() {
          _searchQuery = value;
        });
        context.read<MutualFundBloc>().add(MutualFundSearchEvent(value));
      },
    );
  }

  Widget _buildFundsList() {
    return BlocConsumer<WatchListBloc, WatchListState1>(
      listener: (context, state) {
        if (state.addFundToWatchListUiState is Loading) {
          showProgressDialog(context);
        } else if (state.addFundToWatchListUiState is Failure) {
          context.pop();
          var reason = (state.addFundToWatchListUiState as Failure).reason;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(reason ?? "Something went wrong"),
              duration: const Duration(seconds: 2),
            ),
          );
        } else if (state.addFundToWatchListUiState is Success) {
          context.pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('added from watchlist'),
              duration: const Duration(seconds: 2),
            ),
          );
        }

        if (state.removeFundToWatchListUiState is Loading) {
          showProgressDialog(context);
        } else if (state.removeFundToWatchListUiState is Failure) {
          context.pop();
          var reason = (state.removeFundToWatchListUiState as Failure).reason;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(reason ?? "Something went wrong"),
              duration: const Duration(seconds: 2),
            ),
          );
        } else if (state.removeFundToWatchListUiState is Success) {
          context.pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('removed from watchlist'),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
      builder: (context, watchlistState) {
        return BlocBuilder<MutualFundBloc, MutualFundState>(
          builder: (context, state) {
            if (state is MutualFundLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is MutualFundLoadedState) {
              // Apply category filter if not 'All'

              final filteredFunds = state.funds;

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
      },
    );
  }

  Widget _buildFundCard(MutualFundModel fund) {
    // Determine if the fund is already in the watchlist
    final bool isInWatchlist =
        widget.watchList?.fundIds.contains(fund) ?? false;

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
    final bool isInWatchlist = widget.watchList!.fundIds.contains(fund);

    if (isInWatchlist) {
      // Remove from watchlist
      context.read<WatchListBloc>().add(
        WatchListRemoveFundEvent(widget.watchList!.id, fund.id),
      );
    } else {
      // Add to watchlist
      context.read<WatchListBloc>().add(
        WatchListAddFundEvent(widget.watchList!.id, fund),
      );
    }
  }
}
