class MutualFund {
  final String name;
  final String category;
  final double currentNav;
  final List<double> navHistory;
  final double oneMonthReturn;
  final double threeMonthReturn;
  final double sixMonthReturn;
  final double oneYearReturn;
  final double expenseRatio;
  final double fundSize;
  final String fundManager;

  const MutualFund({
    required this.name,
    required this.category,
    required this.currentNav,
    required this.navHistory,
    required this.oneMonthReturn,
    required this.threeMonthReturn,
    required this.sixMonthReturn,
    required this.oneYearReturn,
    required this.expenseRatio,
    required this.fundSize,
    required this.fundManager,
  });
}
