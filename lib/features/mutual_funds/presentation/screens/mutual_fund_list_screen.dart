import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:khazana_app/core/router/app_router.dart';
import 'package:khazana_app/core/utils/progress_dialog.dart';
import 'package:khazana_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:khazana_app/features/mutual_funds/data/models/mutual_fund_model.dart';
import 'package:khazana_app/features/mutual_funds/presentation/bloc/mutual_fund_bloc.dart';

class MutualFundListScreen extends StatefulWidget {
  const MutualFundListScreen({super.key});

  @override
  State<MutualFundListScreen> createState() => _MutualFundListScreenState();
}

class _MutualFundListScreenState extends State<MutualFundListScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'All';
  String _sortBy = 'name';

  @override
  void initState() {
    super.initState();
    context.read<MutualFundBloc>().add(MutualFundLoadAllEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mutual Funds'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_outlined),
            onPressed: () {
              context.read<AuthBloc>().add(AuthSignOutEvent());
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search funds...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
                context.read<MutualFundBloc>().add(
                  MutualFundSearchEvent(value),
                );
              },
            ),
          ),
        ),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthErrorState) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is AuthAuthenticatedState) {
            context.goNamed(Routes.dashboardRoute);
          } else if (state is AuthUnauthenticatedState) {
            context.goNamed(Routes.loginRoute);
          } else if (state is AuthLoadingState) {
            showProgressDialog(context);
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              _buildFilterBar(),
              Expanded(
                child: BlocBuilder<MutualFundBloc, MutualFundState>(
                  builder: (context, state) {
                    if (state is MutualFundLoadingState) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is MutualFundLoadedState) {
                      final funds = _filterAndSortFunds(state.funds);
                      if (funds.isEmpty) {
                        return const Center(
                          child: Text('No mutual funds found'),
                        );
                      }
                      return RefreshIndicator(
                        onRefresh: () async {
                          context.read<MutualFundBloc>().add(
                            MutualFundLoadAllEvent(),
                          );
                        },
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16.0),
                          itemCount: funds.length,
                          itemBuilder: (context, index) {
                            return _buildFundCard(funds[index]);
                          },
                        ),
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
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: DropdownButton<String>(
              value: _selectedCategory,
              isExpanded: true,
              items:
                  ['All', 'Equity', 'Debt', 'Hybrid', 'Others']
                      .map(
                        (category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ),
                      )
                      .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
                if (value != 'All') {
                  context.read<MutualFundBloc>().add(
                    MutualFundLoadByCategoryEvent(value!),
                  );
                } else {
                  context.read<MutualFundBloc>().add(MutualFundLoadAllEvent());
                }
              },
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: DropdownButton<String>(
              value: _sortBy,
              isExpanded: true,
              items: [
                DropdownMenuItem(value: 'name', child: Text('Sort by Name')),
                DropdownMenuItem(value: 'nav', child: Text('Sort by NAV')),
                DropdownMenuItem(
                  value: 'returns',
                  child: Text('Sort by Returns'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _sortBy = value!;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFundCard(MutualFundModel fund) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      elevation: 2,
      child: InkWell(
        onTap: () {
          context.pushNamed(Routes.fundDetailRoute, extra: fund);
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
              const SizedBox(height: 8.0),
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
              const SizedBox(height: 12.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('NAV', style: TextStyle(fontSize: 12)),
                      Text(
                        '₹${fund.nav.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text('1Y Returns', style: TextStyle(fontSize: 12)),
                      Text(
                        '${fund.returns.oneYear.toStringAsFixed(2)}%',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color:
                              fund.returns.oneYear >= 0
                                  ? Colors.green
                                  : Colors.red,
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

  List<MutualFundModel> _filterAndSortFunds(List<MutualFundModel> funds) {
    var filteredFunds = funds;

    // Apply category filter
    if (_selectedCategory != 'All') {
      filteredFunds =
          filteredFunds
              .where(
                (fund) =>
                    fund.category.toLowerCase() ==
                    _selectedCategory.toLowerCase(),
              )
              .toList();
    }

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filteredFunds =
          filteredFunds
              .where(
                (fund) =>
                    fund.name.toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    ) ||
                    fund.amc.toLowerCase().contains(_searchQuery.toLowerCase()),
              )
              .toList();
    }

    // Apply sorting
    switch (_sortBy) {
      case 'name':
        filteredFunds.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'nav':
        filteredFunds.sort((a, b) => b.nav.compareTo(a.nav));
        break;
      case 'returns':
        filteredFunds.sort(
          (a, b) => b.returns.oneYear.compareTo(a.returns.oneYear),
        );
        break;
    }

    return filteredFunds;
  }
}
