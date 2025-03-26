import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:khazana_app/core/router/app_router.dart';
import 'package:khazana_app/core/theme/app_theme.dart';
import 'package:khazana_app/core/utils/ui_state.dart';
import 'package:khazana_app/features/mutual_funds/data/models/mutual_fund_model.dart';
import 'package:khazana_app/features/mutual_funds/presentation/bloc/mutual_fund_bloc.dart';
import 'package:khazana_app/features/watchlist/data/models/watchlist_model.dart';
import 'package:khazana_app/features/watchlist/presentation/bloc/watchlist_bloc.dart';
import 'package:khazana_app/features/watchlist/presentation/bloc/watchlist_event.dart';
import 'package:khazana_app/features/watchlist/presentation/bloc/watchlist_state.dart';
import 'package:khazana_app/features/watchlist/presentation/screens/add_funds_to_watchlist_screen.dart';
import 'package:khazana_app/features/widgets/error/no_data_found_widget.dart';

class WatchlistScreen extends StatefulWidget {
  const WatchlistScreen({super.key});

  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _newWatchlistController = TextEditingController();
  WatchListModel? _selectedWatchList;

  @override
  void initState() {
    super.initState();
    context.read<WatchListBloc>().add(WatchListLoadAllEvent());
    context.read<MutualFundBloc>().add(MutualFundLoadAllEvent());
  }

  @override
  void dispose() {
    _newWatchlistController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My WatchLists'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showCreateWatchlistDialog,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_selectedWatchList == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Please select or create watchlist')),
            );
            return;
          }
          _showAddMutualFundsDialog();
        },
        child: Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<WatchListBloc>().add(WatchListLoadAllEvent());
        },
        child: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocBuilder<WatchListBloc, WatchListState1>(
      builder: (context, state) {
        if (state.watchListUiState is Loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.watchListUiState is Success<List<WatchListModel>>) {
          final watchLists =
              (state.watchListUiState as Success<List<WatchListModel>>).data ??
              [];
          if (watchLists.isEmpty) {
            return _buildEmptyState();
          }
          return _buildWatchListContent(watchLists);
        } else if (state.watchListUiState is Empty<List<WatchListModel>>) {
          return _buildEmptyState();
        } else if (state.watchListUiState is Failure) {
          final reason =
              (state.watchListUiState as Failure<List<WatchListModel>>).reason;
          return NoDataFoundWidget(message: reason);
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.star_border, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'No watchlists yet',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Create a watchlist to track your favorite funds',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _showCreateWatchlistDialog,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.blueColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Create Watchlist'),
          ),
        ],
      ),
    );
  }

  Widget _buildWatchListContent(List<WatchListModel> watchLists) {
    if (_selectedWatchList != null) {
      bool watchlistExists = watchLists.any(
        (watchlist) => watchlist.id == _selectedWatchList?.id,
      );
      if (!watchlistExists) {
        _selectedWatchList =
            null; // Reset if the selected watchlist no longer exists
      }
    }

    // Set the first watchlist as selected if none is selected and the list is not empty
    if (_selectedWatchList == null && watchLists.isNotEmpty) {
      _selectedWatchList = watchLists.firstOrNull;
      context.read<WatchListBloc>().add(
        WatchListLoadByIdEvent(_selectedWatchList!.id),
      );
    }
    return Column(
      children: [
        _buildWatchlistTabs(watchLists),
        Expanded(child: _buildWatchlistDetails()),
      ],
    );
    /*  if (_selectedWatchlistId != null) {
      bool watchlistExists = watchlists.any(
        (watchlist) => watchlist.id == _selectedWatchlistId,
      );
      if (!watchlistExists) {
        _selectedWatchlistId =
            null; // Reset if the selected watchlist no longer exists
      }
    }

    // Set the first watchlist as selected if none is selected and the list is not empty
    if (_selectedWatchlistId == null && watchlists.isNotEmpty) {
      _selectedWatchlistId = watchlists.first.id;
      context.read<WatchListBloc>().add(
        WatchListLoadByIdEvent(_selectedWatchlistId!),
      );
    }

    return Column(
      children: [
        _buildWatchlistTabs(watchlists),

        Expanded(
          child:
              _selectedWatchlistId != null
                  ? _buildWatchlistDetails()
                  : const Center(
                    child: Text(
                      'Select a watchlist',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
        ),
      ],
    ); */
  }

  Widget _buildWatchlistTabs(List<WatchListModel> watchLists) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: watchLists.length,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          final watchListObj = watchLists[index];
          final isSelected = watchListObj.id == _selectedWatchList?.id;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedWatchList = watchListObj;
              });
              context.read<WatchListBloc>().add(
                WatchListLoadByIdEvent(watchListObj.id),
              );
            },

            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.blueColor : Colors.grey[200],
                borderRadius: BorderRadius.circular(80),
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    watchListObj.name,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () {
                      _showDeleteWatchlistDialog(watchListObj);
                    },
                    child: Icon(
                      Icons.close,
                      size: 16,
                      color: isSelected ? Colors.white : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildWatchlistDetails() {
    return BlocBuilder<WatchListBloc, WatchListState1>(
      builder: (context, state) {
        if (state.watchListDetailUiState is Loading) {
          return LoadingScreenWidget();
        } else if (state.watchListDetailUiState is Empty<WatchListModel>) {
          return NoDataFoundWidget();
        } else if (state.watchListDetailUiState is Error) {
          final reason =
              (state.watchListDetailUiState as Failure<List<WatchListModel>>)
                  .reason;
          return NoDataFoundWidget(message: reason);
        } else if (state.watchListDetailUiState is Success<WatchListModel>) {
          final watchlist =
              (state.watchListDetailUiState as Success<WatchListModel>).data;
          if (watchlist != null && watchlist.fundIds.isEmpty) {
            return _buildEmptyWatchlist(watchlist);
          }
          return _buildWatchlistFunds(watchlist!);
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildEmptyWatchlist(WatchListModel watchlist) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.format_list_bulleted, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'No funds in ${watchlist.name}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Add mutual funds to this watchlist',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              _showAddMutualFundsDialog();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.blueColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Add Mutual Funds'),
          ),
        ],
      ),
    );
  }

  Widget _buildWatchlistFunds(WatchListModel watchlist) {
    final fundList = watchlist.fundIds;

    return ListView.builder(
      key: ValueKey('watchlist_funds_${watchlist.id}_${fundList.length}'),
      padding: const EdgeInsets.all(16),
      itemCount: fundList.length,
      itemBuilder: (context, index) {
        return _buildFundCard(fundList[index], watchlist);
      },
    );
  }

  Widget _buildFundCard(MutualFundModel fund, WatchListModel watchlist) {
    return Slidable(
      key: Key('watchlist_fund_${fund.id}'),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            padding: const EdgeInsets.only(right: 20),
            label: 'Delete',
            onPressed: (context) {
              context.read<WatchListBloc>().add(
                WatchListRemoveFundEvent(watchlist.id, fund.id),
              );
            },
          ),
        ],
      ),
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 2,
        child: InkWell(
          onTap: () {
            context.pushNamed(Routes.fundDetailRoute, extra: fund);
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fund.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      fund.category,
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                    Text(
                      fund.amc,
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('NAV', style: TextStyle(fontSize: 12)),
                        Text(
                          '₹${fund.nav.toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          '1Y Returns',
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          '${fund.returns.oneYear.toStringAsFixed(2)}%',
                          style: TextStyle(
                            color:
                                fund.returns.oneYear >= 0
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
            ),
          ),
        ),
      ),
    );
  }

  void _showCreateWatchlistDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Create New Watchlist'),
            content: TextField(
              controller: _newWatchlistController,
              decoration: const InputDecoration(
                hintText: 'Enter watchlist name',
                border: OutlineInputBorder(),
              ),
              autofocus: true,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _newWatchlistController.clear();
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_newWatchlistController.text.trim().isNotEmpty) {
                    context.read<WatchListBloc>().add(
                      WatchListCreateEvent(_newWatchlistController.text.trim()),
                    );
                    Navigator.pop(context);
                    _newWatchlistController.clear();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Create'),
              ),
            ],
          ),
    );
  }

  void _showDeleteWatchlistDialog(WatchListModel watchlist) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Watchlist'),
            content: Text(
              'Are you sure you want to delete "${watchlist.name}"?',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  context.read<WatchListBloc>().add(
                    WatchListDeleteEvent(watchlist.id),
                  );
                  if (_selectedWatchList?.id == watchlist.id) {
                    setState(() {
                      _selectedWatchList = null;
                    });
                  }
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${watchlist.name} deleted')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }

  void _showAddMutualFundsDialog() {
    // Navigate to the new screen for adding funds to watchlist
    context.pushNamed(
      Routes.addFundsToWatchListRoute,
      extra: _selectedWatchList,
    );
  }
}
