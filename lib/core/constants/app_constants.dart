class AppConstants {
  // API Constants
  static const String baseUrl = 'https://api.example.com';

  // Asset Constants
  static const String logoPath = 'assets/images/logo.svg';
  static const String mutualFundsDataPath = 'assets/data/mutual_funds.json';

  // Hive Constants
  static const String watchlistBox = 'watchlist_box1';
  static const String mutualFundBox = 'mutual_fund_box';
  static const String userBox = 'user_box';

  // Shared Preferences Keys
  static const String userTokenKey = 'user_token';
  static const String userIdKey = 'user_id';
  static const String isLoggedInKey = 'is_logged_in';
  static const String themeModeKey = 'theme_mode';

  // Error Messages
  static const String networkErrorMessage =
      'Network error. Please check your connection.';
  static const String authErrorMessage =
      'Authentication failed. Please try again.';
  static const String generalErrorMessage =
      'Something went wrong. Please try again later.';
}
