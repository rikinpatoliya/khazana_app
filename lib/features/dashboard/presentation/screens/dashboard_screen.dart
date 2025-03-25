import 'package:flutter/material.dart';
import 'package:khazana_app/core/theme/app_theme.dart';
import 'package:khazana_app/features/mutual_funds/presentation/screens/mutual_fund_list_screen.dart';
import 'package:khazana_app/features/watchlist/presentation/screens/watchlist_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const MutualFundListScreen(),
    const WatchlistScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            label: 'Mutual Funds',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Watchlist'),
        ],
      ),
    );
  }
}
