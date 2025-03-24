import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khazana_app/core/theme/app_theme.dart';
import 'package:khazana_app/features/mutual_funds/data/models/mutual_fund_model.dart';
import 'package:khazana_app/features/mutual_funds/presentation/bloc/mutual_fund_bloc.dart';
import 'package:khazana_app/features/watchlist/data/models/watchlist_model.dart';
import 'package:khazana_app/features/watchlist/presentation/bloc/watchlist_bloc.dart';

class WatchlistScreen extends StatefulWidget {
  const WatchlistScreen({super.key});

  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _newWatchlistController = TextEditingController();
  String? _selectedWatchlistId;

  @override
  void initState() {
    super.initState();
    context.read<WatchlistBloc>().add(WatchlistLoadAllEvent());
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _newWatchlistController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Watchlists'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showCreateWatchlistDialog,
          ),
        ],
      ),
      body: BlocBuilder<WatchlistBloc, WatchlistState>(
        builder: (context, state) {
          if (state is WatchlistLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is WatchlistLoadedState) {
            if (state.watchlists.isEmpty) {
              return _buildEmptyState();
            }
            return _buildWatchlistContent(state.watchlists);
          } else if (state is WatchlistErrorState) {
            return Center(
              child: Text(
                'Error: ${state.message}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
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
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Create Watchlist'),
          ),
        ],
      ),
    );
  }

  Widget _buildWatchlistContent(List<WatchlistModel> watchlists) {
    if (_selectedWatchlistId == null && watchlists.isNotEmpty) {
      _selectedWatchlistId = watchlists.first.id;
      context.read<WatchlistBloc>().add(
        WatchlistLoadByIdEvent(_selectedWatchlistId!),
      );
    }

    return Column(
      children: [
        _buildWatchlistTabs(watchlists),
        Expanded(
          child:
              _selectedWatchlistId != null
                  ? _buildWatchlistDetails()
                  : const Center(child: Text('Select a watchlist')),
        ),
      ],
    );
  }

  Widget _buildWatchlistTabs(List<WatchlistModel> watchlists) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: watchlists.length,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          final watchlist = watchlists[index];
          final isSelected = watchlist.id == _selectedWatchlistId;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedWatchlistId = watchlist.id;
              });
              context.read<WatchlistBloc>().add(
                WatchlistLoadByIdEvent(watchlist.id),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primaryColor : Colors.grey[200],
                borderRadius: BorderRadius.circular(25),
              ),
              alignment: Alignment.center,
              child: Text(
                watchlist.name,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildWatchlistDetails() {
    return BlocBuilder<WatchlistBloc, WatchlistState>(
      builder: (context, state) {
        if (state is WatchlistDetailLoadedState) {
          final watchlist = state.watchlist;
          if (watchlist.fundIds.isEmpty) {
            return _buildEmptyWatchlist(watchlist);
          }
          return _buildWatchlistFunds(watchlist);
        } else if (state is WatchlistLoadingState) {
          return const Center(child: CircularProgressIndicator());
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildEmptyWatchlist(WatchlistModel watchlist) {
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
              Navigator.pushNamed(context, '/mutual-funds');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Browse Mutual Funds'),
          ),
        ],
      ),
    );
  }

  Widget _buildWatchlistFunds(WatchlistModel watchlist) {
    return BlocBuilder<MutualFundBloc, MutualFundState>(
      builder: (context, state) {
        if (state is MutualFundLoadedState) {
          final watchlistFunds =
              state.funds
                  .where((fund) => watchlist.fundIds.contains(fund.id))
                  .toList();

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: watchlistFunds.length,
            itemBuilder: (context, index) {
              return _buildFundCard(watchlistFunds[index], watchlist);
            },
          );
        } else if (state is MutualFundLoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else {
          // Load mutual funds if not already loaded
          context.read<MutualFundBloc>().add(MutualFundLoadAllEvent());
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildFundCard(MutualFundModel fund, WatchlistModel watchlist) {
    return Dismissible(
      key: Key('watchlist_fund_${fund.id}'),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        context.read<WatchlistBloc>().add(
          WatchlistRemoveFundEvent(watchlist.id, fund.id),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${fund.name} removed from watchlist'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                context.read<WatchlistBloc>().add(
                  WatchlistAddFundEvent(watchlist.id, fund.id),
                );
              },
            ),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 2,
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/fund-detail', arguments: fund.id);
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
                    context.read<WatchlistBloc>().add(
                      WatchlistCreateEvent(_newWatchlistController.text.trim()),
                    );
                    Navigator.pop(context);
                    _newWatchlistController.clear();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Create'),
              ),
            ],
          ),
    );
  }
}
